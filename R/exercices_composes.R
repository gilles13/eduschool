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


#' Contextes d'exercices composes
#'
#' Les contextes decrivent l'habillage semantique des exercices sans stocker
#' d'enonces complets. Un meme gabarit mathematique peut ainsi etre instancie
#' dans plusieurs situations realistes.
#'
#' @param famille_contexte Famille de contexte facultative.
#' @param statut Statut des contextes. Par defaut, seuls les actifs sont retournes.
#' @return Un data.frame.
#' @export
contextes_exercices = function(famille_contexte = NULL, statut = "ACTIF") {
  x = .lire_csv("examens", "contextes_exercices.csv")
  if (!is.null(famille_contexte)) x = x[x$famille_contexte %in% famille_contexte, , drop = FALSE]
  if (!is.null(statut)) x = x[x$statut %in% statut, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Contextes compatibles avec un gabarit compose
#'
#' @param gabarit_compose_id Identifiant du gabarit compose.
#' @param statut Statut des relations. Par defaut, seules les relations actives sont retournees.
#' @return Un data.frame joignant relation et contexte semantique.
#' @export
gabarits_exercices_contextes = function(gabarit_compose_id = NULL, statut = "ACTIF") {
  r = .lire_csv("examens", "gabarits_exercices_contextes.csv")
  if (!is.null(gabarit_compose_id)) r = r[r$gabarit_compose_id %in% gabarit_compose_id, , drop = FALSE]
  if (!is.null(statut)) r = r[r$statut %in% statut, , drop = FALSE]
  c = contextes_exercices(statut = NULL)
  x = merge(r, c, by = "contexte_id", all.x = TRUE, sort = FALSE, suffixes = c("_relation", "_contexte"))
  rownames(x) = NULL
  x
}

.tirer_contexte_compose = function(gabarit_compose_id, contexte_id = NULL) {
  x = gabarits_exercices_contextes(gabarit_compose_id)
  if (!nrow(x)) return(NULL)
  if (!is.null(contexte_id)) {
    x = x[x$contexte_id == contexte_id, , drop = FALSE]
    if (!nrow(x)) stop("Contexte incompatible avec le gabarit : ", contexte_id, call. = FALSE)
    return(x[1, , drop = FALSE])
  }
  poids = suppressWarnings(as.numeric(x$poids))
  poids[is.na(poids) | poids <= 0] = 1
  x[sample(seq_len(nrow(x)), 1L, prob = poids), , drop = FALSE]
}

.remplacer_texte = function(x, ancien, nouveau) {
  if (is.null(x) || !length(x) || is.na(nouveau) || !nzchar(nouveau)) return(x)
  gsub(ancien, nouveau, x, fixed = TRUE)
}

.majuscule_initiale = function(x) {
  if (is.na(x) || !nzchar(x)) return(x)
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}

.ctx_val = function(contexte, nom, defaut = "") {
  if (is.null(contexte) || !nrow(contexte) || !nom %in% names(contexte)) return(defaut)
  x = contexte[[nom]][[1]]
  if (is.na(x) || !nzchar(x)) defaut else x
}

.appliquer_contexte_compose = function(x, gabarit_compose_id, contexte) {
  if (is.null(contexte) || !nrow(contexte)) return(x)
  p = x$parametres

  if (gabarit_compose_id == "GABC_DNB_GRAND_CUVE") {
    objet_indefini = .ctx_val(contexte, "objet_avec_indefini", "une cuve")
    objet_defini = .ctx_val(contexte, "objet_avec_article", "la cuve")
    contenu = .ctx_val(contexte, "contenu", "eau")
    contenu_article = .ctx_val(contexte, "contenu_avec_article", "l eau")
    verbe_flux_infinitif = .ctx_val(contexte, "verbe_flux_infinitif", "evacuer")
    verbe_flux_present = .ctx_val(contexte, "verbe_flux_present", "evacue")
    feminin = identical(.ctx_val(contexte, "genre_objet"), "F")
    contenu_feminin = identical(.ctx_val(contexte, "genre_contenu"), "F")
    quantifieur_contenu = if (contenu_feminin) "toute " else "tout "
    rempli = if (feminin) "remplie" else "rempli"
    pronom = if (feminin) "Elle" else "Il"

    x$contexte = paste0(.majuscule_initiale(objet_indefini), " a la forme d un pave droit de dimensions ",
      .formater_decimal_fr(p$longueur), " m x ", .formater_decimal_fr(p$largeur), " m x ",
      .formater_decimal_fr(p$hauteur), " m. ", pronom, " est ", rempli, " a ", p$taux,
      " % de ", contenu, ". Une pompe ", verbe_flux_present, " ", p$debit, " litres de ", contenu, " par minute.")
    x$questions = c(
      paste0("Calculer le volume total de ", objet_defini, " en metres cubes puis en litres."),
      paste0("Calculer le volume de ", contenu, " contenu dans ", objet_defini, " lorsqu ", if (feminin) "elle" else "il", " est ", rempli, " a ", p$taux, " %."),
      paste0("Determiner la duree necessaire pour ", verbe_flux_infinitif, " ", quantifieur_contenu, contenu_article, " contenu dans ", objet_defini, "."))
    x$corrections_detaillees[2] = paste0(.majuscule_initiale(objet_defini), " contient ", p$taux, " % de sa capacite en ", contenu,
      ". On calcule ", p$taux, "/100 x ", .formater_decimal_fr(p$volume_l), " = ", .formater_decimal_fr(p$contenu_l), " L.")
    x$corrections_detaillees[3] = paste0("La pompe ", verbe_flux_present, " ", p$debit, " L de ", contenu,
      " chaque minute. La duree vaut volume/debit = ", .formater_decimal_fr(p$contenu_l), "/", p$debit, " = ", .formater_decimal_fr(p$minutes), " minutes.")

  } else if (gabarit_compose_id == "GABC_DNB_GEOM_AMENAGEMENT") {
    objet_indefini = .ctx_val(contexte, "objet_avec_indefini", "un espace vert")
    objet_defini = .ctx_val(contexte, "objet_avec_article", "la parcelle")
    produit_article = .ctx_val(contexte, "produit_avec_article", "du gazon")
    nom_action = .ctx_val(contexte, "nom_action", .ctx_val(contexte, "produit_ou_service", "amenagement"))
    x$contexte = paste0(.majuscule_initiale(objet_indefini), " ABC a la forme d un triangle rectangle en A. AB = ", p$a,
      " m, AC = ", p$b, " m et BC = ", p$c, " m. On souhaite utiliser ", produit_article,
      " sur toute la surface, au tarif de ", p$prix_m2, " euros par m2.")
    x$questions[2] = paste0("Calculer l aire de ", objet_defini, ".")
    x$questions[3] = paste0("Calculer le cout total de ", nom_action, " au tarif de ", p$prix_m2, " euros par m2.")
    x$corrections_detaillees[3] = paste0("La surface est de ", p$aire, " m2. Le cout de ", nom_action,
      " est donc ", p$aire, " x ", p$prix_m2, " = ", p$cout, " euros.")

  } else if (gabarit_compose_id == "GABC_DNB_FONC_TARIFS") {
    unite_s = .ctx_val(contexte, "unite_singulier", "utilisation")
    unite_p = .ctx_val(contexte, "unite_pluriel", "utilisations")
    cadre = .ctx_val(contexte, "acteur_avec_article", .ctx_val(contexte, "libelle", "ce service"))
    u_test = if (p$x_test == 1) unite_s else unite_p
    u_x0 = if (p$x0 == 1) unite_s else unite_p
    x$contexte = paste0("Pour ", cadre, ", deux formules sont proposees. Le tarif A coute ", p$fixe,
      " euros d abonnement puis ", p$a, " euros par ", unite_s, ". Le tarif B coute ", p$b,
      " euros par ", unite_s, ", sans abonnement.")
    x$questions[1] = paste0("Calculer le prix des deux tarifs pour ", p$x_test, " ", u_test, ".")
    x$questions[2] = paste0("A l aide du graphique, estimer pour combien de ", unite_p, " les deux tarifs sont egaux.")
    x$questions[4] = paste0("Quel tarif conseiller pour ", p$x_test, " ", u_test, " ? Justifier.")
    x$reponses[2] = paste0(.formater_decimal_fr(p$x0), " ", u_x0)
    x$ressource$donnees$x_libelle = if (identical(unite_p, "heures")) "Nombre d heures" else paste0("Nombre de ", unite_p)

  } else if (gabarit_compose_id == "GABC_DNB_DATA_ENQUETE") {
    unite_s = .ctx_val(contexte, "unite_singulier", "trajet")
    unite_p = .ctx_val(contexte, "unite_pluriel", "trajets")
    x$contexte = paste0("Pendant sept jours, on releve le nombre de ", unite_p, ". Les resultats sont presentes dans le diagramme ci-dessous.")
    x$questions[2] = paste0("Quel pourcentage des jours compte au moins ", p$seuil, " ", unite_p, " ? Arrondir au dixieme de pourcent.")
    x$questions[3] = paste0("On choisit un jour au hasard. Quelle est la probabilite d avoir au moins ", p$seuil, " ", unite_p, " ?")
    x$reponses[4] = paste0(p$favorables, " jours sur ", p$total, " atteignent ou depassent le seuil de ", p$seuil, " ", unite_p, ".")
    x$corrections_detaillees[2] = paste0("On compte ", p$favorables, " jours sur ", p$total, " avec au moins ", p$seuil, " ", unite_p,
      ". Le pourcentage vaut ", p$favorables, "/", p$total, " x 100 = ", .formater_decimal_fr(p$pct), " %.")
    x$corrections_detaillees[4] = paste0("Dans cette serie de ", p$total, " jours, ", p$favorables,
      " jours atteignent ou depassent ", p$seuil, " ", unite_p, ".")
    x$ressource$donnees$y_libelle = paste0("Nombre de ", unite_p)

  } else if (gabarit_compose_id == "GABC_DNB_ALGO_PROGRAMME") {
    acteur_i = .ctx_val(contexte, "acteur_avec_indefini", "un programme Scratch")
    acteur_a = .ctx_val(contexte, "acteur_avec_article", "le programme")
    verbe = .ctx_val(contexte, "verbe_action_present", "transforme")
    x$contexte = paste0(.majuscule_initiale(acteur_i), " recoit un nombre, le multiplie par ", p$mult,
      " puis ajoute ", p$ajout, ". ", .majuscule_initiale(acteur_a), " ", verbe, " ainsi le nombre choisi.")
    x$questions[3] = paste0("Expliquer comment ", acteur_a, " traduit le programme de calcul.")

  } else if (gabarit_compose_id == "GABC_DNB_GEOM_THALES") {
    objet_i = .ctx_val(contexte, "objet_avec_indefini", "un arbre")
    objet_a = .ctx_val(contexte, "objet_avec_article", "l arbre")
    x$contexte = paste0("Au meme instant, un piquet vertical de ", .formater_decimal_fr(p$petit),
      " m projette une ombre de ", .formater_decimal_fr(p$ombre_petit), " m. ", .majuscule_initiale(objet_i),
      " vertical projette une ombre de ", .formater_decimal_fr(p$ombre_grand), " m. Les rayons du Soleil sont consideres paralleles.")
    x$questions[2] = paste0("Calculer la hauteur de ", objet_a, ".")
    x$ressource$donnees$objet_label = .ctx_val(contexte, "objet", "arbre")

  } else if (gabarit_compose_id == "GABC_DNB_ARITH_LOTS") {
    unite_s = .ctx_val(contexte, "unite_singulier", "jeton")
    unite_p = .ctx_val(contexte, "unite_pluriel", "jetons")
    contenant_p = .ctx_val(contexte, "contenant_pluriel", "sachets")
    x$contexte = paste0("Une association prepare ", p$n, " ", unite_p, " identiques. Elle veut les repartir en ", contenant_p,
      " contenant chacun ", p$div, " ", unite_p, ", sans reste. Parmi les ", p$div,
      " numeros possibles attribues aux ", unite_p, ", ", p$gagnants, " sont gagnants.")
    x$questions[1] = paste0("Verifier que ", p$div, " est un diviseur de ", p$n, " et calculer le nombre de ", contenant_p, ".")
    x$reponses[1] = paste0(p$nb, " ", contenant_p)
    x$corrections[1] = paste0(p$n, " / ", p$div, " = ", p$nb, ", donc la division est exacte et on forme ", p$nb, " ", contenant_p, ".")
    x$corrections_detaillees[1] = paste0("On effectue la division euclidienne : ", p$n, " = ", p$div, " x ", p$nb,
      " + 0. Le reste est nul, donc ", p$div, " divise ", p$n, " et on forme ", p$nb, " ", contenant_p, ".")

  } else if (gabarit_compose_id == "GABC_DNB_EVOLUTION_PRIX") {
    objet_i = .ctx_val(contexte, "objet_avec_indefini", "un article")
    objet_a = .ctx_val(contexte, "objet_avec_article", "l article")
    x$contexte = paste0(.majuscule_initiale(objet_i), " coute initialement ", p$prix, " euros. Son prix augmente de ", p$hausse,
      " %, puis une remise de ", p$remise, " % est appliquee sur le nouveau prix.")
    x$questions[1] = paste0("Calculer le prix de ", objet_a, " apres l augmentation.")
    x$questions[2] = paste0("Calculer le prix final de ", objet_a, " apres la remise.")
  }
  x
}

.median_exacte = function(x) stats::median(sort(x))

.decomposer_premiers = function(n) {
  n = as.integer(n)
  facteurs = integer()
  d = 2L
  while (n > 1L) {
    while (n %% d == 0L) {
      facteurs = c(facteurs, d)
      n = n %/% d
    }
    d = d + 1L
  }
  tab = table(facteurs)
  morceaux = vapply(names(tab), function(k) {
    e = unname(tab[[k]])
    if (e == 1L) k else paste0(k, "^", e)
  }, character(1))
  paste(morceaux, collapse = " x ")
}

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
    corrections_detaillees = c(
      paste0("Le plus grand cote est BC = ", c, " m. On calcule AB^2 + AC^2 = ", a, "^2 + ", b, "^2 = ", a*a+b*b, " et BC^2 = ", c, "^2 = ", c*c, ". Les deux valeurs sont egales : d apres la reciproque du theoreme de Pythagore, ABC est rectangle en A."),
      paste0("Le triangle est rectangle en A. Son aire vaut AB x AC / 2 = ", a, " x ", b, " / 2 = ", aire, " m2."),
      paste0("Toute la parcelle, soit ", aire, " m2, est engazonnee. Le cout est donc ", aire, " x ", prix_m2, " = ", cout, " euros.")),
    ressource = .ressource_examen("FIGURE_GEOMETRIQUE", "plan_triangle_rectangle",
      list(a = a, b = b, c = c)),
    parametres = list(a = a, b = b, c = c, prix_m2 = prix_m2, aire = aire, cout = cout)
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
    corrections_detaillees = c(
      paste0("Pour ", x_test, " utilisations : A = ", fixe, " + ", a, " x ", x_test, " = ", fa, " euros et B = ", b, " x ", x_test, " = ", fb, " euros."),
      paste0("On repere l abscisse du point d intersection des deux droites. Elle est voisine de ", x0, ". A cette abscisse, les deux tarifs ont le meme prix."),
      paste0("On cherche x tel que ", fixe, " + ", a, "x = ", b, "x. On soustrait ", a, "x aux deux membres : ", fixe, " = ", b-a, "x. Donc x = ", fixe, "/", b-a, " = ", x0, "."),
      paste0("Pour ", x_test, " utilisations, on a A = ", fa, " euros et B = ", fb, " euros. Le tarif le moins cher est donc ", meilleur, ".")),
    ressource = .ressource_examen("GRAPHIQUE", "courbes_affines_tarifs",
      list(fixe = fixe, a = a, b = b, xmax = max(12, ceiling(x0 * 1.6)))),
    parametres = list(fixe = fixe, a = a, b = b, x0 = x0, x_test = x_test, fa = fa, fb = fb, meilleur = meilleur)
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
    corrections_detaillees = c(
      paste0("On ordonne les 7 valeurs : ", paste(sort(valeurs), collapse = " ; "), ". Comme l effectif est impair, la mediane est la 4e valeur : ", med, "."),
      paste0("On compte ", favorables, " jours sur ", total, " avec au moins ", seuil, " trajets. Le pourcentage vaut ", favorables, "/", total, " x 100 = ", .formater_decimal_fr(pct), " %."),
      paste0("Le choix d un jour est equiprobable. Il y a ", favorables, " jours favorables parmi ", total, ", donc P = ", .formater_fraction(favorables, total), "."),
      paste0("Cela signifie que, dans cette serie de ", total, " jours, ", favorables, " jours atteignent ou depassent ", seuil, " trajets. La probabilite calculee traduit cette proportion.")),
    ressource = .ressource_examen("DIAGRAMME", "diagramme_batons_enquete",
      list(valeurs = valeurs, seuil = seuil)),
    parametres = list(valeurs = valeurs, med = med, seuil = seuil, favorables = favorables, total = total, pct = pct)
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
    corrections_detaillees = c(
      paste0("On part de ", x_test, ". On multiplie par ", mult, " : ", mult*x_test, ". Puis on ajoute ", ajout, " : ", mult*x_test, " + ", ajout, " = ", sortie, "."),
      paste0("Si le nombre de depart est x, la multiplication donne ", mult, "x puis l ajout de ", ajout, " donne l expression ", mult, "x + ", ajout, "."),
      paste0("Le programme demande un nombre, calcule reponse x ", mult, ", stocke ce resultat, puis ajoute ", ajout, ". Il reproduit donc exactement le programme de calcul."),
      paste0("On resout ", mult, "x + ", ajout, " = ", cible, ". On soustrait ", ajout, " : ", mult, "x = ", cible-ajout, ". Puis on divise par ", mult, " : x = ", cible_x, ".")),
    ressource = .ressource_examen("SCRATCH", "programme_calcul_scratch",
      list(mult = mult, ajout = ajout)),
    parametres = list(mult = mult, ajout = ajout, x_test = x_test, sortie = sortie, cible_x = cible_x, cible = cible)
  )
}


