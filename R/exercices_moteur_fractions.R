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
                           enonce, reponse, correction, parametres, seed = NULL,
                           qcm = NULL) {
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
    correction = correction,
    qcm = qcm
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
  reponse = fmt_fraction(res[["num"]], res[["den"]])
  correction = sprintf(
    "On utilise un d\u00e9nominateur commun : (%d\u00d7%d + %d\u00d7%d)/(%d\u00d7%d) = %s.",
    a,d,c,b,b,d,reponse
  )

  candidats = unique(c(
    fmt_fraction(a + c, b + d),
    fmt_fraction(a * d + c * b, b + d),
    fmt_fraction(a + c, b * d),
    fmt_fraction(abs(a * d - c * b), b * d),
    fmt_fraction(num + 1L, denom),
    fmt_fraction(max(1L, num - 1L), denom)
  ))
  distracteurs = candidats[candidats != reponse]

  k = 1L
  while (length(distracteurs) < 3L) {
    proposition = fmt_fraction(res[["num"]] + k, res[["den"]])
    if (proposition != reponse && !proposition %in% distracteurs) {
      distracteurs = c(distracteurs, proposition)
    }
    k = k + 1L
  }
  distracteurs = distracteurs[seq_len(3L)]

  propositions = c(reponse, distracteurs)
  feedback = c(
    correction,
    vapply(distracteurs, function(x) {
      sprintf(
        "Apr\u00e8s mise au m\u00eame d\u00e9nominateur et simplification, le r\u00e9sultat est %s, pas %s.",
        reponse, x
      )
    }, character(1))
  )

  ordre = sample(seq_len(4L))
  qcm = list(
    intention = "calculer",
    notion = "Fractions",
    rappel = "Pour additionner deux fractions, on les \u00e9crit avec un d\u00e9nominateur commun puis on simplifie le r\u00e9sultat.",
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = feedback[ordre]
  )

  creer_exercice(
    "FRAC_ADD_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(a=a,b=b,c=c,d=d), seed, qcm = qcm
  )
}

generer_proportion = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("cookies", "chaussettes", "crayons"), 1L)
  q1 = sample(2:8, 1); prix_unitaire = sample(2:12, 1); q2 = sample(setdiff(2:12, q1), 1)
  p1 = q1 * prix_unitaire; p2 = q2 * prix_unitaire

  if (cas == "cookies") {
    objet = "cookies"
  } else if (cas == "chaussettes") {
    objet = "chaussettes"
  } else {
    objet = "crayons"
  }
  enonce = sprintf("%d %s coutent %d euros. Combien coutent %d %s au meme prix unitaire ?", q1, objet, p1, q2, objet)
  correction = sprintf("Prix d'un objet : %d / %d = %d euros. Donc %d objets coutent %d x %d = %d euros.", p1, q1, prix_unitaire, q2, q2, prix_unitaire, p2)

  candidats = c(
    p1 + (q2 - q1),
    p1 * q2,
    (q2 - 1) * prix_unitaire,
    (q2 + 1) * prix_unitaire
  )
  feedback_candidats = c(
    "Ajouter ou retirer seulement 1 euro par objet d'ecart ne conserve pas le meme prix unitaire.",
    sprintf("%d euros est deja le prix de %d objets. Le multiplier directement par %d compte beaucoup trop d'objets.", p1, q1, q2),
    sprintf("Ce prix correspond a %d objets, pas a %d.", q2 - 1, q2),
    sprintf("Ce prix correspond a %d objets, pas a %d.", q2 + 1, q2)
  )
  garder = !duplicated(c(p2, candidats))[-1L] & candidats != p2
  distracteurs = candidats[garder][seq_len(3L)]
  feedback_faux = feedback_candidats[garder][seq_len(3L)]

  propositions = c(p2, distracteurs)
  feedback = c(correction, feedback_faux)
  ordre = sample(seq_len(4L))
  qcm = list(
    intention = "appliquer",
    propositions = paste0(propositions[ordre], " euros"),
    correcte = match(1L, ordre),
    feedback = feedback[ordre]
  )

  creer_exercice("PROP_001", niveau_id, capacite_id, difficulte, enonce, paste0(p2, " euros"), correction,
                 list(cas = cas, q1 = q1, p1 = p1, q2 = q2, prix_unitaire = prix_unitaire), seed, qcm = qcm)
}

