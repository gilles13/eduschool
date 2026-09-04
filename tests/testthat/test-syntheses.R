test_that("les syntheses de sixieme sont transdisciplinaires", {
  h = horaires_niveau("6E")
  t = themes_niveau("6E")
  n = notions_niveau("6E")
  r = resume_niveau("6E")
  expect_gte(nrow(h), 8)
  expect_true(all(c("FRA", "MAT", "HG", "SCI", "LVE", "EMC", "EPS", "ARTS", "MUS") %in% unique(t$discipline_id)))
  expect_true(all(c("FRA", "MAT", "HG", "SCI", "LVE", "EMC", "EPS", "ARTS", "MUS") %in% unique(n$discipline_id)))
  expect_true(all(nzchar(r$themes)))
  expect_true(all(nzchar(r$notions)))
})

test_that("la proportionnalite de sixieme a des prerequis", {
  x = prerequis_capacite("ITM_MAT_C3_6E_C31", recursif = TRUE)
  expect_gt(nrow(x), 0)
  expect_true("MAT_NOMBRES_ENTIERS_ET_DECIMAUX" %in% x$notion_id)
})

test_that("plusieurs domaines de sixieme exposent des prerequis", {
  cas = c(
    "ITM_MAT_C3_6E_C09",
    "ITM_MAT_C3_6E_C17",
    "ITM_MAT_C3_6E_C25",
    "ITM_MAT_C3_6E_C28",
    "ITM_MAT_C3_6E_C31"
  )
  nb = vapply(cas, function(id) nrow(prerequis_capacite(id, recursif = TRUE)), integer(1))
  expect_true(all(nb > 0L))
})

test_that("les synthèses couvrent tout le collège", {
  for (niveau in c("5E", "4E", "3E")) {
    x = resume_niveau(niveau)
    expect_gt(nrow(x), 0L)
    expect_true(all(nzchar(x$themes)))
    expect_true(all(nzchar(x$notions)))
  }
})

test_that("les synthèses couvrent le lycée", {
  expect_gt(nrow(resume_niveau("2GT")), 5)
  expect_gt(nrow(resume_niveau("1G")), 5)
  expect_gt(nrow(resume_niveau("TG")), 5)
})

test_that("les thèmes de spécialité restent attachés à leur enseignement", {
  x = themes_niveau("1G")
  expect_true("enseignement_id" %in% names(x))
  expect_true(any(x$enseignement_id == "HGGSP"))
  expect_true(any(x$enseignement_id == "HG_LYCEE"))
})

test_that("les langues vivantes alimentent LVE1 et LVE2", {
  for (niveau in c("5E", "4E", "3E")) {
    x = resume_niveau(niveau)
    lve = x[x$enseignement %in% c("Langue vivante 1", "Langue vivante 2"), , drop = FALSE]
    expect_equal(nrow(lve), 2L)
    expect_true(all(nzchar(lve$themes)))
    expect_true(all(nzchar(lve$notions)))
  }
})

test_that("genere_resume produit une vue courte de sixieme", {
  x = genere_resume("6E")
  expect_equal(names(x), c("matiere", "horaire", "themes", "notions"))
  expect_gte(nrow(x), 8L)
  expect_true(all(nzchar(x$matiere)))
  expect_true(all(nzchar(x$horaire)))
  expect_true(all(nzchar(x$themes)))
  expect_true(all(nzchar(x$notions)))
})

test_that("genere_resume filtre les mathematiques", {
  x = genere_resume("6E", matiere = "MAT")
  expect_equal(nrow(x), 1L)
  expect_equal(x$matiere, "Math\u00e9matiques")

  y = genere_resume("6E", matiere = "maths")
  expect_equal(y, x)
})

test_that("genere_resume limite themes et notions", {
  x = genere_resume("6E", matiere = "MAT", max_themes = 2L, max_notions = 3L)
  expect_lte(length(strsplit(x$themes, ";", fixed = TRUE)[[1]]), 3L)
  expect_lte(length(strsplit(x$notions, ";", fixed = TRUE)[[1]]), 4L)
})

test_that("genere_resume signale une matiere inconnue", {
  expect_error(genere_resume("6E", matiere = "INCONNUE"), "Aucune matiere")
})
