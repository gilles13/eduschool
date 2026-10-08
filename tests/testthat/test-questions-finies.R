test_that("les JSON contiennent uniquement des questions finies", {
  dossiers = list.dirs(system.file("notions", package = "eduschool"),
                       recursive = FALSE, full.names = FALSE)
  erreurs = character()
  for (notion in dossiers) {
    banque = questions(notion)$questions
    for (definition in banque) {
      id = definition$id
      if (!is.character(definition$reponse) || length(definition$reponse) != 1L)
        erreurs = c(erreurs, paste(notion, id, "reponse invalide"))
      if (!is.null(definition$calculs))
        erreurs = c(erreurs, paste(notion, id, "calculs encore present"))
      if (!is.null(definition$presentation$math))
        erreurs = c(erreurs, paste(notion, id, "presentation.math encore presente"))
      variantes = definition$variantes
      if (!length(variantes)) variantes = list(NULL)
      for (i in seq_along(variantes)) {
        concrete = definition
        if (!is.null(variantes[[i]])) concrete$variantes = list(variantes[[i]])
        q = question(concrete)
        prefixe = paste(notion, id, paste0("variante ", i))
        if (sum(q$propositions == q$reponse) != 1L)
          erreurs = c(erreurs, paste(prefixe, "bonne reponse non unique"))
        if (anyDuplicated(q$propositions) > 0L)
          erreurs = c(erreurs, paste(prefixe, "propositions dupliquees"))
        textes = c(q$enonce, q$reponse, q$propositions, q$correction,
                   unlist(q$illustration, use.names = FALSE))
        if (any(grepl("\\[\\[[a-z][a-z0-9_]*\\]\\]", textes)))
          erreurs = c(erreurs, paste(prefixe, "placeholder non remplace"))
      }
    }
  }
  expect_equal(erreurs, character())
})

test_that("les questions numeriques sur les fractions ont des variantes", {
  dossiers = list.dirs(system.file("notions", package = "eduschool"),
                       recursive = FALSE, full.names = FALSE)
  notions = dossiers[startsWith(dossiers, "fractions_")]
  for (notion in notions) {
    banque = questions(notion)$questions
    for (definition in banque) {
      if (!is.null(definition$presentation)) next
      donnees = c(definition$enonce, definition$reponse, definition$propositions)
      if (!is.null(definition$illustration)) {
        illustration = unlist(definition$illustration[names(definition$illustration) != "id"])
        donnees = c(donnees, illustration)
      }
      numerique = any(grepl("[0-9]", donnees))
      if (numerique) expect_true(length(definition$variantes) > 1L)
    }
  }
})

test_that("les variantes des fractions ne sont pas dupliquees", {
  dossiers = list.dirs(system.file("notions", package = "eduschool"),
                       recursive = FALSE, full.names = FALSE)
  notions = dossiers[startsWith(dossiers, "fractions_")]
  banques = character()
  for (notion in notions) {
    banque = questions(notion)$questions
    for (definition in banque) {
      variantes = definition$variantes
      if (length(variantes) < 2L) next
      signatures = vapply(variantes, function(x) {
        paste(capture.output(dput(x$parametres)), collapse = "")
      }, character(1))
      expect_false(anyDuplicated(signatures) > 0L)
      banque_signature = paste(sort(signatures), collapse = "\n")
      expect_false(banque_signature %in% banques)
      banques = c(banques, banque_signature)
    }
  }
})