generer_fraction_quantite = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(2,3,4,5,6,8,10),1)
  num = sample(seq_len(den-1),1)
  base = sample(2:12,1) * den
  rep = base * num / den

  enonce = sprintf("Calculer %d/%d de %d.", num,den,base)
  reponse = as.character(rep)
  correction = sprintf(
    "%d/%d de %d = %d \u00d7 %d / %d = %d.",
    num,den,base,base,num,den,rep
  )

  candidats = unique(c(
    base / den,
    base * num,
    base - rep,
    rep + den,
    abs(rep - den),
    base
  ))
  candidats = candidats[
    is.finite(candidats) &
      candidats >= 0 &
      candidats != rep
  ]

  k = 1L
  while (length(candidats) < 3L) {
    proposition = rep + k
    if (proposition != rep && !proposition %in% candidats) {
      candidats = c(candidats, proposition)
    }
    k = k + 1L
  }

  distracteurs = as.character(candidats[seq_len(3L)])
  propositions = c(reponse, distracteurs)
  feedback = c(
    correction,
    vapply(distracteurs, function(x) {
      sprintf(
        "%d/%d de %d vaut %s, pas %s.",
        num, den, base, reponse, x
      )
    }, character(1))
  )

  ordre = sample(seq_len(4L))
  qcm = list(
    intention = "appliquer",
    notion = "Fractions",
    rappel = "Prendre une fraction d'une quantit\u00e9 revient \u00e0 multiplier la quantit\u00e9 par le num\u00e9rateur puis \u00e0 diviser par le d\u00e9nominateur.",
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = feedback[ordre]
  )

  creer_exercice(
    "FRAC_QTE_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(num=num,den=den,base=base), seed, qcm = qcm
  )
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


generer_pythagore = function(niveau_id = "4E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  triangles = rbind(
    c(3, 4, 5), c(5, 12, 13), c(6, 8, 10), c(8, 15, 17), c(9, 12, 15)
  )
  t = triangles[sample(seq_len(nrow(triangles)), 1L), ]
  k = if (difficulte == 1) 1L else sample(1:3, 1L)
  a = t[[1L]] * k
  b = t[[2L]] * k
  c = t[[3L]] * k
  chercher_hypotenuse = difficulte == 1 || sample(c(TRUE, FALSE), 1L)

  if (chercher_hypotenuse) {
    enonce = sprintf(
      "ABC est rectangle en A, avec AB = %d cm et AC = %d cm. Calculer BC.",
      a, b
    )
    reponse = paste0(c, " cm")
    correction = sprintf(
      "BC est l'hypotenuse. D'apres le theoreme de Pythagore, BC^2 = AB^2 + AC^2 = %d^2 + %d^2 = %d. Donc BC = %d cm.",
      a, b, c^2, c
    )
  } else {
    enonce = sprintf(
      "ABC est rectangle en A, avec AC = %d cm et BC = %d cm. Calculer AB.",
      b, c
    )
    reponse = paste0(a, " cm")
    correction = sprintf(
      "BC est l'hypotenuse. D'apres le theoreme de Pythagore, AB^2 = BC^2 - AC^2 = %d^2 - %d^2 = %d. Donc AB = %d cm.",
      c, b, a^2, a
    )
  }

  creer_exercice(
    "PYTH_001", niveau_id, capacite_id, difficulte, enonce, reponse, correction,
    list(a = a, b = b, c = c, chercher_hypotenuse = chercher_hypotenuse), seed
  )
}


