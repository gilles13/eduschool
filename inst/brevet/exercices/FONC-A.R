construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  figure = file.path(dossier, paste0(sujet, ".png"))
  p = env$graphique_fonctions(fonctions = list("Offre A" = c(d$fixe, d$tarif_a), "Offre B" = c(0, d$tarif_b)), xmax = d$xmax)
  ragg::agg_png(figure, width = 1200, height = 750, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Une entreprise propose deux formules de location de v\u00e9los. L'offre A comprend %s euros de frais fixes puis %s euros par heure. L'offre B co\u00fbte %s euros par heure, sans frais fixes. Les locations sont factur\u00e9es par heures enti\u00e8res. Le graphique ci-dessous repr\u00e9sente les deux tarifs selon la dur\u00e9e de location.", d$fixe, d$tarif_a, d$tarif_b)
  questions = c(
    sprintf("Combien co\u00fbte une location de %s heures avec l'offre A ?", d$duree),
    "Exprimer le co\u00fbt de l'offre A en fonction du nombre x d'heures de location.",
    "Pour quelle dur\u00e9e les deux offres co\u00fbtent-elles le m\u00eame prix ? Justifier.",
    "Quelle offre est la plus avantageuse pour une heure de location ? Et pour huit heures ? Justifier.",
    "\u00c0 partir de combien d\u0027heures enti\u00e8res l\u0027offre A devient-elle strictement moins ch\u00e8re que l\u0027offre B ? Justifier."
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    sprintf("1. Pour %s heures, l'offre A co\u00fbte %s + %s \u00d7 %s = **%s euros**.", d$duree, d$fixe, d$tarif_a, d$duree, r$cout_a),
    sprintf("2. Le co\u00fbt de l'offre A est **%s** euros pour x heures.", r$expression_a),
    sprintf("3. On cherche l'\u00e9galit\u00e9 : %s + %sx = %sx, soit x = **%s heures**. Chaque offre co\u00fbte alors %s euros.", d$fixe, d$tarif_a, d$tarif_b, r$intersection, r$cout_egal),
    sprintf("4. Pour une heure : A = %s euros et B = %s euros, donc **offre %s**. Pour huit heures : A = %s euros et B = %s euros, donc **offre %s**.", d$fixe + d$tarif_a, d$tarif_b, r$offre_1h, d$fixe + 8 * d$tarif_a, 8 * d$tarif_b, r$offre_8h),
    sprintf("5. Les deux offres co\u00fbtent le m\u00eame prix pour %s heures. L\u0027offre A devient strictement moins ch\u00e8re au-del\u00e0 de cette dur\u00e9e, donc d\u00e8s **%s heures enti\u00e8res**.", r$intersection, r$seuil_a),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, figure = figure, points = points, total_points = exercice$total_points)
}
