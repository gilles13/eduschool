audit_proba = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]{3}$", "", id)
  if (identical(f, "PROBA-D")) {
    d = e$donnees
    r = e$resultats
    n = as.numeric(d$nombre_boules)
    if (length(n) != 1L || !is.finite(n) || n < 2 || n != floor(n)) { ajouter(id, f, "nombre_boules", "entier >= 2", "invalide", "ERREUR"); return(invisible(NULL)) }
    nombres = seq_len(n)
    premiers = nombres[nombres >= 2 & vapply(nombres, function(k) !any(k %% seq_len(max(1L, floor(sqrt(k))))[-1L] == 0), logical(1))]
    np = length(premiers)
    pairs = sum(nombres %% 2 == 0)
    m3 = sum(nombres %% 3 == 0)
    comparer(id, f, "nombre_pairs", r$nombre_pairs, pairs)
    comparer(id, f, "nombre_multiples_3", r$nombre_multiples_3, m3)
    comparer(id, f, "nombre_premiers", r$nombre_premiers, np)
    comparer(id, f, "p_pair", r$p_pair, pairs / n)
    comparer(id, f, "p_multiple_3", r$p_multiple_3, m3 / n)
    comparer(id, f, "p_premier", r$p_premier, np / n)
    comparer(id, f, "comparaison", r$comparaison, if (pairs > np) "pairs" else if (np > pairs) "premiers" else "egales")
    comparer(id, f, "p_non_multiple_3", r$p_non_multiple_3, 1 - m3 / n)
    return(invisible(NULL))
  }
  if (identical(f, "PROBA-B") || identical(f, "PROBA-C")) {
    audit_proba_bc(e, comparer, ajouter)
    return(invisible(NULL))
  }
  d = e$donnees
  r = e$resultats
  n = as.numeric(unlist(d[c("rouges", "bleues", "vertes")]))
  if (length(n) != 3L || any(!is.finite(n)) || any(n <= 0) || any(n != floor(n))) {
    ajouter(id, f, "configuration", "effectifs entiers positifs", "invalide", "ERREUR")
    return(invisible(NULL))
  }
  total = sum(n)
  comparer(id, f, "total", r$total, total)
  comparer(id, f, "p_rouge", r$p_rouge, n[1] / total)
  comparer(id, f, "p_non_bleue", r$p_non_bleue, (n[1] + n[3]) / total)
  comparer(id, f, "p_verte", r$p_verte, n[3] / total)
  comparer(id, f, "somme_probabilites", 1, sum(n / total))
  comparer(id, f, "complementaire", r$p_non_bleue, 1 - n[2] / total)
  if (any(unlist(r[c("p_rouge", "p_non_bleue", "p_verte")]) < 0 | unlist(r[c("p_rouge", "p_non_bleue", "p_verte")]) > 1)) ajouter(id, f, "bornes_probabilites", "0..1", "hors bornes", "ERREUR")
}

audit_proba_bc = function(e, comparer, ajouter) {
  id = e$id
  f = sub("-[0-9]{3}$", "", id)
  d = e$donnees
  r = e$resultats
  if (identical(f, "PROBA-B")) {
    n = as.numeric(unlist(d[c("rouges", "bleues", "vertes", "ajout_vertes")]))
    if (length(n) != 4L || any(!is.finite(n)) || any(n <= 0) || any(n != floor(n))) { ajouter(id, f, "effectifs", "entiers positifs", "invalide", "ERREUR"); return(invisible(NULL)) }
    total = sum(n[1:3])
    comparer(id, f, "total", r$total, total)
    comparer(id, f, "p_bleue", r$p_bleue, n[2] / total)
    comparer(id, f, "p_non_rouge", r$p_non_rouge, (n[2] + n[3]) / total)
    comparer(id, f, "total_apres", r$total_apres, total + n[4])
    comparer(id, f, "p_verte_apres", r$p_verte_apres, (n[3] + n[4]) / (total + n[4]))
  } else {
    n = as.numeric(unlist(d[c("a_rouges", "a_bleues", "b_rouges", "b_bleues", "ajout_rouges_b")]))
    if (length(n) != 5L || any(!is.finite(n)) || any(n <= 0) || any(n != floor(n))) { ajouter(id, f, "effectifs", "entiers positifs", "invalide", "ERREUR"); return(invisible(NULL)) }
    ta = n[1] + n[2]
    tb = n[3] + n[4]
    pa = n[1] / ta
    pb = n[3] / tb
    comparer(id, f, "total_a", r$total_a, ta)
    comparer(id, f, "total_b", r$total_b, tb)
    comparer(id, f, "p_rouge_a", r$p_rouge_a, pa)
    comparer(id, f, "p_rouge_b", r$p_rouge_b, pb)
    comparer(id, f, "comparaison", r$comparaison, if (pa > pb) "A" else if (pa < pb) "B" else "egales")
    comparer(id, f, "total_b_apres", r$total_b_apres, tb + n[5])
    comparer(id, f, "p_rouge_b_apres", r$p_rouge_b_apres, (n[3] + n[5]) / (tb + n[5]))
    comparer(id, f, "egalite_apres", pa, (n[3] + n[5]) / (tb + n[5]))
  }
}
