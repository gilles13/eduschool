# Ensembles de nombres : une premiere notion complete et reutilisable

utils::globalVariables(c(
  "xmin", "xmax", "ymin", "ymax",
  "symbole", "nom", "y", "exemple", "exemples", "etiquette"
))

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

#' Diagramme des ensembles de nombres
#'
#' Produit avec ggplot2 un schema de cadres emboites montrant les inclusions
#' N dans Z, Z dans D, D dans Q et Q dans R. Des exemples sont places dans
#' la zone propre a chaque ensemble pour montrer ce que chaque ensemble ajoute.
#'
#' @return Un objet ggplot.
#' @export
diagramme_ensembles_nombres = function() {
  ensembles = ensembles_nombres()
  cadres = ensembles[rev(seq_len(nrow(ensembles))), , drop = FALSE]
  pas = 1.35
  marge = (seq_len(nrow(cadres)) - 1) * pas
  taille = 10 + 2 * (pas - 0.8) * (nrow(cadres) - 1)
  cadres$xmin = marge
  cadres$xmax = taille - marge
  cadres$ymin = marge
  cadres$ymax = taille - marge
  cadres$x = (cadres$xmin + cadres$xmax) / 2
  cadres$y = cadres$ymax - 0.25
  cadres$etiquette = paste(cadres$symbole, "\u2014", cadres$nom)
  cadres$exemples = gsub(" *\\| *", "   ", cadres$exemples)
  chaine = paste(ensembles$symbole, collapse = " \u2282 ")
  centre = taille / 2

  ggplot2::ggplot() +
    ggplot2::geom_rect(
      data = cadres,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = NA,
      colour = "grey35",
      linewidth = 0.8
    ) +
    ggplot2::geom_text(
      data = cadres,
      ggplot2::aes(x = x, y = y, label = etiquette),
      hjust = 0.5,
      vjust = 1,
      fontface = "bold",
      size = 4
    ) +
    ggplot2::geom_text(
      data = cadres,
      ggplot2::aes(x = x, y = y - 0.55, label = exemples),
      hjust = 0.5,
      vjust = 1,
      size = 4.5
    ) +
    ggplot2::annotate(
      "text",
      x = centre, y = -0.65,
      label = chaine,
      fontface = "bold",
      size = 6
    ) +
    ggplot2::annotate(
      "text",
      x = centre, y = -1.15,
      label = "Un nombre entre par le plus petit ensemble qui le contient.",
      size = 4
    ) +
    ggplot2::coord_fixed(
      xlim = c(-0.2, taille + 0.2),
      ylim = c(-1.45, taille + 0.2),
      clip = "off"
    ) +
    ggplot2::labs(
      title = "Les ensembles de nombres",
      subtitle = paste0(
        "Des naturels aux r\u00e9els : ",
        "chaque cadre est contenu dans le suivant."
      )
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 20, face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(
        size = 11.5,
        hjust = 0.5,
        margin = ggplot2::margin(b = 12)
      ),
      plot.margin = ggplot2::margin(t = 15, r = 15, b = 30, l = 15)
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
      notion = "Ensembles de nombres",
      rappel = "\u2115 \u2282 \u2124 \u2282 \U0001D53B \u2282 \u211a \u2282 \u211d",
      propositions = propositions[ordre],
      correcte = correcte,
      feedback = feedback[ordre]
    )
  )
}