.generer_compose_thales = function() {
  petit = sample(c(1.2, 1.5, 1.8, 2), 1L)
  ombre_petit = sample(c(1.5, 2, 2.5), 1L)
  ombre_grand = sample(c(6, 7.5, 8, 10), 1L)
  hauteur = petit * ombre_grand / ombre_petit
  list(
    contexte = paste0("Au meme instant, un piquet vertical de ", .formater_decimal_fr(petit),
      " m projette une ombre de ", .formater_decimal_fr(ombre_petit),
      " m. Un arbre vertical projette une ombre de ", .formater_decimal_fr(ombre_grand),
      " m. Les rayons du Soleil sont consideres paralleles."),
    questions = c(
      "Expliquer pourquoi les deux triangles formes sont semblables.",
      "Calculer la hauteur de l arbre.",
      "Verifier le resultat en ecrivant une egalite de rapports."),
    reponses = c("Les triangles ont les memes angles.", paste0(.formater_decimal_fr(hauteur), " m"),
      paste0(.formater_decimal_fr(petit), "/", .formater_decimal_fr(ombre_petit), " = ", .formater_decimal_fr(hauteur), "/", .formater_decimal_fr(ombre_grand))),
    corrections = c(
      "Les verticales sont paralleles et les rayons du Soleil ont la meme direction : les triangles sont semblables.",
      paste0("h = ", .formater_decimal_fr(petit), " x ", .formater_decimal_fr(ombre_grand), " / ", .formater_decimal_fr(ombre_petit), " = ", .formater_decimal_fr(hauteur), " m."),
      "Les rapports des cotes correspondants sont egaux."),
    corrections_detaillees = c(
      "Chaque triangle est rectangle au sol et partage la meme direction des rayons du Soleil. Ils ont donc deux angles egaux et sont semblables.",
      paste0("Par proportionnalite des cotes correspondants : h/", .formater_decimal_fr(ombre_grand), " = ", .formater_decimal_fr(petit), "/", .formater_decimal_fr(ombre_petit), ". Ainsi h = ", .formater_decimal_fr(ombre_grand), " x ", .formater_decimal_fr(petit), " / ", .formater_decimal_fr(ombre_petit), " = ", .formater_decimal_fr(hauteur), " m."),
      paste0("On controle : ", .formater_decimal_fr(petit), "/", .formater_decimal_fr(ombre_petit), " = ", .formater_decimal_fr(hauteur), "/", .formater_decimal_fr(ombre_grand), ". Les deux rapports sont egaux, ce qui confirme le calcul.")),
    ressource = .ressource_examen("FIGURE_GEOMETRIQUE", "schema_thales_ombres",
      list(petit = petit, ombre_petit = ombre_petit, grand = hauteur, ombre_grand = ombre_grand)),
    parametres = list(petit = petit, ombre_petit = ombre_petit, ombre_grand = ombre_grand, hauteur = hauteur)
  )
}

