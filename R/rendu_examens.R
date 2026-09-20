# Rendu graphique et PDF des examens

.verifier_ressource_examen = function(ressource) {
  if (!is.list(ressource)) stop("ressource doit etre une liste.", call. = FALSE)
  champs = c("type", "moteur", "donnees")
  manquants = champs[!champs %in% names(ressource)]
  if (length(manquants)) {
    stop("Ressource incomplete : ", paste(manquants, collapse = ", "), call. = FALSE)
  }
  invisible(TRUE)
}

.preparer_zone_ressource = function() {
  graphics::par(mar = c(0.2, 0.2, 0.2, 0.2), xaxs = "i", yaxs = "i")
  graphics::plot.new()
  graphics::plot.window(xlim = c(0, 1), ylim = c(0, 1), asp = 1)
}

.dessiner_triangle_angles = function(d) {
  .preparer_zone_ressource()
  x = c(0.12, 0.86, 0.62)
  y = c(0.18, 0.18, 0.82)
  graphics::polygon(x, y, border = "black", lwd = 1.6)
  graphics::text(x[1] - 0.035, y[1] - 0.05, "A", cex = 0.95)
  graphics::text(x[2] + 0.035, y[2] - 0.05, "B", cex = 0.95)
  graphics::text(x[3], y[3] + 0.055, "C", cex = 0.95)
  graphics::text(0.25, 0.25, paste0(d$angle_1, " deg"), cex = 0.9)
  graphics::text(0.76, 0.25, paste0(d$angle_2, " deg"), cex = 0.9)
  graphics::text(0.61, 0.69, "?", cex = 1.25, font = 2)
}

.dessiner_rectangle_dimensions = function(d) {
  .preparer_zone_ressource()
  graphics::rect(0.18, 0.26, 0.82, 0.74, lwd = 1.6)
  graphics::segments(0.18, 0.18, 0.82, 0.18, lwd = 1)
  graphics::segments(c(0.18, 0.82), 0.15, c(0.18, 0.82), 0.21, lwd = 1)
  graphics::text(0.50, 0.11, paste0(d$longueur, " cm"), cex = 0.9)
  graphics::segments(0.89, 0.26, 0.89, 0.74, lwd = 1)
  graphics::segments(0.86, c(0.26, 0.74), 0.92, c(0.26, 0.74), lwd = 1)
  graphics::text(0.95, 0.50, paste0(d$largeur, " cm"), srt = 90, cex = 0.9)
}

.dessiner_urne_deux_couleurs = function(d) {
  .preparer_zone_ressource()
  theta = seq(0, 2 * pi, length.out = 240)
  x = 0.50 + 0.31 * cos(theta)
  y = 0.48 + 0.36 * sin(theta)
  graphics::polygon(x, y, border = "black", lwd = 1.5)
  graphics::segments(0.34, 0.79, 0.66, 0.79, lwd = 2)
  graphics::text(0.50, 0.58, paste0("Rouges : ", d$favorables), cex = 0.95)
  graphics::text(0.50, 0.40, paste0("Bleues : ", d$autres), cex = 0.95)
  graphics::text(0.50, 0.18, "Tirage au hasard", cex = 0.85)
}

.dessiner_scratch_boucle = function(d) {
  grid::grid.newpage()
  grid::pushViewport(grid::viewport(xscale = c(0, 1), yscale = c(0, 1)))
  gp_controle = grid::gpar(fill = "grey85", col = "black", lwd = 1.2)
  gp_mouvement = grid::gpar(fill = "grey94", col = "black", lwd = 1.2)
  grid::grid.roundrect(
    x = 0.50, y = 0.66, width = 0.76, height = 0.24,
    r = grid::unit(0.06, "snpc"), gp = gp_controle
  )
  grid::grid.text(
    paste0("repeter ", d$repetitions, " fois"),
    x = 0.22, y = 0.70, just = "left",
    gp = grid::gpar(fontsize = 12, fontface = "bold")
  )
  grid::grid.roundrect(
    x = 0.56, y = 0.46, width = 0.58, height = 0.17,
    r = grid::unit(0.05, "snpc"), gp = gp_mouvement
  )
  grid::grid.text(
    paste0("avancer de ", d$pas, " pas"),
    x = 0.33, y = 0.46, just = "left",
    gp = grid::gpar(fontsize = 11)
  )
  grid::popViewport()
}

