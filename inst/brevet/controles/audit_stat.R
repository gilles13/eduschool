audit_stat = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]+$", "", id)
  d = e$donnees
  r = e$resultats
  notes = as.numeric(unlist(d$notes))
  if (id == "STAT-A-001") {
    effectifs = as.numeric(unlist(d$effectifs))
    if (length(notes) != length(effectifs) || any(effectifs < 0) || any(effectifs != floor(effectifs)) || sum(effectifs) == 0) {
      ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
      return(invisible(NULL))
    }
    serie = rep(notes, effectifs)
    retenus = sum(serie >= as.numeric(d$seuil))
    comparer(id, f, "total", r$total, length(serie))
    comparer(id, f, "moyenne", r$moyenne, mean(serie))
    comparer(id, f, "mediane", r$mediane, stats::median(serie))
    comparer(id, f, "effectif_au_moins_seuil", r$effectif_au_moins_seuil, retenus)
    comparer(id, f, "pourcentage_au_moins_seuil", r$pourcentage_au_moins_seuil, 100 * retenus / length(serie))
  } else if (id == "STAT-B-001") {
    coef = as.numeric(unlist(d$coefficients))
    nouveau = as.numeric(d$nouveau_coefficient)
    objectif = as.numeric(d$objectif)
    if (length(notes) != length(coef) || any(coef <= 0) || nouveau <= 0 || any(notes < 0 | notes > 20)) {
      ajouter(id, f, "configuration", "valide", "invalide", "ERREUR")
      return(invisible(NULL))
    }
    somme = sum(notes * coef)
    total = sum(coef)
    seuil = (objectif * (total + nouveau) - somme) / nouveau
    minimum = if (isTRUE(d$note_entiere)) ceiling(seuil - 1e-10) else seuil
    comparer(id, f, "somme_ponderee", r$somme_ponderee, somme)
    comparer(id, f, "total_coefficients", r$total_coefficients, total)
    comparer(id, f, "moyenne", r$moyenne, weighted.mean(notes, coef))
    comparer(id, f, "moyenne_arrondie", r$moyenne_arrondie, round(weighted.mean(notes, coef), 2))
    comparer(id, f, "etendue", r$etendue, diff(range(notes)))
    comparer(id, f, "seuil_note", r$seuil_note, seuil)
    comparer(id, f, "note_minimale", r$note_minimale, minimum)
    if (minimum > 20 || minimum < 0) ajouter(id, f, "note_possible", "0..20", minimum, "ERREUR")
    moyenne_minimum = (somme + nouveau * minimum) / (total + nouveau)
    moyenne_precedente = (somme + nouveau * (minimum - 1)) / (total + nouveau)
    comparer(id, f, "objectif_avec_note_minimale", TRUE, moyenne_minimum >= objectif)
    if (isTRUE(d$note_entiere) && minimum > 0) comparer(id, f, "minimalite_note_entiere", TRUE, moyenne_precedente < objectif)
    comparer(id, f, "seuil_dans_intervalle", TRUE, seuil >= 0 && seuil <= 20)
  } else ajouter(id, f, "couverture", NA, NA, "NON_VERIFIE")
}
