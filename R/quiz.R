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

.base64_raw = function(x) {
  if (!is.raw(x)) x = as.raw(x)
  n = length(x)
  if (n == 0L) return("")

  alphabet = strsplit(
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
    "", fixed = TRUE
  )[[1L]]
  bytes = as.integer(x)
  pad = (3L - (n %% 3L)) %% 3L
  if (pad > 0L) bytes = c(bytes, rep.int(0L, pad))

  m = matrix(bytes, ncol = 3L, byrow = TRUE)
  i1 = bitwShiftR(m[, 1L], 2L)
  i2 = bitwOr(
    bitwShiftL(bitwAnd(m[, 1L], 3L), 4L),
    bitwShiftR(m[, 2L], 4L)
  )
  i3 = bitwOr(
    bitwShiftL(bitwAnd(m[, 2L], 15L), 2L),
    bitwShiftR(m[, 3L], 6L)
  )
  i4 = bitwAnd(m[, 3L], 63L)

  out = alphabet[c(rbind(i1, i2, i3, i4)) + 1L]
  if (pad > 0L) {
    out[(length(out) - pad + 1L):length(out)] = "="
  }
  paste0(out, collapse = "")
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
#' L'en-tete reprend la charte eduschool et, lorsqu'elles sont fournies par les
#' QCM, la notion et une courte formule de rappel.
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

  if (is.null(fichier)) fichier = .chemin_fichier_document(exercices, "quiz")
  if (!grepl("\\.html$", fichier, ignore.case = TRUE)) fichier = paste0(fichier, ".html")
  fichier = normalizePath(fichier, mustWork = FALSE)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)

  logo = system.file("figures", "logo-hexa.png", package = "eduschool")
  logo_html = ""
  if (nzchar(logo) && file.exists(logo)) {
    logo_raw = readBin(logo, what = "raw", n = file.info(logo)$size)
    logo_b64 = .base64_raw(logo_raw)
    logo_html = sprintf(
      '<img class="logo-quiz" src="data:image/png;base64,%s" alt="eduschool">',
      logo_b64
    )
  }

  niveaux = unique(vapply(exercices, function(ex) {
    x = ex$niveau_id
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  niveaux = niveaux[nzchar(niveaux)]
  niveau_id = if (length(niveaux) == 1L) niveaux[[1L]] else ""

  cycle_id = if (nzchar(niveau_id)) .cycle_revision(niveau_id) else "NEUTRE"
  accent = couleur_cycle(cycle_id)
  classe = if (nzchar(niveau_id)) libelle_niveau(niveau_id) else "Plusieurs niveaux"

  notions = unique(vapply(exercices, function(ex) {
    x = ex$qcm$notion
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  notions = notions[nzchar(notions)]
  notion = if (length(notions) == 1L) notions[[1L]] else ""

  rappels = unique(vapply(exercices, function(ex) {
    x = ex$qcm$rappel
    if (is.null(x) || length(x) != 1L || is.na(x)) "" else as.character(x)
  }, character(1)))
  rappels = rappels[nzchar(rappels)]
  rappel = if (length(rappels) == 1L) rappels[[1L]] else ""

  notion_html = if (nzchar(notion) || nzchar(rappel)) {
    paste0(
      '<section class="notion">',
      '<div class="notion-label">Notion</div>',
      if (nzchar(notion)) sprintf('<h2>%s</h2>', .html_echapper(notion)) else "",
      if (nzchar(rappel)) sprintf('<div class="rappel">%s</div>', .html_echapper(rappel)) else "",
      '<p>Besoin d\'un rappel ? La fiche de revision est une antis\u00e8che autorisee.</p>',
      '</section>'
    )
  } else {
    ""
  }

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
    intention = if (!is.null(qcm$intention) && length(qcm$intention) == 1L &&
                    !is.na(qcm$intention) && nzchar(qcm$intention)) {
      sprintf('<span class="intention">%s</span>', .html_echapper(qcm$intention))
    } else {
      ""
    }
    sprintf(
      paste0(
        '<section class="question" data-question="%d" data-correct="%d">',
        '<h2><span>Question %d</span>%s</h2><p class="enonce">%s</p>%s',
        '<div class="retour" aria-live="polite"></div>%s</section>'
      ),
      i, qcm$correcte, i, intention, .html_echapper(ex$enonce),
      paste(propositions, collapse = "\n"), feedback
    )
  }, character(1))

  html = c(
    '<!doctype html>', '<html lang="fr">', '<head>',
    '<meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    sprintf('<title>%s</title>', .html_echapper(titre)),
    '<style>',
    '*{box-sizing:border-box}',
    'body{font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;max-width:900px;margin:0 auto;padding:0 1.2rem 2rem;line-height:1.5;color:#202428;background:#fafafa}',
    '.entete{margin:0 -1.2rem 1.4rem;padding:1.1rem 1.4rem 1.25rem;border-top:8px solid var(--accent);border-bottom:1px solid #dfe3e6;background:#fff}',
    '.marque{font-size:1.2rem;font-weight:750;letter-spacing:.01em}.infini{color:var(--accent);font-size:1.35em;vertical-align:-.04em}',
    '.meta-ligne{display:flex;align-items:center;justify-content:space-between;gap:1rem;margin:.65rem 0 .8rem}.meta{display:flex;gap:.5rem;flex-wrap:wrap;margin:0}.meta span{font-size:.82rem;border:1px solid #d8dde0;border-radius:999px;padding:.2rem .6rem;background:#f7f8f8}.logo-quiz{display:block;width:72px;height:auto;flex:0 0 auto}',
    '.entete h1{font-size:clamp(1.7rem,5vw,2.45rem);line-height:1.1;margin:.15rem 0 .35rem}.promesse{margin:0;color:#555}',
    '.notion{border-left:5px solid var(--accent);border-radius:8px;background:#fff;padding:1rem 1.15rem;margin:1.2rem 0 1.6rem;box-shadow:0 1px 4px rgba(0,0,0,.05)}',
    '.notion-label{text-transform:uppercase;letter-spacing:.08em;font-size:.72rem;font-weight:750;color:#666}.notion h2{margin:.2rem 0 .45rem;font-size:1.2rem}',
    '.rappel{font-size:1.35rem;font-weight:750;letter-spacing:.035em;margin:.35rem 0}.notion p{margin:.55rem 0 0;color:#555}',
    '.question{background:#fff;border:1px solid #d7dce0;border-radius:10px;padding:1rem 1.1rem;margin:1.2rem 0;box-shadow:0 1px 3px rgba(0,0,0,.035)}',
    '.question h2{font-size:1.05rem;margin:.1rem 0 .65rem;display:flex;align-items:center;justify-content:space-between;gap:.8rem}',
    '.intention{font-size:.72rem;font-weight:650;text-transform:uppercase;letter-spacing:.06em;color:#666;background:#f2f3f3;border-radius:999px;padding:.2rem .55rem}',
    '.enonce{font-weight:650}.proposition{display:flex;gap:.65rem;align-items:flex-start;padding:.6rem .5rem;border-radius:7px;cursor:pointer}',
    '.proposition:hover{background:#f4f5f6}.proposition input{margin-top:.27rem;accent-color:var(--accent)}',
    '.question.juste{border-left:5px solid #2e7d32;background:#f1f8f2}.question.a-revoir{border-left:5px solid #d97706;background:#fff7ed}.question.sans-reponse{border-left:5px solid #999}',
    '.question.juste .retour{color:#256b2b}.question.a-revoir .retour{color:#b45309}.question.sans-reponse .retour{color:#666}',
    '.retour{margin-top:.8rem;font-weight:750}.feedback-option{display:none;margin-top:.4rem;padding:.65rem .75rem;background:#f6f7f7;border-radius:7px}',
    '.feedback-option.choisie-fausse{border-left:4px solid #d97706;background:#fff7ed}.feedback-option.attendue{border-left:4px solid #2e7d32;background:#f1f8f2}',
    '.actions{display:flex;gap:.75rem;flex-wrap:wrap;margin:1.6rem 0}.actions button{font:inherit;font-weight:650;padding:.7rem 1rem;border:1px solid var(--accent);border-radius:8px;background:#fff;color:#222;cursor:pointer}',
    '.actions #valider{background:var(--accent);color:#fff}.actions button:hover{filter:brightness(.97)}',
    '#bilan{font-size:1.08rem;font-weight:700;margin:1rem 0 2rem;padding:1rem 1.1rem;background:#fff;border-radius:8px;border:1px solid #d7dce0}',
    '#bilan .bilan-juste{color:#256b2b}#bilan .bilan-faux{color:#b45309}#bilan .bilan-vide{color:#666}',
    '@media (max-width:600px){body{padding-left:.8rem;padding-right:.8rem}.entete{margin-left:-.8rem;margin-right:-.8rem}.logo-quiz{width:60px}.question{padding:.9rem}.question h2{align-items:flex-start;flex-direction:column;gap:.35rem}}',
    '</style>', '</head>',
    sprintf('<body style="--accent:%s">', .html_echapper(accent)),
    '<header class="entete">',
    '<div class="marque">edusch<span class="infini">\u221e</span>l <strong>Math</strong></div>',
    '<div class="meta-ligne">',
    sprintf(
      '<div class="meta"><span>%s</span><span>Math\u00e9matiques</span><span>Quiz</span></div>',
      .html_echapper(classe)
    ),
    logo_html,
    '</div>',
    sprintf('<h1>%s</h1>', .html_echapper(titre)),
    '<p class="promesse">Voir les maths autrement. Toujours avec rigueur.</p>',
    '</header>',
    notion_html,
    '<p>Choisis une reponse pour chaque question, puis valide le quiz. Tu peux revenir a la fiche quand tu veux.</p>',
    questions,
    '<div class="actions"><button id="valider" type="button">Valider le quiz</button><button id="reessayer" type="button">Reessayer</button></div>',
    '<div id="bilan" aria-live="polite"></div>',
    '<script>',
    'const questions=[...document.querySelectorAll(".question")];',
    'document.getElementById("valider").addEventListener("click",()=>{',
    ' let bonnes=0; let repondues=0;',
    ' questions.forEach(q=>{',
    '  const choix=q.querySelector("input:checked"); const retour=q.querySelector(".retour");',
    '  q.classList.remove("juste","a-revoir","sans-reponse");',
    '  q.querySelectorAll(".feedback-option").forEach(x=>{x.style.display="none";x.classList.remove("choisie-fausse","attendue");});',
    '  if(!choix){q.classList.add("sans-reponse");retour.textContent="SANS REPONSE \u2014 aucune reponse choisie.";return;}',
    '  repondues++; const ok=choix.value===q.dataset.correct; if(ok){bonnes++;q.classList.add("juste");}else{q.classList.add("a-revoir");}',
    '  const choisie=choix.closest(".proposition").querySelector("span").textContent;',
    '  const correcte=q.querySelector(`input[value="${q.dataset.correct}"]`).closest(".proposition").querySelector("span").textContent;',
    '  retour.textContent=ok?`JUSTE \u2014 ta reponse : ${choisie}.`:`FAUX \u2014 ta reponse : ${choisie}. Reponse correcte : ${correcte}.`;',
    '  const fChoisie=q.querySelector(`.feedback-option[data-option="${choix.value}"]`);',
    '  if(fChoisie){if(!ok)fChoisie.classList.add("choisie-fausse");fChoisie.style.display="block";}',
    '  if(!ok){const fCorrecte=q.querySelector(`.feedback-option[data-option="${q.dataset.correct}"]`);if(fCorrecte){fCorrecte.classList.add("attendue");fCorrecte.style.display="block";}}',
    ' });',
    ' const bilan=document.getElementById("bilan");',
    ' const fausses=repondues-bonnes; const sansReponse=questions.length-repondues;',
    ' bilan.innerHTML=`Bilan : <span class="bilan-juste">${bonnes} reponse(s) correcte(s)</span> \u2014 <span class="bilan-faux">${fausses} reponse(s) fausse(s)</span> \u2014 <span class="bilan-vide">${sansReponse} sans reponse</span>.`;',
    '});',
    'document.getElementById("reessayer").addEventListener("click",()=>{',
    ' document.querySelectorAll("input[type=radio]").forEach(x=>x.checked=false);',
    ' questions.forEach(q=>q.classList.remove("juste","a-revoir","sans-reponse"));',
    ' document.querySelectorAll(".retour").forEach(x=>x.textContent="");',
    ' document.querySelectorAll(".feedback-option").forEach(x=>{x.style.display="none";x.classList.remove("choisie-fausse","attendue");});',
    ' document.getElementById("bilan").textContent=""; window.scrollTo({top:0,behavior:"smooth"});',
    '});',
    '</script>', '</body>', '</html>'
  )

  writeLines(html, fichier, useBytes = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(fichier)
  invisible(fichier)
}