.theme_examen_ggplot = function(base_size = 10) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      axis.title = ggplot2::element_text(face = "bold", colour = "#27323C"),
      axis.text = ggplot2::element_text(colour = "#27323C"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = "#E4E8EC", linewidth = 0.35),
      plot.margin = ggplot2::margin(8, 18, 10, 14, unit = "pt"),
      legend.title = ggplot2::element_blank(),
      legend.position = "top"
    )
}

# Construit des mappings ggplot2 a partir de noms de colonnes sans
# evaluation non standard dans le code du package. Cette petite passerelle
# reste volontairement en base R et evite a la fois les bindings globaux
# de R CMD check et les expressions data$colonne deconseillees par ggplot2.
.aes_colonnes = function(...) {
  colonnes = list(...)
  do.call(ggplot2::aes, lapply(colonnes, as.name))
}

.dessiner_plan_triangle_rectangle = function(d) {
  sommets = data.frame(
    sommet = c("A", "B", "C"),
    x = c(-0.08 * d$b, -0.08 * d$b, 1.07 * d$b),
    y = c(-0.08 * d$a, 1.06 * d$a, -0.08 * d$a),
    stringsAsFactors = FALSE
  )
  triangle = data.frame(
    x = c(0, 0, d$b, 0),
    y = c(0, d$a, 0, 0)
  )
  etiquettes = data.frame(
    x = c(-0.08 * d$b, 0.50 * d$b, 0.55 * d$b),
    y = c(0.50 * d$a, -0.10 * d$a, 0.58 * d$a),
    label = c(paste0(d$a, " m"), paste0(d$b, " m"), paste0(d$c, " m")),
    angle = c(90, 0, -atan2(d$a, d$b) * 180 / pi),
    stringsAsFactors = FALSE
  )

  p = ggplot2::ggplot(triangle, .aes_colonnes(x = "x", y = "y")) +
    ggplot2::geom_path(linewidth = 0.9, colour = "#25364a") +
    ggplot2::annotate(
      "segment", x = 0, y = 0.12 * d$a,
      xend = 0.12 * d$b, yend = 0.12 * d$a,
      linewidth = 0.55, colour = "#25364a"
    ) +
    ggplot2::annotate(
      "segment", x = 0.12 * d$b, y = 0,
      xend = 0.12 * d$b, yend = 0.12 * d$a,
      linewidth = 0.55, colour = "#25364a"
    ) +
    ggplot2::geom_text(
      data = sommets, .aes_colonnes(x = "x", y = "y", label = "sommet"),
      inherit.aes = FALSE, fontface = "bold", size = 3.6
    ) +
    ggplot2::geom_text(
      data = etiquettes,
      .aes_colonnes(x = "x", y = "y", label = "label", angle = "angle"),
      inherit.aes = FALSE, size = 3.3
    ) +
    ggplot2::coord_fixed(
      xlim = c(-0.18 * d$b, 1.12 * d$b),
      ylim = c(-0.18 * d$a, 1.12 * d$a),
      clip = "off"
    ) +
    ggplot2::theme_void(base_size = 10) +
    ggplot2::theme(plot.margin = ggplot2::margin(12, 22, 14, 22, unit = "pt"))

  print(p)
  invisible(p)
}