.generer_compose_cuve = function() {
  longueur = sample(c(2, 2.5, 3), 1L)
  largeur = sample(c(1.2, 1.5, 2), 1L)
  hauteur = sample(c(1, 1.2, 1.5), 1L)
  taux = sample(c(60, 70, 75, 80), 1L)
  debit = sample(c(20, 25, 30, 40), 1L)
  volume_m3 = longueur * largeur * hauteur
  volume_l = volume_m3 * 1000
  contenu = volume_l * taux / 100
  minutes = contenu / debit
  list(
    contexte = paste0("Une cuve a la forme d un pave droit de dimensions ", .formater_decimal_fr(longueur), " m x ",
      .formater_decimal_fr(largeur), " m x ", .formater_decimal_fr(hauteur), " m. Elle est remplie a ", taux,
      " %. Une pompe evacue ", debit, " litres par minute."),
    questions = c(
      "Calculer le volume total de la cuve en metres cubes puis en litres.",
      paste0("Calculer le volume d eau contenu lorsque la cuve est remplie a ", taux, " %."),
      "Determiner la duree necessaire pour vider cette eau avec la pompe."),
    reponses = c(paste0(.formater_decimal_fr(volume_m3), " m3 = ", .formater_decimal_fr(volume_l), " L"),
      paste0(.formater_decimal_fr(contenu), " L"), paste0(.formater_decimal_fr(minutes), " min")),
    corrections = c(
      paste0("V = L x l x h = ", .formater_decimal_fr(volume_m3), " m3, soit ", .formater_decimal_fr(volume_l), " L."),
      paste0(taux, " % de ", .formater_decimal_fr(volume_l), " L = ", .formater_decimal_fr(contenu), " L."),
      paste0(.formater_decimal_fr(contenu), " / ", debit, " = ", .formater_decimal_fr(minutes), " min.")),
    corrections_detaillees = c(
      paste0("Le volume d un pave droit est L x l x h : ", .formater_decimal_fr(longueur), " x ", .formater_decimal_fr(largeur), " x ", .formater_decimal_fr(hauteur), " = ", .formater_decimal_fr(volume_m3), " m3. Comme 1 m3 = 1000 L, cela donne ", .formater_decimal_fr(volume_l), " L."),
      paste0("La cuve contient ", taux, " % de sa capacite. On calcule ", taux, "/100 x ", .formater_decimal_fr(volume_l), " = ", .formater_decimal_fr(contenu), " L."),
      paste0("La pompe retire ", debit, " L chaque minute. La duree vaut volume/debit = ", .formater_decimal_fr(contenu), "/", debit, " = ", .formater_decimal_fr(minutes), " minutes.")),
    ressource = .ressource_examen("SCHEMA", "schema_cuve_pave",
      list(longueur = longueur, largeur = largeur, hauteur = hauteur, taux = taux)),
    parametres = list(
      longueur = longueur, largeur = largeur, hauteur = hauteur, taux = taux, debit = debit,
      volume_m3 = volume_m3, volume_l = volume_l, contenu_l = contenu, minutes = minutes)
  )
}