.qcm_fraction = function(propositions, feedback, intention, rappel) {
  if (length(propositions) != 4L || length(unique(propositions)) != 4L) {
    stop("Un QCM de fractions doit proposer quatre reponses distinctes.")
  }
  if (length(feedback) != 4L) {
    stop("Un QCM de fractions doit proposer quatre feedbacks.")
  }
  ordre = sample(seq_len(4L))
  list(
    intention = intention,
    notion = "Fractions",
    rappel = rappel,
    propositions = propositions[ordre],
    correcte = match(1L, ordre),
    feedback = feedback[ordre]
  )
}

.fraction_brute = function(num, den) paste0(num, "/", den)

generer_fraction_quotient = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(2:10, 1L)
  num = sample(seq_len(den - 1L), 1L)
  cas = sample(c("fraction_vers_quotient", "quotient_vers_fraction"), 1L)

  if (cas == "fraction_vers_quotient") {
    enonce = sprintf("Quel quotient est exactement egal a %d/%d ?", num, den)
    reponse = sprintf("%d / %d", num, den)
    propositions = c(
      reponse,
      sprintf("%d / %d", den, num),
      sprintf("%d + %d", num, den),
      sprintf("%d x %d", num, den)
    )
  } else {
    enonce = sprintf("Quelle fraction represente exactement le quotient %d / %d ?", num, den)
    reponse = .fraction_brute(num, den)
    propositions = c(
      reponse,
      .fraction_brute(den, num),
      .fraction_brute(num + 1L, den),
      .fraction_brute(num, den + 1L)
    )
  }

  correction = sprintf("Par definition, %d/%d est le quotient exact de %d par %d.", num, den, num, den)
  feedback = c(
    correction,
    "Cette proposition inverse le role du numerateur et du denominateur.",
    "Cette proposition ne traduit pas le quotient demande.",
    "Cette proposition ne traduit pas le quotient demande."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "interpreter",
    "La fraction a/b designe le quotient exact de a par b, avec b non nul."
  )
  creer_exercice(
    "FRAC_QUOT_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(num = num, den = den, cas = cas), seed, qcm = qcm
  )
}

generer_fraction_droite = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(2L, 3L, 4L, 5L, 6L, 8L), 1L)
  candidats_k = (den + 1L):(3L * den - 1L)
  candidats_k = candidats_k[vapply(candidats_k, function(k) pgcd(k, den) == 1L, logical(1))]
  k = sample(candidats_k, 1L)
  reponse = .fraction_brute(k, den)
  enonce = sprintf(
    "Sur une demi-droite, chaque unite est partagee en %d parts egales. Le point A est a la %de graduation apres 0. Quelle est son abscisse ?",
    den, k
  )
  correction = sprintf("Une graduation vaut 1/%d. Apres %d graduations, A a pour abscisse %s.", den, k, reponse)
  propositions = c(
    reponse,
    .fraction_brute(den, k),
    .fraction_brute(k - 1L, den),
    .fraction_brute(k, den + 1L)
  )
  feedback = c(
    correction,
    "Cette proposition inverse le nombre de graduations et le nombre de parts par unite.",
    "Cette proposition compte une graduation de moins.",
    "Cette proposition change le partage de l'unite."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "placer",
    "Si une unite est partagee en b parts egales, chaque graduation vaut 1/b."
  )
  creer_exercice(
    "FRAC_DROITE_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(k = k, den = den), seed, qcm = qcm
  )
}

