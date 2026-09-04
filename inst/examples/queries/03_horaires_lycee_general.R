horaires_1G = horaires |>
  filter(niveau_id == "1G", version_id == "2026_2027") |>
  left_join(enseignements, by = "enseignement_id") |>
  collect()
