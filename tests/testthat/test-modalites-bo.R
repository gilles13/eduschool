test_that("les modalites BO proviennent des referentiels", {
  x = modalites_bo("programmes")
  expect_true("PRG_MAT_C3_2025" %in% x$programme_id)
  expect_true(all(file.exists(file.path(system.file("programmes", "textes", package = "eduschool"), paste0(x$programme_id, ".md")))))
  y = modalites_bo("notions_documentaires")
  expect_true("MAT_AIRES" %in% y$notion_id)
})
test_that("consulter_bo utilise les cycles au college", {
  expect_error(consulter_bo("6E", ouvrir = FALSE), "C3")
  expect_error(consulter_bo("5E", ouvrir = FALSE), "C4")
  expect_true(is.character(consulter_bo("C3", ouvrir = FALSE)) || is.data.frame(consulter_bo("C3", ouvrir = FALSE)))
})