generer_fraction_equivalente = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(3:9, 1L)
  num = sample(seq_len(den - 1L), 1L)
  facteur = sample(2:5, 1L)
  reponse = .fraction_brute(num * facteur, den * facteur)
  enonce = sprintf("Quelle fraction est egale a %d/%d ?", num, den)
  propositions = c(
    reponse,
    .fraction_brute(num + facteur, den + facteur),
    .fraction_brute(num * facteur, den),
    .fraction_brute(num, den * facteur)
  )
  correction = sprintf(
    "On multiplie le numerateur et le denominateur par %d : %d/%d = %s.",
    facteur, num, den, reponse
  )
  feedback = c(
    correction,
    "Ajouter le meme nombre au numerateur et au denominateur ne conserve pas la fraction.",
    "Multiplier seulement le numerateur change la valeur de la fraction.",
    "Multiplier seulement le denominateur change la valeur de la fraction."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "reconnaitre_equivalence",
    "Multiplier le numerateur et le denominateur par un meme nombre non nul donne une fraction egale."
  )
  creer_exercice(
    "FRAC_EQUIV_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(num = num, den = den, facteur = facteur), seed, qcm = qcm
  )
}

generer_fraction_comparer = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  cas = sample(c("meme_denominateur", "meme_numerateur"), 1L)
  if (cas == "meme_denominateur") {
    den = sample(4:10, 1L)
    nums = sample(seq_len(den - 1L), 2L)
    a = nums[[1L]]; c = nums[[2L]]; b = den; d = den
  } else {
    num = sample(2:8, 1L)
    dens = sample((num + 1L):(num + 7L), 2L)
    a = num; c = num; b = dens[[1L]]; d = dens[[2L]]
  }
  signe = if (a * d < c * b) "<" else ">"
  reponse = signe
  enonce = sprintf("Quel signe complete correctement : %d/%d ... %d/%d ?", a, b, c, d)
  correction = if (cas == "meme_denominateur") {
    sprintf("Les denominateurs sont identiques : on compare %d et %d. Donc %d/%d %s %d/%d.", a, c, a, b, signe, c, d)
  } else {
    sprintf("Les numerateurs sont identiques : la fraction avec le plus petit denominateur est la plus grande. Donc %d/%d %s %d/%d.", a, b, signe, c, d)
  }
  propositions = c(reponse, if (signe == "<") ">" else "<", "=", "impossible a savoir")
  feedback = c(
    correction,
    "Ce signe donne l'ordre inverse de celui des deux fractions.",
    "Ces deux fractions ne sont pas egales.",
    "Les informations donnees suffisent pour comparer ces deux fractions."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "comparer",
    "Avec un meme denominateur, on compare les numerateurs ; avec un meme numerateur, le plus petit denominateur donne la plus grande fraction."
  )
  creer_exercice(
    "FRAC_COMP_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(a = a, b = b, c = c, d = d, cas = cas), seed, qcm = qcm
  )
}

generer_fraction_encadrer = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(2:8, 1L)
  entier = sample(1:4, 1L)
  reste = sample(seq_len(den - 1L), 1L)
  num = entier * den + reste
  frac = .fraction_brute(num, den)
  reponse = sprintf("%d < %s < %d", entier, frac, entier + 1L)
  enonce = sprintf("Quel encadrement entre deux entiers consecutifs est correct pour %s ?", frac)
  propositions = c(
    reponse,
    sprintf("%d < %s < %d", entier - 1L, frac, entier),
    sprintf("%d < %s < %d", entier + 1L, frac, entier + 2L),
    sprintf("%d < %s < %d", entier - 2L, frac, entier - 1L)
  )
  correction = sprintf("%d = %d x %d + %d, donc %s est compris entre %d et %d.", num, entier, den, reste, frac, entier, entier + 1L)
  feedback = c(
    correction,
    "Cet intervalle est situe une unite trop bas.",
    "Cet intervalle est situe une unite trop haut.",
    "La fraction est superieure a 1."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "encadrer",
    "Pour encadrer a/b, on cherche entre quels multiples consecutifs de b se trouve a."
  )
  creer_exercice(
    "FRAC_ENCADR_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(num = num, den = den, entier = entier, reste = reste), seed, qcm = qcm
  )
}