#' Quiz sur les ensembles de nombres
#'
#' Construit de cinq a dix QCM courts sur les inclusions usuelles, les plus
#' petits ensembles contenant quelques nombres et la difference entre
#' appartenance et inclusion. Le resultat peut etre passe directement a
#'
#' Les cinq premieres questions constituent le parcours court historique. Avec
#' `n = 10`, cinq questions supplementaires ajoutent quelques pieges utiles :
#' zero, une fraction qui se simplifie, un decimal negatif, racine de deux et
#' raisonnement par inclusion.
#'
#' @param seed Graine facultative utilisee pour melanger les propositions.
#' @param n Nombre de questions a produire, de 1 a 10. Par defaut, 5.
#' @return Une liste de `n` exercices eduschool munis d'un QCM.
#' @export
exercices_ensembles_nombres = function(seed = NULL, n = 5L) {
  if (length(n) != 1L || !is.numeric(n) || is.na(n) ||
      n != as.integer(n) || n < 1L || n > 10L) {
    stop("`n` doit etre un entier compris entre 1 et 10.", call. = FALSE)
  }
  n = as.integer(n)
  graines = if (is.null(seed)) rep(list(NULL), 10L) else as.list(seed + 0:9)

  questions = list(
    .qcm_ensembles(
      "ENS_R_MOT_001",
      paste0(
        "Une personne est r\u00e9elle dans le langage courant. ",
        "Peut-on pour autant ecrire : cette personne appartient a R ?"
      ),
      "Non : R est un ensemble de nombres",
      c(
        "Oui : puisqu'elle existe reellement",
        "Non : R est un ensemble de nombres",
        "Non : une personne ne peut pas \u00eatre n\u00e9gative",
        "Oui : son \u00e2ge est un nombre r\u00e9el"
      ),
      c(
        paste0(
          "Ici, le mot r\u00e9el change de sens. Dans le langage courant, une personne ",
          "peut \u00eatre r\u00e9elle ; en math\u00e9matiques, R contient des nombres."
        ),
        paste0(
          "Exactement : une personne peut \u00eatre r\u00e9elle au sens courant sans \u00eatre ",
          "un nombre r\u00e9el. Appartenir \u00e0 R signifie \u00eatre un nombre r\u00e9el."
        ),
        paste0(
          "Le probleme n'est pas le signe. Des nombres positifs et negatifs ",
          "appartiennent a R ; une personne n'est simplement pas un nombre."
        ),
        paste0(
          "L'\u00e2ge d'une personne peut \u00eatre repr\u00e9sent\u00e9 par un nombre r\u00e9el, mais la ",
          "personne et son age sont deux objets differents."
        )
      ),
      "definir", graines[[1L]]
    ),
    .qcm_ensembles(
      "ENS_Z_001",
      "Quel est le plus petit ensemble usuel contenant le nombre -2 ?",
      "\u2124",
      c("\u2115", "\u2124", "\U0001D53B", "\u211a"),
      c(
        "Les naturels ne contiennent pas les entiers strictement negatifs.",
        "-2 est un entier relatif : -2 appartient a Z.",
        "-2 a une \u00e9criture d\u00e9cimale finie, mais Z est un ensemble plus petit.",
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
        "0,25 a une \u00e9criture d\u00e9cimale finie : il appartient \u00e0 D.",
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
        "L'\u00e9criture d\u00e9cimale de 2/3 est infinie p\u00e9riodique : 2/3 n'appartient pas \u00e0 D.",
        "2/3 est le quotient de deux entiers avec un denominateur non nul : il appartient a Q.",
        "2/3 est r\u00e9el, mais Q est un ensemble plus petit."
      ),
      "raisonner", graines[[4L]]
    ),
    .qcm_ensembles(
      "ENS_SYM_001",
      "Quelle \u00e9criture traduit correctement : 3 est un \u00e9l\u00e9ment de l'ensemble des naturels ?",
      "3 \u2208 \u2115",
      c("3 \u2208 \u2115", "3 \u2282 \u2115", "\u2115 \u2208 3", "\u2115 \u2282 3"),
      c(
        "Le symbole d'appartenance relie un \u00e9l\u00e9ment \u00e0 un ensemble : 3 appartient \u00e0 N.",
        "Le symbole d'inclusion relie deux ensembles ; 3 est ici un nombre, pas un ensemble.",
        "L'ordre est inverse : c'est 3 qui appartient a N.",
        "L'inclusion relie deux ensembles et l'ordre est ici inverse."
      ),
      "distinguer", graines[[5L]]
    ),
    .qcm_ensembles(
      "ENS_N_ZERO_001",
      "Quel est le plus petit ensemble usuel contenant 0 ?",
      "\u2115",
      c("\u2115", "\u2124", "\U0001D53B", "\u211a"),
      c(
        "Dans la convention scolaire usuelle en France, 0 appartient aux nombres naturels.",
        "0 est bien un entier relatif, mais N est un ensemble plus petit qui le contient deja.",
        "0 a une \u00e9criture d\u00e9cimale finie, mais N est un ensemble plus petit.",
        "0 est rationnel, mais N est un ensemble plus petit."
      ),
      "classer", graines[[6L]]
    ),
    .qcm_ensembles(
      "ENS_FRAC_SIMPL_001",
      "Quel est le plus petit ensemble usuel contenant 4/2 ?",
      "\u2115",
      c("\u2115", "\u2124", "\U0001D53B", "\u211a"),
      c(
        "4/2 = 2. Le nombre 2 est naturel : le plus petit ensemble est donc N.",
        "4/2 = 2 est bien un entier relatif, mais N est plus petit et contient deja 2.",
        "4/2 = 2 a une \u00e9criture d\u00e9cimale finie, mais N est plus petit.",
        "4/2 est un quotient d'entiers, mais il vaut 2 : N est le plus petit ensemble propose."
      ),
      "se-mefier", graines[[7L]]
    ),
    .qcm_ensembles(
      "ENS_D_NEG_001",
      "Quel est le plus petit ensemble usuel contenant -0,5 ?",
      "\U0001D53B",
      c("\u2124", "\U0001D53B", "\u211a", "\u211d"),
      c(
        "-0,5 n'est pas un entier relatif.",
        "-0,5 a une \u00e9criture d\u00e9cimale finie : il appartient \u00e0 D.",
        "-0,5 est rationnel, mais D est un ensemble plus petit.",
        "-0,5 est r\u00e9el, mais D est un ensemble plus petit."
      ),
      "classer", graines[[8L]]
    ),
    .qcm_ensembles(
      "ENS_R_IRR_001",
      "Quel est le plus petit ensemble usuel contenant \u221a2 ?",
      "\u211d",
      c("\U0001D53B", "\u211a", "\u211d", "\u2115"),
      c(
        "La racine de 2 n'a pas d'\u00e9criture d\u00e9cimale finie : elle n'appartient pas \u00e0 D.",
        "La racine de 2 est irrationnelle : elle ne peut pas s'ecrire comme quotient de deux entiers.",
        "La racine de 2 est un nombre r\u00e9el et n'appartient pas aux ensembles D ou Q.",
        "La racine de 2 n'est pas un entier naturel."
      ),
      "raisonner", graines[[9L]]
    ),
    .qcm_ensembles(
      "ENS_INCLUSION_001",
      "Si un nombre x appartient a Z, que peut-on affirmer avec certitude ?",
      "x \u2208 \u211d",
      c("x \u2208 \u2115", "x \u2208 \u211d", "\u211d \u2208 x", "x \u2209 \u211a"),
      c(
        "Un entier relatif peut \u00eatre n\u00e9gatif : il n'appartient donc pas n\u00e9cessairement \u00e0 N.",
        "Comme Z est inclus dans D, Q puis R, tout entier relatif appartient aussi a R.",
        "Le symbole d'appartenance relie un \u00e9l\u00e9ment \u00e0 un ensemble ; R n'est pas un \u00e9l\u00e9ment du nombre x.",
        "Tout entier relatif est rationnel : on peut l'ecrire comme quotient de lui-meme par 1."
      ),
      "inclure", graines[[10L]]
    )
  )

  questions[seq_len(n)]
}

