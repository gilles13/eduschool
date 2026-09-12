# Croiser des notions mathematiques sans construire une usine a gaz.

.qcm_intersection = function(modele_id, enonce, reponse, propositions, feedback,
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
      notion = "Ensembles de nombres x proportions",
      rappel = paste0(
        "proportion = partie / total ; ",
        "\u2115 \u2282 \u2124 \u2282 \U0001D53B \u2282 \u211a \u2282 \u211d"
      ),
      propositions = propositions[ordre],
      correcte = correcte,
      feedback = feedback[ordre]
    )
  )
}

#' Cinq QCM croisant ensembles de nombres et proportions
#'
#' Construit cinq petites situations ou il faut mobiliser en meme temps une
#' proportion, une fraction, un pourcentage ou un effectif et le classement
#' dans les ensembles de nombres. L'objectif n'est pas d'ajouter un nouveau
#' chapitre, mais de faire circuler entre des notions deja rencontrees.
#'
#' @param seed Graine facultative utilisee pour melanger les propositions.
#' @return Une liste de cinq exercices eduschool munis d'un QCM.
#' @examples
#' \dontrun{
#' exercices_ensembles_proportions(seed = 2026) |>
#'   produire_quiz(titre = "Ensembles et proportions")
#' }
#' @export
exercices_ensembles_proportions = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 5L) else as.list(seed + 0:4)

  list(
    .qcm_intersection(
      "INT_ENS_PROP_001",
      paste0(
        "Dans une classe de 28 eleves, 3/4 des eleves participent a une activite. ",
        "Quelle chaine de raisonnements est correcte ?"
      ),
      "3/4 = 0,75 = 75 % ; 21 eleves ; 0,75 appartient a D et 21 appartient a N",
      c(
        "3/4 = 0,75 = 75 % ; 21 eleves ; 0,75 appartient a D et 21 appartient a N",
        "3/4 = 0,75 = 75 % ; 21 eleves ; 0,75 appartient seulement a Q et 21 appartient a Z",
        "3/4 = 0,34 = 34 % ; 21 eleves ; 0,34 appartient a D et 21 appartient a N",
        "3/4 = 0,75 = 75 % ; 7 eleves ; 0,75 appartient a D et 7 appartient a N"
      ),
      c(
        paste0(
          "Oui : 3/4 = 0,75, donc 75 % de 28 vaut 21. ",
          "0,75 a une ecriture decimale finie et 21 est naturel."
        ),
        paste0(
          "0,75 appartient bien a Q, mais D est un ensemble plus petit qui le contient. ",
          "De meme, 21 appartient a Z mais son plus petit ensemble usuel est N."
        ),
        "3/4 vaut 0,75, pas 0,34. Le calcul de l'effectif ne suffit pas si la representation de la proportion est fausse.",
        "75 % de 28 vaut 0,75 x 28 = 21. Le nombre 7 correspondrait a 25 % de 28."
      ),
      "relier", graines[[1L]]
    ),
    .qcm_intersection(
      "INT_ENS_PROP_002",
      paste0(
        "40 % de 15 vaut 6. Quels sont les plus petits ensembles usuels contenant ",
        "respectivement 0,4 et 6 ?"
      ),
      "0,4 appartient a D ; 6 appartient a N",
      c(
        "0,4 appartient a D ; 6 appartient a N",
        "0,4 appartient a Q ; 6 appartient a Z",
        "0,4 appartient a N ; 6 appartient a D",
        "0,4 appartient a R ; 6 appartient a Q"
      ),
      c(
        "0,4 a une ecriture decimale finie : D. Le resultat 6 est un naturel : N.",
        "Les deux affirmations sont vraies, mais elles ne donnent pas les plus petits ensembles usuels.",
        "0,4 n'est pas un entier. En revanche 6 est deja dans N, plus petit que D.",
        "R et Q contiennent ces nombres, mais on peut les classer dans des ensembles plus petits."
      ),
      "classer-et-calculer", graines[[2L]]
    ),
    .qcm_intersection(
      "INT_ENS_PROP_003",
      paste0(
        "Une quantite augmente de 25 %. On la multiplie donc par 1,25. ",
        "Quel est le plus petit ensemble usuel contenant ce coefficient multiplicateur ?"
      ),
      "D, car 1,25 a une ecriture decimale finie",
      c(
        "N, car 25 est un entier naturel",
        "D, car 1,25 a une ecriture decimale finie",
        "Q, car tout pourcentage est seulement rationnel",
        "R, car un coefficient multiplicateur est toujours reel mais jamais decimal"
      ),
      c(
        "Le coefficient n'est pas 25 : une hausse de 25 % correspond au coefficient 1,25.",
        "Exact : 1,25 est decimal, donc son plus petit ensemble usuel est D.",
        "1,25 est bien rationnel, mais il appartient deja au sous-ensemble D.",
        "1,25 est reel, mais il est aussi decimal : D est plus petit que R."
      ),
      "ouvrir-vers-taux", graines[[3L]]
    ),
    .qcm_intersection(
      "INT_ENS_PROP_004",
      paste0(
        "Les 2/3 d'un groupe de 30 personnes representent 20 personnes. ",
        "Quelle affirmation distingue correctement la proportion du resultat ?"
      ),
      "2/3 appartient a Q mais pas a D ; 20 appartient a N",
      c(
        "2/3 appartient a D ; 20 appartient a N",
        "2/3 appartient a Q mais pas a D ; 20 appartient a N",
        "2/3 appartient a N ; 20 appartient a Q mais pas a N",
        "2/3 et 20 ont necessairement le meme plus petit ensemble"
      ),
      c(
        "L'ecriture decimale de 2/3 est infinie periodique : 2/3 n'appartient pas a D.",
        "Exact : la proportion est rationnelle non decimale, tandis que l'effectif obtenu est naturel.",
        "2/3 n'est pas un entier naturel, tandis que 20 appartient bien a N.",
        "Une operation peut relier des nombres dont les plus petits ensembles sont differents."
      ),
      "changer-de-representation", graines[[4L]]
    ),
    .qcm_intersection(
      "INT_ENS_PROP_005",
      paste0(
        "12,5 % de 32 vaut 4. On peut ecrire 12,5 % = 0,125 = 1/8. ",
        "Que montre cet exemple ?"
      ),
      "Une meme proportion peut avoir plusieurs ecritures et 0,125 appartient a D",
      c(
        "Une meme proportion peut avoir plusieurs ecritures et 0,125 appartient a D",
        "Une fraction appartient toujours a Q mais jamais a D",
        "Un pourcentage n'est pas un nombre et ne peut donc appartenir a aucun ensemble",
        "Puisque le resultat vaut 4, la proportion 0,125 appartient a N"
      ),
      c(
        paste0(
          "Oui : 12,5 %, 0,125 et 1/8 representent la meme proportion. ",
          "Comme 0,125 a une ecriture decimale finie, ce nombre appartient a D."
        ),
        "1/8 = 0,125 : certaines fractions sont aussi des nombres decimaux.",
        "12,5 % est une ecriture de la proportion 0,125 : on peut donc etudier le nombre qu'elle represente.",
        "Le resultat 4 et la proportion 0,125 sont deux nombres differents : leur classement peut donc differer."
      ),
      "relier-les-ecritures", graines[[5L]]
    )
  )
}
