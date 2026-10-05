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
