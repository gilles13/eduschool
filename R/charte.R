# ============================================================
# Charte graphique eduschool
# ============================================================

.lire_charte_eduschool = function() {
  f = system.file("themes", "charte.csv", package = "eduschool")
  if (!nzchar(f) || !file.exists(f)) f = file.path("inst", "themes", "charte.csv")
  if (!file.exists(f)) stop("Charte graphique eduschool introuvable.", call. = FALSE)
  utils::read.csv2(f, stringsAsFactors = FALSE, check.names = FALSE)
}

#' Charte graphique eduschool
#'
#' Retourne les couleurs d'identite utilisees par les fiches et graphiques.
#'
#' @return Un data.frame de couleurs nommees.
#' @export
charte_eduschool = function() {
  .lire_charte_eduschool()
}

#' Couleur d'un cycle scolaire
#'
#' @param cycle_id Identifiant de cycle (`"C3"`, `"C4"`,
#'   `"CYCLE_TERMINAL"`) ou `"LYCEE"` pour la seconde.
#' @return Une couleur au format hexadecimal.
#' @export
couleur_cycle = function(cycle_id) {
  x = .lire_charte_eduschool()
  i = match(as.character(cycle_id), x$id)
  if (is.na(i)) i = match("NEUTRE", x$id)
  x$couleur[[i]]
}

.cycle_revision = function(niveau_id) {
  niveaux = .lire_csv("referentiels", "niveaux.csv")
  i = match(niveau_id, niveaux$niveau_id)
  cycle_id = if (is.na(i)) "" else niveaux$cycle_id[[i]]
  if (is.na(cycle_id) || !nzchar(cycle_id)) {
    if (niveau_id == "2GT") return("LYCEE")
    if (niveau_id %in% c("1G", "TG", "1T", "TT")) return("CYCLE_TERMINAL")
    return("NEUTRE")
  }
  cycle_id
}

.decoration_eduschool = function(id = "maths") {
  f = system.file("figures", "decorations", paste0(id, ".png"), package = "eduschool")
  if (!nzchar(f) || !file.exists(f)) {
    f = file.path("inst", "figures", "decorations", paste0(id, ".png"))
  }
  if (!file.exists(f)) return("")
  f
}

#' Identite visuelle d'une fiche de revision
#'
#' Construit les metadonnees stables affichees dans le bandeau des fiches.
#'
#' @param revision Objet `eduschool_revision`.
#' @return Une liste contenant cycle, classe, matiere, type de fiche et couleur.
#' @export
identite_revision = function(revision) {
  if (!inherits(revision, "eduschool_revision")) {
    stop("`revision` doit etre un objet eduschool_revision.", call. = FALSE)
  }
  cycle_id = .cycle_revision(revision$niveau_id)
  charte = .lire_charte_eduschool()
  i = match(cycle_id, charte$id)
  cycle = if (is.na(i)) "Scolarite" else charte$libelle[[i]]
  type = if (identical(revision$type, "ESSENTIEL")) "Fiche essentielle" else "Fiche de r\u00e9vision"
  list(
    cycle_id = cycle_id,
    cycle = cycle,
    classe = libelle_niveau(revision$niveau_id),
    matiere = "Math\u00e9matiques",
    type = type,
    titre = revision$titre,
    couleur = couleur_cycle(cycle_id),
    logo = .logo_eduschool(),
    decoration = .decoration_eduschool("maths")
  )
}

#' Theme ggplot2 eduschool
#'
#' Applique une mise en forme sobre et coherente avec les fiches. La fonction
#' retourne un objet theme ggplot2 et laisse les donnees et geometries libres.
#'
#' @param cycle_id Cycle dont la couleur sert d'accent.
#' @param base_size Taille de base du texte.
#' @return Un objet `theme` de ggplot2.
#' @export
theme_eduschool = function(cycle_id = "NEUTRE", base_size = 11) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Le package `ggplot2` est necessaire pour utiliser theme_eduschool().", call. = FALSE)
  }
  theme_minimal = getExportedValue("ggplot2", "theme_minimal")
  theme = getExportedValue("ggplot2", "theme")
  element_text = getExportedValue("ggplot2", "element_text")
  element_line = getExportedValue("ggplot2", "element_line")
  element_blank = getExportedValue("ggplot2", "element_blank")
  accent = couleur_cycle(cycle_id)
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", colour = accent, size = base_size * 1.25),
      plot.subtitle = element_text(colour = "#59636E"),
      axis.title = element_text(face = "bold", colour = "#27323C"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = "#E4E8EC", linewidth = 0.35),
      plot.caption = element_text(colour = "#6C757D", size = base_size * 0.8),
      legend.title = element_text(face = "bold")
    )
}


