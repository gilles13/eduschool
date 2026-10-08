test_that("toutes les questions numeriques ont plusieurs variantes distinctes", {
  dossiers = list.dirs(system.file("notions", package = "eduschool"),
                       recursive = FALSE, full.names = FALSE)
  for (notion in dossiers) {
    banque = questions(notion)$questions
    for (definition in banque) {
      if (!is.null(definition$presentation)) next
      donnees = c(definition$enonce, definition$reponse, definition$propositions,
                   unlist(definition$variantes, use.names = FALSE))
      if (!any(grepl("[0-9]", donnees))) next
      expect_true(length(definition$variantes) > 1L)
      parametres = vapply(definition$variantes, function(variante)
        paste(unlist(variante$parametres, use.names = TRUE), collapse = "\r"),
        character(1L))
      expect_false(anyDuplicated(parametres) > 0L)
    }
  }
})

test_that("chaque question porte le niveau du referentiel", {
  catalogue = notions()
  ids = unique(catalogue$identifiant[catalogue$type == "notion"])
  for (id in ids) {
    banque = questions(id)$questions
    expect_true(all(vapply(banque, function(definition)
      is.character(definition$niveau) && length(definition$niveau) == 1L &&
        !is.na(definition$niveau) && nzchar(definition$niveau), logical(1L))))
  }
})
