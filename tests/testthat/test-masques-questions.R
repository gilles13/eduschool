# Check every active JSON question, including notions outside current families.
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

      expect_true(length(choix) > 1L && !anyDuplicated(choix),
                  info = contexte)
      expect_true(all(choix %in% names(valeurs)), info = contexte)
      if (!all(choix %in% names(valeurs))) next
      affichages = unname(valeurs[choix])
      expect_true(all(!is.na(affichages) & nzchar(trimws(affichages))),
                  info = contexte)
      expect_identical(anyDuplicated(affichages), 0L, info = contexte)
    }
  }
})
