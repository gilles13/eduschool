test_that("les identites remarquables ouvrent cinq intentions pedagogiques", {
  x = exercices("2GT", "identites remarquables", n = 5, seed = 2026, humour_ratio = 0)
  intentions = vapply(x, function(ex) ex$qcm$intention, character(1))
  expect_setequal(intentions, c("reconnaitre", "developper", "factoriser", "se_mefier_des_signes", "relier_equivalence"))
  expect_length(unique(vapply(x, function(ex) ex$modele_id, character(1))), 5L)
})

test_that("les identites remarquables fournissent quinze situations QCM", {
  generateurs = list(
    generer_identite_reconnaitre,
    generer_identite_developper,
    generer_identite_factoriser,
    generer_identite_signe,
    generer_identite_equivalence
  )
  cas_attendus = list(
    c("carre_somme", "carre_difference", "difference_carres"),
    c("carre_somme", "carre_difference", "produit_conjugue"),
    c("carre_somme", "carre_difference", "difference_carres"),
    c("plus", "moins", "difference"),
    c("somme", "difference", "carres")
  )
  for (i in seq_along(generateurs)) {
    lot = lapply(1:100, function(seed) generateurs[[i]](seed = seed))
    cas = unique(vapply(lot, function(ex) ex$parametres$cas, character(1)))
    expect_setequal(cas, cas_attendus[[i]])
    expect_true(all(vapply(lot, function(ex) {
      length(ex$qcm$propositions) == 4L &&
        length(unique(ex$qcm$propositions)) == 4L &&
        identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
    }, logical(1))))
  }
})

test_that("un quiz d identites remarquables est directement produisible", {
  x = exercices("2GT", "identites remarquables", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")
  expect_true(file.exists(sortie))
  expect_true(grepl("Identités remarquables", html, fixed = TRUE))
  expect_true(grepl("<sup>2</sup>", html, fixed = TRUE))

  rendus = vapply(x, function(ex) {
                      paste(
                            .html_math(ex$enonce),
                            .html_math(ex$qcm$propositions),
                            .html_correction(ex$correction),
                            collapse = "\n"
                      )
  }, character(1))

  expect_false(any(grepl("\\^-?[0-9]+", rendus, perl = TRUE)))
  expect_equal(length(x), 15L)
})


test_that("Ryacas valide les developpements produits par eduschool", {
  skip_if_not_installed("Ryacas")

  lot = lapply(1:100, function(seed) generer_identite_developper(seed = seed))

  validations = vapply(lot, function(ex) {
    commande = sprintf(
      "TestYacas(%s, %s)",
      ex$parametres$expression_depart,
      ex$parametres$expression_resultat
    )
    identical(Ryacas::yac_str(commande), "True")
  }, logical(1))

  expect_true(all(validations))
})

test_that("la question d equivalence conserve le a accent grave", {
  lot = lapply(1:100, function(seed) generer_identite_equivalence(seed = seed))
  enonces = vapply(lot, function(ex) ex$enonce, character(1))

  expect_true(all(grepl(" à ", enonces, fixed = TRUE)))
  expect_false(any(grepl(" a ", enonces, fixed = TRUE)))
})


test_that("les identites distinguent visuellement multiplication et variable", {
  lot = lapply(1:100, function(seed) generer_identite_signe(seed = seed))
  corrections = vapply(lot, function(ex) ex$correction, character(1))

  expect_true(any(grepl("2 \u00d7 \U0001d465 \u00d7", corrections, fixed = TRUE)))
  expect_true(any(grepl("-2 \u00d7 \U0001d465 \u00d7", corrections, fixed = TRUE)))
})

test_that("la correction d equivalence distingue verifier et demontrer", {
  ex = generer_identite_equivalence(seed = 2026)

  expect_match(ex$correction, "vraie pour toutes les valeurs admises", fixed = TRUE)
  expect_match(ex$correction, "ne suffit pas à démontrer l'identité", fixed = TRUE)
  expect_identical(ex$qcm$feedback[[1L]], ex$correction)
})

test_that("les exercices d'identites remarquables conservent les accents", {
  reconnaitre = generer_identite_reconnaitre(seed = 2026)
  developper = generer_identite_developper(seed = 2026)
  factoriser = generer_identite_factoriser(seed = 2026)

  expect_match(reconnaitre$enonce, "identité remarquable", fixed = TRUE)
  expect_match(reconnaitre$enonce, "reconnaît-on", fixed = TRUE)
  expect_match(developper$enonce, "Développer", fixed = TRUE)
  expect_match(factoriser$correction, "reconnaît l'identité", fixed = TRUE)
  expect_equal(reconnaitre$qcm$notion, "Identités remarquables")
})

