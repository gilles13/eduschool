# Banque de gabarits d'exercices pour les examens

#' Gabarits d'exercices d'examen
#'
#' @param examen_code Code d'examen facultatif.
#' @param partie_type Type de partie facultatif.
#' @param domaine Domaine mathematique facultatif.
#' @param statut Statut des gabarits. Par defaut, seuls les gabarits actifs sont retournes.
#' @return Un data.frame.
#' @export
gabarits_examen = function(examen_code = NULL, partie_type = NULL,
                            domaine = NULL, statut = "ACTIF") {
  x = .lire_csv("examens", "gabarits_exercices.csv")
  if (!is.null(examen_code)) x = x[x$examen_code %in% examen_code, , drop = FALSE]
  if (!is.null(partie_type)) x = x[x$partie_type %in% partie_type, , drop = FALSE]
  if (!is.null(domaine)) x = x[x$domaine %in% domaine, , drop = FALSE]
  if (!is.null(statut)) x = x[x$statut %in% statut, , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Decrire un gabarit d'exercice
#'
#' @param gabarit_id Identifiant du gabarit.
#' @return Une liste contenant le gabarit, ses concepts et ses parametres.
#' @export
gabarit_examen = function(gabarit_id) {
  x = gabarits_examen(statut = NULL)
  x = x[x$gabarit_id == gabarit_id, , drop = FALSE]
  if (!nrow(x)) stop("Gabarit inconnu : ", gabarit_id, call. = FALSE)
  if (nrow(x) > 1L) stop("Identifiant de gabarit duplique : ", gabarit_id, call. = FALSE)

  concepts = .lire_csv("examens", "gabarits_exercices_concepts.csv")
  concepts = concepts[concepts$gabarit_id == gabarit_id, , drop = FALSE]
  parametres = .lire_csv("examens", "gabarits_parametres.csv")
  parametres = parametres[parametres$gabarit_id == gabarit_id, , drop = FALSE]

  rownames(concepts) = NULL
  rownames(parametres) = NULL
  list(gabarit = x, concepts = concepts, parametres = parametres)
}

.parametre_gabarit = function(parametres, nom) {
  x = parametres[parametres$parametre == nom, , drop = FALSE]
  if (!nrow(x)) stop("Parametre de gabarit manquant : ", nom, call. = FALSE)
  x[1, , drop = FALSE]
}

.tirer_parametre = function(parametres, nom) {
  p = .parametre_gabarit(parametres, nom)
  type = p$type[[1]]
  if (type == "choice") {
    valeurs = strsplit(p$valeurs[[1]], "\\|", fixed = FALSE)[[1]]
    valeur = sample(valeurs, 1L)
    if (all(grepl("^-?[0-9]+(?:\\.[0-9]+)?$", valeurs, perl = TRUE))) return(as.numeric(valeur))
    return(valeur)
  }
  if (type == "integer") {
    mini = as.integer(p$minimum[[1]])
    maxi = as.integer(p$maximum[[1]])
    return(sample(seq.int(mini, maxi), 1L))
  }
  stop("Type de parametre non gere : ", type, call. = FALSE)
}

.pgcd = function(a, b) {
  a = abs(as.integer(a))
  b = abs(as.integer(b))
  while (b != 0L) {
    z = b
    b = a %% b
    a = z
  }
  a
}

.formater_fraction = function(numerateur, denominateur) {
  d = .pgcd(numerateur, denominateur)
  n = numerateur / d
  q = denominateur / d
  if (q == 1) as.character(n) else paste0(n, "/", q)
}

.generer_fraction_somme = function(p) {
  d = .tirer_parametre(p, "denominateur")
  a = .tirer_parametre(p, "numerateur_1")
  b = .tirer_parametre(p, "numerateur_2")
  list(
    enonce = paste0("Calculer et donner le resultat sous forme irreductible : ", a, "/", d, " + ", b, "/", d, "."),
    reponse = .formater_fraction(a + b, d),
    parametres = list(numerateur_1 = a, numerateur_2 = b, denominateur = d)
  )
}

.generer_fraction_quantite = function(p) {
  d = .tirer_parametre(p, "denominateur")
  amax = min(d - 1L, as.integer(.parametre_gabarit(p, "numerateur")$maximum[[1]]))
  amin = as.integer(.parametre_gabarit(p, "numerateur")$minimum[[1]])
  a = sample(seq.int(amin, amax), 1L)
  q = .tirer_parametre(p, "quotient")
  total = d * q
  list(
    enonce = paste0("Calculer ", a, "/", d, " de ", total, "."),
    reponse = as.character(a * q),
    parametres = list(numerateur = a, denominateur = d, quantite = total)
  )
}

.generer_pourcentage = function(p) {
  taux = .tirer_parametre(p, "taux")
  base = .tirer_parametre(p, "base")
  reponse = base * taux / 100
  list(
    enonce = paste0("Calculer ", taux, " % de ", base, "."),
    reponse = as.character(reponse),
    parametres = list(taux = taux, base = base)
  )
}

.generer_priorites = function(p) {
  a = .tirer_parametre(p, "a")
  b = .tirer_parametre(p, "b")
  c = .tirer_parametre(p, "c")
  list(
    enonce = paste0("Calculer : ", a, " + ", b, " x ", c, "."),
    reponse = as.character(a + b * c),
    parametres = list(a = a, b = b, c = c)
  )
}

.denominateur_decimal_fini = function(denominateur) {
  d = abs(as.integer(denominateur))
  if (d == 0L) return(FALSE)
  while (d %% 2L == 0L) d = d %/% 2L
  while (d %% 5L == 0L) d = d %/% 5L
  d == 1L
}

.formater_decimal_fr = function(x) {
  txt = format(x, scientific = FALSE, trim = TRUE, digits = 15)
  txt = sub("\\.?0+$", "", txt)
  sub("\\.", ",", txt)
}

.formater_rationnel = function(numerateur, denominateur) {
  if (denominateur == 0) stop("Denominateur nul", call. = FALSE)
  if (denominateur < 0) {
    numerateur = -numerateur
    denominateur = -denominateur
  }
  d = .pgcd(numerateur, denominateur)
  n = as.integer(numerateur / d)
  q = as.integer(denominateur / d)
  if (q == 1L) return(as.character(n))
  if (.denominateur_decimal_fini(q)) return(.formater_decimal_fr(n / q))
  paste0(n, "/", q)
}

.generer_equation_ax_b = function(p) {
  a = .tirer_parametre(p, "a")
  b = .tirer_parametre(p, "b")
  droite = .tirer_parametre(p, "membre_droit")
  signe = if (b < 0) " - " else " + "
  terme = abs(b)
  gauche = if (b == 0) paste0(a, "x") else paste0(a, "x", signe, terme)
  numerateur = droite - b
  solution = .formater_rationnel(numerateur, a)
  list(
    enonce = paste0("Resoudre l equation ", gauche, " = ", droite, "."),
    reponse = paste0("x = ", solution),
    parametres = list(
      a = a,
      b = b,
      membre_droit = droite,
      solution_numerateur = numerateur,
      solution_denominateur = a
    )
  )
}

.generer_mediane = function(p) {
  n = as.integer(.tirer_parametre(p, "effectif"))
  mini = .tirer_parametre(p, "minimum")
  maxi = .tirer_parametre(p, "maximum")
  valeurs = sample(seq.int(mini, maxi), n, replace = TRUE)
  ordonnees = sort(valeurs)
  med = ordonnees[(n + 1L) / 2L]
  list(
    enonce = paste0("Determiner la mediane de la serie : ", paste(valeurs, collapse = " ; "), "."),
    reponse = as.character(med),
    parametres = list(valeurs = valeurs)
  )
}

.generer_divisibilite = function(p) {
  d = as.integer(.tirer_parametre(p, "diviseur"))
  q = as.integer(.tirer_parametre(p, "quotient"))
  divisible = sample(c(TRUE, FALSE), 1L)
  n = d * q
  if (!divisible) n = n + sample(seq_len(d - 1L), 1L)
  list(
    enonce = paste0("Le nombre ", n, " est-il divisible par ", d, " ?"),
    reponse = if (divisible) "Oui" else "Non",
    parametres = list(nombre = n, diviseur = d, divisible = divisible)
  )
}

.generer_puissances_dix = function(p) {
  a = .tirer_parametre(p, "exposant_1")
  b = .tirer_parametre(p, "exposant_2")
  list(
    enonce = paste0("Ecrire sous la forme d une puissance de 10 : 10^", a, " x 10^", b, "."),
    reponse = paste0("10^", a + b),
    parametres = list(exposant_1 = a, exposant_2 = b)
  )
}

.generer_proportionnalite = function(p) {
  u = .tirer_parametre(p, "valeur_unitaire")
  q = .tirer_parametre(p, "quantite")
  list(
    enonce = paste0("Une unite coute ", u, " euros. Combien coutent ", q, " unites ?"),
    reponse = paste0(u * q, " euros"),
    parametres = list(valeur_unitaire = u, quantite = q)
  )
}

.formater_nombre_examen = function(numerateur, denominateur = 1L) {
  .formater_rationnel(numerateur, denominateur)
}

.ressource_examen = function(type, moteur, donnees) {
  list(type = type, moteur = moteur, donnees = donnees)
}

.generer_angle_triangle = function(p) {
  repeat {
    a = .tirer_parametre(p, "angle_1")
    b = .tirer_parametre(p, "angle_2")
    c = 180L - a - b
    if (c >= 20L) break
  }
  list(
    enonce = paste0(
      "Dans un triangle, deux angles mesurent ", a, " degres et ", b,
      " degres. Quelle est la mesure du troisieme angle ?"
    ),
    reponse = paste0(c, " degres"),
    parametres = list(angle_1 = a, angle_2 = b, angle_3 = c),
    ressource = .ressource_examen(
      "FIGURE_GEOMETRIQUE",
      "triangle_angles",
      list(angle_1 = a, angle_2 = b, angle_3 = c)
    )
  )
}

.generer_probabilite_urne = function(p) {
  favorables = .tirer_parametre(p, "favorables")
  autres = .tirer_parametre(p, "autres")
  total = favorables + autres
  list(
    enonce = paste0(
      "Une urne contient ", favorables, " boules rouges et ", autres,
      " boules bleues, indiscernables au toucher. On tire une boule au hasard. ",
      "Quelle est la probabilite d obtenir une boule rouge ?"
    ),
    reponse = .formater_nombre_examen(favorables, total),
    parametres = list(favorables = favorables, autres = autres, total = total),
    ressource = .ressource_examen(
      "SCHEMA",
      "urne_deux_couleurs",
      list(favorables = favorables, autres = autres)
    )
  )
}

.generer_aire_rectangle = function(p) {
  longueur = .tirer_parametre(p, "longueur")
  largeur = .tirer_parametre(p, "largeur")
  aire = longueur * largeur
  list(
    enonce = paste0(
      "Un rectangle mesure ", longueur, " cm de longueur et ", largeur,
      " cm de largeur. Calculer son aire."
    ),
    reponse = paste0(aire, " cm^2"),
    parametres = list(longueur = longueur, largeur = largeur, aire = aire),
    ressource = .ressource_examen(
      "FIGURE_GEOMETRIQUE",
      "rectangle_dimensions",
      list(longueur = longueur, largeur = largeur)
    )
  )
}

.generer_scratch_boucle = function(p) {
  repetitions = .tirer_parametre(p, "repetitions")
  pas = .tirer_parametre(p, "pas")
  total = repetitions * pas
  list(
    enonce = paste0(
      "Un programme Scratch repete ", repetitions,
      " fois l instruction avancer de ", pas,
      " pas. De combien de pas le lutin avance-t-il au total ?"
    ),
    reponse = paste0(total, " pas"),
    parametres = list(repetitions = repetitions, pas = pas, total = total),
    ressource = .ressource_examen(
      "SCRATCH",
      "boucle_avancer",
      list(repetitions = repetitions, pas = pas)
    )
  )
}

.generateur_gabarit = function(id) {
  generateurs = list(
    fraction_somme = .generer_fraction_somme,
    fraction_quantite = .generer_fraction_quantite,
    pourcentage = .generer_pourcentage,
    priorites = .generer_priorites,
    equation_ax_b = .generer_equation_ax_b,
    mediane = .generer_mediane,
    divisibilite = .generer_divisibilite,
    puissances_dix = .generer_puissances_dix,
    proportionnalite = .generer_proportionnalite,
    angle_triangle = .generer_angle_triangle,
    probabilite_urne = .generer_probabilite_urne,
    aire_rectangle = .generer_aire_rectangle,
    scratch_boucle = .generer_scratch_boucle
  )
  f = generateurs[[id]]
  if (is.null(f)) stop("Generateur de gabarit non implemente : ", id, call. = FALSE)
  f
}

#' Instancier un gabarit d'examen
#'
#' Genere un enonce et sa reponse a partir d'un gabarit parametrique. La graine
#' permet de reproduire exactement la meme variante.
#'
#' @param gabarit_id Identifiant du gabarit.
#' @param seed Graine aleatoire facultative.
#' @return Une liste avec metadonnees, enonce, reponse et parametres tires.
#' @export
generer_gabarit_examen = function(gabarit_id, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  g = gabarit_examen(gabarit_id)
  f = .generateur_gabarit(g$gabarit$generateur_id[[1]])
  variante = f(g$parametres)
  if (is.null(variante$correction)) {
    variante$correction = paste0("Reponse attendue : ", variante$reponse, ".")
  }
  if (is.null(variante$ressource)) variante$ressource = NULL
  c(
    list(
      gabarit_id = gabarit_id,
      domaine = g$gabarit$domaine[[1]],
      support = g$gabarit$support[[1]],
      difficulte = g$gabarit$difficulte[[1]],
      origine = g$gabarit$origine[[1]],
      source_id = g$gabarit$source_id[[1]],
      session_source = g$gabarit$session_source[[1]]
    ),
    variante
  )
}

.selectionner_gabarit_examen = function(code, partie_type, domaine, support, difficulte, concept_id = NULL) {
  x = gabarits_examen(examen_code = code, partie_type = partie_type, domaine = domaine)
  if (!nrow(x)) return(NA_character_)

  if (!is.null(concept_id) && !is.na(concept_id) && nzchar(concept_id)) {
    liens = .lire_csv("examens", "gabarits_exercices_concepts.csv")
    ids = liens$gabarit_id[liens$concept_id == concept_id]
    exacts = x[x$gabarit_id %in% ids, , drop = FALSE]
    if (nrow(exacts)) x = exacts
  }

  d = suppressWarnings(as.integer(x$difficulte))
  cible = suppressWarnings(as.integer(difficulte))
  compatibles = x[d == cible & x$support == support, , drop = FALSE]
  if (!nrow(compatibles)) compatibles = x[d == cible, , drop = FALSE]
  if (!nrow(compatibles)) compatibles = x
  sample(compatibles$gabarit_id, 1L)
}

.concept_gabarit_examen = function(gabarit_id, fallback = NA_character_) {
  if (is.null(gabarit_id) || is.na(gabarit_id) || !nzchar(gabarit_id)) return(fallback)
  liens = .lire_csv("examens", "gabarits_exercices_concepts.csv")
  liens = liens[liens$gabarit_id == gabarit_id, , drop = FALSE]
  if (!nrow(liens)) return(fallback)
  centraux = liens$concept_id[liens$role == "CENTRAL"]
  if (length(centraux)) return(centraux[[1]])
  liens$concept_id[[1]]
}
