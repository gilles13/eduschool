programmes_niveau = programme_applications |>
  filter(niveau_id == "1G", version_id == "2026_2027") |>
  left_join(programmes, by = "programme_id") |>
  left_join(disciplines, by = "discipline_id") |>
  collect()