.generer_compose_arith = function() {
  p = sample(c(2, 3, 5), 1L)
  q = sample(c(2, 3, 5, 7), 1L)
  n = p * q * sample(c(4, 6, 8), 1L)
  div = p * q
  nb = n / div
  gagnants = sample(seq_len(max(2, div - 1)), 1L)
  list(
    contexte = paste0("Une association prepare ", n, " jetons identiques. Elle veut les repartir en sachets contenant chacun ", div,
      " jetons, sans reste. Parmi les ", div, " numeros possibles sur un jeton, ", gagnants, " sont gagnants."),
    questions = c(
      paste0("Verifier que ", div, " est un diviseur de ", n, " et calculer le nombre de sachets."),
      paste0("Decomposer ", n, " en facteurs premiers."),
      "On choisit un numero au hasard parmi les numeros possibles. Calculer la probabilite d obtenir un numero gagnant."),
    reponses = c(paste0(nb, " sachets"), paste0(n, " = ", .decomposer_premiers(n)), .formater_fraction(gagnants, div)),
    corrections = c(
      paste0(n, " / ", div, " = ", nb, ", donc la division est exacte."),
      paste0(n, " = ", .decomposer_premiers(n), "."),
      paste0("P = ", gagnants, "/", div, ".")),
    corrections_detaillees = c(
      paste0("On effectue la division euclidienne : ", n, " = ", div, " x ", nb, " + 0. Le reste est nul, donc ", div, " divise ", n, " et on forme ", nb, " sachets."),
      paste0("On divise successivement par des nombres premiers : ", n, " = ", .decomposer_premiers(n), ". Le produit des facteurs redonne bien ", n, "."),
      paste0("Les ", div, " numeros sont equiprobables et ", gagnants, " sont gagnants. La probabilite vaut donc nombre d issues favorables / nombre total d issues = ", gagnants, "/", div, ".")),
    ressource = NULL,
    parametres = list(n = n, div = div, nb = nb, gagnants = gagnants)
  )
}

