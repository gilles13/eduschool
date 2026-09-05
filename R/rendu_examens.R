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

  p = ggplot2::ggplot(triangle, ggplot2::aes(x = x, y = y)) +
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
      data = sommets, ggplot2::aes(x = x, y = y, label = sommet),
      inherit.aes = FALSE, fontface = "bold", size = 3.6
    ) +
    ggplot2::geom_text(
      data = etiquettes,
      ggplot2::aes(x = x, y = y, label = label, angle = angle),
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

  p = ggplot2::ggplot(donnees, ggplot2::aes(x = x, y = prix, linetype = tarif)) +
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
    ggplot2::labs(x = "Nombre d'utilisations", y = "Prix (euros)", linetype = NULL) +
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

  p = ggplot2::ggplot(donnees, ggplot2::aes(x = jour, y = trajets)) +
    ggplot2::geom_col(width = 0.68, fill = "#dbe8f2", colour = "#25364a", linewidth = 0.5) +
    ggplot2::geom_text(
      ggplot2::aes(label = trajets),
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
    ggplot2::labs(x = "Jour", y = "Nombre de trajets") +
    ggplot2::coord_cartesian(clip = "off") +
    .theme_examen_ggplot(base_size = 10) +
    ggplot2::theme(legend.position = "none")

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

.produire_ressources_examen = function(examen, repertoire) {
  dir.create(repertoire, recursive = TRUE, showWarnings = FALSE)
  if (!length(examen$ressources)) return(character())

  sorties = character()
  for (id in names(examen$ressources)) {
    nom = paste0(normaliser_nom_fichier(id), ".pdf")
    f = file.path(repertoire, nom)
    produire_ressource_examen(examen$ressources[[id]], f, format = "pdf")
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

#' Produire un examen redige en PDF
#'
#' Assemble l'en-tete, les questions et les ressources vectorielles d'un objet
#' produit par [rediger_examen()]. Le sujet et le corrige utilisent le meme objet
#' intermediaire afin de garantir leur coherence.
#'
#' @param examen Objet produit par [rediger_examen()].
#' @param fichier Chemin de sortie. Si `NULL`, un nom est construit automatiquement.
#' @param corrige Inclure les reponses et corrections.
#' @param ouvrir Ouvrir le PDF apres creation.
#' @return Invisiblement, le chemin absolu du PDF produit.
#' @export
produire_examen = function(examen, fichier = NULL, corrige = FALSE, ouvrir = FALSE) {
  if (!inherits(examen, "eduschool_examen_redige")) {
    stop("examen doit etre produit par rediger_examen().", call. = FALSE)
  }
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("Le package rmarkdown est necessaire.", call. = FALSE)
  }
  if (!rmarkdown::pandoc_available()) stop("Pandoc est necessaire pour produire le PDF.", call. = FALSE)
  if (!nzchar(Sys.which("pdflatex"))) stop("pdflatex est necessaire pour produire le PDF.", call. = FALSE)

  if (is.null(fichier)) fichier = .nom_fichier_examen(examen, corrige = corrige)
  fichier = sub("\\.pdf$", "", as.character(fichier), ignore.case = TRUE)
  fichier = paste0(fichier, ".pdf")
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  fichier = normalizePath(fichier, winslash = "/", mustWork = FALSE)

  travail = tempfile("eduschool-examen-")
  dir.create(travail, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(travail, recursive = TRUE, force = TRUE), add = TRUE)

  entree = file.path(travail, "examen_pdf.Rmd")
  file.copy(.template_examen_pdf(), entree, overwrite = TRUE)
  ressources = .produire_ressources_examen(examen, file.path(travail, "ressources"))

  rendu = rmarkdown::render(
    input = entree,
    output_format = rmarkdown::pdf_document(
      latex_engine = "pdflatex",
      keep_tex = FALSE
    ),
    output_file = basename(fichier),
    output_dir = dirname(fichier),
    params = list(
      examen = examen,
      ressources = as.list(ressources),
      corrige = isTRUE(corrige),
      logo = .logo_eduschool()
    ),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )

  rendu = normalizePath(rendu, winslash = "/", mustWork = TRUE)
  if (isTRUE(ouvrir)) utils::browseURL(rendu)
  invisible(rendu)
}

#' Produire le corrige d'un examen redige
#'
#' @inheritParams produire_examen
#' @return Invisiblement, le chemin absolu du PDF produit.
#' @export
produire_corrige_examen = function(examen, fichier = NULL, ouvrir = FALSE) {
  produire_examen(examen, fichier = fichier, corrige = TRUE, ouvrir = ouvrir)
}
