# Le plan est construit a partir de coordonnees propres a chaque variante.
# Les distances affichees sont controlees avant le rendu.
graphique_reseau_pistes = function(sommets, distances) {
  if (length(sommets) != 12L) stop("Donnees de sommets invalides.")
  sommets = matrix(unlist(sommets, use.names = FALSE), ncol = 3L, byrow = TRUE)
  sommets = data.frame(nom = sommets[, 1], x = as.numeric(sommets[, 2]), y = as.numeric(sommets[, 3]))
  l = as.numeric(distances)
  if (!identical(as.character(sommets$nom), c("A", "B", "C", "D")) || length(l) != 5L || any(!is.finite(l)) || any(l <= 0) || any(!is.finite(sommets$x)) || any(!is.finite(sommets$y))) stop("Sommets ou distances invalides.")
  aretes = data.frame(depart = c("A", "A", "B", "C", "B"), arrivee = c("B", "C", "D", "D", "C"), longueur = l)
  aretes = aretes |>
    dplyr::left_join(dplyr::rename(sommets, depart = nom, x0 = x, y0 = y), by = "depart") |>
    dplyr::left_join(dplyr::rename(sommets, arrivee = nom, x1 = x, y1 = y), by = "arrivee") |>
    dplyr::mutate(corde = sqrt((x1 - x0)^2 + (y1 - y0)^2), xm = (x0 + x1) / 2, ym = (y0 + y1) / 2)
  if (any(abs(aretes$corde - aretes$longueur) > 1e-9)) stop("Distances incoherentes avec le plan a l'echelle.")
  # Etiquettes directement sur les segments : aucune ambiguite d'association.
  # Les positions sont distinctes pour eviter de concentrer les textes au centre.
  fractions = c(0.42, 0.58, 0.42, 0.58, 0.50)
  aretes = aretes |>
    dplyr::mutate(xlabel = x0 + fractions * (x1 - x0), ylabel = y0 + fractions * (y1 - y0))
  taille = max(diff(range(sommets$x)), diff(range(sommets$y)))
  marge = 0.12 * taille
  xlim = range(sommets$x) + c(-marge, marge)
  ylim = range(sommets$y) + c(-marge, marge)
  ggplot2::ggplot() +
    ggplot2::geom_segment(data = aretes, ggplot2::aes(x = x0, y = y0, xend = x1, yend = y1), linewidth = 1.1, colour = "#387CA3") +
    ggplot2::geom_label(data = aretes, ggplot2::aes(x = xlabel, y = ylabel, label = paste0(longueur, " km")), size = 5.5, label.size = 0, label.padding = grid::unit(0.12, "lines"), fill = "white") +
    ggplot2::geom_point(data = sommets, ggplot2::aes(x = x, y = y), size = 5, colour = "#183F56") +
    ggplot2::geom_text(data = sommets, ggplot2::aes(x = x, y = y, label = nom), colour = "white", fontface = "bold", size = 4) +
    ggplot2::coord_equal(xlim = xlim, ylim = ylim, expand = FALSE, clip = "off") +
    ggplot2::labs(title = "R\u00e9seau de pistes cyclables", subtitle = "Segments trac\u00e9s \u00e0 l'\u00e9chelle ; pistes utilisables dans les deux sens") +
    ggplot2::theme_void(base_size = 13) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = .5), plot.subtitle = ggplot2::element_text(hjust = .5), plot.margin = ggplot2::margin(20, 35, 20, 35))
}

construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  l = as.numeric(d$distances)
  points = e$points
  p = graphique_reseau_pistes(d$sommets, l)
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  figure = file.path(dossier, paste0(sujet, ".png"))
  ragg::agg_png(figure, width = 1350, height = 900, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Une association organise une livraison \u00e0 v\u00e9lo \u00e9lectrique entre les points A et D. Le sch\u00e9ma indique les pistes cyclables disponibles et leurs longueurs. Les pistes sont empruntables dans les deux sens. Le v\u00e9lo roule \u00e0 vitesse constante de %s km/h. Sa batterie est charg\u00e9e \u00e0 %s %% au d\u00e9part et chaque kilom\u00e8tre parcouru consomme %s %% de la capacit\u00e9 totale de la batterie.", d$vitesse, d$batterie, d$consommation)
  q = c("Calculer les longueurs des itin\u00e9raires A-B-D et A-C-D.", "D\u00e9terminer le plus court itin\u00e9raire entre A et D parmi tous les trajets sans repasser par un m\u00eame point. Justifier.", "Calculer la dur\u00e9e du trajet aller par cet itin\u00e9raire, en minutes.", "Le livreur peut-il effectuer l'aller-retour par ce m\u00eame itin\u00e9raire sans recharger sa batterie ? Justifier.")
  questions = paste0(seq_along(q), ". ", q, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  chemins = c("A-B-D", "A-C-D", "A-B-C-D", "A-C-B-D")
  j = which.min(as.numeric(r$longueurs))
  correction = paste("## Corrig\u00e9 - MIX-I", "### 1. Deux itin\u00e9raires", sprintf("A-B-D : $$%s+%s=%s\\ \\mathrm{km}$$", l[1], l[3], r$longueurs[[1]]), sprintf("A-C-D : $$%s+%s=%s\\ \\mathrm{km}$$", l[2], l[4], r$longueurs[[2]]), "### 2. Itin\u00e9raire le plus court", sprintf("Les quatre trajets possibles sans r\u00e9p\u00e9tition de point ont pour longueurs : %s.", paste(paste0(chemins, " : ", unlist(r$longueurs), " km"), collapse = " ; ")), sprintf("Le plus court est **%s**, de longueur **%s km**.", chemins[j], r$distance_min), "### 3. Dur\u00e9e", sprintf("$$t=\\frac{%s}{%s}\\times60=\\boxed{%s\\ \\mathrm{min}}$$", r$distance_min, d$vitesse, r$duree_minutes), "### 4. Autonomie", sprintf("L'aller-retour mesure $$2\\times%s=%s\\ \\mathrm{km}$$ et consomme $$%s\\times%s=%s\\ \\%%$$ de la batterie.", r$distance_min, 2*r$distance_min, 2*r$distance_min, d$consommation, r$batterie_aller_retour), sprintf("Charge initiale : %s %%. Charge restante : $$%s-%s=%s\\ \\%%$$. **%s**", d$batterie, d$batterie, r$batterie_aller_retour, r$batterie_restante, if (r$retour_possible) "L'aller-retour est possible." else "L'aller-retour n'est pas possible."), sep = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points, figure = figure)
}