.generer_compose_evolution = function() {
  prix = sample(seq(40, 120, by = 10), 1L)
  hausse = sample(c(5, 10, 15, 20), 1L)
  remise = sample(c(10, 15, 20, 25), 1L)
  apres_hausse = prix * (1 + hausse/100)
  final = apres_hausse * (1 - remise/100)
  coeff = (1 + hausse/100) * (1 - remise/100)
  evolution = (coeff - 1) * 100
  list(
    contexte = paste0("Un article coute initialement ", prix, " euros. Son prix augmente de ", hausse,
      " %, puis une remise de ", remise, " % est appliquee sur le nouveau prix."),
    questions = c(
      "Calculer le prix apres l augmentation.",
      "Calculer le prix final apres la remise.",
      "Determiner le coefficient multiplicateur global puis le taux d evolution global. Expliquer pourquoi les deux pourcentages ne s annulent pas necessairement."),
    reponses = c(paste0(.formater_decimal_fr(apres_hausse), " euros"), paste0(.formater_decimal_fr(final), " euros"),
      paste0("coefficient = ", .formater_decimal_fr(coeff), " ; evolution = ", .formater_decimal_fr(evolution), " %")),
    corrections = c(
      paste0(prix, " x ", .formater_decimal_fr(1+hausse/100), " = ", .formater_decimal_fr(apres_hausse), " euros."),
      paste0(.formater_decimal_fr(apres_hausse), " x ", .formater_decimal_fr(1-remise/100), " = ", .formater_decimal_fr(final), " euros."),
      paste0("Le coefficient global est le produit des deux coefficients : ", .formater_decimal_fr(coeff), ".")),
    corrections_detaillees = c(
      paste0("Une hausse de ", hausse, " % correspond au coefficient multiplicateur ", .formater_decimal_fr(1+hausse/100), ". Le prix devient ", prix, " x ", .formater_decimal_fr(1+hausse/100), " = ", .formater_decimal_fr(apres_hausse), " euros."),
      paste0("Une remise de ", remise, " % correspond au coefficient ", .formater_decimal_fr(1-remise/100), ". On l applique au prix deja augmente : ", .formater_decimal_fr(apres_hausse), " x ", .formater_decimal_fr(1-remise/100), " = ", .formater_decimal_fr(final), " euros."),
      paste0("Les evolutions successives se composent par multiplication : ", .formater_decimal_fr(1+hausse/100), " x ", .formater_decimal_fr(1-remise/100), " = ", .formater_decimal_fr(coeff), ". Le taux global est (", .formater_decimal_fr(coeff), " - 1) x 100 = ", .formater_decimal_fr(evolution), " %. Les pourcentages portent sur des bases differentes, donc on ne peut pas simplement les additionner ou les soustraire.")),
    ressource = NULL,
    parametres = list(prix = prix, hausse = hausse, remise = remise, apres_hausse = apres_hausse,
      final = final, coeff = coeff, evolution = evolution)
  )
}