.generer_exercice_ensemble_nombres = function(
  modele_id, niveau_id, capacite_id = NA_character_, difficulte = 1, seed = NULL
) {
  if (!identical(as.character(niveau_id), "2GT")) {
    stop("Les exercices sur les ensembles de nombres sont disponibles en 2GT.", call. = FALSE)
  }

  banque = exercices_ensembles_nombres(seed = seed, n = 10L)
  ids = vapply(banque, function(x) x$modele_id, character(1))
  i = match(modele_id, ids)

  if (is.na(i)) {
    stop("Modele d'ensembles inconnu : ", modele_id, call. = FALSE)
  }

  exercice = banque[[i]]
  exercice$capacite_id = capacite_id
  exercice$difficulte = difficulte
  exercice
}

.generateur_ensemble_nombres = function(modele_id) {
  force(modele_id)
  function(niveau_id, capacite_id = NA_character_, difficulte = 1, seed = NULL) {
    .generer_exercice_ensemble_nombres(
      modele_id = modele_id,
      niveau_id = niveau_id,
      capacite_id = capacite_id,
      difficulte = difficulte,
      seed = seed
    )
  }
}

.generer_ens_r_mot = .generateur_ensemble_nombres("ENS_R_MOT_001")
.generer_ens_z = .generateur_ensemble_nombres("ENS_Z_001")
.generer_ens_d = .generateur_ensemble_nombres("ENS_D_001")
.generer_ens_q = .generateur_ensemble_nombres("ENS_Q_001")
.generer_ens_sym = .generateur_ensemble_nombres("ENS_SYM_001")
.generer_ens_n_zero = .generateur_ensemble_nombres("ENS_N_ZERO_001")
.generer_ens_frac_simpl = .generateur_ensemble_nombres("ENS_FRAC_SIMPL_001")
.generer_ens_d_neg = .generateur_ensemble_nombres("ENS_D_NEG_001")
.generer_ens_r_irr = .generateur_ensemble_nombres("ENS_R_IRR_001")
.generer_ens_inclusion = .generateur_ensemble_nombres("ENS_INCLUSION_001")
