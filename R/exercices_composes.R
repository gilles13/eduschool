# Gabarits composes pour la partie raisonnement des examens

#' Gabarits d'exercices composes
#'
#' @param examen_code Code d'examen facultatif.
#' @param partie_type Type de partie facultatif.
#' @param statut Statut des gabarits. Par defaut, seuls les actifs sont retournes.
#' @return Un data.frame.
#' @export
gabarits_exercices_composes = function(examen_code = NULL, partie_type = NULL, statut = "ACTIF") {
  x = .lire_csv("examens", "gabarits_exercices_composes.csv")
  if (!is.null(examen_code)) x = x[x$examen_code %in% examen_code, , drop = FALSE]
  if (!is.null(partie_type)) x = x[x$partie_type %in% partie_type, , drop = FALSE]
  if (!is.null(statut)) x = x[x$statut %in% statut, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Decrire un gabarit d'exercice compose
#'
#' @param gabarit_compose_id Identifiant du gabarit compose.
#' @return Une liste avec gabarit, questions et ressources.
#' @export
gabarit_exercice_compose = function(gabarit_compose_id) {
  g = gabarits_exercices_composes(statut = NULL)
  g = g[g$gabarit_compose_id == gabarit_compose_id, , drop = FALSE]
  if (!nrow(g)) stop("Gabarit compose inconnu : ", gabarit_compose_id, call. = FALSE)
  q = .lire_csv("examens", "gabarits_exercices_questions.csv")
  q = q[q$gabarit_compose_id == gabarit_compose_id, , drop = FALSE]
  q = q[order(as.integer(q$ordre)), , drop = FALSE]
  r = .lire_csv("examens", "gabarits_exercices_ressources.csv")
  r = r[r$gabarit_compose_id == gabarit_compose_id, , drop = FALSE]
  list(gabarit = g, questions = q, ressources = r)
}

.median_exacte = function(x) stats::median(sort(x))

.generer_compose_geom = function() {
  k = sample(1:3, 1L)
  a = 3 * k
  b = 4 * k
  c = 5 * k
  prix_m2 = sample(c(4, 5, 6, 8), 1L)
  aire = a * b / 2
  cout = aire * prix_m2
  list(
    contexte = paste0("Un espace vert triangulaire ABC est rectangle en A. AB = ", a,
      " m, AC = ", b, " m et BC = ", c,
      " m. On souhaite engazonner toute la parcelle au tarif de ", prix_m2, " euros par m2."),
    questions = c(
      paste0("Montrer que le triangle ABC est rectangle en A."),
      "Calculer l aire de la parcelle.",
      paste0("Calculer le cout total de l engazonnement au tarif de ", prix_m2, " euros par m2.")
    ),
    reponses = c(
      paste0(a, "^2 + ", b, "^2 = ", c, "^2 : le triangle est rectangle en A."),
      paste0(aire, " m2"), paste0(cout, " euros")
    ),
    corrections = c(
      "On compare le carre du plus grand cote a la somme des carres des deux autres cotes.",
      paste0("Aire = ", a, " x ", b, " / 2 = ", aire, " m2."),
      paste0(aire, " x ", prix_m2, " = ", cout, " euros.")),
    ressource = .ressource_examen("FIGURE_GEOMETRIQUE", "plan_triangle_rectangle",
      list(a = a, b = b, c = c))
  )
}

.generer_compose_fonc = function() {
  fixe = sample(c(6, 8, 10, 12), 1L)
  a = sample(c(2, 3, 4), 1L)
  b = a + sample(c(1, 2), 1L)
  x0 = fixe / (b - a)
  x_test = sample(c(2, 4, 6), 1L)
  fa = fixe + a * x_test
  fb = b * x_test
  meilleur = if (fa < fb) "A" else if (fb < fa) "B" else "identiques"
  list(
    contexte = paste0("Deux services proposent des tarifs pour x utilisations. Le tarif A coute ",
      fixe, " euros d abonnement puis ", a, " euros par utilisation. Le tarif B coute ", b,
      " euros par utilisation, sans abonnement."),
    questions = c(
      paste0("Calculer le prix des deux tarifs pour ", x_test, " utilisations."),
      "A l aide du graphique, estimer pour combien d utilisations les deux tarifs sont egaux.",
      "Retrouver cette valeur en resolvant une equation.",
      paste0("Quel tarif conseiller pour ", x_test, " utilisations ? Justifier.")),
    reponses = c(paste0("A = ", fa, " euros ; B = ", fb, " euros"),
      paste0(x0, " utilisations"), paste0("x = ", x0), paste0("Tarif ", meilleur)),
    corrections = c(
      paste0("A(x) = ", fixe, " + ", a, "x et B(x) = ", b, "x."),
      "Le point d intersection des deux droites donne l egalite des prix.",
      paste0(fixe, " + ", a, "x = ", b, "x, donc x = ", x0, "."),
      "On compare les deux valeurs calculees pour le nombre d utilisations demande."),
    ressource = .ressource_examen("GRAPHIQUE", "courbes_affines_tarifs",
      list(fixe = fixe, a = a, b = b, xmax = max(12, ceiling(x0 * 1.6))))
  )
}

.generer_compose_data = function() {
  valeurs = sample(2:12, 7, replace = TRUE)
  med = .median_exacte(valeurs)
  seuil = sample(6:9, 1L)
  favorables = sum(valeurs >= seuil)
  total = length(valeurs)
  pct = round(100 * favorables / total, 1)
  list(
    contexte = paste0("Pendant sept jours, on releve le nombre de trajets a velo effectues par un groupe. ",
      "Les resultats sont presentes dans le diagramme ci-dessous."),
    questions = c(
      "Determiner la mediane de cette serie.",
      paste0("Quel pourcentage des jours compte au moins ", seuil, " trajets ? Arrondir au dixieme de pourcent."),
      paste0("On choisit un jour au hasard. Quelle est la probabilite d avoir au moins ", seuil, " trajets ?"),
      "Interpreter cette probabilite dans le contexte."),
    reponses = c(as.character(med), paste0(.formater_decimal_fr(pct), " %"),
      .formater_fraction(favorables, total),
      paste0(favorables, " jours sur ", total, " atteignent ou depassent le seuil.")),
    corrections = c(
      "Avec 7 valeurs ordonnees, la mediane est la quatrieme valeur.",
      paste0(favorables, "/", total, " x 100 = ", .formater_decimal_fr(pct), " %."),
      paste0("Il y a ", favorables, " issues favorables sur ", total, " jours equiprobables."),
      "La probabilite mesure ici la frequence des jours satisfaisant le critere dans la serie proposee."),
    ressource = .ressource_examen("DIAGRAMME", "diagramme_batons_enquete",
      list(valeurs = valeurs, seuil = seuil))
  )
}

.generer_compose_algo = function() {
  mult = sample(c(2, 3, 4), 1L)
  ajout = sample(c(3, 5, 7, 9), 1L)
  x_test = sample(2:6, 1L)
  sortie = mult * x_test + ajout
  cible_x = sample(3:8, 1L)
  cible = mult * cible_x + ajout
  list(
    contexte = paste0("On choisit un nombre, on le multiplie par ", mult,
      " puis on ajoute ", ajout, ". Un programme Scratch automatise ce calcul."),
    questions = c(
      paste0("Quel resultat obtient-on en choisissant ", x_test, " ?"),
      "Ecrire l expression litterale du resultat obtenu a partir d un nombre x.",
      "Expliquer comment le programme Scratch traduit ce programme de calcul.",
      paste0("Quel nombre faut-il choisir pour obtenir ", cible, " ?")),
    reponses = c(as.character(sortie), paste0(mult, "x + ", ajout),
      paste0("Le programme calcule ", mult, " fois la reponse puis ajoute ", ajout, "."),
      as.character(cible_x)),
    corrections = c(paste0(mult, " x ", x_test, " + ", ajout, " = ", sortie, "."),
      paste0("Le programme se traduit par ", mult, "x + ", ajout, "."),
      "Les blocs effectuent successivement la multiplication puis l addition.",
      paste0(mult, "x + ", ajout, " = ", cible, ", donc x = ", cible_x, ".")),
    ressource = .ressource_examen("SCRATCH", "programme_calcul_scratch",
      list(mult = mult, ajout = ajout))
  )
}

.generateur_compose = function(id) {
  f = list(compose_geom_amenagement = .generer_compose_geom,
    compose_fonc_tarifs = .generer_compose_fonc,
    compose_data_enquete = .generer_compose_data,
    compose_algo_programme = .generer_compose_algo)[[id]]
  if (is.null(f)) stop("Generateur compose non implemente : ", id, call. = FALSE)
  f
}

#' Instancier un exercice compose
#'
#' @param gabarit_compose_id Identifiant du gabarit compose.
#' @param seed Graine aleatoire facultative.
#' @return Une liste contenant contexte, questions, corrections et ressource.
#' @export
generer_exercice_compose = function(gabarit_compose_id, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  g = gabarit_exercice_compose(gabarit_compose_id)
  f = .generateur_compose(g$gabarit$generateur_id[[1]])
  x = f()
  q = g$questions
  if (length(x$questions) != nrow(q)) stop("Nombre de questions incoherent dans le gabarit compose.", call. = FALSE)
  q$enonce = x$questions
  q$reponse = x$reponses
  q$correction = x$corrections
  list(gabarit_compose_id = gabarit_compose_id, libelle = g$gabarit$libelle[[1]],
    domaine = g$gabarit$domaine[[1]], contexte = x$contexte, questions = q,
    ressource = x$ressource, seed = seed)
}

.selectionner_gabarits_composes = function(code, partie_type, n) {
  x = gabarits_exercices_composes(code, partie_type)
  if (!nrow(x)) return(character())
  n = min(as.integer(n), nrow(x))
  sample(x$gabarit_compose_id, n, replace = FALSE)
}