generer_soustraction_fractions = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(3L, 4L, 5L, 6L, 8L, 10L, 12L), 1L)
  nums = sort(sample(seq_len(den - 1L), 2L), decreasing = TRUE)
  a = nums[[1L]]; c = nums[[2L]]
  reponse = fmt_fraction(a - c, den)
  enonce = sprintf("Calculer et simplifier : %d/%d - %d/%d", a, den, c, den)
  correction = sprintf("Les denominateurs sont identiques : (%d - %d)/%d = %s.", a, c, den, reponse)
  propositions = unique(c(
    reponse,
    fmt_fraction(a + c, den),
    .fraction_brute(a - c, 2L * den),
    .fraction_brute(a - c, max(1L, den - 1L)),
    .fraction_brute(a, den - c)
  ))
  propositions = propositions[seq_len(4L)]
  feedback = c(
    correction,
    sprintf("La difference vaut %s.", reponse),
    sprintf("La difference vaut %s.", reponse),
    sprintf("La difference vaut %s.", reponse)
  )
  qcm = .qcm_fraction(
    propositions, feedback, "soustraire",
    "Avec le meme denominateur, on soustrait les numerateurs et on conserve le denominateur."
  )
  creer_exercice(
    "FRAC_SUB_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(a = a, c = c, den = den), seed, qcm = qcm
  )
}

generer_fraction_terme_manquant = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(4L, 5L, 6L, 8L, 10L, 12L), 1L)
  cibles = seq.int(3L, den - 1L)
  cible = cibles[[sample.int(length(cibles), 1L)]]
  connu = sample(seq_len(cible - 1L), 1L)
  manque = cible - connu
  reponse = .fraction_brute(manque, den)
  enonce = sprintf("Quelle fraction manque ?  ? + %d/%d = %d/%d", connu, den, cible, den)
  correction = sprintf("Il faut completer %d jusqu'a %d : %d - %d = %d. La fraction manquante est %s.", connu, cible, cible, connu, manque, reponse)
  nums_faux = unique(c(connu, cible + connu, max(1L, manque - 1L), manque + 1L, cible))
  nums_faux = nums_faux[nums_faux != manque]
  propositions = c(
    reponse,
    vapply(nums_faux[seq_len(3L)], function(x) .fraction_brute(x, den), character(1))
  )
  feedback = c(
    correction,
    "Cette proposition additionne au lieu de chercher ce qui manque.",
    "Le denominateur reste le meme dans cette addition.",
    "Cette proposition recopie la fraction deja connue."
  )
  qcm = .qcm_fraction(
    propositions, feedback, "completer",
    "Avec le meme denominateur, chercher le terme manquant revient a completer les numerateurs."
  )
  creer_exercice(
    "FRAC_MANQ_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(connu = connu, cible = cible, manque = manque, den = den), seed, qcm = qcm
  )
}

generer_fraction_par_entier = function(niveau_id = "6E", capacite_id = NA_character_, difficulte = 1, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  den = sample(c(2L, 3L, 4L, 5L, 6L, 8L), 1L)
  num = sample(seq_len(den - 1L), 1L)
  entier = sample(2:8, 1L)
  reponse = fmt_fraction(entier * num, den)
  enonce = sprintf("Calculer et simplifier : %d x %d/%d", entier, num, den)
  correction = sprintf("%d x %d/%d = (%d x %d)/%d = %s.", entier, num, den, entier, num, den, reponse)
  propositions = c(
    reponse,
    fmt_fraction(entier * num + den, den),
    .fraction_brute(entier * num, entier * den),
    .fraction_brute(num, entier * den)
  )
  feedback = c(
    correction,
    sprintf("Le produit vaut %s.", reponse),
    sprintf("Le produit vaut %s.", reponse),
    sprintf("Le produit vaut %s.", reponse)
  )
  qcm = .qcm_fraction(
    propositions, feedback, "multiplier",
    "Multiplier a/b par un entier n revient a multiplier le numerateur par n."
  )
  creer_exercice(
    "FRAC_MULT_ENT_001", niveau_id, capacite_id, difficulte, enonce,
    reponse, correction, list(entier = entier, num = num, den = den), seed, qcm = qcm
  )
}
