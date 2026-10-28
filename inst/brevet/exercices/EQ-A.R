construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  enonce = sprintf("Un rectangle a un p\u00e9rim\u00e8tre de %s cm. Sa longueur d\u00e9passe sa largeur de %s cm. L\u00e9a propose l'\u00e9quation $2x+2(x+%s)=%s$. Sami propose $x+(x+%s)=%s$. Noah propose $2x+%s=%s$.", d$perimetre, d$ecart, d$ecart, d$perimetre, d$ecart, r$demi_perimetre, d$ecart, d$perimetre)
  textes = c("Expliquer ce que repr\u00e9sente $x$.", "Les propositions de L\u00e9a et Sami traduisent-elles correctement la situation ? Justifier.", "D\u00e9terminer les dimensions du rectangle.", "Expliquer l'erreur de Noah et v\u00e9rifier les dimensions obtenues.")
  corrections = c("1. $x$ repr\u00e9sente la largeur, en centim\u00e8tres.", sprintf("2. Les deux \u00e9quations sont correctes : la seconde exprime le demi-p\u00e9rim\u00e8tre (%s cm), soit la moiti\u00e9 de la premi\u00e8re.", r$demi_perimetre), sprintf("3. $2x+2(x+%s)=%s$, donc $4x+%s=%s$, d'o\u00f9 $x=%s$. La longueur vaut %s cm.", d$ecart, d$perimetre, 2*d$ecart, d$perimetre, r$largeur, r$longueur), sprintf("4. Noah ne compte pas les deux longueurs et les deux largeurs. V\u00e9rification : $2\\times%s+2\\times%s=%s$ cm.", r$largeur, r$longueur, d$perimetre))
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", corrections), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points)
}
