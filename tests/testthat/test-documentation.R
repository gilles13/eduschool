test_that("les notions et documents sont cohérents", {
  n = notions()
  expect_false(anyDuplicated(n$notion_id) > 0L)
  expect_true(all(vapply(n$notion_id, function(id) file.exists(eduschool::eduschool_path("documentation", n$document[n$notion_id == id][1])), logical(1))))
})

test_that("les liens documentaires ne sont pas orphelins", {
  nc = read.csv2(eduschool::eduschool_path("documentation", "notions_capacites.csv"), stringsAsFactors = FALSE)
  expect_true(all(nc$notion_id %in% notions()$notion_id))
  expect_true(all(nc$capacite_id %in% capacites(discipline_id = "MAT")$item_id))
})
