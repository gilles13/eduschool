# ============================================================
# Humour des exercices
# ============================================================

.catalogue_humour = list(
  "PROP_001:cookies" =
    " Promis, partir avec le paquet n'est pas une methode de proportionnalite.",
  "PROP_001:chaussettes" =
    " Pourquoi uniquement des chaussettes ? Le cahier des charges reste mysterieux.",
  "PROP_001:crayons" =
    " Oui, encore des crayons. Picasso aurait probablement demande un autre exercice.",
  "PROP_RECON_001:coefficient" =
    " Le prix du pop-corn, lui, refuse de participer a cette enquete.",
  "PROP_RECON_001:taxi" =
    " Le taxi augmente, mais pas comme eduschool le voudrait.",
  "PROP_RECON_001:tableau" =
    " Meme dans l'espace, le multiplicateur finit par nous retrouver.",
  "PROP_TABLE_001:cahiers" =
    " Encore des fournitures scolaires : le suspense est insoutenable.",
  "PROP_TABLE_001:boisson" =
    " Les bouteilles promettent de ne pas changer de taille pendant le calcul.",
  "PROP_TABLE_001:distance" =
    " A vitesse constante : ces trois mots font presque tout le boulot.",
  "PROP_PIEGE_001:prix_unitaire" =
    " Gare au calcul qui a l'air malin mais raconte n'importe quoi.",
  "PROP_PIEGE_001:doublement" =
    " Le produit en croix peut rester assis : ici, doubler suffit.",
  "PROP_PIEGE_001:addition" =
    " Attention au piege : il a mis une moustache pour avoir l'air credible.",
  "PROP_TRANSF_001:riz" =
    " La proportionnalite vient officiellement de sauver le diner.",
  "PROP_TRANSF_001:peinture" =
    " Picasso n'est pas disponible, il va falloir calculer.",
  "PROP_TRANSF_001:jus" =
    " Les verres sont identiques, sinon ce serait franchement chiant.",

  "FRAC_ADD_001" = c(
    " Les denominateurs ont accepte de cooperer. Merci de ne pas les brusquer.",
    " Le denominateur commun : meme les fractions finissent par trouver un terrain d'entente.",
    " Deux fractions entrent dans un calcul. Une seule en ressort. Aucun numerateur n'a souhaite temoigner.",
    " On met tout le monde au meme denominateur. Democratie mathematique, avec simplification au second tour.",
    " Les fractions se rapprochent. Merci de respecter leur intimite.",
    " Un denominateur commun vient d'etre trouve. Les negociations ont ete plus rapides qu'a l'ONU.",
    " Additionner les numerateurs directement serait tentant. Le piege aussi trouve l'idee excellente.",
    " Encore une addition de fractions. Quelque part, un denominateur cherche deja un avocat.",
    " Les fractions etaient irreconciliables. Puis quelqu'un a prononce les mots denominateur commun.",
    " Rien ne se perd, rien ne se cree, tout se met au meme denominateur. Lavoisier n'a pas valide cette phrase."
  ),

  "FRAC_QTE_001" = c(
    " Une fraction d'un nombre reste un nombre. Jusqu'ici, l'univers tient bon.",
    " On ne prend qu'une fraction du nombre. Inutile d'appeler les secours.",
    " Le nombre va perdre une partie de lui-meme. Il a signe le formulaire de consentement.",
    " Une petite fraction, un grand calcul. Enfin... gardons le sens des proportions.",
    " Aucun nombre n'a ete maltraite pendant la fabrication de cet exercice.",
    " Calculer une fraction d'un nombre : la division fait le tri, la multiplication finit le travail.",
    " Le nombre est entier au debut. Pour la suite, son avocat nous conseille de ne rien declarer.",
    " Une fraction vient reclamer sa part. Le service comptable est formel : il faut calculer.",
    " Si le resultat semble etrange, rassure-toi : nous avons deja vu un bouton HTML traverser la quatrieme dimension.",
    " Une fraction de nombre, c'est moins spectaculaire qu'une porte interdimensionnelle, mais nettement plus simple a tester."
  )
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
  any(.cles_humour(exercice) %in% names(.catalogue_humour))
}

.ajouter_humour = function(exercice) {
  cles = .cles_humour(exercice)
  cle = cles[cles %in% names(.catalogue_humour)]

  if (!length(cle)) {
    return(exercice)
  }

  chutes = .catalogue_humour[[cle[[1L]]]]
  seed = exercice$seed

  if (is.null(seed) || length(seed) != 1L || is.na(seed)) {
    position = 1L
  } else {
    position = (abs(as.integer(seed)) %% length(chutes)) + 1L
  }

  exercice$enonce = paste0(
    exercice$enonce,
    chutes[[position]]
  )
  exercice$qcm$humour = TRUE
  exercice
}
