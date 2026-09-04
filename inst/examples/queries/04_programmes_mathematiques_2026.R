# Programmes de mathématiques publiés en 2026

programmes_mathematiques <- function() {
  tables$programmes |>
    dplyr::filter(discipline_id == "MAT") |>
    dplyr::arrange(date_publication, programme_id)
}

items_mathematiques <- function(programme = NULL) {
  x <- tables$programme_items
  if (!is.null(programme)) x <- dplyr::filter(x, programme_id %in% programme)
  x |>
    dplyr::arrange(programme_id, niveau, ordre)
}
