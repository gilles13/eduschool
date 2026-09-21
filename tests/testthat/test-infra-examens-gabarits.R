test_that("la banque de gabarits DNB est extensible et tracee", {
  x = gabarits_examen("DNB", "AUTOMATISMES")
  expect_gte(nrow(x), 8)
  expect_true(all(x$statut == "ACTIF"))
  expect_true(all(nzchar(x$generateur_id)))
  expect_true(all(nzchar(x$origine)))
  expect_true(all(nzchar(x$session_source)))
  expect_true(all(x$source_id %in% .lire_csv("metadata", "sources.csv")$source_id))
})

test_that("un gabarit expose ses concepts et ses parametres", {
  x = gabarit_examen("GAB_DNB_AUT_FRACTION_SOMME")
  expect_equal(x$gabarit$domaine, "NOMBRES")
  expect_true("MATC_FRACTION" %in% x$concepts$concept_id)
  expect_true(all(c("denominateur", "numerateur_1", "numerateur_2") %in% x$parametres$parametre))
})

test_that("les variantes de gabarits sont reproductibles", {
  a = generer_gabarit_examen("GAB_DNB_AUT_EQUATION", seed = 42)
  b = generer_gabarit_examen("GAB_DNB_AUT_EQUATION", seed = 42)
  expect_identical(a, b)
  expect_true(nzchar(a$enonce))
  expect_true(nzchar(a$reponse))
})



test_that("les solutions d equations sont exactes sans troncature", {
  expect_equal(.formater_rationnel(0, 6), "0")
  expect_equal(.formater_rationnel(3, 2), "1,5")
  expect_equal(.formater_rationnel(-2, 3), "-2/3")
  expect_equal(.formater_rationnel(6, 4), "1,5")
})

test_that("le gabarit equation calcule la solution depuis les coefficients", {
  x = gabarit_examen("GAB_DNB_AUT_EQUATION")
  expect_true("membre_droit" %in% x$parametres$parametre)
  expect_false("solution" %in% x$parametres$parametre)

  y = generer_gabarit_examen("GAB_DNB_AUT_EQUATION", seed = 42)
  a = y$parametres$a
  b = y$parametres$b
  c = y$parametres$membre_droit
  attendu = paste0("x = ", .formater_rationnel(c - b, a))
  expect_equal(y$reponse, attendu)
})

test_that("tous les generateurs actifs produisent un enonce et une reponse", {
  x = gabarits_examen("DNB", "AUTOMATISMES")
  for (i in seq_len(nrow(x))) {
    y = generer_gabarit_examen(x$gabarit_id[[i]], seed = 100 + i)
    expect_true(nzchar(y$enonce), info = x$gabarit_id[[i]])
    expect_true(nzchar(y$reponse), info = x$gabarit_id[[i]])
  }
})

test_that("composer_examen rattache les automatismes a la banque quand possible", {
  x = composer_examen("DNB", 2026, seed = 123)
  p1 = x[x$partie_id == "DNB2026_P1", , drop = FALSE]
  expect_true("gabarit_id" %in% names(x))
  expect_true(any(!is.na(p1$gabarit_id)))
  ids = p1$gabarit_id[!is.na(p1$gabarit_id)]
  expect_true(all(ids %in% gabarits_examen()$gabarit_id))
})

test_that("les nouvelles tables de gabarits appartiennent au mini SI", {
  inv = inventaire_si()
  expect_true(all(c(
    "gabarits_exercices",
    "gabarits_exercices_concepts",
    "gabarits_parametres"
  ) %in% inv$table))
  x = controle_integrite_si(niveau = "structure")
  expect_true(all(x$ok))
})

test_that("la banque couvre tous les domaines d automatismes du DNB 2026", {
  s = structure_examen("DNB", 2026)
  p1 = s$parties$partie_id[s$parties$type == "AUTOMATISMES"]
  domaines = unique(s$profils$domaine[s$profils$partie_id %in% p1])
  banque = gabarits_examen("DNB", "AUTOMATISMES")
  expect_true(all(domaines %in% banque$domaine))
})

test_that("les nouveaux gabarits declarent les futures ressources graphiques", {
  angle = generer_gabarit_examen("GAB_DNB_AUT_ANGLE_TRIANGLE", seed = 1)
  proba = generer_gabarit_examen("GAB_DNB_AUT_PROBA_URNE", seed = 2)
  scratch = generer_gabarit_examen("GAB_DNB_AUT_SCRATCH_BOUCLE", seed = 3)

  expect_equal(angle$ressource$type, "FIGURE_GEOMETRIQUE")
  expect_equal(proba$ressource$type, "SCHEMA")
  expect_equal(scratch$ressource$type, "SCRATCH")
  expect_true(nzchar(angle$correction))
  expect_true(nzchar(proba$correction))
  expect_true(nzchar(scratch$correction))
})

test_that("le concept d un automatisme reste coherent avec son gabarit", {
  x = composer_examen("DNB", 2026, seed = 987)
  p1 = x[x$partie_id == "DNB2026_P1", , drop = FALSE]
  liens = .lire_csv("examens", "gabarits_exercices_concepts.csv")

  expect_true(all(!is.na(p1$gabarit_id)))
  for (i in seq_len(nrow(p1))) {
    concepts = liens$concept_id[liens$gabarit_id == p1$gabarit_id[[i]]]
    expect_true(p1$concept_id[[i]] %in% concepts, info = p1$item_id[[i]])
  }
})
