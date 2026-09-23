# ============================================================
# Humour des exercices
# ============================================================

.catalogue_humour = data.frame(
  cle = c(
    "PROP_001:cookies",
    "PROP_001:chaussettes",
    "PROP_001:crayons",
    "PROP_RECON_001:coefficient",
    "PROP_RECON_001:taxi",
    "PROP_RECON_001:tableau",
    "PROP_TABLE_001:cahiers",
    "PROP_TABLE_001:boisson",
    "PROP_TABLE_001:distance",
    "PROP_PIEGE_001:prix_unitaire",
    "PROP_PIEGE_001:doublement",
    "PROP_PIEGE_001:addition",
    "PROP_TRANSF_001:riz",
    "PROP_TRANSF_001:peinture",
    "PROP_TRANSF_001:jus",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_ADD_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001",
    "FRAC_QTE_001"
  ),
  niveau = c(
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    1L,
    2L,
    1L,
    2L,
    1L,
    1L,
    1L,
    1L,
    2L,
    1L,
    1L,
    1L,
    2L,
    1L,
    1L,
    2L
  ),
  texte = c(
    " Promis, partir avec le paquet n'est pas une m\u00e9thode de proportionnalit\u00e9.",
    " Pourquoi uniquement des chaussettes ? Le cahier des charges reste myst\u00e9rieux.",
    " Oui, encore des crayons. Picasso aurait probablement demand\u00e9 un autre exercice.",
    " Le prix du pop-corn, lui, refuse de participer a cette enquete.",
    " Le taxi augmente, mais pas comme eduschool le voudrait.",
    " M\u00eame dans l'espace, le multiplicateur finit par nous retrouv\u00e9r.",
    " Encore des fournitures scolaires : le suspense est insoutenable.",
    " Les bouteilles promettent de ne pas changer de taille pendant le calcul.",
    " A vitesse constante : ces trois mots font presque tout le boulot.",
    " Gare au calcul qui a l'air malin mais raconte n'importe quoi.",
    " Le produit en croix peut rester assis : ici, doubler suffit.",
    " Attention au pi\u00e8ge : il a mis une moustache pour avoir l'air cr\u00e9dible.",
    " La proportionnalit\u00e9 vient officiellement de sauver le d\u00eener.",
    " Picasso n'est pas disponible, il va falloir calculer.",
    " Les verres sont identiques, sinon ce serait franchement chiant.",
    " Les d\u00e9nominateurs ont accept\u00e9 de coop\u00e9rer. Merci de ne pas les brusquer.",
    " Le d\u00e9nominateur commun : m\u00eame les fractions finissent par trouver un terrain d'entente.",
    " Deux fractions entrent dans un calcul. Une seule en ressort. Aucun num\u00e9rateur n'a souhait\u00e9 t\u00e9moigner.",
    " On met tout le monde au m\u00eame d\u00e9nominateur. D\u00e9mocratie math\u00e9matique, avec simplification au second tour.",
    " Les fractions se rapprochent. Merci de respecter leur intimit\u00e9.",
    " Un d\u00e9nominateur commun vient d'\u00eatre trouv\u00e9. Les n\u00e9gociations ont \u00e9t\u00e9 plus rapides qu'\u00e0 l'ONU.",
    " Additionner les num\u00e9rateurs directement serait tentant. Le pi\u00e8ge aussi a trouv\u00e9 l\u2019id\u00e9e excellente.",
    " Encore une addition de fractions. Quelque part, un d\u00e9nominateur cherche d\u00e9j\u00e0 un avocat.",
    " Les fractions \u00e9taient irr\u00e9conciliables. Puis quelqu'un a prononc\u00e9 les mots d\u00e9nominateur commun.",
    " Rien ne se perd, rien ne se cr\u00e9e, tout se met au m\u00eame d\u00e9nominateur. Lavoisier n'a pas valid\u00e9 cette phrase.",
    " Une fraction d'un nombre reste un nombre. Jusqu'ici, l'univers tient bon.",
    " On ne prend qu'une fraction du nombre. Inutile d'appeler les secours.",
    " Le nombre va perdre une partie de lui-m\u00eame. Il a sign\u00e9 le formulaire de consentement.",
    " Une petite fraction, un grand calcul. Enfin... gardons le sens des proportions.",
    " Aucun nombre n'a \u00e9t\u00e9 maltrait\u00e9 pendant la fabrication de cet exercice.",
    " Calculer une fraction d'un nombre : la division fait le tri, la multiplication finit le travail.",
    " Le nombre est entier au d\u00e9but. Pour la suite, son avocat nous conseille de ne rien d\u00e9clarer.",
    " Une fraction vient r\u00e9clamer sa part. Le service comptable est formel : il faut calculer.",
    " Si le r\u00e9sultat semble \u00e9trange, rassure-toi : nous avons d\u00e9j\u00e0 vu un bouton HTML traverser la quatri\u00e8me dimension.",
    " Une fraction de nombre, c'est moins spectaculaire qu'une porte interdimensionnelle, mais nettement plus simple \u00e0 tester."
  ),
  stringsAsFactors = FALSE
)

.cles_humour = function(exercice) {
  cas = exercice$parametres$cas

  c(
    if (!is.null(cas) && length(cas) == 1L && !is.na(cas) && nzchar(cas)) {
      paste(exercice$modele_id, cas, sep = ":")
    },
    exercice$modele_id
  )
}

.humour_disponible = function(exercice) {
  if (identical(exercice$qcm$forme_question, "nommer_notion")) return(FALSE)

  feedback_humour = exercice$qcm$feedback_humour
  if (!is.null(feedback_humour) && length(feedback_humour) == 4L) {
    return(TRUE)
  }
  any(.cles_humour(exercice) %in% .catalogue_humour$cle)
}

.ajouter_humour = function(exercice) {
  if (identical(exercice$qcm$forme_question, "nommer_notion")) return(exercice)

  feedback_humour = exercice$qcm$feedback_humour
  if (!is.null(feedback_humour) && length(feedback_humour) == 4L) {
    exercice$qcm$feedback = feedback_humour
    exercice$qcm$humour = TRUE
    return(exercice)
  }

  cles = .cles_humour(exercice)
  cle = cles[cles %in% .catalogue_humour$cle]

  if (!length(cle)) {
    return(exercice)
  }

  chutes = .catalogue_humour$texte[
    .catalogue_humour$cle == cle[[1L]] & .catalogue_humour$niveau <= 1L
  ]
  seed = exercice$seed

  if (is.null(seed) || length(seed) != 1L || is.na(seed)) {
    position = 1L
  } else {
    position = (abs(as.integer(seed)) %% length(chutes)) + 1L
  }

  exercice$qcm$apart_humour = trimws(chutes[[position]])
  exercice$qcm$humour = TRUE
  exercice
}