.dessiner_courbes_affines_tarifs = function(d) {
  x = seq(0, d$xmax, length.out = 120)
  donnees = rbind(
    data.frame(x = x, prix = d$fixe + d$a * x, tarif = "Tarif A"),
    data.frame(x = x, prix = d$b * x, tarif = "Tarif B")
  )
  ymax = max(donnees$prix)

  p = ggplot2::ggplot(donnees, .aes_colonnes(x = "x", y = "prix", linetype = "tarif")) +
    ggplot2::geom_line(linewidth = 0.9, colour = "#25364a") +
    ggplot2::scale_linetype_manual(values = c("Tarif A" = "solid", "Tarif B" = "22")) +
    ggplot2::scale_x_continuous(
      limits = c(0, d$xmax),
      expand = ggplot2::expansion(mult = c(0.01, 0.04))
    ) +
    ggplot2::scale_y_continuous(
      limits = c(0, ymax * 1.08),
      expand = ggplot2::expansion(mult = c(0, 0.03))
    ) +
    ggplot2::labs(x = if (!is.null(d$x_libelle)) d$x_libelle else "Nombre d'utilisations", y = "Prix (euros)", linetype = NULL) +
    ggplot2::coord_cartesian(clip = "off") +
    .theme_examen_ggplot(base_size = 10)

  print(p)
  invisible(p)
}

.dessiner_diagramme_batons_enquete = function(d) {
  donnees = data.frame(
    jour = factor(paste0("J", seq_along(d$valeurs)), levels = paste0("J", seq_along(d$valeurs))),
    trajets = d$valeurs
  )
  ymax = max(c(d$valeurs, d$seuil))

  p = ggplot2::ggplot(donnees, .aes_colonnes(x = "jour", y = "trajets")) +
    ggplot2::geom_col(width = 0.68, fill = "#dbe8f2", colour = "#25364a", linewidth = 0.5) +
    ggplot2::geom_text(
      .aes_colonnes(label = "trajets"),
      vjust = -0.45, fontface = "bold", size = 3.2
    ) +
    ggplot2::geom_hline(yintercept = d$seuil, linetype = "dashed", linewidth = 0.65, colour = "#7A3E2C") +
    ggplot2::annotate(
      "text", x = Inf, y = d$seuil,
      label = paste0("Seuil : ", d$seuil),
      hjust = 1.04, vjust = -0.55, size = 3.0, colour = "#7A3E2C"
    ) +
    ggplot2::scale_y_continuous(
      limits = c(0, ymax * 1.22),
      expand = ggplot2::expansion(mult = c(0, 0.02))
    ) +
    ggplot2::labs(x = "Jour", y = if (!is.null(d$y_libelle)) d$y_libelle else "Nombre de trajets") +
    ggplot2::coord_cartesian(clip = "off") +
    .theme_examen_ggplot(base_size = 10) +
    ggplot2::theme(legend.position = "none")

  print(p)
  invisible(p)
}


.dessiner_schema_thales_ombres = function(d) {
  ecart = 0.18 * d$ombre_grand
  origine_grand = d$ombre_petit + ecart
  xmax = origine_grand + d$ombre_grand
  ymax = max(d$petit, d$grand)
  segments = data.frame(
    x = c(0, 0, origine_grand, origine_grand),
    y = c(0, 0, 0, 0),
    xend = c(0, d$ombre_petit, origine_grand, origine_grand + d$ombre_grand),
    yend = c(d$petit, 0, d$grand, 0),
    stringsAsFactors = FALSE
  )
  rayons = data.frame(
    x = c(0, origine_grand), y = c(d$petit, d$grand),
    xend = c(d$ombre_petit, origine_grand + d$ombre_grand), yend = c(0, 0)
  )
  p = ggplot2::ggplot() +
    ggplot2::geom_segment(
      data = segments,
      .aes_colonnes(x = "x", y = "y", xend = "xend", yend = "yend"),
      linewidth = 0.9, colour = "#25364a"
    ) +
    ggplot2::geom_segment(
      data = rayons,
      .aes_colonnes(x = "x", y = "y", xend = "xend", yend = "yend"),
      linewidth = 0.65, linetype = "dashed", colour = "#7A3E2C"
    ) +
    ggplot2::annotate("text", x = -0.02 * xmax, y = d$petit/2,
      label = paste0(.formater_decimal_fr(d$petit), " m"), hjust = 1, size = 3.1) +
    ggplot2::annotate("text", x = d$ombre_petit/2, y = -0.05 * ymax,
      label = paste0(.formater_decimal_fr(d$ombre_petit), " m"), vjust = 1, size = 3.1) +
    ggplot2::annotate("text", x = origine_grand - 0.02 * xmax, y = d$grand/2,
      label = "hauteur ?", hjust = 1, size = 3.1, fontface = "bold") +
    ggplot2::annotate("text", x = origine_grand + d$ombre_grand/2, y = -0.05 * ymax,
      label = paste0(.formater_decimal_fr(d$ombre_grand), " m"), vjust = 1, size = 3.1) +
    ggplot2::annotate("text", x = d$ombre_petit/2, y = 0.10 * ymax,
      label = "piquet", size = 2.8) +
    ggplot2::annotate("text", x = origine_grand + d$ombre_grand/2, y = 0.10 * ymax,
      label = if (!is.null(d$objet_label)) d$objet_label else "arbre", size = 2.8) +
    ggplot2::coord_fixed(
      xlim = c(-0.12 * xmax, 1.04 * xmax), ylim = c(-0.14 * ymax, 1.08 * ymax),
      clip = "off"
    ) +
    ggplot2::theme_void(base_size = 10) +
    ggplot2::theme(plot.margin = ggplot2::margin(14, 20, 18, 24, unit = "pt"))
  print(p)
  invisible(p)
}

