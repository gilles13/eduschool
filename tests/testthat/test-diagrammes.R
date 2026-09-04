test_that("le catalogue des diagrammes est cohérent", {
  x = diagrammes_disponibles()
  attendus = c(
    "parcours_scolaire",
    "prise_en_main",
    "programmes_capacites",
    "architecture_si",
    "documentation_pedagogique",
    "exercices_revisions",
    "tests_package",
    "developpement"
  )

  expect_true(all(attendus %in% x$diagramme_id))
  expect_false(anyDuplicated(x$diagramme_id))
})

test_that("les diagrammes SVG sont autonomes", {
  types = diagrammes_disponibles()$diagramme_id

  for (type in types) {
    fichier = tempfile(fileext = ".svg")
    sortie = produire_diagramme_svg(type, fichier = fichier)

    expect_true(file.exists(sortie))
    contenu = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    expect_match(contenu, "<svg")
    expect_match(contenu, "marker-end")
    expect_false(grepl("mermaid|cdn.jsdelivr|npm", contenu, ignore.case = TRUE))
  }
})

test_that("les diagrammes HTML embarquent le SVG sans dépendance externe", {
  types = diagrammes_disponibles()$diagramme_id

  for (type in types) {
    fichier = tempfile(fileext = ".html")
    sortie = produire_diagramme_html(type, fichier = fichier)

    expect_true(file.exists(sortie))
    contenu = paste(readLines(sortie, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    expect_match(contenu, "<svg")
    expect_match(contenu, "class=\"diagramme\"")
    expect_false(grepl("mermaid|cdn.jsdelivr|npm", contenu, ignore.case = TRUE))
  }
})

test_that("le parcours utilise les séries des référentiels", {
  fichier = tempfile(fileext = ".svg")
  produire_diagramme_svg("parcours_scolaire", fichier)
  contenu = paste(readLines(fichier, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

  expect_match(contenu, "ST2S")
  expect_match(contenu, "STI2D")
  expect_match(contenu, "STMG")
  expect_match(contenu, "Cycle 3")
  expect_match(contenu, "Cycle 4")
  expect_match(contenu, "Cycle terminal")
  expect_match(contenu, "group_C3")
  expect_match(contenu, "group_C4")
  expect_match(contenu, "group_CYCLE_TERMINAL")
})
