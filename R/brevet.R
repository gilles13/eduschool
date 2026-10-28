# Helpers internes de production du brevet.
construire_exercice_brevet = function(sujet, dossier) {
  if (!grepl("^[A-Z]+-[A-Z]+-[0-9]{3}$", sujet)) stop("Identifiant de brevet invalide : ", sujet, call. = FALSE)
  modele = sub("-[0-9]{3}$", "", sujet)
  chemin = system.file("brevet", "exercices", paste0(modele, ".R"), package = "eduschool")
  if (!nzchar(chemin)) stop("Sujet inconnu : ", sujet, call. = FALSE)
  fichiers = 
      c(
        system.file("graphiques", "_etiquettes.R", package = "eduschool"),
        system.file("graphiques", "triangle_rectangle.R", package = "eduschool"),
        system.file("graphiques", "tableau.R", package = "eduschool"),
        system.file("graphiques", "algo_scratch.R", package = "eduschool"),
        system.file("graphiques", "fonctions.R", package = "eduschool"),
        system.file("graphiques", "sac_boules.R", package = "eduschool"),
        system.file("graphiques", "cylindre.R", package = "eduschool"),
        system.file("graphiques", "rectangle.R", package = "eduschool")
      )
  if (any(!nzchar(fichiers))) stop("Fichiers eduschool introuvables : reinstaller le package", call. = FALSE)
  env = new.env(parent = asNamespace("eduschool"))
  for (f in fichiers) sys.source(f, envir = env)
  exercice = new.env(parent = env)
  sys.source(chemin, envir = exercice)
  exercice$construire_exercice(env, dossier, sujet)
}


assembler_brevet = function(exercices, mode, fmt, largeur_figure) {
  image = function(f) if (fmt == "html") sprintf('<p><img src="%s" style="width:%scm;max-width:100%%;"></p>', f, largeur_figure) else sprintf("\\begin{center}\n\\includegraphics[width=%scm]{%s}\n\\end{center}", largeur_figure, f)
  illustration = function(id) {
    famille = sub("-[0-9]{3}$", "", id)
    nom = switch(famille, "MIX-C" = "deplacements_college", "MIX-D" = "jetons_tournoi", "STAT-A" = "statistiques", "STAT-B" = "statistiques", NULL)
    if (is.null(nom)) return(NULL)
    fichier = system.file("brevet", "illustrations", paste0(nom, ".png"), package = "eduschool")
    if (!nzchar(fichier)) stop("Illustration introuvable : ", nom, call. = FALSE)
    if (fmt == "html") sprintf('<p><img src="%s" alt="Illustration du contexte" style="width:4cm;max-width:100%%;"></p>', fichier) else sprintf("\\begin{center}\n\\includegraphics[width=4cm]{%s}\n\\end{center}", fichier)
  }
  sujets = vapply(seq_along(exercices), function(i) {
    x = exercices[[i]]
    figure = if (!is.null(x$figure) && nzchar(x$figure)) image(x$figure) else NULL
    tableau = if (!is.null(x$tableau)) x$tableau else NULL
    paste(c(paste0("## Exercice ", i, if (!is.null(x$total_points)) paste0(" (", x$total_points, " points)") else ""), illustration(x$id), x$enonce, figure, tableau, x$questions), collapse = "\n\n")
  }, character(1))
  corriges = vapply(seq_along(exercices), function(i) {
    x = exercices[[i]]
    sub("^## Corrigé - Exercice 1", paste0("## Corrigé - Exercice ", i), x$correction)
  }, character(1))
  separation = if (fmt == "html") '<div style="break-before:page;page-break-before:always;"></div>' else "\\newpage"
  sujet = paste(sujets, collapse = "\n\n")
  corrige = paste(corriges, collapse = "\n\n")
  switch(mode, sujet = sujet, corrige = corrige, sujet_corrige = paste(sujet, separation, corrige, sep = "\n\n"))
}


rendre_brevet = function(exercices, sujets, format, format_auto, mode, dossier, largeur_figure) {
  modele = system.file("modeles", "divers.Rmd", package = "eduschool")
  if (!nzchar(modele)) stop("Modele divers.Rmd introuvable", call. = FALSE)
  capacites = read.csv(system.file("brevet", "brevet_capacites.csv", package = "eduschool"),
                       sep = ";", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
  mots = unlist(strsplit(capacites$capacites[match(sujets, capacites$sujet)], " | ", fixed = TRUE), use.names = FALSE)
  mots = unique(trimws(mots[!is.na(mots)]))
  titre = "Brevet - Mathématiques"
  # Sous-titre dans le contenu : aucun changement au modele commun.
  entete_capacites = if (length(mots)) paste0("*", paste(mots, collapse = " | "), "*") else ""
  generer = function(fmt) {
    contenu = assembler_brevet(exercices, mode, fmt, largeur_figure)
    if (nzchar(entete_capacites)) contenu = paste(entete_capacites, contenu, sep = "\n\n")
    rmarkdown::render(input = modele, output_format = paste0(fmt, "_document"), output_file = paste0(paste(sujets, collapse = "_"), "-", mode, ".", fmt), output_dir = dossier, params = list(titre = titre, contenu = contenu), envir = new.env(parent = globalenv()), quiet = TRUE)
  }
  sorties = character()
  for (fmt in format) {
    if (format_auto && fmt == "pdf") {
      chemin = tryCatch(generer("pdf"), error = function(e) {message("Compilation PDF impossible ; production HTML : ", conditionMessage(e)); generer("html")})
      sorties[if (grepl("\\.pdf$", chemin)) "pdf" else "html"] = chemin
    } else sorties[fmt] = generer(fmt)
  }
  sorties
}
ouvrir_brevet = function(fichiers) {
  if (!length(fichiers)) return(invisible(NULL))
  fichier = if ("pdf" %in% names(fichiers)) fichiers[["pdf"]] else fichiers[["html"]]
  if (nzchar(Sys.which("xdg-open"))) system2("xdg-open", shQuote(fichier), wait = FALSE) else utils::browseURL(fichier)
  invisible(NULL)
}