.dessiner_schema_cuve_pave = function(d) {
  x = c(0.18, 0.72, 0.88, 0.34, 0.18, 0.18, 0.34, 0.88, 0.72)
  y = c(0.20, 0.20, 0.38, 0.38, 0.20, 0.70, 0.88, 0.88, 0.70)
  seg = data.frame(
    x = x[c(1,2,3,4,1,6,7,8,9,6,4,3,2)],
    y = y[c(1,2,3,4,1,6,7,8,9,6,4,3,2)],
    xend = x[c(2,3,4,1,6,7,8,9,6,1,7,8,9)],
    yend = y[c(2,3,4,1,6,7,8,9,6,1,7,8,9)]
  )
  niveau = 0.20 + 0.50 * d$taux / 100
  p = ggplot2::ggplot() +
    ggplot2::annotate("rect", xmin = 0.185, xmax = 0.715, ymin = 0.205, ymax = niveau,
      fill = "#dbe8f2", alpha = 0.65) +
    ggplot2::geom_segment(data = seg,
      .aes_colonnes(x = "x", y = "y", xend = "xend", yend = "yend"),
      linewidth = 0.8, colour = "#25364a") +
    ggplot2::annotate("text", x = 0.45, y = 0.12,
      label = paste0(.formater_decimal_fr(d$longueur), " m"), size = 3.1) +
    ggplot2::annotate("text", x = 0.84, y = 0.27,
      label = paste0(.formater_decimal_fr(d$largeur), " m"), size = 3.1, angle = 35) +
    ggplot2::annotate("text", x = 0.10, y = 0.45,
      label = paste0(.formater_decimal_fr(d$hauteur), " m"), size = 3.1, angle = 90) +
    ggplot2::annotate("text", x = 0.46, y = niveau + 0.04,
      label = paste0(d$taux, " %"), size = 3.2, fontface = "bold") +
    ggplot2::coord_fixed(xlim = c(0, 1), ylim = c(0.02, 1), clip = "off") +
    ggplot2::theme_void(base_size = 10) +
    ggplot2::theme(plot.margin = ggplot2::margin(12, 22, 14, 22, unit = "pt"))
  print(p)
  invisible(p)
}

