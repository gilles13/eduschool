# Audit editorial des banques JSON, hors runtime eduschool.
# Charger avec source("tools/audit_banques.R"), puis audit_banques().
audit_banques = function(notions = NULL, racine = ".", sortie = file.path("/tmp", "eduschool-audit"), ouvrir = interactive(), verbose = TRUE) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) stop("Installer jsonlite")
  racine = normalizePath(racine, mustWork = TRUE)
  dossier = file.path(racine, "inst", "notions")
  if (!dir.exists(dossier)) stop("Dossier inst/notions introuvable : ", dossier)
  if (is.null(notions)) {
    fichiers = list.files(dossier, pattern = "^questions[.]json$", recursive = TRUE, full.names = TRUE)
    notions = sort(unique(basename(dirname(fichiers))))
  }
  if (!is.character(notions) || anyNA(notions) || any(!nzchar(notions))) stop("notions doit etre un vecteur de noms non vides, ou NULL")
  dir.create(sortie, recursive = TRUE, showWarnings = FALSE)
  issues = list()
  instances = list()
  add_issue = function(notion, id, variante, severite, controle, detail) {
    issues[[length(issues) + 1L]] <<- data.frame(notion = notion, id = id, variante = variante, severite = severite, controle = controle, detail = detail)
  }
  substituer = function(texte, params) {
    if (is.null(texte) || length(texte) != 1L || is.na(texte)) return("")
    for (cle in names(params)) texte = gsub(paste0("[[", cle, "]]"), as.character(params[[cle]]), texte, fixed = TRUE)
    texte
  }
  reste_placeholder = function(texte) grepl("\\[\\[[^]]+\\]\\]", texte)
  valeur_rationnelle = function(x) {
    # Controle restreint aux nombres et fractions simples, sans interpreter des expressions.
    z = trimws(x)
    z = gsub("\\(", "", z, fixed = TRUE)
    z = gsub("\\)", "", z, fixed = TRUE)
    z = gsub("\\\\frac\\{(-?[0-9]+)\\}\\{([0-9]+)\\}", "\\1/\\2", z)
    if (!grepl("^-?[0-9]+(\\.[0-9]+)?(/[0-9]+)?$", z)) return(NA_real_)
    morceaux = strsplit(z, "/", fixed = TRUE)[[1]]
    if (length(morceaux) == 1L) return(as.numeric(morceaux))
    if (as.numeric(morceaux[2]) == 0) return(NA_real_)
    as.numeric(morceaux[1]) / as.numeric(morceaux[2])
  }
  # Controles editoriaux independants des reponses JSON (hors runtime).
  controle_math = function(notion, id, p, reponse, propositions) {
    resultat = list(statut = "NON_VERIFIE", detail = "")
    if (identical(notion, "statistiques_comparaison_series") && identical(id, "COMP-STAT-001")) {
      a = suppressWarnings(as.numeric(p$e1))
      b = suppressWarnings(as.numeric(p$e2))
      if (length(a) != 1L || length(b) != 1L || !is.finite(a) || !is.finite(b)) return(resultat)
      attendu = if (a < b) "B" else if (a > b) "A" else "egalite"
      # Cette banque annonce toujours une etendue B strictement plus grande.
      annonce_b = grepl("B est plus dispers", reponse, fixed = TRUE)
      # On ne certifie pas les autres conclusions textuelles avec ce controle limite.
      resultat$statut = if (attendu != "B" && annonce_b) "ERREUR" else "NON_VERIFIE"
      resultat$detail = paste0("Etendues recalculees : A=", a, ", B=", b, "; conclusion : ", attendu, "; reponse JSON : ", reponse)
      return(resultat)
    }
    if (identical(notion, "probabilites_experience_aleatoire") && identical(id, "PROBA-BASE-001")) {
      f = suppressWarnings(as.numeric(p$favorables))
      t = suppressWarnings(as.numeric(p$total))
      if (length(f) != 1L || length(t) != 1L || !is.finite(f) || !is.finite(t) || t <= 0 || f < 0 || f > t) return(resultat)
      attendu = f / t
      rep = valeur_rationnelle(reponse)
      valeurs = vapply(propositions, valeur_rationnelle, numeric(1))
      if (!is.finite(rep) || !length(valeurs) || any(!is.finite(valeurs))) return(resultat)
      correctes = which(abs(valeurs - attendu) < 1e-12)
      ok = abs(rep - attendu) < 1e-12 && length(correctes) == 1L
      resultat$statut = if (ok) "VALIDE" else "ERREUR"
      resultat$detail = paste0("P(A) = ", f, "/", t, " = ", format(attendu), "; reponse JSON = ", reponse, "; propositions mathematiquement correctes : ", paste(correctes, collapse = ", "))
      return(resultat)
    }
    resultat
  }
  audit_notion = function(notion) {
    chemin = file.path(racine, "inst", "notions", notion, "questions.json")
    if (!file.exists(chemin)) { add_issue(notion, "", 0L, "ERREUR", "fichier", "questions.json absent"); return(invisible(NULL)) }
    banque = tryCatch(jsonlite::fromJSON(chemin, simplifyVector = FALSE), error = function(e) e)
    if (inherits(banque, "error")) { add_issue(notion, "", 0L, "ERREUR", "json", conditionMessage(banque)); return(invisible(NULL)) }
    if (!identical(banque$notion_id, notion)) add_issue(notion, "", 0L, "ERREUR", "notion_id", "Incoherence dossier / notion_id")
    if (is.null(banque$questions)) { add_issue(notion, "", 0L, "ERREUR", "questions", "Champ questions absent"); return(invisible(NULL)) }
    ids = vapply(banque$questions, function(q) if (is.null(q$id)) "" else as.character(q$id), character(1))
    if (anyDuplicated(ids)) add_issue(notion, "", 0L, "ERREUR", "identifiants", "IDs de modeles dupliques")
    for (q in banque$questions) {
      id = if (is.null(q$id)) "(sans id)" else q$id
      variantes = if (is.null(q$variantes) || !length(q$variantes)) list(list(parametres = list())) else q$variantes
      for (i in seq_along(variantes)) {
        p = variantes[[i]]$parametres
        if (is.null(p)) p = list()
        enonce = substituer(q$enonce, p)
        reponse = substituer(q$reponse, p)
        correction = substituer(q$correction, p)
        propositions = if (is.null(q$propositions)) character() else vapply(q$propositions, substituer, character(1), params = p)
        champs = c(enonce, reponse, correction, propositions)
        if (any(vapply(champs, reste_placeholder, logical(1)))) add_issue(notion, id, i, "ERREUR", "placeholders", "Variable [[...]] non substituee")
        if (!nzchar(trimws(enonce))) add_issue(notion, id, i, "ERREUR", "enonce", "Enonce vide")
        if (!nzchar(trimws(reponse))) add_issue(notion, id, i, "ERREUR", "reponse", "Reponse vide")
        if (!nzchar(trimws(correction))) add_issue(notion, id, i, "AVERTISSEMENT", "correction", "Correction vide")
        if (length(propositions)) {
          if (sum(propositions == reponse) != 1L) add_issue(notion, id, i, "ERREUR", "cle_qcm", "La reponse n'apparait pas exactement une fois")
          if (anyDuplicated(propositions)) add_issue(notion, id, i, "ERREUR", "collision_texte", "Propositions identiques")
          rationnels = vapply(propositions, valeur_rationnelle, numeric(1))
          if (length(rationnels) > 1L && all(is.finite(rationnels)) && anyDuplicated(round(rationnels, 12))) add_issue(notion, id, i, "ERREUR", "collision_fraction", "Propositions numeriquement equivalentes (controle limite aux rationnels simples)")
        }
        verif = controle_math(notion, id, p, reponse, propositions)
        if (identical(verif$statut, "ERREUR")) add_issue(notion, id, i, "ERREUR", "calcul_independant", verif$detail)
        instances[[length(instances) + 1L]] <<- data.frame(notion = notion, id = id, variante = i, type = if (is.null(q$type)) "" else q$type, enonce = enonce, reponse = reponse, correction = correction, propositions = paste(propositions, collapse = " || "), controle_math = verif$statut, detail_math = verif$detail)
      }
    }
  }
  for (notion in notions) audit_notion(notion)
  instances_df = if (length(instances)) do.call(rbind, instances) else data.frame()
  issues_df = if (length(issues)) do.call(rbind, issues) else data.frame(notion = character(), id = character(), variante = integer(), severite = character(), controle = character(), detail = character())
  write.csv(instances_df, file.path(sortie, "instances.csv"), row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(issues_df, file.path(sortie, "anomalies.csv"), row.names = FALSE, fileEncoding = "UTF-8")
  # Referentiel editorial : une notion peut figurer a plusieurs niveaux.
  ref_path = file.path(racine, "inst", "referentiels", "editorial_familles_notions.csv")
  familles = if (file.exists(ref_path)) utils::read.csv2(ref_path, stringsAsFactors = FALSE) else data.frame()
  famille_de = function(notion) {
    if (!all(c("notion", "libelle_famille") %in% names(familles))) return("Famille non renseignee")
    x = unique(familles$libelle_famille[familles$notion == notion])
    if (!length(x)) "Famille non renseignee" else paste(x, collapse = " / ")
  }
  if (nrow(instances_df)) instances_df$famille = vapply(instances_df$notion, famille_de, character(1))
  if (nrow(issues_df)) issues_df$famille = vapply(issues_df$notion, famille_de, character(1))
  toutes_familles = unique(c(if (nrow(instances_df)) instances_df$famille else character(), if (nrow(issues_df)) issues_df$famille else character()))
  bilan = do.call(rbind, lapply(toutes_familles, function(f) {
    a = if (nrow(issues_df)) issues_df[issues_df$famille == f, , drop = FALSE] else issues_df
    q = if (nrow(instances_df)) instances_df[instances_df$famille == f, , drop = FALSE] else instances_df
    data.frame(famille = f, notions = length(unique(c(as.character(q$notion), as.character(a$notion)))), variantes = nrow(q),
      erreurs = sum(a$severite == "ERREUR"), avertissements = sum(a$severite == "AVERTISSEMENT"),
      math_valides = sum(q$controle_math == "VALIDE"), non_verifies = sum(q$controle_math != "VALIDE"), stringsAsFactors = FALSE)
  }))
  if (is.null(bilan)) bilan = data.frame(famille = character(), notions = integer(), variantes = integer(), erreurs = integer(), avertissements = integer(), math_valides = integer(), non_verifies = integer())
  write.csv(bilan, file.path(sortie, "bilan.csv"), row.names = FALSE, fileEncoding = "UTF-8")
  html = function(z) {
    z = as.character(z)
    z = gsub("&", "&amp;", z, fixed = TRUE)
    z = gsub("<", "&lt;", z, fixed = TRUE)
    z = gsub(">", "&gt;", z, fixed = TRUE)
    z = gsub('"', "&quot;", z, fixed = TRUE)
    z
  }
  # Le JSON contient du texte et du LaTeX, pas du Markdown a transformer en table.
  texte_html = function(z) paste0('<div class="contenu">', gsub("\n", "<br>", html(z), fixed = TRUE), '</div>')
  anomalies_html = if (!nrow(issues_df)) {
    "<p>Aucune anomalie detectee par les controles implementes.</p>"
  } else {
    paste(vapply(seq_len(nrow(issues_df)), function(i) {
      a = issues_df[i, ]
      paste0('<article class="anomalie"><strong>', html(a$severite), '</strong> — ', html(a$notion),
             ' / ', html(a$id), ' / variante ', a$variante, '<p>', html(a$controle), ' : ', html(a$detail), '</p></article>')
    }, character(1)), collapse = "\n")
  }
  statut = function(erreurs, avertissements, non_verifies) {
    if (erreurs > 0L) return(c("rouge", "Erreurs"))
    if (avertissements > 0L) return(c("orange", "Avertissements"))
    if (non_verifies > 0L) return(c("jaune", "A verifier"))
    c("vert", "Valide")
  }
  total = c(erreurs = sum(issues_df$severite == "ERREUR"), avertissements = sum(issues_df$severite == "AVERTISSEMENT"),
    variantes = nrow(instances_df), math_valides = sum(instances_df$controle_math == "VALIDE"), non_verifies = sum(instances_df$controle_math != "VALIDE"))
  synthese = paste0('<section id="bilan"><h2>Bilan</h2><div class="indicateurs">',
    paste(vapply(names(total), function(n) paste0('<div class="indicateur"><strong>', total[[n]], '</strong><span>', html(gsub("_", " ", n, fixed = TRUE)), '</span></div>'), character(1)), collapse = ""), '</div>',
    '<p class="note">Le vert exige une validation mathematique effective. Une question non verifiee reste jaune, meme sans anomalie structurelle.</p>',
    '<h3>Par famille</h3><div class="table-wrap"><table><thead><tr><th>Famille</th><th>Notions</th><th>Variantes</th><th>Erreurs</th><th>Avertissements</th><th>Math. valides</th><th>Non verifiees</th><th>Statut</th></tr></thead><tbody>',
    paste(vapply(seq_len(nrow(bilan)), function(i) {
      b = bilan[i, ]; etat = statut(b$erreurs, b$avertissements, b$non_verifies)
      paste0('<tr><td>', html(b$famille), '</td>', paste0('<td>', c(b$notions,b$variantes,b$erreurs,b$avertissements,b$math_valides,b$non_verifies), '</td>', collapse = ""),
        '<td><span class="pastille ', etat[1], '">', etat[2], '</span></td></tr>')
    }, character(1)), collapse = ""), '</tbody></table></div></section>')
  question_html = if (!nrow(instances_df)) {
    "<p>Aucune question instanciee.</p>"
  } else {
    paste(vapply(seq_len(nrow(instances_df)), function(i) {
      q = instances_df[i, ]
      options = strsplit(q$propositions, " || ", fixed = TRUE)[[1]]
      choix = if (!nzchar(q$propositions)) "" else paste0('<ol class="choix">',
        paste0('<li>', vapply(options, texte_html, character(1)), '</li>', collapse = ""), '</ol>')
      paste0('<details class="question" open><summary><span class="numero">', html(q$notion),
        '</span> <code>', html(q$id), '</code> · variante ', q$variante,
        ' <small>', html(q$type), '</small></summary>',
        '<div class="bloc"><h3>Enonce</h3>', texte_html(q$enonce), '</div>',
        if (nzchar(choix)) paste0('<div class="bloc"><h3>Propositions</h3>', choix, '</div>') else "",
        '<div class="bloc"><h3>Reponse</h3>', texte_html(q$reponse), '</div>',
        '<div class="bloc"><h3>Correction</h3>', texte_html(q$correction), '</div>',
        '<p class="limite" style="font-weight:bold;color:', if (q$controle_math == 'ERREUR') '#b42318' else if (q$controle_math == 'VALIDE') '#12632d' else '#705900', '">Verification mathematique : ', html(q$controle_math), '</p>', if (nzchar(q$detail_math)) texte_html(q$detail_math) else '', '</details>')
    }, character(1)), collapse = "\n")
  }
  style = paste0('<style>',
    'body{font:16px/1.55 system-ui,sans-serif;max-width:1050px;margin:2rem auto;padding:0 1rem;color:#202124;background:#fafafa}',
    'h1,h2{line-height:1.2}h3{font-size:.88rem;text-transform:uppercase;color:#526071;margin:0 0 .35rem}',
    '.question,.anomalie{background:white;border:1px solid #d6dce3;border-radius:9px;margin:.7rem 0;padding:.8rem 1rem}',
    '.question summary{cursor:pointer;font-weight:600;overflow-wrap:anywhere}',
    '.question[open] summary{border-bottom:1px solid #eee;padding-bottom:.7rem;margin-bottom:.8rem}',
    '.numero{font-weight:700}.bloc{margin:.85rem 0}.contenu{overflow-wrap:anywhere;white-space:normal}',
    '.choix{padding-left:2rem}.choix li{margin:.45rem 0}.limite{font-size:.85rem;color:#667085}',
    '.anomalie{border-left:4px solid #b42318}.anomalie p{margin:.25rem 0 0}',
    '.indicateurs{display:flex;flex-wrap:wrap;gap:.6rem}.indicateur{background:white;border:1px solid #ddd;border-radius:8px;padding:.6rem 1rem;min-width:115px}.indicateur strong{display:block;font-size:1.7rem}.indicateur span{font-size:.85rem}',
    '.table-wrap{overflow-x:auto}table{border-collapse:collapse;width:100%;background:white}th,td{border:1px solid #ddd;padding:.5rem;text-align:left}th{background:#eee}',
    '.pastille{border-radius:6px;padding:.25rem .5rem;font-weight:700;white-space:nowrap}.rouge{background:#fce8e6;color:#9b1c1c}.orange{background:#fff0d5;color:#8c4a00}.jaune{background:#fff9c4;color:#705900}.vert{background:#def4e4;color:#12632d}',
    '.commandes{position:sticky;top:0;background:#fafafa;padding:.6rem 0;z-index:2;display:flex;gap:.5rem}button{cursor:pointer;padding:.5rem .8rem;border:1px solid #aaa;border-radius:6px;background:white}',
    'code{font-size:.9em}small{color:#667085} .note{color:#555}',
    '</style>')
  # MathJax rend les expressions LaTeX du JSON (\\(...\\) et \\[...\\]).
  mathjax = paste0('<script>window.MathJax={tex:{inlineMath:[["\\\\(","\\\\)"],["$","$"]],',
    'displayMath:[["\\\\[","\\\\]"]]}};</script>',
    '<script defer src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>')
  page = paste0('<!doctype html><html lang="fr"><head><meta charset="utf-8">',
    '<meta name="viewport" content="width=device-width,initial-scale=1">',
    '<title>Audit eduschool</title>', style, mathjax, '</head><body>',
    '<h1>Audit des banques eduschool</h1>',
    '<p class="note">', nrow(instances_df), ' variantes. Cliquer sur une question pour afficher son contenu. ',
    'Les calculs ne sont verifies que pour les modeles explicitement couverts. Les corrections et figures ne sont pas validees.</p>',
    synthese, '<h2>Anomalies (', nrow(issues_df), ')</h2>', anomalies_html,
    '<h2>Questions instanciees</h2><div class="commandes"><button type="button" onclick="document.querySelectorAll(&quot;details.question&quot;).forEach(x=>x.open=true)">Tout deplier</button><button type="button" onclick="document.querySelectorAll(&quot;details.question&quot;).forEach(x=>x.open=false)">Tout replier</button></div>',
    question_html, '</body></html>')
  writeLines(page, file.path(sortie, "audit.html"), useBytes = TRUE)
  if (isTRUE(verbose)) cat("Instances :", nrow(instances_df), "\nAnomalies :", nrow(issues_df), "\nSortie :", sortie, "\n")
  if (isTRUE(ouvrir)) utils::browseURL(file.path(sortie, "audit.html"))
  invisible(list(instances = instances_df, anomalies = issues_df, bilan = bilan, html = file.path(sortie, "audit.html"), dossier = sortie))
}
