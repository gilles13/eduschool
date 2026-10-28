
graphique_tableau = function(illustration = NULL, donnees = NULL, titre = NULL) {
  if (is.data.frame(illustration)) {
    donnees = illustration
  } else if (!is.null(illustration)) {
    donnees = illustration$donnees
    if (!is.null(illustration$titre)) titre = illustration$titre
  }
  if (!is.data.frame(donnees) || !nrow(donnees) || !ncol(donnees)) stop("Fournir un data.frame non vide.")
  if (anyNA(donnees)) stop("Les valeurs manquantes doivent être affichées explicitement.")
  valeurs = lapply(donnees, as.character)
  entetes = names(donnees)
  if (is.null(entetes) || any(!nzchar(entetes))) stop("Toutes les colonnes doivent avoir un nom.")
  contenu = rbind(entetes, do.call(cbind, valeurs))
  n = nrow(contenu)
  p = ncol(contenu)
  largeurs = vapply(seq_len(p), function(j) {
  textes = contenu[, j]
  mesures = vapply(seq_along(textes), function(i) {
    grid::convertWidth(
      grid::grobWidth(grid::textGrob(
        textes[i],
        gp = grid::gpar(
          fontsize = 9,
          fontface = if (i == 1L) "bold" else "plain"
        )
      )),
      "cm",
      valueOnly = TRUE
    )
  }, numeric(1))
  max(1.1, max(mesures) + .5)
}, numeric(1))
  hauteur_ligne = .42
  largeur = sum(largeurs)
  hauteur = n * hauteur_ligne + if (is.null(titre)) 0 else .55
  centres_x = (cumsum(largeurs) - largeurs / 2) / largeur
  objets = list()
  k = 0L
  for (i in seq_len(n)) for (j in seq_len(p)) {
    x = centres_x[j]
    y = 1 - ((i - .5) * hauteur_ligne + if (is.null(titre)) 0 else .55) / hauteur
    k = k + 1L
    objets[[k]] = grid::rectGrob(
      x = x,
      y = y,
      width = largeurs[j] / largeur,
      height = hauteur_ligne / hauteur,
      gp = grid::gpar(
        fill = if (i == 1L) "#e8edf2" else "white",
        col = "#666666",
        lwd = .8
      )
    )
    k = k + 1L
    objets[[k]] = grid::textGrob(
      contenu[i, j],
      x = x,
      y = y,
      gp = grid::gpar(
        fontsize = 9,
        fontface = if (i == 1L) "bold" else "plain"
      )
    )
  }
  if (!is.null(titre)) {
    k = k + 1L
    objets[[k]] = grid::textGrob(
      titre,
      x = .5,
      y = 1 - .275 / hauteur,
      gp = grid::gpar(fontsize = 11, fontface = "bold")
    )
  }
  figure = grid::gTree(
    children = do.call(grid::gList, objets),
    vp = grid::viewport(
      width = grid::unit(largeur, "cm"),
      height = grid::unit(hauteur, "cm")
    )
  )
  attr(figure, "eduschool_dimensions") = c(largeur, hauteur)
  figure
}

