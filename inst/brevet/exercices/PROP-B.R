construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = exercice$donnees
  r = exercice$resultats
  points = exercice$points
  nombre = function(x) format(x, big.mark = "", scientific = FALSE, trim = TRUE)
  taux = function(x) format(round(x, 1), decimal.mark = ",", scientific = FALSE, trim = TRUE)
  n0 = d$visiteurs_depart
  n1 = r$visiteurs_annee_2
  n2 = r$visiteurs_annee_3
  a = d$annee_depart
  enonce = sprintf("Un mus\u00e9e a accueilli %s visiteurs en %s. En %s, sa fr\u00e9quentation a augment\u00e9 de %s %%. En %s, elle a diminu\u00e9 de %s %% par rapport \u00e0 l'ann\u00e9e pr\u00e9c\u00e9dente.", nombre(n0), a, a + 1, d$hausse, a + 2, d$baisse)
  questions = c(
    sprintf("Calculer le nombre de visiteurs accueillis en %s.", a + 1),
    sprintf("Calculer le nombre de visiteurs accueillis en %s.", a + 2),
    sprintf("D\u00e9terminer le taux d'\u00e9volution global de la fr\u00e9quentation entre %s et %s.", a, a + 2),
    sprintf("Un \u00e9l\u00e8ve affirme : \u00ab Une hausse de %s %% suivie d'une baisse de %s %% correspond \u00e0 une \u00e9volution globale de %s %% \u00bb. Cette affirmation est-elle correcte ? Justifier.", d$hausse, d$baisse, d$hausse - d$baisse),
    sprintf("Le mus\u00e9e souhaite retrouver en %s son niveau de fr\u00e9quentation de %s. De quel pourcentage la fr\u00e9quentation doit-elle augmenter par rapport \u00e0 %s ? Arrondir au dixi\u00e8me de pourcentage.", a + 3, a, a + 2)
  )
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    "### 1. Premi\u00e8re \u00e9volution",
    sprintf("Une augmentation de %s %% revient \u00e0 multiplier par $1 + %s/100 = %s$. On obtient $%s \\times %s = %s$ visiteurs.", d$hausse, d$hausse, 1 + d$hausse / 100, nombre(n0), 1 + d$hausse / 100, nombre(n1)),
    "### 2. Deuxi\u00e8me \u00e9volution",
    sprintf("La diminution de %s %% s'applique au nombre de visiteurs de l'ann\u00e9e pr\u00e9c\u00e9dente, pas au nombre initial. On multiplie par $1 - %s/100 = %s$. Ainsi, $%s \\times %s = %s$ visiteurs.", d$baisse, d$baisse, 1 - d$baisse / 100, nombre(n1), 1 - d$baisse / 100, nombre(n2)),
    "### 3. \u00c9volution globale",
    sprintf("On compare la valeur finale \u00e0 la valeur initiale : $\\frac{%s - %s}{%s} \\times 100 = %s \\%%$. Il s'agit donc d'une %s de **%s %%**.", nombre(n2), nombre(n0), nombre(n0), taux(r$evolution_globale_pourcent), if (r$evolution_globale_pourcent < 0) "baisse" else "hausse", taux(abs(r$evolution_globale_pourcent))),
    "### 4. Affirmation",
    sprintf("L'affirmation est **fausse** : on ne peut pas simplement soustraire %s %% de %s %%, car les pourcentages s'appliquent \u00e0 des valeurs de r\u00e9f\u00e9rence diff\u00e9rentes. Le taux global est de %s %%.", d$baisse, d$hausse, taux(r$evolution_globale_pourcent)),
    "### 5. Retour \u00e0 la fr\u00e9quentation initiale",
    sprintf("On part de %s visiteurs et on cherche le pourcentage d'augmentation permettant d'atteindre %s visiteurs. Le taux recherch\u00e9 vaut $\\frac{%s - %s}{%s} \\times 100 \\approx %s \\%%$. Il faut donc une **hausse d'environ %s %%**. Le taux de retour n'est pas l'oppos\u00e9 du taux global : la base de calcul a chang\u00e9.", nombre(n2), nombre(n0), nombre(n0), nombre(n2), nombre(n2), taux(r$hausse_retour_pourcent), taux(r$hausse_retour_pourcent)),
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points)
}
