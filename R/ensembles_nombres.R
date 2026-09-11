# Ensembles de nombres : une premiere notion complete et reutilisable

#' Ensembles de nombres usuels
#'
#' Retourne la petite table pedagogique utilisee par les fiches, schemas et
#' exercices consacres aux ensembles de nombres en seconde.
#'
#' @return Un data.frame ordonne de N a R.
#' @export
ensembles_nombres = function() {
  x = .lire_csv("mathematiques", "ensembles_nombres.csv")
  x$ordre = as.integer(x$ordre)
  x = x[order(x$ordre), , drop = FALSE]
  rownames(x) = NULL
  x
}

.ellipse_ensembles = function(cx = 0, cy = 0, rx = 1, ry = 1, n = 300L) {
  angle = seq(0, 2 * pi, length.out = n)
  data.frame(
    x = cx + rx * cos(angle),
    y = cy + ry * sin(angle)
  )
}

#' Diagramme des ensembles de nombres
#'
#' Produit avec ggplot2 un schema d'ovales emboites montrant les inclusions
#' N dans Z, Z dans D, D dans Q et Q dans R.
#'
#' @return Un objet ggplot.
#' @export
diagramme_ensembles_nombres = function() {
  x = ensembles_nombres()

  rayons_x = c(1.65, 2.55, 3.35, 4.15, 4.95)
  rayons_y = c(0.78, 1.40, 2.05, 2.72, 3.42)
  centres_y = c(-1.02, -0.78, -0.53, -0.27, 0)

  formes = lapply(seq_len(nrow(x)), function(i) {
    z = .ellipse_ensembles(
      rx = rayons_x[[i]],
      ry = rayons_y[[i]],
      cy = centres_y[[i]]
    )
    z$code = x$code[[i]]
    z$ordre = x$ordre[[i]]
    z
  })
  formes = do.call(rbind, formes)

  # Les grands ensembles sont dessines d'abord afin de laisser visibles
  # les ensembles plus petits qui viennent ensuite.
  formes$ordre_trace = 6L - formes$ordre
  formes = formes[order(formes$ordre_trace), , drop = FALSE]

  labels = data.frame(
    code = x$code,
    symbole = x$symbole,
    nom = x$nom,
    x = 0,
    y = centres_y + rayons_y * 0.62,
    stringsAsFactors = FALSE
  )

  chaine = paste(x$symbole, collapse = " \u2282 ")

  ggplot2::ggplot() +
    ggplot2::geom_polygon(
      data = formes,
      ggplot2::aes(x = x, y = y, group = code, fill = code),
      alpha = 0.24,
      linewidth = 0.8
    ) +
    ggplot2::geom_text(
      data = labels,
      ggplot2::aes(x = x, y = y, label = paste(symbole, "-", nom)),
      fontface = "bold",
      size = 4.5
    ) +
    ggplot2::annotate(
      "text",
      x = 0,
      y = -4.05,
      label = chaine,
      size = 6,
      fontface = "bold"
    ) +
    ggplot2::coord_fixed(
      xlim = c(-5.35, 5.35),
      ylim = c(-4.4, 3.7),
      clip = "off"
    ) +
    ggplot2::labs(
      title = "Les ensembles de nombres",
      subtitle = "Un element appartient ; un ensemble est inclus."
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 20, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12),
      legend.position = "none",
      plot.margin = ggplot2::margin(12, 12, 12, 12)
    )
}

.qcm_ensembles = function(modele_id, enonce, reponse, propositions, feedback,
                           intention, seed) {
  if (!is.null(seed)) set.seed(seed)
  ordre = sample(seq_along(propositions))
  correcte = match(reponse, propositions[ordre])

  creer_exercice(
    modele_id = modele_id,
    niveau_id = "2GT",
    capacite_id = NA_character_,
    difficulte = 1,
    enonce = enonce,
    reponse = reponse,
    correction = feedback[[match(reponse, propositions)]],
    parametres = list(),
    seed = seed,
    qcm = list(
      intention = intention,
      propositions = propositions[ordre],
      correcte = correcte,
      feedback = feedback[ordre]
    )
  )
}

