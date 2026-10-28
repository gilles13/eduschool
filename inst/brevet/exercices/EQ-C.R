construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  enonce = sprintf("On cherche tous les nombres $x$ pour lesquels $(x-%s)(x%+d)=0$. Trois \u00e9l\u00e8ves ont travaill\u00e9 : le premier propose $x=%s$, le deuxi\u00e8me propose $x=%s$, le troisi\u00e8me affirme que ces deux valeurs conviennent.", d$racine_a, -d$racine_b, d$racine_a, d$racine_b)
  textes = c(sprintf("V\u00e9rifier que $x=%s$ convient.", d$racine_a), sprintf("V\u00e9rifier que $x=%s$ convient.", d$racine_b), "Pourquoi la v\u00e9rification de ces deux valeurs ne suffit-elle pas, \u00e0 elle seule, \u00e0 prouver qu'il n'existe aucune autre solution ?", "D\u00e9terminer toutes les valeurs qui conviennent et justifier qu'il n'y en a pas d'autres.", "Le troisi\u00e8me \u00e9l\u00e8ve a-t-il donn\u00e9 l'ensemble complet des solutions ? Justifier.")
  corrections = c(sprintf("1. Pour $x=%s$, le premier facteur est nul, donc le produit vaut 0.", d$racine_a), sprintf("2. Pour $x=%s$, le second facteur est nul, donc le produit vaut 0.", d$racine_b), "3. V\u00e9rifier des valeurs prouve seulement qu'elles sont solutions, pas qu'il n'en existe pas d'autres.", sprintf("4. Un produit est nul si et seulement si au moins un facteur est nul : $x-%s=0$ ou $x%+d=0$. Les seules solutions sont %s et %s.", d$racine_a, -d$racine_b, d$racine_a, d$racine_b), "5. Oui : les deux solutions sont trouv\u00e9es, et la propri\u00e9t\u00e9 du produit nul exclut toute autre valeur.")
  questions = paste0(seq_along(textes), ". ", textes, " **(", e$points, " point", ifelse(e$points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(c("## Corrig\u00e9 - Exercice 1", corrections), collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = e$points, total_points = e$total_points)
}
