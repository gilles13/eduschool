#' Labo OH WAIT : beaucoup d'exemples ne font pas une preuve
#'
#' Utilise le polynôme n^2 + n + 41 pour faire sentir la différence entre
#' vérification, conjecture, contre-exemple et démonstration.
#'
#' @param seed Graine facultative utilisée pour mélanger les propositions.
#' @return Une liste de quatre exercices eduschool munis d'un QCM.
#' @examples
#' \dontrun{
#' exercices_oh_wait_euler(seed = 2026) |>
#'   produire_quiz(titre = "OH WAIT... beaucoup d'exemples suffisent-ils ?")
#' }
exercices_oh_wait_euler = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 4L) else as.list(seed + 0:3)
  f = function(n) n^2 + n + 41

  qcm = function(modele_id, enonce, reponse, propositions, feedback,
                 intention, graine) {
    x = .qcm_ensembles(
      modele_id = modele_id,
      enonce = enonce,
      reponse = reponse,
      propositions = propositions,
      feedback = feedback,
      intention = intention,
      seed = graine
    )
    x$qcm$notion = "Vérifier, conjecturer, réfuter"
    x$qcm$rappel = paste0(
      "Vérifier beaucoup de cas peut faire naître une conjecture. ",
      "Cela ne remplace pas une démonstration."
    )
    x
  }

  list(
    qcm(
      "OH_WAIT_EULER_OBSERVER_001",
      paste0(
        "On calcule f(n) = n^2 + n + 41. Pour n = 0, 1, 2 et 3, on obtient ",
        f(0), ", ", f(1), ", ", f(2), " et ", f(3), ", qui sont premiers. ",
        "Qu'est-il raisonnable de faire ensuite ?"
      ),
      "Tester d'autres valeurs et chercher si le motif continue",
      c(
        "Tester d'autres valeurs et chercher si le motif continue",
        "Annoncer que f(n) est premier pour tout entier naturel n",
        "Conclure que quatre exemples constituent une démonstration",
        "Arrêter : les quatre calculs suffisent à traiter tous les entiers"
      ),
      c(
        "Les premiers calculs suggèrent un motif : on peut poursuivre l'exploration avant de formuler ou tester une conjecture.",
        "Les quatre valeurs calculées ne couvrent pas tous les entiers naturels.",
        "Quatre exemples favorables restent quatre cas particuliers ; ils ne constituent pas une démonstration générale.",
        "Il existe une infinité d'entiers naturels : quatre calculs ne traitent pas les cas non observés."
      ),
      "observer-un-motif", graines[[1L]]
    ),
    qcm(
      "OH_WAIT_EULER_CONJECTURE_001",
      paste0(
        "On poursuit les calculs : f(n) est premier pour chaque entier n de 0 à 39. ",
        "Que sait-on alors ?"
      ),
      "La propriété est vérifiée de 0 à 39 ; on peut conjecturer qu'elle continue",
      c(
        "La propriété est vérifiée de 0 à 39 ; on peut conjecturer qu'elle continue",
        "La propriété est démontrée pour tout entier naturel",
        "La propriété est vraie pour tous les entiers parce que 40 essais ont réussi",
        "Il ne peut plus exister de contre-exemple après 39"
      ),
      c(
        "Les quarante cas sont vérifiés, mais les entiers au-delà de 39 n'ont pas été traités : la généralisation reste une conjecture.",
        "Une vérification finie, même longue, ne demontre pas une affirmation portant sur tous les entiers naturels.",
        "Le nombre de succès ne transforme pas les cas non testés en cas démontrés.",
        "Les calculs jusqu'à 39 ne donnent aucune garantie logique sur les valeurs suivantes."
      ),
      "distinguer-vérification-preuve", graines[[2L]]
    ),
    qcm(
      "OH_WAIT_EULER_CONTREEXEMPLE_001",
      paste0(
        "OH WAIT... calculons f(40). On obtient ", f(40), ". ",
        "Quelle observation suffit à casser la conjecture selon laquelle f(n) serait toujours premier ?"
      ),
      "1681 = 41 × 41, donc f(40) n'est pas premier",
      c(
        "1681 = 41 × 41, donc f(40) n'est pas premier",
        "1681 est plus grand que les valeurs précédentes",
        "40 est un entier pair",
        "41 est lui-même un nombre premier"
      ),
      c(
        "Comme 1681 se factorise en 41 × 41, f(40) n'est pas premier : n = 40 est un contre-exemple.",
        "Être plus grand que les valeurs précédentes n'empêche pas un nombre d'être premier.",
        "La parité de n ne suffit pas a montrer que la valeur f(n) est composée.",
        "Le fait que 41 soit premier n'implique pas que 41 × 41 le soit ; ce produit est composé."
      ),
      "trouver-le-contre-exemple", graines[[3L]]
    ),
    qcm(
      "OH_WAIT_EULER_BILAN_001",
      "Que nous apprend cette expérience sur une affirmation qui prétend être vraie pour tout entier naturel ?",
      "Des exemples favorables peuvent suggérer une conjecture ; un seul contre-exemple suffit à la réfuter",
      c(
        "Des exemples favorables peuvent suggérer une conjecture ; un seul contre-exemple suffit à la réfuter",
        "Quarante exemples favorables valent toujours une démonstration",
        "Une conjecture devient vraie dès qu'elle résiste assez longtemps",
        "Un contre-exemple compte moins que plusieurs exemples favorables"
      ),
      c(
        "Les cas de 0 à 39 ont rendu la conjecture plausible ; le seul cas n = 40 suffit pourtant a montrer qu'elle n'est pas vraie pour tout n.",
        "Les quarante exemples établissent quarante cas, pas tous les entiers naturels.",
        "Résister à des essais ne suffit pas a rendre universelle une affirmation non démontrée.",
        "Pour une affirmation universelle, un seul cas qui satisfait les conditions mais pas la propriété suffit à la réfuter."
      ),
      "comprendre-exemple-contre-exemple", graines[[4L]]
    )
  )
}
