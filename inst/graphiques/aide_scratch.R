# Aide visuelle ponctuelle pour la syntaxe et les couleurs Scratch.
source("inst/graphiques/algo_scratch.R")
bloc = function(type, niveau, texte, fin = NULL) {
  list(type = type, niveau = niveau, texte = texte, fin = fin)
}
exemples = list(
  list(
    titre = "1. Variables et affichage",
    explication = "Jaune : evenement | Orange : variables | Violet : apparence",
    blocs = list(
      bloc("evenement", 0, "Quand le drapeau est cliqu\u00e9"),
      bloc("variable", 0, "Mettre score \u00e0 0"),
      bloc("variable", 0, "Ajouter 10 \u00e0 score"),
      bloc("apparence", 0, "Afficher score")
    )
  ),
  list(
    titre = "2. Repeter une action",
    explication = "Orange clair : controle | Bleu : mouvement",
    blocs = list(
      bloc("evenement", 0, "Quand le drapeau est cliqu\u00e9"),
      bloc("controle", 0, "R\u00e9p\u00e9ter 4 fois :", fin = 4),
      bloc("mouvement", 1, "Avancer de 100 pas"),
      bloc("mouvement", 1, "Tourner de 90 degr\u00e9s")
    )
  ),
  list(
    titre = "3. Tester une condition",
    explication = "Le controle orange utilise une comparaison verte.",
    blocs = list(
      bloc("evenement", 0, "Quand le drapeau est cliqu\u00e9"),
      bloc("variable", 0, "Mettre x \u00e0 12"),
      bloc("controle", 0, "Si x > 10 :", fin = 4),
      bloc("apparence", 1, "Dire Bravo"),
      bloc("apparence", 0, "Dire Fin")
    )
  ),
  list(
    titre = "4. Repeter jusqu'a une condition",
    explication = "La boucle s'arrete lorsque total atteint 100.",
    blocs = list(
      bloc("evenement", 0, "Quand le drapeau est cliqu\u00e9"),
      bloc("variable", 0, "Mettre total \u00e0 0"),
      bloc("controle", 0, "R\u00e9p\u00e9ter jusqu'\u00e0 total >= 100 :", fin = 4),
      bloc("variable", 1, "Ajouter 15 \u00e0 total"),
      bloc("apparence", 0, "Afficher total")
    )
  )
)
graphiques = lapply(exemples, function(e) {
  graphique_algo_scratch(illustration = list(blocs = e$blocs))
})
grDevices::dev.new(width = 16, height = 12)
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(2, 2)))
for (i in seq_along(exemples)) {
  ligne = (i - 1) %/% 2 + 1
  colonne = (i - 1) %% 2 + 1
  grid::pushViewport(grid::viewport(layout.pos.row = ligne, layout.pos.col = colonne))
  grid::grid.text(exemples[[i]]$titre, x = 0.5, y = 0.96, gp = grid::gpar(fontsize = 15, fontface = "bold"))
  grid::grid.text(exemples[[i]]$explication, x = 0.5, y = 0.89, gp = grid::gpar(fontsize = 10))
  print(graphiques[[i]], vp = grid::viewport(y = 0.43, height = 0.78), newpage = FALSE)
  grid::popViewport()
}
grid::popViewport()
