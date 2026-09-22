# Helpers encore utilises hors de l ancien moteur de generation.

.textes_exercice = function(famille, modele_id) {
  fichier = paste0("textes_", famille, ".md")
  chemin = eduschool_path("exercices", fichier)
  lignes = readLines(chemin, warn = FALSE, encoding = "UTF-8")

  prefixe = paste0("## ", modele_id, " / ")
  debut = which(startsWith(lignes, prefixe))
  if (!length(debut)) {
    stop("Textes d'exercice introuvables : ", modele_id, call. = FALSE)
  }

  lire_texte = function(i) {
    fin = which(seq_along(lignes) > i & startsWith(lignes, "## "))
    fin = if (length(fin)) fin[[1L]] - 1L else length(lignes)
    texte = lignes[seq.int(i + 1L, fin)]
    while (length(texte) && !nzchar(texte[[1L]])) texte = texte[-1L]
    while (length(texte) && !nzchar(texte[[length(texte)]])) texte = texte[-length(texte)]
    paste(texte, collapse = "\n")
  }

  ids = substring(lignes[debut], nchar(prefixe) + 1L)
  if (anyDuplicated(ids)) {
    stop("Identifiants de textes dupliques : ", modele_id, call. = FALSE)
  }

  stats::setNames(vapply(debut, lire_texte, character(1)), ids)
}

creer_exercice = function(modele_id, niveau_id, capacite_id, difficulte,
                           enonce, reponse, correction, parametres, seed = NULL,
                           qcm = NULL) {
  list(
    exercice_id = paste(modele_id, if (is.null(seed)) sample.int(1e9, 1) else seed, sep = "_"),
    modele_id = modele_id,
    niveau_id = niveau_id,
    capacite_id = capacite_id,
    difficulte = difficulte,
    seed = seed,
    parametres = parametres,
    enonce = enonce,
    reponse = reponse,
    correction = correction,
    qcm = qcm
  )
}
