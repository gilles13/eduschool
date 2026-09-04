specialites_1G = offres_enseignements |>
  filter(niveau_id == "1G", statut == "SPECIALITE") |>
  left_join(enseignements, by = "enseignement_id") |>
  collect()
