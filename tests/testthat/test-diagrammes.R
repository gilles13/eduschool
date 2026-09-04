test_that("le catalogue des diagrammes est cohérent", {
  x = diagrammes_disponibles()
  expect_true(all(c("parcours_scolaire", "architecture_si", "tests_package") %in% x$diagramme_id))
  expect_false(anyDuplicated(x$diagramme_id))
})

test_that("les diagrammes HTML sont générés", {
  types = diagrammes_disponibles()$diagramme_id

  for (type in types) {
    fichier = tempfile(fileext = ".html")
    sortie = produire_diagramme_html(type, fichier = fichier)

    expect_true(file.exists(sortie))
    contenu = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    expect_match(contenu, "class=\\\"mermaid\\\"")
    expect_match(contenu, "cdn.jsdelivr.net/npm/mermaid@11")
  }
})

test_that("le parcours utilise les séries des référentiels", {
  fichier = tempfile(fileext = ".html")
  diagramme_parcours_scolaire(fichier)
  contenu = paste(readLines(fichier, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  expect_match(contenu, "ST2S")
  expect_match(contenu, "STI2D")
  expect_match(contenu, "STMG")
})
