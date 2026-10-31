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
    sub("^## Corrig\u00e9 - Exercice 1", paste0("## Corrig\u00e9 - Exercice ", i), x$correction)
  }, character(1))
  automatique = startsWith(vapply(exercices, function(x) x$id, character(1)), "AUTO-")
  joindre = function(blocs, selection) paste(blocs[selection], collapse = "\n\n")
  list(
    partie1 = joindre(sujets, automatique),
    partie2 = joindre(sujets, !automatique),
    corrige1 = joindre(corriges, automatique),
    corrige2 = joindre(corriges, !automatique)
  )
}


rendre_brevet = function(exercices, sujets, format, format_auto, mode, dossier, largeur_figure) {
  modele = system.file("modeles", "brevet.Rmd", package = "eduschool")
  if (!nzchar(modele)) stop("Modele brevet.Rmd introuvable", call. = FALSE)
  titre = "Dipl\u00f4me national du brevet (version eduschool)"
  logo = system.file("assets", "logo-hexa.png", package = "eduschool")
  if (!nzchar(logo) || !file.exists(logo)) stop("Logo hexa introuvable", call. = FALSE)
  generer = function(fmt) {
    contenu = assembler_brevet(exercices, mode, fmt, largeur_figure)
    rmarkdown::render(input = modele, output_format = paste0(fmt, "_document"), output_file = paste0(paste(sujets, collapse = "_"), "-", mode, ".", fmt), output_dir = dossier, params = c(list(titre = titre, mode = mode, logo = logo), contenu), envir = new.env(parent = globalenv()), quiet = TRUE)
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
