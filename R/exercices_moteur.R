# ============================================================
# Moteur de génération d'exercices
# ============================================================

pgcd = function(a, b) {
  a = abs(as.integer(a)); b = abs(as.integer(b))
  while (b != 0L) {
    tmp = b
    b = a %% b
    a = tmp
  }
  a
}

simplifier_fraction = function(num, den) {
  if (den == 0) stop("D\u00e9nominateur nul.")
  if (den < 0) { num = -num; den = -den }
  g = pgcd(num, den)
  c(num = num / g, den = den / g)
}

fmt_fraction = function(num, den) {
  f = simplifier_fraction(num, den)
  if (f[["den"]] == 1) as.character(f[["num"]]) else paste0(f[["num"]], "/", f[["den"]])
}

creer_exercice = function(modele_id, niveau_id, capacite_id, difficulte,
                           enonce, reponse, correction, parametres, seed = NULL) {
  list(
    exercice_id = paste(modele_id, if (is.null(seed)) sample.int(1e9, 1) else seed, sep = "_"),
    modele_id = modele_id,
    niveau_id = niveau_id,
    capacite_id = capacite_id,
    difficulte = difficulte,
    seed = seed,
    parametres = parametres,
    enonce = enonce,
    reponse = reponse,
    correction = correction
  )
}

generer_equation_1degre = function(niveau_id = "5E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  x = sample(-12:12, 1); if (x == 0) x = 3
  a = sample(c(-9:-2, 2:9), 1)
  b = if (difficulte == 1) 0 else sample(-20:20, 1)
  cst = a * x + b
  enonce = if (b == 0) sprintf("R\u00e9soudre : %dx = %d", a, cst) else sprintf("R\u00e9soudre : %dx %+d = %d", a, b, cst)
  correction = if (b == 0) sprintf("On divise les deux membres par %d : x = %d.", a, x) else sprintf("On soustrait %d, puis on divise par %d : x = %d.", b, a, x)
  creer_exercice("EQ1DEG_001", niveau_id, capacite_id, difficulte, enonce, as.character(x), correction,
                 list(a=a,b=b,c=cst,x=x), seed)
}

generer_addition_fractions = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = c(2,3,4,5,6,8,10,12)
  b = sample(den,1)
  d = if (difficulte == 1) b else sample(den,1)
  a = sample(seq_len(b-1),1); c = sample(seq_len(d-1),1)
  num = a*d + c*b; denom = b*d; res = simplifier_fraction(num,denom)
  enonce = sprintf("Calculer et simplifier : %d/%d + %d/%d", a,b,c,d)
  correction = sprintf("On utilise un d\u00e9nominateur commun : (%d\u00d7%d + %d\u00d7%d)/(%d\u00d7%d) = %s.", a,d,c,b,b,d,fmt_fraction(res[["num"]],res[["den"]]))
  creer_exercice("FRAC_ADD_001", niveau_id, capacite_id, difficulte, enonce,
                 fmt_fraction(res[["num"]],res[["den"]]), correction,
                 list(a=a,b=b,c=c,d=d), seed)
}

generer_proportion = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  q1 = sample(2:8,1); prix_unitaire = sample(2:12,1); q2 = sample(setdiff(2:12,q1),1)
  p1 = q1*prix_unitaire; p2 = q2*prix_unitaire
  enonce = sprintf("%d objets co\u00fbtent %d \u20ac. Combien co\u00fbtent %d objets au m\u00eame prix unitaire ?", q1,p1,q2)
  correction = sprintf("Prix d'un objet : %d / %d = %d \u20ac. Donc %d objets co\u00fbtent %d \u00d7 %d = %d \u20ac.", p1,q1,prix_unitaire,q2,q2,prix_unitaire,p2)
  creer_exercice("PROP_001", niveau_id, capacite_id, difficulte, enonce, paste0(p2," \u20ac"), correction,
                 list(q1=q1,p1=p1,q2=q2,prix_unitaire=prix_unitaire), seed)
}

generer_fraction_quantite = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(2,3,4,5,6,8,10),1); num = sample(seq_len(den-1),1)
  base = sample(2:12,1) * den; rep = base * num / den
  enonce = sprintf("Calculer %d/%d de %d.", num,den,base)
  correction = sprintf("%d/%d de %d = %d \u00d7 %d / %d = %d.", num,den,base,base,num,den,rep)
  creer_exercice("FRAC_QTE_001", niveau_id, capacite_id, difficulte, enonce, as.character(rep), correction,
                 list(num=num,den=den,base=base), seed)
}

generer_pourcentage = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  pct = if (difficulte == 1) sample(c(10,20,25,50,75),1) else sample(c(5,15,30,40,60),1)
  base = sample(2:20,1) * 20
  rep = base * pct / 100
  enonce = sprintf("Calculer %d %% de %d.", pct, base)
  correction = sprintf("%d %% de %d = %d \u00d7 %d / 100 = %d.", pct,base,base,pct,rep)
  creer_exercice("PCT_001", niveau_id, capacite_id, difficulte, enonce, as.character(rep), correction,
                 list(pct=pct,base=base), seed)
}
