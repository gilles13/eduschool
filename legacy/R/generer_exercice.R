#' Generer des exercices de mathematiques
#'
#' Tous les parametres sont facultatifs. Ils servent uniquement a restreindre
#' l'univers des exercices qu'eduschool sait actuellement produire.
#'
#' @param notion Notion souhaitee. `NULL` laisse eduschool choisir.
#' @param type Type d'exercice. `"all"` ne filtre pas.
#' @param niveau Niveau souhaite. `NULL` laisse eduschool choisir.
#' @param n Nombre d'exercices a produire. Par defaut, 5.
#' @return Une liste de `n` exercices, chacun avec son enonce, sa reponse et sa verification.
#' @export
generer_exercice = function(notion = NULL, type = "all", niveau = NULL, n = 5L) {
  types = c("all", "libre", "booleen", "3_reponses", "mot_a_trou", "mot_masque")
  if (length(type) != 1L || is.na(type) || !type %in% types) {
    stop("Type d'exercice inconnu : ", paste(type, collapse = ", "), call. = FALSE)
  }
  if (length(n) != 1L || is.na(n) || n < 1L || n != as.integer(n)) {
    stop("n doit etre un entier strictement positif.", call. = FALSE)
  }
  n = as.integer(n)

  notion_demandee = if (is.null(notion)) "proportionnalite" else notion
  notion_cle = iconv(tolower(notion_demandee), to = "ASCII//TRANSLIT")
  notion_cle = gsub("[^a-z0-9]+", "_", notion_cle)
  notion_cle = gsub("^_|_$", "", notion_cle)

  if (!notion_cle %in% c("proportionnalite", "mat_prop")) {
    stop("Aucun exercice disponible pour la notion : ", notion_demandee, call. = FALSE)
  }

  niveaux = c("6E", "5E", "4E", "3E")
  if (!is.null(niveau) &&
      (length(niveau) != 1L || is.na(niveau) || !niveau %in% niveaux)) {
    stop("Aucun exercice de proportionnalite disponible pour le niveau : ",
         paste(niveau, collapse = ", "), call. = FALSE)
  }

  if (!type %in% c("all", "libre")) {
    stop("Aucun exercice de proportionnalite disponible pour le type : ", type,
         call. = FALSE)
  }

  chemin = eduschool_path("mathematiques", "exercices", "proportionnalite.md")
  lignes = readLines(chemin, warn = FALSE, encoding = "UTF-8")
  debut = which(lignes == "%d %s coûtent %d euros. Combien coûtent %d %s au même prix unitaire ?")
  if (length(debut) != 1L) {
    stop("Formulation de proportionnalite introuvable.", call. = FALSE)
  }
  modele = lignes[[debut]]
  objets = c("cahiers", "stylos", "carnets", "billets")

  lapply(seq_len(n), function(i) {
    niveau_exercice = if (is.null(niveau)) sample(niveaux, 1L) else niveau
    objet = sample(objets, 1L)
    prix_unitaire = sample(2:12, 1L)
    quantite_depart = sample(2:8, 1L)
    quantite_demandee = sample(setdiff(2:12, quantite_depart), 1L)
    prix_depart = quantite_depart * prix_unitaire
    reponse = quantite_demandee * prix_unitaire

    enonce = sprintf(
      modele,
      quantite_depart, objet, prix_depart, quantite_demandee, objet
    )

    verification = isTRUE(
                          all.equal(as.numeric(reponse),
                                    quantite_demandee * (prix_depart / quantite_depart)
                          )
    )

    list(
      notion = "proportionnalite",
      type = "libre",
      niveau = niveau_exercice,
      enonce = enonce,
      reponse = reponse,
      verification = verification
    )
  })
}
