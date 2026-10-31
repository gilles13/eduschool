test_that("les variantes definies ont des parametres distincts", {
  dossiers = list.dirs(system.file("notions", package = "eduschool"),
                       recursive = FALSE, full.names = FALSE)
  dossiers = dossiers[file.exists(file.path(system.file("notions", package = "eduschool"), dossiers, "questions.json"))]
  for (notion in dossiers) {
    banque = questions(notion)$questions
    for (definition in banque) {
      variantes = definition$variantes
      if (length(variantes) < 2L) next
      parametres = vapply(variantes, function(variante)
        paste(unlist(variante$parametres, use.names = TRUE), collapse = "\r"),
        character(1L))
      expect_false(anyDuplicated(parametres) > 0L,
                   info = paste(notion, definition$id))
    }
  }
})

test_that("chaque question porte le niveau du referentiel", {
  catalogue = notions()
  ids = unique(catalogue$identifiant[catalogue$type == "notion"])
  ids = ids[file.exists(file.path(system.file("notions", package = "eduschool"), ids, "questions.json"))]
  for (id in ids) {
    banque = questions(id)$questions
    expect_true(all(vapply(banque, function(definition)
      is.character(definition$niveau) && length(definition$niveau) == 1L &&
        !is.na(definition$niveau) && nzchar(definition$niveau), logical(1L))))
  }
})
