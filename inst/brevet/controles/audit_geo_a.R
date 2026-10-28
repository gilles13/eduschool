audit_geo_a = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]+$", "", id)
  d = lapply(e$donnees, as.numeric)
  r = e$resultats
  if (id == "GEO-A-001") {
    if (any(unlist(d) <= 0) || d$AD >= d$AB || d$AE >= d$AC) ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
    comparer(id, f, "BC", r$BC, sqrt(d$AB^2 + d$AC^2))
    comparer(id, f, "paralleles_DE_BC", r$paralleles_DE_BC, isTRUE(all.equal(d$AD * d$AC, d$AE * d$AB)))
    comparer(id, f, "DE", r$DE, sqrt(d$AD^2 + d$AE^2))
    comparer(id, f, "aire_DBCE", r$aire_DBCE, (d$AB * d$AC - d$AD * d$AE) / 2)
  } else if (id == "GEO-B-001") {
    if (any(unlist(d) <= 0)) ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
    comparer(id, f, "OA", r$OA, sqrt(d$OB^2 + d$AB^2))
    ajouter(id, f, "paralleles_AB_CD", r$paralleles_AB_CD, NA, "NON_VERIFIE", "Hypotheses d'angles droits absentes du JSON")
    cd = d$AB * d$OD / d$OB
    comparer(id, f, "CD", r$CD, cd)
    comparer(id, f, "aire_OCD", r$aire_OCD, d$OD * cd / 2)
  } else if (id == "GEO-C-001") {
    if (any(unlist(d) <= 0) || d$AD >= d$AB) ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
    comparer(id, f, "AC", r$AC, sqrt(d$AB^2 + d$BC^2))
    ajouter(id, f, "paralleles_DE_BC", r$paralleles_DE_BC, NA, "NON_VERIFIE", "Hypotheses d'angles droits absentes du JSON")
    de = d$BC * d$AD / d$AB
    comparer(id, f, "DE", r$DE, de)
    comparer(id, f, "aire_DBCE", r$aire_DBCE, (d$AB * d$BC - d$AD * de) / 2)
  } else if (f == "GEO-D") {
    rc = d$rayon_cylindre
    rs = d$rayon_demi_sphere
    h = d$hauteur
    if (any(unlist(d) <= 0) || rc > rs) ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
    comparer(id, f, "aire_cylindre_coefficient_pi", r$aire_cylindre_coefficient_pi, 2 * rc * h + 2 * rc^2)
    comparer(id, f, "aire_demi_boule_coefficient_pi", r$aire_demi_boule_coefficient_pi, 3 * rs^2)
    comparer(id, f, "aire_contact_coefficient_pi", r$aire_contact_coefficient_pi, rc^2)
    comparer(id, f, "aire_exterieure_coefficient_pi", r$aire_exterieure_coefficient_pi, 2 * rc * h + 3 * rs^2)
  } else ajouter(id, f, "couverture", NA, NA, "NON_VERIFIE")
}
