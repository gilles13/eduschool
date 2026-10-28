construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  fmt = function(x) format(x, trim = TRUE, scientific = FALSE, decimal.mark = ",")
  figure = file.path(dossier, paste0(sujet, ".png"))
  lib_a = c(longueur = "x", largeur = paste0(fmt(d$hauteur_a), " m"))
  lib_b = c(longueur = paste0("x - ", fmt(d$ecart_b)), largeur = paste0(fmt(d$hauteur_b), " m"))
  pa = env$graphique_rectangle(longueur = r$x, largeur = d$hauteur_a, libelles = lib_a, titre = "Jardin A")
  pb = env$graphique_rectangle(longueur = r$x - d$ecart_b, largeur = d$hauteur_b, libelles = lib_b, titre = "Jardin B")
  ragg::agg_png(figure, width = 1600, height = 800, res = 150)
  tryCatch({
    grid::grid.newpage()
    grid::pushViewport(grid::viewport(layout = grid::grid.layout(1, 2)))
    print(pa, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1), newpage = FALSE)
    print(pb, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 2), newpage = FALSE)
  }, finally = grDevices::dev.off())
  enonce = sprintf("Un paysagiste am\u00e9nage deux jardins rectangulaires A et B de m\u00eame aire. La longueur du c\u00f4t\u00e9 horizontal du jardin A est not\u00e9e x, en m\u00e8tres. Le c\u00f4t\u00e9 horizontal du jardin B mesure %s m de moins que celui du jardin A. Les autres dimensions figurent sur les dessins, qui ne sont pas n\u00e9cessairement \u00e0 l'\u00e9chelle. Le paysagiste souhaite ensuite entourer enti\u00e8rement chaque jardin d'une cl\u00f4ture, sans ouverture.", fmt(d$ecart_b))
  questions = c("Exprimer l'aire du jardin A en fonction de x.", "Exprimer l'aire du jardin B en fonction de x.", "D\u00e9terminer la valeur de x. Justifier la r\u00e9ponse.", "Calculer la longueur de cl\u00f4ture n\u00e9cessaire pour chacun des jardins. Quel jardin n\u00e9cessite le moins de cl\u00f4ture, et de combien de m\u00e8tres ?")
  points = exercice$points
  questions = paste0(seq_along(questions), ". ", questions, " **(", fmt(points), " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  ha = d$hauteur_a
  hb = d$hauteur_b
  delta = d$ecart_b
  moins = if (r$perimetre_a < r$perimetre_b) "A" else if (r$perimetre_b < r$perimetre_a) "B" else "aucun des deux"
  correction = paste("## Corrig\u00e9 - Exercice 1", sprintf("1. Aire du jardin A : %sx m\u00b2.", fmt(ha)), sprintf("2. Aire du jardin B : %s(x - %s) m\u00b2.", fmt(hb), fmt(delta)), sprintf("3. Les aires sont \u00e9gales : %sx = %s(x - %s).", fmt(ha), fmt(hb), fmt(delta)), sprintf("En d\u00e9veloppant : %sx = %sx - %s.", fmt(ha), fmt(hb), fmt(hb * delta)), sprintf("En regroupant : %s = %sx.", fmt(hb * delta), fmt(hb - ha)), sprintf("En divisant par %s : **x = %s m**. Chaque aire vaut %s m\u00b2.", fmt(hb - ha), fmt(r$x), fmt(r$aire_a)), sprintf("4. Longueurs de cl\u00f4ture : A = 2 \u00d7 (%s + %s) = **%s m** ; B = 2 \u00d7 (%s + %s) = **%s m**. Le jardin %s n\u00e9cessite le moins de cl\u00f4ture, avec **%s m** de moins.", fmt(r$x), fmt(ha), fmt(r$perimetre_a), fmt(r$x - delta), fmt(hb), fmt(r$perimetre_b), moins, fmt(r$difference_cloture)), sep = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, figure = figure, points = points, total_points = exercice$total_points)
}
