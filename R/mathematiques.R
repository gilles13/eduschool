# Eduschool 2 : deux notions pilotes, sans dépendance au moteur historique.
.chemin_edu = function(...) {
  p = system.file(..., package = "eduschool")
  if (!nzchar(p)) stop("Ressource eduschool introuvable : ", paste(c(...), collapse = "/"))
  p
}

#' Lire les questions d'une notion pilote
#' @param notion "addition_fractions" ou "pythagore".
#' @export
questions = function(notion) {
  stopifnot(notion %in% c("addition_fractions", "pythagore"))
  jsonlite::fromJSON(.chemin_edu("notions", notion, "questions.json"),
                     simplifyVector = FALSE)
}

.calcul_edu = function(expression, moteur, valeurs) {
  expr = parse(text = expression)[[1L]]
  env = list2env(valeurs, parent = baseenv())
  if (identical(moteur, "R")) return(eval(expr, envir = env))
  if (!identical(moteur, "Ryacas")) stop("Moteur inconnu : ", moteur)
  remplacer = function(x) {
    if (is.symbol(x) && as.character(x) %in% names(valeurs))
      return(as.numeric(valeurs[[as.character(x)]]))
    if (is.call(x)) return(as.call(lapply(as.list(x), remplacer)))
    x
  }
  Ryacas::yac_str(paste0("Simplify(",
    paste(deparse(remplacer(expr)), collapse = ""), ")"))
}

#' Instancier une question (JSON local de confiance uniquement)
#' @param definition Élément de questions(notion)$questions.
#' @export
question = function(definition) {
  valeurs = list()
  if (length(definition$parametres)) {
    for (nom in names(definition$parametres)) {
      valeurs[[nom]] = .calcul_edu(definition$parametres[[nom]], "R", valeurs)
    }
  }
  enonce = definition$enonce
  for (nom in names(valeurs)) {
    enonce = gsub(paste0("{", nom, "}"), as.character(valeurs[[nom]]),
                  enonce, fixed = TRUE)
  }
  rep = definition$reponse
  bonne = if (identical(rep$mode, "editoriale")) rep$valeur else
    .calcul_edu(rep$expression, rep$moteur, valeurs)
  bonne = as.character(bonne)
  if (!is.null(rep$attendue) && !identical(bonne, rep$attendue)) {
    stop("Réponse inattendue pour ", definition$id, " : ", bonne,
         " (attendue : ", rep$attendue, ")")
  }
  propositions = unlist(definition$propositions, use.names = FALSE)
  if (length(definition$distracteurs$expressions)) {
    d = definition$distracteurs
    calculees = vapply(d$expressions, function(x) {
      as.character(.calcul_edu(x, d$moteur, valeurs))
    }, character(1))
    propositions = c(propositions, calculees)
  }
  # Une question ouverte conserve zéro proposition ; un QCM inclut la réponse.
  if (length(propositions)) {
    propositions = unique(c(bonne, propositions))
    propositions = propositions[nzchar(propositions)]
    if (length(propositions) < 2L) stop("QCM sans alternative : ", definition$id)
    propositions = sample(propositions)
  }
  list(id = definition$id, enonce = enonce, reponse = bonne,
       propositions = propositions, correction = definition$correction,
       illustration = definition$illustration, parametres = valeurs)
}

#' Dessiner le triangle des questions de Pythagore
#' @param q Question instanciée.
#' @export
illustrer_question = function(q) {
  if (is.null(q$illustration)) return(NULL)
  if (!q$illustration$id %in% c("triangle_angle_droit_A", "triangle_rectangle_A"))
    stop("Illustration inconnue")
  triangle = data.frame(x = c(0, 4, 0, 0), y = c(0, 0, 3, 0))
  ggplot2::ggplot(triangle, ggplot2::aes(x, y)) +
    ggplot2::geom_path(linewidth = .8) +
    ggplot2::geom_path(data = data.frame(x = c(0, .35, .35, 0),
                                        y = c(.35, .35, 0, 0)), linewidth = .5) +
    ggplot2::annotate("text", x = c(-.2, 4.2, -.2),
                      y = c(-.2, -.2, 3.2), label = c("A", "B", "C")) +
    ggplot2::coord_equal(xlim = c(-.4, 4.4), ylim = c(-.4, 3.5)) +
    ggplot2::theme_void()
}

#' Produire une fiche ou un quiz HTML/PDF
#' @param notion Notion pilote.
#' @param support "decouverte", "synthese", "revision" ou "quiz".
#' @param dossier Repertoire de destination.
#' @param format "html" ou "pdf".
#' @param variantes Nombre de tirages pre-calcules pour relancer un quiz HTML.
#' @param ouvrir Ouvrir le document genere (TRUE par defaut).
#' @export
produire = function(notion, support, dossier = getwd(), format = "html",
                    variantes = 5L, ouvrir = TRUE) {
  stopifnot(notion %in% c("addition_fractions", "pythagore"),
            support %in% c("decouverte", "synthese", "revision", "quiz"),
            format %in% c("html", "pdf"),
            length(variantes) == 1L, !is.na(variantes), variantes >= 1L)
  if (!dir.exists(dossier)) dir.create(dossier, recursive = TRUE)
  modele = .chemin_edu("modeles", if (support == "quiz") "quiz.Rmd" else "fiche.Rmd")
  sortie = if (format == "html") "html_document" else "pdf_document"
  fichier = rmarkdown::render(modele,
                    output_format = sortie,
                    params = list(notion = notion, support = support,
                                  variantes = as.integer(variantes)),
                    output_file = paste0(notion, "-", support, ".", format),
                    output_dir = normalizePath(dossier),
                    envir = new.env(parent = globalenv()), quiet = TRUE)
  if (isTRUE(ouvrir)) {
    if (identical(format, "pdf") && identical(Sys.info()[["sysname"]], "Linux")) {
      system2("xdg-open", shQuote(normalizePath(fichier)), wait = FALSE)
    } else {
      utils::browseURL(fichier)
    }
  }
  invisible(fichier)
}