.dessiner_programme_calcul_scratch = function(d) {
  grid::grid.newpage()
  bloc = function(y, texte, fill, width = .72) {
    grid::grid.roundrect(x = .5, y = y, width = width, height = .15,
      r = grid::unit(.035, "snpc"), gp = grid::gpar(fill = fill, col = "white", lwd = 1.2))
    grid::grid.text(texte, x = .18, y = y, just = "left", gp = grid::gpar(col = "white", fontsize = 11, fontface = "bold"))
  }
  bloc(.78, "quand drapeau vert clique", "#e6a23c")
  bloc(.58, "demander [choisir un nombre]", "#4c97ff")
  bloc(.38, paste0("mettre [resultat] a (reponse x ", d$mult, ")"), "#ff8c1a")
  bloc(.18, paste0("ajouter ", d$ajout, " a [resultat]"), "#ff8c1a")
}

.dessiner_ressource_examen = function(ressource) {
  .verifier_ressource_examen(ressource)
  moteur = ressource$moteur
  d = ressource$donnees

  if (identical(moteur, "triangle_angles")) return(.dessiner_triangle_angles(d))
  if (identical(moteur, "rectangle_dimensions")) return(.dessiner_rectangle_dimensions(d))
  if (identical(moteur, "urne_deux_couleurs")) return(.dessiner_urne_deux_couleurs(d))
  if (identical(moteur, "boucle_avancer")) return(.dessiner_scratch_boucle(d))
  if (identical(moteur, "plan_triangle_rectangle")) return(.dessiner_plan_triangle_rectangle(d))
  if (identical(moteur, "courbes_affines_tarifs")) return(.dessiner_courbes_affines_tarifs(d))
  if (identical(moteur, "diagramme_batons_enquete")) return(.dessiner_diagramme_batons_enquete(d))
  if (identical(moteur, "schema_thales_ombres")) return(.dessiner_schema_thales_ombres(d))
  if (identical(moteur, "schema_cuve_pave")) return(.dessiner_schema_cuve_pave(d))
  if (identical(moteur, "programme_calcul_scratch")) return(.dessiner_programme_calcul_scratch(d))

  stop("Moteur de ressource non implemente : ", moteur, call. = FALSE)
}

#' Produire une ressource graphique d'examen
#'
#' Transforme une specification declarative attachee a une question en figure.
#' Le PDF et le SVG restent vectoriels et sont privilegies pour l'impression.
#'
#' @param ressource Specification de ressource produite par [rediger_examen()].
#' @param fichier Chemin du fichier a produire. Si `NULL`, un fichier temporaire est cree.
#' @param format `"pdf"`, `"svg"` ou `"png"`.
#' @param largeur Largeur du dessin en pouces.
#' @param hauteur Hauteur du dessin en pouces.
#' @return Invisiblement, le chemin absolu du fichier produit.
#' @export
produire_ressource_examen = function(ressource, fichier = NULL,
                                      format = c("pdf", "svg", "png"),
                                      largeur = 4.8, hauteur = 2.6) {
  .verifier_ressource_examen(ressource)
  format = match.arg(format)
  if (is.null(fichier)) fichier = tempfile("eduschool-ressource-")
  fichier = sub("\\.(pdf|svg|png)$", "", as.character(fichier), ignore.case = TRUE)
  fichier = paste0(fichier, ".", format)
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)

  if (format == "pdf") {
    grDevices::pdf(fichier, width = largeur, height = hauteur, useDingbats = FALSE)
  } else if (format == "svg") {
    grDevices::svg(fichier, width = largeur, height = hauteur)
  } else {
    grDevices::png(fichier, width = largeur, height = hauteur, units = "in", res = 180)
  }
  on.exit(grDevices::dev.off(), add = TRUE)
  .dessiner_ressource_examen(ressource)
  invisible(fichier)
}

.produire_ressources_examen = function(examen, repertoire, format = c("pdf", "png")) {
  format = match.arg(format)
  dir.create(repertoire, recursive = TRUE, showWarnings = FALSE)
  if (!length(examen$ressources)) return(character())

  sorties = character()
  for (id in names(examen$ressources)) {
    nom = paste0(normaliser_nom_fichier(id), ".", format)
    f = file.path(repertoire, nom)
    produire_ressource_examen(examen$ressources[[id]], f, format = format)
    sorties[id] = normalizePath(f, winslash = "/", mustWork = TRUE)
  }
  sorties
}