#' Cinq rappels sur les ensembles de nombres
#'
#' Construit cinq QCM courts sur les inclusions usuelles, les plus petits
#' ensembles contenant quelques nombres et la difference entre appartenance
#' et inclusion. Le resultat peut etre passe directement a [produire_quiz()].
#'
#' @param seed Graine facultative utilisee pour melanger les propositions.
#' @return Une liste de cinq exercices eduschool munis d'un QCM.
#' @examples
#' \dontrun{
#' exercices_ensembles_nombres(seed = 2026) |>
#'   produire_quiz(titre = "Mes 5 rappels sur les ensembles")
#' }
#' @export
exercices_ensembles_nombres = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 5L) else as.list(seed + 0:4)

  list(
    .qcm_ensembles(
      "ENS_N_001",
      "Quel est le plus petit ensemble usuel contenant le nombre 3 ?",
      "\u2115",
      c("\u2115", "\u2124", "\u211a", "\u211d"),
      c(
        "3 est un entier naturel : 3 appartient a N.",
        "3 appartient aussi a Z, mais N est un ensemble plus petit.",
        "3 appartient aussi a Q, mais N est un ensemble plus petit.",
        "3 appartient aussi a R, mais N est un ensemble plus petit."
      ),
      "reconnaitre", graines[[1L]]
    ),
    .qcm_ensembles(
      "ENS_Z_001",
      "Quel est le plus petit ensemble usuel contenant le nombre -2 ?",
      "\u2124",
      c("\u2115", "\u2124", "\U0001D53B", "\u211a"),
      c(
        "Les naturels ne contiennent pas les entiers strictement negatifs.",
        "-2 est un entier relatif : -2 appartient a Z.",
        "-2 a une ecriture decimale finie, mais Z est un ensemble plus petit.",
        "-2 est rationnel, mais Z est un ensemble plus petit."
      ),
      "classer", graines[[2L]]
    ),
    .qcm_ensembles(
      "ENS_D_001",
      "Quel est le plus petit ensemble usuel contenant 0,25 ?",
      "\U0001D53B",
      c("\u2115", "\u2124", "\U0001D53B", "\u211a"),
      c(
        "0,25 n'est pas un entier naturel.",
        "0,25 n'est pas un entier relatif.",
        "0,25 a une ecriture decimale finie : il appartient a D.",
        "0,25 est rationnel, mais D est un ensemble plus petit."
      ),
      "classer", graines[[3L]]
    ),
    .qcm_ensembles(
      "ENS_Q_001",
      "Quel est le plus petit ensemble usuel contenant 2/3 ?",
      "\u211a",
      c("\u2124", "\U0001D53B", "\u211a", "\u211d"),
      c(
        "2/3 n'est pas un entier relatif.",
        "L'ecriture decimale de 2/3 est infinie periodique : 2/3 n'appartient pas a D.",
        "2/3 est le quotient de deux entiers avec un denominateur non nul : il appartient a Q.",
        "2/3 est reel, mais Q est un ensemble plus petit."
      ),
      "raisonner", graines[[4L]]
    ),
    .qcm_ensembles(
      "ENS_SYM_001",
      "Quelle ecriture traduit correctement : 3 est un element de l'ensemble des naturels ?",
      "3 \u2208 \u2115",
      c("3 \u2208 \u2115", "3 \u2282 \u2115", "\u2115 \u2208 3", "\u2115 \u2282 3"),
      c(
        "Le symbole d'appartenance relie un element a un ensemble : 3 appartient a N.",
        "Le symbole d'inclusion relie deux ensembles ; 3 est ici un nombre, pas un ensemble.",
        "L'ordre est inverse : c'est 3 qui appartient a N.",
        "L'inclusion relie deux ensembles et l'ordre est ici inverse."
      ),
      "distinguer", graines[[5L]]
    )
  )
}