.police_manuelle_eduschool = function() {
  police = getOption("eduschool.police_manuelle", "cursive")
  police = as.character(police)[1L]
  if (is.na(police) || !nzchar(police)) "cursive" else police
}

.dessiner_note_manuelle = function(texte, rotation = 0, cex = 1.05) {
  if (length(texte) != 1L || is.na(texte) || !nzchar(texte)) {
    return(invisible(NULL))
  }
  grid::grid.newpage()
  grid::grid.text(
    texte,
    x = grid::unit(0.04, "npc"),
    y = grid::unit(0.55, "npc"),
    just = c("left", "center"),
    rot = rotation,
    gp = grid::gpar(
      fontfamily = .police_manuelle_eduschool(),
      fontsize = 12 * cex,
      col = "#405B6B"
    )
  )
  invisible(NULL)
}

.html_escape_fiche = function(x) {
  x = gsub("&", "&amp;", x, fixed = TRUE)
  x = gsub("<", "&lt;", x, fixed = TRUE)
  x = gsub(">", "&gt;", x, fixed = TRUE)
  gsub('"', "&quot;", x, fixed = TRUE)
}

.bandeau_revision_html = function(revision, logo_uri = "", decoration_uri = "") {
  x = identite_revision(revision)
  logo = if (nzchar(logo_uri)) paste0('<img src="', logo_uri, '" alt="Logo eduschool">') else ""
  decoration = if (nzchar(decoration_uri)) paste0('<img class="eduschool-decoration-img" src="', decoration_uri, '" alt="">') else ""
  paste0(
    '<div class="eduschool-header" style="--edu-accent:', x$couleur, '">',
    '<div class="eduschool-decoration">', decoration, '</div>',
    '<div class="eduschool-header-main"><div class="eduschool-kicker">',
    .html_escape_fiche(x$cycle), ' &nbsp;\u00b7&nbsp; ', .html_escape_fiche(x$classe),
    '</div><div class="eduschool-matiere">', .html_escape_fiche(x$matiere),
    '</div><div class="eduschool-type">', .html_escape_fiche(x$type),
    '</div><div class="eduschool-titre">', .html_escape_fiche(x$titre),
    '</div></div><div class="eduschool-logo">', logo, '</div></div>'
  )
}

.css_fiche_eduschool = function() {
  paste(
    "<style>",
    ".eduschool-header{display:flex;justify-content:space-between;align-items:flex-start;gap:1.5rem;border-left:8px solid var(--edu-accent);border-bottom:1px solid #dfe4e8;background:#f8fafb;padding:1.15rem 1.3rem;margin:0 0 1.8rem 0;border-radius:0 8px 8px 0}",
    ".eduschool-decoration{width:54px;flex:0 0 54px;align-self:center}",
    ".eduschool-decoration-img{width:54px;height:54px;object-fit:contain;display:block;border-radius:10px}",
    ".eduschool-header-main{min-width:0;flex:1}",
    ".eduschool-kicker{font-size:.82rem;font-weight:700;letter-spacing:.055em;text-transform:uppercase;color:var(--edu-accent);margin-bottom:.35rem}",
    ".eduschool-matiere{font-size:1.55rem;line-height:1.1;font-weight:750;color:#17212b}",
    ".eduschool-type{font-size:.82rem;font-weight:700;text-transform:uppercase;color:#59636e;margin-top:.55rem}",
    ".eduschool-titre{font-size:1.05rem;color:#27323c;margin-top:.12rem}",
    ".eduschool-logo img{width:120px;height:auto;display:block}",
    ".eduschool-bloc{border-left:4px solid var(--edu-accent);padding:.75rem 1rem;margin:1rem 0;background:#fbfcfd}",
    ".eduschool-bloc h2{margin-top:0;color:var(--edu-accent)}",
    "@media(max-width:600px){.eduschool-header{gap:.7rem}.eduschool-decoration{width:42px;flex-basis:42px}.eduschool-decoration-img{width:42px;height:42px}.eduschool-logo img{width:82px}.eduschool-matiere{font-size:1.3rem}}",
    "</style>", sep = "\n"
  )
}