.template_examen_pdf = function() {
  f = system.file("templates", "examen_pdf.Rmd", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)
  f = file.path("inst", "templates", "examen_pdf.Rmd")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))
  stop("Template PDF d examen introuvable.", call. = FALSE)
}

.nom_fichier_examen = function(examen, corrige = FALSE) {
  e = examen$entete
  suffixe = if (isTRUE(corrige)) "corrige" else "sujet"
  paste(
    tolower(e$code), e$session, paste0("partie", e$ordre), suffixe,
    sep = "_"
  )
}

.template_examen_html = function() {
  f = system.file("templates", "examen_html.Rmd", package = "eduschool")
  if (nzchar(f) && file.exists(f)) return(f)
  f = file.path("inst", "templates", "examen_html.Rmd")
  if (file.exists(f)) return(normalizePath(f, winslash = "/", mustWork = TRUE))
  stop("Template HTML d examen introuvable.", call. = FALSE)
}

.chemins_examen = function(examen, fichier = NULL, format = c("html", "pdf")) {
  format = match.arg(format)
  extension = paste0(".", format)
  if (is.null(fichier)) {
    base = file.path(tempdir(), .nom_fichier_examen(examen, corrige = FALSE))
  } else {
    base = sub("\\.(html|pdf)$", "", as.character(fichier), ignore.case = TRUE)
  }
  if (grepl("_sujet$", base)) {
    base_corrige = sub("_sujet$", "_corrige", base)
  } else if (grepl("-sujet$", base)) {
    base_corrige = sub("-sujet$", "-corrige", base)
  } else {
    base_corrige = paste0(base, "-corrige")
  }
  c(
    examen = paste0(base, extension),
    corrige = paste0(base_corrige, extension)
  )
}

.rendre_examen = function(examen, fichier, format = c("html", "pdf"), corrige = FALSE, detaille = FALSE) {
  format = match.arg(format)
  travail = tempfile("eduschool-examen-")
  dir.create(travail, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(travail, recursive = TRUE, force = TRUE), add = TRUE)

  template = if (identical(format, "pdf")) .template_examen_pdf() else .template_examen_html()
  entree = file.path(travail, basename(template))
  file.copy(template, entree, overwrite = TRUE)
  format_ressource = if (identical(format, "pdf")) "pdf" else "png"
  ressources = .produire_ressources_examen(
    examen,
    file.path(travail, "ressources"),
    format = format_ressource
  )

  sortie = if (identical(format, "pdf")) {
    rmarkdown::pdf_document(latex_engine = "pdflatex", keep_tex = FALSE)
  } else {
    rmarkdown::html_document(self_contained = TRUE)
  }

  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)
  rendu = rmarkdown::render(
    input = entree,
    output_format = sortie,
    output_file = basename(fichier),
    output_dir = dirname(fichier),
    params = list(
      examen = examen,
      ressources = as.list(ressources),
      corrige = isTRUE(corrige),
      detaille = isTRUE(detaille),
      logo = .logo_eduschool()
    ),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  normalizePath(rendu, winslash = "/", mustWork = TRUE)
}

.formater_reponse_examen_html = function(x) {
  x = .echapper_html_tableau(x)
  gsub("\\^(-?[0-9]+)", "<sup>\\1</sup>", x, perl = TRUE)
}

.formater_reponse_examen_tex = function(x) {
  x = echapper_tex(x)
  gsub("\\\\textasciicircum\\{\\}(-?[0-9]+)", "\\\\textsuperscript{\\1}", x, perl = TRUE)
}

.correction_examen_redondante = function(reponse, correction) {
  if (length(correction) == 0L || is.na(correction) || !nzchar(trimws(correction))) return(FALSE)
  attendu = paste0("Reponse attendue : ", reponse, ".")
  identical(trimws(correction), attendu)
}

