# ============================================================
# Quiz HTML autonomes
# ============================================================

.html_echapper = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x = gsub('"', "&quot;", x, fixed = TRUE)
  x
}

.verifier_qcm = function(exercice) {
  qcm = exercice$qcm
  if (is.null(qcm)) {
    stop(sprintf(
      "L'exercice %s ne propose pas encore de QCM auto-corrigeable.",
      exercice$modele_id
    ), call. = FALSE)
  }
  if (length(qcm$propositions) != 4L || length(unique(qcm$propositions)) != 4L) {
    stop("Un QCM eduschool doit proposer exactement quatre reponses distinctes.", call. = FALSE)
  }
  if (length(qcm$correcte) != 1L || !qcm$correcte %in% seq_len(4L)) {
    stop("Un QCM eduschool doit avoir exactement une reponse correcte.", call. = FALSE)
  }
  if (length(qcm$feedback) != 4L) {
    stop("Chaque proposition d'un QCM eduschool doit avoir son feedback.", call. = FALSE)
  }
  invisible(TRUE)
}

#' Produire un quiz HTML auto-corrigeant
#'
#' Produit un fichier HTML autonome : aucun serveur, aucune bibliotheque
#' JavaScript et aucune session R ne sont necessaires pour faire le quiz.
#' Chaque question comporte quatre propositions et une seule bonne reponse.
#'
#' @param exercices Liste d'exercices munis de propositions QCM.
#' @param fichier Chemin du fichier HTML. Si `NULL`, un nom est construit
#'   automatiquement a partir des exercices.
#' @param titre Titre affiche dans le quiz.
#' @param ouvrir Ouvrir le quiz dans le navigateur apres sa creation.
#' @return Invisiblement, le chemin absolu du fichier HTML produit.
#' @examples
#' \dontrun{
#' exercices("6E", "proportionnalite", n = 5) |>
#'   produire_quiz()
#' }
#' @export
produire_quiz = function(exercices, fichier = NULL,
                         titre = "Mon entrainement eduschool",
                         ouvrir = TRUE) {
  .verifier_exercices(exercices)
  invisible(lapply(exercices, .verifier_qcm))

  if (is.null(fichier)) fichier = .nom_fichier_document(exercices, "quiz")
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")
  fichier = normalizePath(fichier, mustWork = FALSE)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  questions = vapply(seq_along(exercices), function(i) {
    ex = exercices[[i]]
    qcm = ex$qcm
    propositions = vapply(seq_len(4L), function(j) {
      sprintf(
        '<label class="proposition"><input type="radio" name="q%d" value="%d"><span>%s</span></label>',
        i, j, .html_echapper(qcm$propositions[[j]])
      )
    }, character(1))
    feedback = paste(sprintf(
      '<div class="feedback-option" data-question="%d" data-option="%d">%s</div>',
      i, seq_len(4L), .html_echapper(qcm$feedback)
    ), collapse = "\n")
    sprintf(
      paste0(
        '<section class="question" data-question="%d" data-correct="%d">',
        '<h2>Question %d</h2><p class="enonce">%s</p>%s',
        '<div class="retour" aria-live="polite"></div>%s</section>'
      ),
      i, qcm$correcte, i, .html_echapper(ex$enonce),
      paste(propositions, collapse = "\n"), feedback
    )
  }, character(1))

  html = c(
    '<!doctype html>', '<html lang="fr">', '<head>',
    '<meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    sprintf('<title>%s</title>', .html_echapper(titre)),
    '<style>',
    'body{font-family:system-ui,sans-serif;max-width:820px;margin:0 auto;padding:1.2rem;line-height:1.45;color:#222}',
    '.question{border:1px solid #d7dce0;border-radius:8px;padding:1rem 1.1rem;margin:1.2rem 0}',
    '.question h2{font-size:1.05rem;margin:.1rem 0 .65rem}.enonce{font-weight:600}',
    '.proposition{display:flex;gap:.65rem;align-items:flex-start;padding:.55rem .45rem;border-radius:6px;cursor:pointer}',
    '.proposition:hover{background:#f4f5f6}.proposition input{margin-top:.25rem}',
    '.retour{margin-top:.75rem;font-weight:650}.feedback-option{display:none;margin-top:.35rem}',
    '.actions{display:flex;gap:.75rem;flex-wrap:wrap;margin:1.5rem 0}',
    'button{font:inherit;padding:.65rem 1rem;border:1px solid #777;border-radius:7px;background:#fff;cursor:pointer}',
    '#bilan{font-size:1.05rem;font-weight:650;margin:1rem 0 2rem}',
    '</style>', '</head>', '<body>',
    sprintf('<h1>%s</h1>', .html_echapper(titre)),
    '<p>Choisis une reponse pour chaque question, puis valide le quiz.</p>',
    questions,
    '<div class="actions"><button id="valider" type="button">Valider le quiz</button><button id="reessayer" type="button">Reessayer</button></div>',
    '<div id="bilan" aria-live="polite"></div>',
    '<script>',
    'const questions=[...document.querySelectorAll(".question")];',
    'document.getElementById("valider").addEventListener("click",()=>{',
    ' let bonnes=0; let repondues=0;',
    ' questions.forEach(q=>{',
    '  const choix=q.querySelector("input:checked"); const retour=q.querySelector(".retour");',
    '  q.querySelectorAll(".feedback-option").forEach(x=>x.style.display="none");',
    '  if(!choix){retour.textContent="Choisis une reponse avant de valider cette question.";return;}',
    '  repondues++; const ok=choix.value===q.dataset.correct; if(ok) bonnes++;',
    '  retour.textContent=ok?"Bien vu.":"Cette question merite encore un petit detour.";',
    '  const f=q.querySelector(`.feedback-option[data-option="${choix.value}"]`); if(f) f.style.display="block";',
    ' });',
    ' const bilan=document.getElementById("bilan");',
    ' if(repondues<questions.length) bilan.textContent=`${repondues} question(s) repondue(s) sur ${questions.length}. Complete tranquillement les autres.`;',
    ' else if(bonnes===questions.length) bilan.textContent="Toutes les reponses sont justes. Tu peux continuer ou revenir demain pour un nouvel entrainement.";',
    ' else bilan.textContent=`${bonnes} reponse(s) juste(s) sur ${questions.length}. Regarde les explications, puis essaie a nouveau.`;',
    '});',
    'document.getElementById("reessayer").addEventListener("click",()=>{',
    ' document.querySelectorAll("input[type=radio]").forEach(x=>x.checked=false);',
    ' document.querySelectorAll(".retour").forEach(x=>x.textContent="");',
    ' document.querySelectorAll(".feedback-option").forEach(x=>x.style.display="none");',
    ' document.getElementById("bilan").textContent=""; window.scrollTo({top:0,behavior:"smooth"});',
    '});',
    '</script>', '</body>', '</html>'
  )

  writeLines(html, fichier, useBytes = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}
