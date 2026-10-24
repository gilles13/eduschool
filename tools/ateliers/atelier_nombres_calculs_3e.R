# Atelier jetable - Nombres et calculs, 3E.
# A executer au REPL, jamais source par eduschool.
objectif = c(`1` = 17L, `2` = 17L, `3` = 16L)
palier = function(i) if (i <= 17L) 1L else if (i <= 34L) 2L else 3L
selectionner = function(candidats) {
  valides = list()
  rejets = list()
  for (i in seq_along(candidats)) {
    x = candidats[[i]]
    vals = c(x$bonne, x$d1, x$d2, x$d3)
    raison = NULL
    if (any(!nzchar(vals))) raison = "reponse vide"
    if (length(unique(vals)) != 4L) raison = "propositions non distinctes"
    if (is.null(raison) && length(valides) < 50L) {
      x$progression = palier(length(valides) + 1L)
      x$types_distracteurs = c("erreur_regle", "erreur_calcul", "confusion")
      valides[[length(valides) + 1L]] = x
    } else if (!is.null(raison)) {
      x$progression = palier(min(i, 50L))
      x$source = x$source %||% "candidat"
      x$raison = raison
      rejets[[length(rejets) + 1L]] = x
    }
  }
  list(valides = valides, rejets = rejets)
}
`%||%` = function(x, y) if (is.null(x)) y else x
candidat = function(source, bonne, d1, d2, d3) list(source = source, bonne = bonne, d1 = d1, d2 = d2, d3 = d3)
banques = list()
banques$puissances_exposant_negatif = unlist(lapply(c(2, 3, 4, 5, 10), function(a) lapply(1:10, function(n) candidat(paste0(a, "^-", n), paste0("1/", a, "^", n), paste0("-", a, "^", n), paste0(a, "^", n), paste0("1/", a + 1L)))), recursive = FALSE)
banques$puissances_proprietes = unlist(lapply(c(2, 3, 4, 5, 7), function(a) lapply(list(c(2,3),c(3,2),c(4,3),c(5,2),c(3,4),c(6,2),c(5,3),c(4,5),c(7,2),c(6,3)), function(mn) candidat(paste(a, mn[1], mn[2]), paste0(a, "^", sum(mn)), paste0(a, "^", prod(mn)), paste0(a, "^", abs(diff(mn))), paste0(2*a, "^", sum(mn))))), recursive = FALSE)
coef = c(1.2,2.5,3.6,4.8,7.2,6.4,8.1,9.5,1.7,5.3)
banques$puissances_notation_scientifique = unlist(lapply(seq_along(coef), function(i) lapply(c(3,-3,4,-4,5), function(e) candidat(paste(coef[i], e), paste(coef[i], "x10^", e), paste(coef[i], "x10^", e+1), paste(coef[i]*10, "x10^", e), paste(coef[i], "x10^", e-1)))), recursive = FALSE)
banques$racine_carree = lapply(rep(2:11, 5), function(k) candidat(paste0("sqrt(", k*k, ")"), as.character(k), as.character(k*k+1), as.character(k+1), as.character(k-1)))
fractions = Filter(function(z) z[3] > 1L, unlist(lapply(2:19, function(a) lapply((a+1):24, function(b) c(a,b,gcd = as.integer(Reduce(function(x,y) if (y==0) x else Recall(y,x%%y), c(a,b)))))), recursive = FALSE))
banques$fractions_irreductibles = lapply(head(fractions, 50), function(z) {a=z[1];b=z[2];g=z[3];candidat(paste0(a,"/",b), paste0(a/g,"/",b/g), paste0(a/g,"/",b), paste0(a,"/",b/g), paste0(a+1,"/",b+1))})
banques$fractions_problemes = lapply(seq_len(50), function(i) {total=c(24,30,36,40,48,54,60,72,80,90)[(i-1)%%10+1]; nd=list(c(1,2),c(1,3),c(2,3),c(3,4),c(2,5))[[(i-1)%%5+1]]; bonne=total*nd[1]/nd[2]; candidat(paste(total,nd[1],nd[2]), as.character(bonne), as.character(bonne+1), as.character(bonne-1), as.character(total))})
factoriser = function(n) { x = n; p = 2L; f = integer(); while (p * p <= x) { while (x %% p == 0L) { f = c(f, p); x = x %/% p }; p = p + 1L }; if (x > 1L) f = c(f, x); paste(f, collapse = " x ") }
banques$decomposition_facteurs_premiers = lapply(c(12,18,20,24,28,30,36,40,42,45,48,50,54,56,60,63,70,72,75,80,84,90,96,98,100,108,120,126,135,140,144,150,160,168,175,180,189,196,200,210,216,225,240,250,252,270,280,294,300,315), function(n) candidat(as.character(n), factoriser(n), paste(n/2,"x2"), paste(n,"x1"), paste(n/3,"x3")))
banques$equations_carre_constante = lapply(rep(1:10, 5), function(k) candidat(paste0("x^2=",k*k), paste0("x=-",k," ou x=",k), paste0("x=",k), paste0("x=-",k), paste0("x=",k*k+1)))
banques$simplification_expression_algebrique = unlist(lapply(2:11, function(a) lapply(2:6, function(b) candidat(paste(a,b), paste0(a*b,"x^2"), paste0(a*b+1,"x^2"), paste0(a*b,"x"), paste0(a*b+1,"x")))), recursive = FALSE)
resultats = lapply(banques, selectionner)
for (nom in names(resultats)) {
  valides = resultats[[nom]]$valides
  rejets = resultats[[nom]]$rejets
  progression = vapply(valides, `[[`, integer(1), "progression")
  cat("\n================", nom, "================\n")
  cat("Variantes valides    :", length(valides), "\n")
  cat("Combinaisons rejetees:", length(rejets), "\n")
  cat("Progression          :", paste(names(table(progression)), as.integer(table(progression)), sep = "=", collapse = " ; "), "\n")
}
cat("\n================ BILAN DOMAINE ================\n")
cat("Notions travaillees :", length(resultats), "\n")
cat("Variantes retenues  :", sum(vapply(resultats, function(x) length(x$valides), integer(1))), "\n")
cat("Rejets              :", sum(vapply(resultats, function(x) length(x$rejets), integer(1))), "\n")
