DBI::dbGetQuery(con, "
SELECT item_id, parent_item_id, libelle, description
FROM programme_items
WHERE programme_id = 'PRG_MAT_C3_2025'
  AND niveau = '6E'
  AND type = 'CAPACITE'
ORDER BY parent_item_id, ordre
")