.generateur_compose = function(id) {
  f = list(compose_geom_amenagement = .generer_compose_geom,
    compose_fonc_tarifs = .generer_compose_fonc,
    compose_data_enquete = .generer_compose_data,
    compose_algo_programme = .generer_compose_algo,
    compose_geom_thales = .generer_compose_thales,
    compose_grand_cuve = .generer_compose_cuve,
    compose_arith_lots = .generer_compose_arith,
    compose_evolution_prix = .generer_compose_evolution)[[id]]
  if (is.null(f)) stop("Generateur compose non implemente : ", id, call. = FALSE)
  f
}

#' Instancier un exercice compose
#'
#' @param gabarit_compose_id Identifiant du gabarit compose.
#' @param seed Graine aleatoire facultative.
#' @param contexte_id Contexte semantique facultatif. S il est omis, un contexte compatible est tire.
#' @return Une liste contenant contexte, questions, corrections et ressource.
#' @export
generer_exercice_compose = function(gabarit_compose_id, seed = NULL, contexte_id = NULL) {
  if (!is.null(seed)) set.seed(seed)
  g = gabarit_exercice_compose(gabarit_compose_id)
  f = .generateur_compose(g$gabarit$generateur_id[[1]])
  contexte = .tirer_contexte_compose(gabarit_compose_id, contexte_id)
  x = f()
  x = .appliquer_contexte_compose(x, gabarit_compose_id, contexte)
  q = g$questions
  if (length(x$questions) != nrow(q)) stop("Nombre de questions incoherent dans le gabarit compose.", call. = FALSE)
  q$enonce = x$questions
  q$reponse = x$reponses
  q$correction = x$corrections
  q$correction_detaillee = if (!is.null(x$corrections_detaillees)) x$corrections_detaillees else x$corrections
  list(gabarit_compose_id = gabarit_compose_id, libelle = g$gabarit$libelle[[1]],
    domaine = g$gabarit$domaine[[1]], contexte = x$contexte, questions = q,
    ressource = x$ressource, contexte_id = if (is.null(contexte)) NA_character_ else contexte$contexte_id[[1]], seed = seed)
}

.selectionner_gabarits_composes = function(code, partie_type, n) {
  x = gabarits_exercices_composes(code, partie_type)
  if (!nrow(x)) return(character())
  n = min(as.integer(n), nrow(x))
  sample(x$gabarit_compose_id, n, replace = FALSE)
}
