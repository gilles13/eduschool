# ============================================================
# Rendu des fiches et des liens mathematiques
# ============================================================

.formule_math_markdown = function(x) {
  if (length(x) != 1L || is.na(x) || !nzchar(x)) return("")
  paste0("\n$$\n", x, "\n$$\n\n")
}

.relations_niveau_math = function(niveau_id) {
  concepts_niveau = concepts_math(niveau_introduction = niveau_id)
  if (!nrow(concepts_niveau)) return(data.frame())

  relations = relations_concepts_math(concept_id = concepts_niveau$concept_id)
  relations = relations[
    relations$concept_id %in% concepts_niveau$concept_id &
      relations$importance == "fort",
    ,
    drop = FALSE
  ]
  if (!nrow(relations)) return(relations)

  concepts_ref = concepts_math()
  libelles = stats::setNames(concepts_ref$libelle, concepts_ref$concept_id)
  source = unname(libelles[relations$concept_id])
  cible = unname(libelles[relations$concept_lie_id])
  source[is.na(source)] = relations$concept_id[is.na(source)]
  cible[is.na(cible)] = relations$concept_lie_id[is.na(cible)]

  inverser = relations$type_relation %in% c(
    "FORMALISE", "REPOSE_SUR", "MOBILISE", "GEOMETRISE",
    "PROLONGE", "MODELISATION", "STRUCTURE", "UTILISE", "SPECIALISE"
  )
  symetrique = relations$type_relation %in% c("ASSOCIE", "COMPARE", "REPRESENTE")

  relations$depart_libelle = ifelse(inverser, cible, source)
  relations$arrivee_libelle = ifelse(inverser, source, cible)
  relations$fleche_html = ifelse(symetrique, "&harr;", "&rarr;")
  rownames(relations) = NULL
  relations
}

.html_revision = function(x) {
  x = gsub("&", "&amp;", as.character(x), fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  x = gsub('"', "&quot;", x, fixed = TRUE)
  x
}

.rendre_relations_niveau_html = function(niveau_id) {
  relations = .relations_niveau_math(niveau_id)
  if (!nrow(relations)) return("")

  css = paste0(
    '<style>\n',
    '.eduschool-carte-liens{display:grid;gap:.85rem;margin:1.1rem 0 1.6rem;}\n',
    '.eduschool-lien{padding:.25rem 0 .8rem;border-bottom:1px solid var(--bs-border-color,#dee2e6);}\n',
    '.eduschool-chemin{display:flex;align-items:center;flex-wrap:wrap;gap:.5rem;font-size:1.08rem;line-height:1.35;}\n',
    '.eduschool-noeud{font-weight:700;}\n',
    '.eduschool-fleche{font-size:1.35rem;font-weight:700;line-height:1;}\n',
    '.eduschool-explication{margin:.3rem 0 0;color:var(--bs-secondary-color,#5c636a);}\n',
    '</style>\n'
  )

  lignes = vapply(seq_len(nrow(relations)), function(i) {
    source = .html_revision(relations$depart_libelle[[i]])
    cible = .html_revision(relations$arrivee_libelle[[i]])
    fleche = relations$fleche_html[[i]]
    commentaire = .html_revision(relations$commentaire[[i]])
    paste0(
      '<div class="eduschool-lien">',
      '<div class="eduschool-chemin">',
      '<span class="eduschool-noeud">', source, '</span>',
      '<span class="eduschool-fleche" aria-hidden="true">', fleche, '</span>',
      '<span class="eduschool-noeud">', cible, '</span>',
      '</div>',
      '<p class="eduschool-explication">', commentaire, '</p>',
      '</div>'
    )
  }, character(1))

  paste0(css, '<div class="eduschool-carte-liens">\n', paste(lignes, collapse = "\n"), '\n</div>\n')
}