#' Produire un examen redige et son corrige
#'
#' Produit, a partir du meme objet redige, le sujet et son corrige. Le format
#' `"auto"` choisit le PDF lorsque LaTeX est disponible et HTML sinon.
#'
#' @param examen Objet produit par [rediger_examen()].
#' @param fichier Chemin de base du sujet. Le corrige recoit le suffixe
#'   `"-corrige"`. Si `NULL`, les deux fichiers sont crees dans le repertoire temporaire.
#' @param format `"auto"`, `"html"` ou `"pdf"`.
#' @param ouvrir Document a ouvrir apres creation : `"examen"` par defaut,
#'   `"les_deux"` ou `"aucun"`.
#' @param detaille Pour le corrige, afficher les etapes de raisonnement detaillees lorsqu elles sont disponibles.
#' @return Invisiblement, un vecteur nomme contenant les chemins du sujet et du corrige.
#' @export
produire_examen = function(
  examen,
  fichier = NULL,
  format = c("auto", "html", "pdf"),
  ouvrir = c("examen", "les_deux", "aucun"),
  detaille = FALSE
) {
  if (!inherits(examen, "eduschool_examen_redige")) {
    stop("examen doit etre produit par rediger_examen().", call. = FALSE)
  }
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Le package rmarkdown est necessaire.", call. = FALSE)
  }
  if (!rmarkdown::pandoc_available()) {
    stop("Pandoc est necessaire pour produire l examen.", call. = FALSE)
  }

  format = .choisir_format_fiche(format)
  ouvrir = match.arg(ouvrir)
  chemins = .chemins_examen(examen, fichier = fichier, format = format)

  chemins[["examen"]] = .rendre_examen(
    examen, chemins[["examen"]], format = format, corrige = FALSE, detaille = FALSE
  )
  chemins[["corrige"]] = .rendre_examen(
    examen, chemins[["corrige"]], format = format, corrige = TRUE, detaille = detaille
  )

  if (ouvrir %in% c("examen", "les_deux")) utils::browseURL(chemins[["examen"]])
  if (identical(ouvrir, "les_deux")) utils::browseURL(chemins[["corrige"]])
  invisible(chemins)
}

#' Produire un DNB complet et ses corriges
#'
#' Compose une variante parametree du DNB 2026, redige les deux parties et
#' produit les sujets et leurs corriges. Les deux parties restent separees afin
#' de respecter la logique de l epreuve, dont la partie 1 est ramassee avant la
#' partie 2.
#'
#' @param seed Graine pseudo-aleatoire utilisee pour controler les tirages de la generation.
#' @param repertoire Repertoire de sortie.
#' @param detaille Produire des corriges detailles avec etapes de raisonnement.
#' @param format `"auto"`, `"html"` ou `"pdf"`.
#' @param ouvrir Document(s) a ouvrir : `"examen"`, `"les_deux"` ou `"aucun"`.
#' @return Un vecteur nomme contenant les quatre chemins produits.
#' @export
produire_dnb = function(
  seed = NULL,
  repertoire = ".",
  detaille = FALSE,
  format = c("auto", "html", "pdf"),
  ouvrir = c("examen", "les_deux", "aucun")
) {
  dir.create(repertoire, recursive = TRUE, showWarnings = FALSE)
  sujet = composer_examen("DNB", 2026, seed = seed)
  p1 = rediger_examen(sujet, partie = 1)
  p2 = rediger_examen(sujet, partie = 2)

  format = match.arg(format)
  ouvrir = match.arg(ouvrir)
  r1 = produire_examen(
    p1,
    file.path(repertoire, "dnb-2026-partie1-sujet"),
    format = format,
    ouvrir = ouvrir,
    detaille = detaille
  )
  r2 = produire_examen(
    p2,
    file.path(repertoire, "dnb-2026-partie2-sujet"),
    format = format,
    ouvrir = ouvrir,
    detaille = detaille
  )
  c(
    partie1_sujet = r1[["examen"]],
    partie1_corrige = r1[["corrige"]],
    partie2_sujet = r2[["examen"]],
    partie2_corrige = r2[["corrige"]]
  )
}
