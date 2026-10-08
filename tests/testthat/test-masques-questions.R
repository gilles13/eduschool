# Check every active JSON question, including notions outside current families.
.masque_trou_valide = function(mot, masque) {
  compact = gsub(" ", "", masque, fixed = TRUE)
  lettres = strsplit(mot, "", fixed = TRUE)[[1]]
  signes = strsplit(compact, "", fixed = TRUE)[[1]]
  length(lettres) == length(signes) &&
    all(signes == "_" | signes == lettres)
}
test_that("les masques des QCM sont complets et distincts", {
  racine = system.file("notions", package = "eduschool")
  fichiers = list.files(racine, pattern = "^questions[.]json$",
                        recursive = TRUE, full.names = TRUE)
  expect_gt(length(fichiers), 0L)
  for (fichier in fichiers) {
    banque = jsonlite::fromJSON(fichier, simplifyVector = FALSE)
    for (q in banque$questions) {
      masques = q$presentation$masques
      if (is.null(masques)) next
      choix = unlist(q$propositions, use.names = FALSE)
      valeurs = unlist(masques, use.names = TRUE)
      contexte = paste(basename(dirname(fichier)), q$id, sep = " / ")
      if (!(length(choix) > 1L && !anyDuplicated(choix)))
        stop(paste(contexte, ": propositions dupliquees"), call. = FALSE)
      if (!all(choix %in% names(valeurs)))
        stop(paste(contexte, ": masque manquant"), call. = FALSE)
      affichages = unname(valeurs[choix])
      if (!all(!is.na(affichages) & nzchar(trimws(affichages))))
        stop(paste(contexte, ": masque vide"), call. = FALSE)
      if (anyDuplicated(affichages))
        stop(paste(contexte, ": masques visuellement identiques"), call. = FALSE)
      if (identical(q$presentation$type, "mot_a_trou")) {
        valides = mapply(.masque_trou_valide, choix, affichages, USE.NAMES = FALSE)
        if (!all(valides))
          stop(paste(contexte, ": mot a trou incoherent pour",
                     paste(choix[!valides], collapse = ", ")), call. = FALSE)
      }
      if (identical(q$presentation$type, "mot_masque")) {
        if (any(grepl(" ", trimws(choix), fixed = TRUE)))
          stop(paste(contexte, ": mot masque compose de plusieurs mots"), call. = FALSE)
        avertissement = q$presentation$avertissement
        if (is.null(avertissement) || !nzchar(trimws(avertissement)))
          stop(paste(contexte, ": avertissement mot masque absent"), call. = FALSE)
      }
    }
  }
})

test_that("les nouvelles banques respectent le contrat vocabulaire", {
  # Dette historique explicite. Une nouvelle banque n'entre jamais ici.
  # Retirer une notion de cette liste des que ses deux formes sont presentes.
  legacy_sans_contrat = c(
    "cercle_trigonometrique", "decomposition_facteurs_premiers", "developpement_identites", "equations_carre_constante",
    "equations_produit_nul", "evolution_pourcentage", "factorisation_facteur_commun", "factorisation_identites",
    "fonctions_affine", "fonctions_carree", "fonctions_definition", "fonctions_lineaire",
    "fractions_addition", "fractions_comparaison", "fractions_division", "fractions_droite",
    "fractions_encadrement", "fractions_fois_entier", "fractions_multiplication", "fractions_problemes",
    "fractions_quantite", "fractions_quotient", "fractions_soustraction", "fractions_terme_manquant",
    "geometrie_deductive", "grandeur_quotient", "intervalles_reels", "pourcentage",
    "probabilites_deux_epreuves", "probabilites_evenements_operations", "probabilites_experience_aleatoire", "probabilites_frequence_simulation",
    "proportionnalite", "puissances_carres_cubes", "puissances_exposant_negatif", "puissances_notation_scientifique",
    "puissances_proprietes", "pythagore", "racine_carree", "ratio",
    "relatifs_addition_soustraction", "relatifs_multiplication_division", "relatifs_reperage", "simplification_expression_algebrique",
    "statistiques_comparaison_series", "statistiques_indicateurs", "statistiques_quartiles_boite_moustaches", "statistiques_representations",
    "trigonometrie_triangle_rectangle"
  )
  racine = system.file("notions", package = "eduschool")
  fichiers = list.files(racine, pattern = "^questions[.]json$",
                        recursive = TRUE, full.names = TRUE)
  erreurs = character()
  encore_legacy = character()
  for (fichier in fichiers) {
    notion = basename(dirname(fichier))
    banque = jsonlite::fromJSON(fichier, simplifyVector = FALSE)
    formes = vapply(banque$questions, function(q) {
      type = q$presentation$type
      if (is.null(type)) "" else type
    }, character(1))
    manque = setdiff(c("mot_a_trou", "mot_masque"), formes)
    if (notion %in% legacy_sans_contrat) {
      if (!length(manque)) encore_legacy = c(encore_legacy, notion)
    } else if (length(manque)) {
      erreurs = c(erreurs, paste(notion, "manque", paste(manque, collapse = " + ")))
    }
  }
  expect_equal(erreurs, character())
  expect_equal(encore_legacy, character())
})
