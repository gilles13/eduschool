construire_exercice = function(env, dossier, sujet, afficher_formules = getOption("eduschool.brevet.geo_d.formules", TRUE)) {
  source("inst/brevet/charger.R", local = TRUE)
  exercice = charger_exercice_brevet(sujet)
  d = unlist(exercice$donnees)
  r = unlist(exercice$resultats)
  points = exercice$points
  rc = d[["rayon_cylindre"]]
  rs = d[["rayon_demi_sphere"]]
  h = d[["hauteur"]]
  figure = file.path(dossier, paste0(sujet, ".png"))
  figure_corrige = file.path(dossier, paste0(sujet, "-contact.png"))
  tracer = function(chemin, contact) {
    p = graphique_cylindre_demi_sphere(rayon_cylindre = rc, rayon_demi_sphere = rs, hauteur = h, disque_contact = contact, couleur_contact = "red")
    ragg::agg_png(chemin, width = 500, height = 600, res = 150)
    tryCatch(print(p), finally = grDevices::dev.off())
  }
  tracer(figure, FALSE)
  tracer(figure_corrige, TRUE)
  enonce = sprintf("Un solide est form\u00e9 d'un cylindre de rayon %s cm et de hauteur %s cm, surmont\u00e9 d'une demi-boule de rayon %s cm. Les deux solides sont assembl\u00e9s sans se chevaucher. On cherche l'aire de la surface ext\u00e9rieure de l'ensemble. Donner les r\u00e9sultats exacts en fonction de $\\pi$.", rc, h, rs)
  if (afficher_formules) enonce = paste(enonce, "Rappels : aire totale d'un cylindre : $S_c = 2\\pi rh + 2\\pi r^2$ ; aire d'une sph\u00e8re : $S_s = 4\\pi r^2$.", sep = "\n\n")
  questions = c("Calculer l'aire totale du cylindre, avant assemblage.", "Calculer l'aire totale de la demi-boule, avant assemblage.", "En d\u00e9duire l'aire de la surface ext\u00e9rieure du solide assembl\u00e9.")
  questions = paste0(seq_along(questions), ". ", questions, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  correction = paste(
    "## Corrig\u00e9 - Exercice 1",
    "### 1. Aire totale du cylindre (Sc)",
    "Le cylindre poss\u00e8de une surface lat\u00e9rale et deux disques : un en haut et un en bas.",
    "La surface lat\u00e9rale est le p\u00e9rim\u00e8tre du cercle de base multipli\u00e9 par la hauteur : $2\\pi r_c h$.",
    "Les deux disques ont chacun pour aire $\\pi r_c^2$. Ainsi :",
    sprintf("$S_c = 2\\pi r_c h + 2\\pi r_c^2 = 2\\pi \\times %s \\times %s + 2\\pi \\times %s^2 = %s\\pi\\ \\mathrm{cm}^2$.", rc, h, rc, r[["aire_cylindre_coefficient_pi"]]),
    "\u00c0 cette \u00e9tape, on compte aussi le disque sup\u00e9rieur, m\u00eame s\u2019il sera ensuite cach\u00e9 par la demi-boule.",
    "### 2. Aire totale de la demi-boule (Sdb)",
    "L\u2019aire d\u2019une sph\u00e8re enti\u00e8re de rayon $r_s$ est $4\\pi r_s^2$.",
    "La demi-boule ne poss\u00e8de que la moiti\u00e9 de cette surface courbe :",
    sprintf("$S_{courbe} = \\dfrac{4\\pi r_s^2}{2} = 2\\pi r_s^2 = 2\\pi \\times %s^2 = %s\\pi\\ \\mathrm{cm}^2$.", rs, 2 * rs^2),
    "Mais la demi-boule poss\u00e8de aussi une face plane : son disque de base. Il faut l\u2019ajouter pour obtenir l\u2019aire **totale** :",
    sprintf("$S_{disque} = \\pi r_s^2 = \\pi \\times %s^2 = %s\\pi\\ \\mathrm{cm}^2$.", rs, rs^2),
    sprintf("$S_{db} = 2\\pi r_s^2 + \\pi r_s^2 = 3\\pi r_s^2 = %s\\pi\\ \\mathrm{cm}^2$.", r[["aire_demi_boule_coefficient_pi"]]),
    "**Attention :** diviser l\u2019aire de la sph\u00e8re par deux ne donne que la surface courbe, pas l\u2019aire totale de la demi-boule.",
    "### 3. Aire ext\u00e9rieure de l\u2019assemblage",
    sprintf("![Disque de contact en rouge](%s)", figure_corrige),
    "Les aires $S_c$ et $S_{db}$ ont \u00e9t\u00e9 calcul\u00e9es **avant assemblage**. Certaines surfaces deviennent int\u00e9rieures lorsque les deux solides sont r\u00e9unis.",
    "Le disque rouge correspond au dessus du cylindre, de rayon $r_c$. Il est enti\u00e8rement en contact avec une partie du disque de base de la demi-boule.",
    sprintf("$S_{contact} = \\pi r_c^2 = \\pi \\times %s^2 = %s\\pi\\ \\mathrm{cm}^2$.", rc, r[["aire_contact_coefficient_pi"]]),
    "Ce disque est compt\u00e9 **deux fois** dans $S_c + S_{db}$ : une fois comme dessus du cylindre et une fois comme portion de la base de la demi-boule. Pourtant, aucune de ces deux faces en contact n\u2019est visible de l\u2019ext\u00e9rieur.",
    "Il faut donc retirer **deux fois l\u2019aire du disque rouge**, et non une seule fois :",
    sprintf("$S_{ext} = S_c + S_{db} - 2S_{contact} = %s\\pi + %s\\pi - 2 \\times %s\\pi = \\boxed{%s\\pi\\ \\mathrm{cm}^2}$.", r[["aire_cylindre_coefficient_pi"]], r[["aire_demi_boule_coefficient_pi"]], r[["aire_contact_coefficient_pi"]], r[["aire_exterieure_coefficient_pi"]]),
    "Si la demi-boule est plus large que le cylindre, la couronne de sa base qui d\u00e9passe reste une surface ext\u00e9rieure : elle n\u2019est pas retir\u00e9e.",
    "**V\u00e9rification :** en simplifiant l\u2019expression g\u00e9n\u00e9rale, on obtient $S_{ext} = 2\\pi r_c h + 3\\pi r_s^2$.",
    sep = "\n\n"
  )
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = exercice$total_points, figure = figure)
}
