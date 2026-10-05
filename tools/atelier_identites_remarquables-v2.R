# Atelier jetable - identites remarquables.
# Copie adaptee de documentation/modeles/atelier_questions.R.
# Hors package : ce fichier fabrique et controle le contenu, il ne pilote pas eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
valides = list()
rejets = list()
moins = "\u2212"
x_math = "\U0001D465"
controle_affichage = function(...) {
  textes = unlist(list(...), use.names = FALSE)
  if (any(grepl("[\\^*]", textes))) stop("Syntaxe moteur detectee dans un texte destine a l affichage.")
  if (any(grepl("(?<![A-Za-z])x(?![A-Za-z])", textes, perl = TRUE))) stop("Variable x ASCII detectee dans un texte destine a l affichage.")
  invisible(TRUE)
}
# Audit des types :
# - QCM symbolique de developpement : retenu.
# - QCM symbolique de factorisation : retenu.
# - QCM de reconnaissance / raisonnement historiques : conserves.
# - boite : retenue pour retrouver le double produit.
# - mot_a_trou : retenu pour "identite".
# - mot_masque : retenu pour un autre mot, "conjuguees".
# - aucun nouveau type ni nouveau mode moteur.
fmt_ax = function(a) if (a == 1L) x_math else paste0(a, x_math)
fmt_binome = function(a, b, signe) paste0("(", fmt_ax(a), " ", signe, " ", b, ")")
fmt_trinome = function(a2, ab2, b2, signe) paste(paste0(a2, x_math, "\u00b2"), signe, paste0(ab2, x_math), "+", b2)
fmt_difference = function(a2, b2) paste(paste0(a2, x_math, "\u00b2"), moins, b2)
verifier_equivalence = function(source, candidat) {
  resultat = Ryacas::yac_str(paste0("Simplify(Expand((", source, ")-(``, candidat, ")))"))
  identical(trimws(resultat), "0")
}
# Le remplacement des deux backticks ci-dessus est volontairement fait ici pour
# garder la construction de la commande Ryacas lisible en ASCII.
verifier_equivalence = function(source, candidat) {
  commande = paste0("Simplify(Expand((", source, ")-(`", candidat, ")))" )
  commande = gsub("`", "", commande, fixed = TRUE)
  identical(trimws(Ryacas::yac_str(commande)), "0")
}
ajouter = function(banque, progression, source, affichage_source, bonne, bonne_expression, distracteurs, expressions, types) {
  controle_affichage(affichage_source, bonne, distracteurs)
  raison = character()
  candidats = c(bonne_expression, expressions)
  equivalences = vapply(candidats, function(z) verifier_equivalence(source, z), logical(1))
  if (!identical(equivalences, c(TRUE, FALSE, FALSE, FALSE))) raison = c(raison, "unicite algebrique non respectee")
  if (anyDuplicated(c(bonne, distracteurs))) raison = c(raison, "collision entre propositions")
  item = list(banque = banque, progression = progression, source = affichage_source, bonne = bonne, distracteurs = distracteurs, types_distracteurs = types, valides = !length(raison), raison = paste(raison, collapse = " ; "))
  if (item$valides) valides[[length(valides) + 1L]] <<- item else rejets[[length(rejets) + 1L]] <<- item
}
# DEVELOPPEMENT : (ax+b)^2, (ax-b)^2, (ax-b)(ax+b).
# Les domaines sont volontairement finis : l atelier explore, le JSON selectionne.
comb_dev = rbind(
  cbind(1L, 1L, 2:18),
  cbind(2L, rep(c(1L,2L), length.out = 17L), 2:18),
  cbind(3L, rep(c(1L,2L,3L), length.out = 16L), 2:17)
)
for (i in seq_len(nrow(comb_dev))) {
  p = comb_dev[i,1]; a = comb_dev[i,2]; b = comb_dev[i,3]
  famille = ((i - 1L) %% 3L) + 1L
  if (famille == 1L) {
    source = paste0("(", a, "*x+", b, ")^2"); affichage = paste0(fmt_binome(a,b,"+"), "\u00b2")
    bonne = fmt_trinome(a*a, 2*a*b, b*b, "+"); bonne_expr = paste0(a*a,"*x^2+",2*a*b,"*x+",b*b)
    d = c(fmt_trinome(a*a,a*b,b*b,"+"), fmt_trinome(a*a,2*a*b,b*b,moins), paste(paste0(a*a, x_math, "\u00b2"), "+", b*b))
    de = c(paste0(a*a,"*x^2+",a*b,"*x+",b*b),paste0(a*a,"*x^2-",2*a*b,"*x+",b*b),paste0(a*a,"*x^2+",b*b))
    types = c("double produit oublie", "signe du double produit inverse", "terme croise omis")
  } else if (famille == 2L) {
    source = paste0("(", a, "*x-", b, ")^2"); affichage = paste0(fmt_binome(a,b,moins), "\u00b2")
    bonne = fmt_trinome(a*a, 2*a*b, b*b, moins); bonne_expr = paste0(a*a,"*x^2-",2*a*b,"*x+",b*b)
    d = c(fmt_trinome(a*a,a*b,b*b,moins), fmt_trinome(a*a,2*a*b,b*b,"+"), paste(paste0(a*a, x_math, "\u00b2"), "+", b*b))
    de = c(paste0(a*a,"*x^2-",a*b,"*x+",b*b),paste0(a*a,"*x^2+",2*a*b,"*x+",b*b),paste0(a*a,"*x^2+",b*b))
    types = c("double produit incomplet", "signe du double produit inverse", "terme croise omis")
  } else {
    source = paste0("(",a,"*x-",b,")*(",a,"*x+",b,")"); affichage = paste0(fmt_binome(a,b,moins),fmt_binome(a,b,"+"))
    bonne = fmt_difference(a*a,b*b); bonne_expr = paste0(a*a,"*x^2-",b*b)
    d = c(paste(paste0(a*a, x_math, "\u00b2"), "+", b*b), fmt_trinome(a*a,2*a*b,b*b,moins), fmt_trinome(a*a,2*a*b,b*b,"+"))
    de = c(paste0(a*a,"*x^2+",b*b),paste0(a*a,"*x^2-",2*a*b,"*x+",b*b),paste0(a*a,"*x^2+",2*a*b,"*x+",b*b))
    types = c("signe de la difference de carres", "confusion avec carre d une difference", "confusion avec carre d une somme")
  }
  ajouter("developpement",p,source,affichage,bonne,bonne_expr,d,de,types)
}
# FACTORISATION : memes identites lues dans l autre sens.
comb_fac = comb_dev
for (i in seq_len(nrow(comb_fac))) {
  p = comb_fac[i,1]; a = comb_fac[i,2]; b = comb_fac[i,3]
  famille = ((i - 1L) %% 3L) + 1L
  if (famille == 1L) {
    source = paste0(a*a,"*x^2+",2*a*b,"*x+",b*b); affichage = fmt_trinome(a*a,2*a*b,b*b,"+")
    bonne = paste0(fmt_binome(a,b,"+"),"\u00b2"); bonne_expr = paste0("(",a,"*x+",b,")^2")
    d = c(paste0(fmt_binome(a,b,moins),"\u00b2"),paste0(fmt_binome(a,b,"+"),fmt_binome(a,b,moins)),paste0(fmt_ax(a),"(",fmt_ax(a)," + ",b,")"))
    de = c(paste0("(",a,"*x-",b,")^2"),paste0("(",a,"*x+",b,")*(",a,"*x-",b,")"),paste0(a,"*x*(``,a,"*x+",b,")"))
    de[3] = gsub("`", "", de[3], fixed = TRUE)
    types = c("signe du binome inverse", "confusion difference de carres", "mise en facteur incomplete")
  } else if (famille == 2L) {
    source = paste0(a*a,"*x^2-",2*a*b,"*x+",b*b); affichage = fmt_trinome(a*a,2*a*b,b*b,moins)
    bonne = paste0(fmt_binome(a,b,moins),"\u00b2"); bonne_expr = paste0("(",a,"*x-",b,")^2")
    d = c(paste0(fmt_binome(a,b,"+"),"\u00b2"),paste0(fmt_binome(a,b,moins),fmt_binome(a,b,"+")),paste0(fmt_ax(a),"(",fmt_ax(a)," ",moins," ",b,")"))
    de = c(paste0("(",a,"*x+",b,")^2"),paste0("(",a,"*x-",b,")*(",a,"*x+",b,")"),paste0(a,"*x*(``,a,"*x-",b,")"))
    de[3] = gsub("`", "", de[3], fixed = TRUE)
    types = c("signe du binome inverse", "confusion difference de carres", "mise en facteur incomplete")
  } else {
    source = paste0(a*a,"*x^2-",b*b); affichage = fmt_difference(a*a,b*b)
    bonne = paste0(fmt_binome(a,b,moins),fmt_binome(a,b,"+")); bonne_expr = paste0("(",a,"*x-",b,")*(",a,"*x+",b,")")
    d = c(paste0(fmt_binome(a,b,moins),"\u00b2"),paste0(fmt_binome(a,b,"+"),"\u00b2"),paste0(fmt_ax(a),"(",fmt_ax(a)," ",moins," ",b*b,")"))
    de = c(paste0("(",a,"*x-",b,")^2"),paste0("(",a,"*x+",b,")^2"),paste0(a,"*x*(``,a,"*x-",b*b,")"))
    de[3] = gsub("`", "", de[3], fixed = TRUE)
    types = c("confusion avec carre d une difference", "confusion avec carre d une somme", "mise en facteur incomplete")
  }
  ajouter("factorisation",p,source,affichage,bonne,bonne_expr,d,de,types)
}
# Les deux banques doivent chacune respecter 17 / 17 / 16.
for (banque in c("developpement", "factorisation")) {
  vb = valides[vapply(valides, `[[`, character(1), "banque") == banque]
  progression_b = vapply(vb, `[[`, integer(1), "progression")
  if (!identical(as.integer(table(factor(progression_b, levels = 1:3))), unname(objectif))) stop(paste("Quotas non respectes pour", banque))
}
progression = vapply(valides, `[[`, integer(1), "progression")
cat("\n================ DISTRACTEURS ================\n")
for (banque in c("developpement", "factorisation")) {
  cat("\nBANQUE :", toupper(banque), "\n")
  vb = valides[vapply(valides, `[[`, character(1), "banque") == banque]
  pb = vapply(vb, `[[`, integer(1), "progression")
  for (p in sort(unique(pb))) {
    vp = vb[pb == p]
    types = unlist(lapply(vp, `[[`, "types_distracteurs"), use.names = FALSE)
    cat("\nPalier", p, "-", length(vp), "variantes\n")
    for (type in names(table(types))) cat(" ", type, ":", unname(table(types)[[type]]), "\n")
  }
}
tous_types = unlist(lapply(valides, `[[`, "types_distracteurs"), use.names = FALSE)
cat("\nTOTAL\n")
cat("Variantes              :", length(valides), "\n")
cat("Distracteurs controles :", length(tous_types), "\n")
cat("Types de distracteurs  :", length(unique(tous_types)), "\n")
cat("\n================ REJETS ================\n")
cat("Total :", length(rejets), "\n")
if (!length(rejets)) {
  cat("Aucune combinaison rejetee.\n")
} else {
  progression_rejets = vapply(rejets, `[[`, integer(1), "progression")
  raisons = vapply(rejets, `[[`, character(1), "raison")
  cat("\nPar palier :\n")
  for (p in sort(unique(c(as.integer(names(objectif)), progression_rejets)))) cat(" ", p, ":", sum(progression_rejets == p), "\n")
  cat("\nPar raison :\n")
  for (raison in names(sort(table(raisons), decreasing = TRUE))) cat(" ", unname(table(raisons)[[raison]]), ":", raison, "\n")
  cat("\nExemples (3 maximum) :\n")
  for (i in seq_len(min(3L, length(rejets)))) {
    rejet = rejets[[i]]
    cat("\n[", rejet$banque, " / palier ", rejet$progression, "]\n", sep = "")
    cat("Source :", rejet$source, "\n")
    cat("Bonne  :", rejet$bonne, "\n")
    cat("Raison :", rejet$raison, "\n")
  }
}
cat("\n================ BILAN ================\n")
cat("Objectif             : 50 developpements + 50 factorisations\n")
cat("Variantes valides    :", length(valides), "\n")
cat("Combinaisons rejetees:", length(rejets), "\n")
for (banque in c("developpement", "factorisation")) {
  vb = valides[vapply(valides, `[[`, character(1), "banque") == banque]
  pb = vapply(vb, `[[`, integer(1), "progression")
  cat("Progression", banque, ":", paste(names(table(pb)), as.integer(table(pb)), sep = "=", collapse = " ; "), "\n")
}
cat("OK - deux banques pretes a etre figees dans le JSON.\n")
