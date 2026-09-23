test_that("les bifurcations principales d orientation sont relationnelles", {
  p = orientation_parcours()
  expect_true(all(c("3E", "2GT", "1G", "1T", "POSTBAC") %in% p$noeuds$noeud_id))
  expect_true(all(p$liens$de %in% p$noeuds$noeud_id))
  expect_true(all(p$liens$vers %in% p$noeuds$noeud_id))
})

test_that("les huit series technologiques sont referencees", {
  x = series_technologiques()
  expect_equal(nrow(x), 8L)
  expect_true("STAV" %in% x$serie_id)
})

test_that("les specialites et options du lycee sont distinguees", {
  s = specialites_generales()
  o = enseignements_optionnels_lycee("TG", "2026_2027")
  expect_equal(nrow(s), 13L)
  expect_true(all(s$type == "SPECIALITE"))
  expect_true("MATH_EXPERTES" %in% o$enseignement_id)
  expect_true("MATH_COMPLEMENTAIRES" %in% o$enseignement_id)
})

test_that("Parcoursup separe structure campagne et calendrier", {
  e = parcoursup_etapes()
  c = parcoursup_campagne("PS2026")
  cal = parcoursup_calendrier("PS2026")
  n = parcoursup_nouveautes("PS2026")
  expect_equal(e$etape_id[[1]], "PS_INFO")
  expect_equal(c$annee[[1]], "2026")
  expect_equal(cal$date[cal$evenement_id == "PS26_CAL_03"], "2026-03-12")
  expect_true(all(cal$campagne_id == "PS2026"))
  expect_true(nrow(n) >= 2L)
})

test_that("les grandes filieres post bac ont des durees coherentes", {
  x = filieres_postbac()
  expect_true(all(as.integer(x$duree_min) <= as.integer(x$duree_max)))
  expect_true(all(c("LICENCE", "BUT", "BTS", "CPGE") %in% x$filiere_id))
})

test_that("les schemas orientation sont produits", {
  f1 = tempfile(fileext = ".svg")
  f2 = tempfile(fileext = ".svg")
  f3 = tempfile(fileext = ".svg")
  on.exit(unlink(c(f1, f2, f3)), add = TRUE)
  produire_schema_orientation_svg(f1)
  produire_schema_parcoursup_svg(f2)
  produire_frise_parcoursup_svg("PS2026", f3)
  expect_true(file.exists(f1))
  expect_true(file.exists(f2))
  expect_true(file.exists(f3))
})
