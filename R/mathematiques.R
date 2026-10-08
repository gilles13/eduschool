# Eduschool 2 : deux notions pilotes, sans dependance au moteur historique.
.chemin_edu = function(...) {
  p = system.file(..., package = "eduschool")
  if (!nzchar(p)) stop("Ressource eduschool introuvable : ", paste(c(...), collapse = "/"))
  p
}

# Read explicit family memberships; an empty vector means a simple notion.
.libelle_notion_ou_famille = function(identifiant) {
  fichier = .chemin_edu("referentiels", "editorial_familles_notions.csv")
  ref = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  familles = unique(ref[ref$famille == identifiant & nzchar(ref$famille),
    c("famille", "libelle_famille"), drop = FALSE])
  if (nrow(familles)) {
    libelles = unique(familles$libelle_famille[nzchar(familles$libelle_famille)])
    if (length(libelles) != 1L)
      stop("Libelle de famille manquant ou incoherent : ", identifiant)
    return(libelles[[1L]])
  }
  notions = unique(ref[ref$notion == identifiant,
    c("notion", "libelle_notion"), drop = FALSE])
  libelles = unique(notions$libelle_notion[nzchar(notions$libelle_notion)])
  if (length(libelles) != 1L)
    stop("Libelle de notion manquant ou incoherent : ", identifiant)
  libelles[[1L]]
}

.notions_famille = function(famille, niveau = "") {
  fichier = .chemin_edu("referentiels", "editorial_familles_notions.csv")
  liens = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  liens = liens[liens$famille == famille, , drop = FALSE]
  if (nzchar(niveau) && nrow(liens)) {
    ordre = c("CP", "CE1", "CE2", "CM1", "CM2", "6E", "5E", "4E", "3E",
              "2GT", "1G", "TG")
    cible = match(niveau, ordre)
    if (is.na(cible)) stop("Niveau inconnu : ", niveau)
    introduction = match(liens$niveau, ordre)
    # An unknown introduction level is never silently included in a
    # level-specific quiz.
    liens = liens[!is.na(introduction) & introduction <= cible, , drop = FALSE]
  }
  unique(liens$notion)
}

.niveau_notion_ou_famille = function(identifiant) {
  fichier = .chemin_edu("referentiels", "editorial_familles_notions.csv")
  ref = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  lignes = ref[ref$famille == identifiant, , drop = FALSE]
  if (!nrow(lignes)) lignes = ref[ref$notion == identifiant, , drop = FALSE]
  niveaux = unique(lignes$niveau[nzchar(lignes$niveau)])
  if (!length(niveaux)) return("")
  ordre = c("CP", "CE1", "CE2", "CM1", "CM2", "6E", "5E", "4E", "3E",
            "2GT", "1G", "TG")
  positions = match(niveaux, ordre)
  if (anyNA(positions)) return(paste(niveaux, collapse = " a "))
  niveaux = niveaux[order(positions)]
  if (length(niveaux) == 1L) niveaux[[1L]] else
    paste(niveaux[[1L]], "a", niveaux[[length(niveaux)]])
}

#' Reperer les notions et familles disponibles
#'
#' Les identifiants retournes peuvent etre passes a `produire(notion = ...)`.
#' Le catalogue est construit depuis les ressources du package, sans liste
#' de notions codee en dur.
#' @return Un data.frame : type, identifiant, libelle, famille, niveau.
#' @export
notions = function() {
  fichier = .chemin_edu("referentiels", "editorial_familles_notions.csv")
  liens = utils::read.csv(fichier, sep = ";", stringsAsFactors = FALSE)
  dossiers = list.dirs(.chemin_edu("notions"), recursive = FALSE, full.names = FALSE)
  liens = liens[liens$notion %in% dossiers, , drop = FALSE]
  membres = unique(liens[, c("notion", "libelle_notion", "famille", "niveau")])
  names(membres) = c("identifiant", "libelle", "famille", "niveau")
  absents = setdiff(dossiers, membres$identifiant)
  if (length(absents))
    stop("Notions absentes de editorial_familles_notions.csv : ", paste(absents, collapse = ", "))
  membres$type = "notion"
  familles = unique(liens[nzchar(liens$famille), c("famille", "libelle_famille")])
  if (any(!nzchar(familles$libelle_famille)) || any(duplicated(familles$famille)))
    stop("Libelles de familles manquants ou incoherents dans editorial_familles_notions.csv")
  groupes = data.frame(type = "famille", identifiant = familles$famille,
    libelle = familles$libelle_famille, famille = "", niveau = "")
  resultat = rbind(membres[, names(groupes)], groupes)
  rownames(resultat) = NULL
  resultat[order(resultat$type, resultat$identifiant), , drop = FALSE]
}

#' Lire les questions d'une notion pilote
#' @param notion Identifiant d'une notion ou d'une famille.
#' @param niveau Niveau scolaire facultatif pour filtrer les notions d'une famille.
#' @export
questions = function(notion, niveau = "") {
  stopifnot(length(notion) == 1L, is.character(notion),
            grepl("^[a-z][a-z0-9_]*$", notion))
  membres = .notions_famille(notion, niveau = niveau)
  if (length(membres)) {
    banques = lapply(membres, questions)
    return(list(notion_id = notion,
      questions = unlist(lapply(banques, `[[`, "questions"), recursive = FALSE)))
  }
  if (nzchar(niveau) && length(.notions_famille(notion)))
    stop("Aucune notion disponible pour ce niveau : ", niveau)
  banque = jsonlite::fromJSON(.chemin_edu("notions", notion, "questions.json"),
                              simplifyVector = FALSE)
  niveau_notion = .niveau_notion_ou_famille(notion)
  banque$questions = lapply(banque$questions, function(definition) {
    definition$niveau = niveau_notion
    definition
  })
  banque
}

.remplacer_parametres_edu = function(x, valeurs) {
  if (is.character(x)) {
    for (nom in names(valeurs))
      x = gsub(paste0("[[", nom, "]]"), as.character(valeurs[[nom]]),
               x, fixed = TRUE)
    return(x)
  }
  if (is.list(x)) {
    noms = names(x)
    x = lapply(x, .remplacer_parametres_edu, valeurs = valeurs)
    if (!is.null(noms)) names(x) = .remplacer_parametres_edu(noms, valeurs)
  }
  x
}

.instancier_variante_edu = function(definition) {
  if (!length(definition$variantes))
    return(list(definition = definition, parametres = list(), progression = NULL))
  variantes = definition$variantes
  variante = variantes[[sample.int(length(variantes), 1L)]]
  valeurs = variante$parametres
  progression = variante$progression
  definition$variantes = NULL
  definition = .remplacer_parametres_edu(definition, valeurs)
  list(definition = definition, parametres = valeurs, progression = progression)
}

#' Instancier une question finie
#' @param definition Element de questions(notion)$questions.
#' @export
question = function(definition) {
  instance = .instancier_variante_edu(definition)
  definition = instance$definition
  bonne = as.character(definition$reponse)
  propositions = unlist(definition$propositions, use.names = FALSE)
  if (length(bonne) != 1L || is.na(bonne) || !nzchar(bonne))
    stop("Reponse absente : ", definition$id)
  if (length(propositions) < 2L || anyNA(propositions) || any(!nzchar(propositions)))
    stop("QCM sans alternatives : ", definition$id)
  if (anyDuplicated(propositions))
    stop("Propositions dupliquees : ", definition$id)
  if (sum(propositions == bonne) != 1L)
    stop("Reponse absente ou multiple : ", definition$id)
  if (!is.null(definition$presentation$masques)) {
    masques = unlist(definition$presentation$masques, use.names = TRUE)
    if (!all(propositions %in% names(masques)) ||
        anyDuplicated(unname(masques[propositions])))
      stop("Masques manquants ou visuellement identiques : ", definition$id)
  }
  correction = definition$correction
  if (!is.character(correction) || length(correction) != 1L ||
      is.na(correction) || !nzchar(trimws(correction)))
    stop("Correction absente : ", definition$id)
  list(id = definition$id, enonce = definition$enonce, reponse = bonne,
       propositions = sample(propositions), correction = correction,
       illustration = definition$illustration, parametres = instance$parametres,
       progression = instance$progression, presentation = definition$presentation,
       humour = definition$humour, apart_humour = definition$apart_humour,
       niveau = definition$niveau)
}

.tirer_questions_quiz_edu = function(definitions, n = NULL, tirages = 1L,
                                      melanger = FALSE, humour_ratio = 0) {
  if (!is.list(definitions) || !length(definitions))
    stop("Banque de questions vide")
  if (is.null(n)) n = length(definitions)
  stopifnot(length(n) == 1L, is.numeric(n), is.finite(n), n >= 1L,
            n == as.integer(n), length(tirages) == 1L, is.numeric(tirages),
            is.finite(tirages), tirages >= 1L, tirages == as.integer(tirages),
            length(melanger) == 1L, is.logical(melanger), !is.na(melanger))
  indices = lapply(seq_len(tirages), function(i) {
    if (n >= length(definitions)) {
      resultat = seq_along(definitions)
      if (n > length(definitions)) {
        variables = which(vapply(definitions, function(x) length(x$variantes) > 0L,
                                 logical(1)))
        supplement = n - length(definitions)
        if (length(variables)) {
          capacites = pmax(0L, vapply(definitions[variables], function(x)
            length(x$variantes) - 1L, integer(1)))
          candidats = rep(variables, capacites)
        } else {
          candidats = integer()
        }
        if (supplement > length(candidats))
          stop("Pas assez de questions distinctes pour ce quiz")
        supplementaires = if (supplement)
          sample(candidats, supplement, replace = FALSE) else integer()
        resultat = c(resultat, supplementaires)
      }
      if (melanger) resultat = sample(resultat)
      return(resultat)
    }
    sample.int(length(definitions), size = n, replace = FALSE)
  })
  occurrences = unlist(indices, use.names = FALSE)
  choix_variantes = vector("list", length(definitions))
  for (i in unique(occurrences)) {
    nombre = sum(occurrences == i)
    variantes = definitions[[i]]$variantes
    if (!length(variantes)) next
    disponibles = seq_along(variantes)
    choix = integer()
    while (length(choix) < nombre) choix = c(choix, sample(disponibles))
    choix_variantes[[i]] = choix[seq_len(nombre)]
  }
  compteurs = integer(length(definitions))
  lapply(indices, function(selection) {
    definitions_tirage = lapply(selection, function(i) {
      definition = definitions[[i]]
      if (length(definition$variantes)) {
        compteurs[[i]] <<- compteurs[[i]] + 1L
        j = choix_variantes[[i]][[compteurs[[i]]]]
        definition$variantes = definition$variantes[j]
      }
      definition
    })
    .humour_edu(lapply(definitions_tirage, question), humour_ratio)
  })
}

# Select a controlled number of eligible jokes without changing the corrections.
.humour_edu = function(tirage, ratio) {
  textes_humour = lapply(tirage, function(q) {
    textes = unlist(q$humour, use.names = FALSE)
    textes = textes[!is.na(textes) & nzchar(textes)]
    as.character(textes)
  })
  disponibles = which(lengths(textes_humour) > 0L)
  nombre = min(length(disponibles), floor(length(tirage) * ratio + 0.5))
  if (nombre > 0L) {
    indices = disponibles[sample.int(length(disponibles), nombre)]
    for (i in indices) {
      tirage[[i]]$apart_humour = sample(textes_humour[[i]], 1L)
    }
  }
  tirage
}

#' Dessiner une illustration de question
#' @param q Question instanciee.
#' @export
illustrer_question = function(q) {
  if (is.null(q$illustration)) return(NULL)
  illustration = q$illustration
  # No dynamic illustration parameters in fixed questions.
  if (any(vapply(illustration, function(x) is.character(x) &&
                 length(x) == 1L && startsWith(x, "{"), logical(1))))
    stop("Illustration non figee : ", q$id)
  graphique(illustration$id, illustration = illustration)
}

#' Dessiner un graphique pedagogique reutilisable
#' @importFrom ggplot2 ggplot
#' @importFrom ggsketch geom_sketch_segment
#' @param id Identifiant unique du graphique.
#' @param ... Parametres de la fonction graphique.
#' @export
graphique = function(id, ...) {
  stopifnot(length(id) == 1L, is.character(id),
            grepl("^[a-z][A-Za-z0-9_]*$", id))
  fichier = .chemin_edu("graphiques", paste0(id, ".R"))
  environnement = new.env(parent = environment())
  auxiliaire = .chemin_edu("graphiques", "_etiquettes.R")
  if (file.exists(auxiliaire)) source(auxiliaire, local = environnement)
  source(fichier, local = environnement)
  fonction = paste0("graphique_", id)
  if (!exists(fonction, envir = environnement, inherits = FALSE))
    stop("Fonction graphique absente : ", fonction)
  environnement[[fonction]](...)
}

# Convert simple editorial markers into ordinary Markdown images.
# The only accepted arguments are named numeric scalars; no code is evaluated.
.illustrations_fiche = function(lignes, notion = NULL) {
  images = grep("<!-- image:", lignes, fixed = TRUE)
  for (i in images) {
    ligne = trimws(lignes[[i]])
    if (!grepl("^<!-- image: [a-zA-Z0-9_-]+[.]png -->$", ligne))
      stop("Declaration image invalide : ", ligne)
    if (is.null(notion) || !grepl("^[a-z][a-z0-9_]*$", notion))
      stop("Notion absente pour une image")
    nom = sub("^<!-- image: (.*) -->$", "\\1", ligne)
    chemin = .chemin_edu("notions", notion, "assets", nom)
    if (!file.exists(chemin)) stop("Image introuvable : ", chemin)
    lignes[[i]] = paste0("![](", chemin, "){width=55%}")
  }
  motif = "^<!-- graphique: ([a-z][A-Za-z0-9_]*)([[:space:]]+[^<>]*)? -->$"
  indices = grep("<!-- graphique:", lignes, fixed = TRUE)
  for (i in indices) {
    ligne = trimws(lignes[[i]])
    if (!grepl(motif, ligne)) stop("Declaration graphique invalide : ", ligne)
    elements = strsplit(gsub("^<!-- graphique: | -->$", "", ligne),
                        "[[:space:]]+")[[1L]]
    id = elements[[1L]]
    arguments = list()
    for (element in elements[-1L]) {
      if (!grepl("^[a-z][A-Za-z0-9_]*=-?[0-9]+([.][0-9]+)?$", element))
        stop("Parametre graphique invalide : ", element)
      paire = strsplit(element, "=", fixed = TRUE)[[1L]]
      if (paire[[1L]] %in% names(arguments))
        stop("Parametre graphique repete : ", paire[[1L]])
      arguments[[paire[[1L]]]] = as.numeric(paire[[2L]])
    }
    figure = do.call(graphique, c(list(id = id), arguments))
    chemin = tempfile(pattern = paste0("eduschool-", id, "-"), fileext = ".png")
    dimensions = attr(figure, "eduschool_dimensions")
    if (is.null(dimensions)) dimensions = c(4.6, 2.8)
    ggplot2::ggsave(chemin, plot = figure, width = dimensions[[1L]],
                    height = dimensions[[2L]], units = "in", dpi = 150)
    largeur = attr(figure, "eduschool_display_width")
    if (is.null(largeur)) largeur = "65%"
    lignes[[i]] = paste0("![](", chemin, "){width=", largeur, "}")
  }
  lignes
}

#' Produire une fiche ou un quiz HTML/PDF
#' @param notion Notion simple ou famille definie dans editorial_familles_notions.csv.
#' @param support "decouverte", "synthese", "quiz" ou "tous".
#' @param dossier Repertoire de destination ; NULL cree un fichier temporaire.
#' @param format "html" ou "pdf".
#' @param variantes Ancien nom de tirages (conserve pour compatibilite).
#' @param n Nombre de questions par quiz ; NULL utilise toute la banque.
#' @param tirages Nombre de quiz pre-calcules pour le HTML ; NULL reprend variantes.
#' @param ouvrir Ouvrir le document genere (TRUE par defaut).
#' @param niveau Niveau scolaire facultatif.
#' @param humour_ratio Proportion cible de questions avec humour, entre 0 et 1.
#' @param seed Graine facultative pour reproduire les tirages et l'humour.
#' @details support = "tous" produit les supports disponibles dans un meme dossier.
#' Pour une famille, les fiches rassemblent les Markdown des membres
#' dans l'ordre du referentiel ; le quiz utilise leurs banques JSON.
#' @export
produire = function(notion, support = "tous", dossier = NULL, format = "html",
                    variantes = 20L, ouvrir = TRUE, niveau = "", n = NULL, tirages = NULL,
                    humour_ratio = 0.2, seed = NULL) {
  stopifnot(length(notion) == 1L, is.character(notion),
            grepl("^[a-z][a-z0-9_]*$", notion),
            length(support) == 1L, support %in% c("decouverte", "synthese", "quiz", "tous"),
            format %in% c("html", "pdf"),
            length(variantes) == 1L, !is.na(variantes), variantes >= 1L)
  if (!is.null(n)) stopifnot(length(n) == 1L, is.numeric(n),
                             is.finite(n), n >= 1L, n == as.integer(n))
  if (!is.null(tirages)) stopifnot(length(tirages) == 1L, is.numeric(tirages),
                                   is.finite(tirages), tirages >= 1L,
                                   tirages == as.integer(tirages))
  stopifnot(length(humour_ratio) == 1L, is.numeric(humour_ratio),
            is.finite(humour_ratio), humour_ratio >= 0, humour_ratio <= 1)
  if (!is.null(seed)) stopifnot(length(seed) == 1L, is.numeric(seed),
                                is.finite(seed), seed == as.integer(seed))
  if (identical(humour_ratio, 0))
    message("humour_ratio = 0 : les maths sans humour ? C'est votre choix !")
  if (is.null(tirages)) tirages = variantes
  membres_tous = .notions_famille(notion)
  membres = .notions_famille(notion, niveau = niveau)
  if (length(membres_tous) && !length(membres))
    stop("Aucune notion disponible pour ce niveau : ", niveau)
  if (identical(support, "tous")) {
    temporaire = is.null(dossier)
    if (temporaire) dossier = tempfile(pattern = paste0("eduschool-", notion, "-"))
    if (!dir.exists(dossier)) dir.create(dossier, recursive = TRUE)
    if (!dir.exists(dossier)) stop("Dossier de sortie inaccessible : ", dossier)
    dossier = normalizePath(dossier)
    supports = c("decouverte", "synthese", "quiz")
    disponibles = vapply(supports, function(s) {
      ressource = if (identical(s, "quiz")) "questions.json" else paste0(s, ".md")
      if (length(membres)) {
        return(any(vapply(membres, function(m)
          nzchar(system.file("notions", m, ressource, package = "eduschool")),
          logical(1))))
      }
      nzchar(system.file("notions", notion, ressource, package = "eduschool"))
    }, logical(1))
    if (!any(disponibles)) stop("Aucun support disponible pour : ", notion)
    if (any(!disponibles))
      message("Supports absents : ", paste(supports[!disponibles], collapse = ", "))
    fichiers = vapply(supports[disponibles], function(s) {
      suppressMessages(produire(notion = notion, support = s, dossier = dossier,
        format = format, variantes = variantes, ouvrir = FALSE,
        niveau = niveau, n = n, tirages = tirages,
        humour_ratio = humour_ratio, seed = seed))
    }, character(1))
    if (isTRUE(ouvrir)) {
      for (fichier in unname(fichiers)) {
        if (identical(format, "pdf") && identical(Sys.info()[["sysname"]], "Linux")) {
          system2("xdg-open", shQuote(fichier), wait = FALSE)
        } else {
          utils::browseURL(fichier)
        }
      }
    }
    message(length(fichiers), " document(s) g\u00e9n\u00e9r\u00e9(s).\nR\u00e9pertoire : ", dossier,
            if (temporaire) " (temporaire : pr\u00e9ciser dossier pour conserver les fichiers)" else "")
    return(invisible(fichiers))
  }
  if (length(membres) && !identical(support, "quiz") &&
      !any(vapply(membres, function(m)
        nzchar(system.file("notions", m, paste0(support, ".md"),
                           package = "eduschool")), logical(1))))
    stop("Aucun support ", support, " disponible pour : ", notion)
  temporaire = is.null(dossier)
  if (temporaire) dossier = tempdir()
  if (!dir.exists(dossier)) dir.create(dossier, recursive = TRUE)
  if (!dir.exists(dossier)) stop("Dossier de sortie inaccessible : ", dossier)
  modele = .chemin_edu("modeles", if (support == "quiz") "quiz.Rmd" else "fiche.Rmd")
  sortie = if (format == "html") "html_document" else "pdf_document"
  fichier = rmarkdown::render(modele,
                    output_format = sortie,
                    params = list(notion = notion, support = support,
                                  tirages = as.integer(tirages), n = if (is.null(n)) NULL else as.integer(n),
                                  niveau = niveau, humour_ratio = humour_ratio, seed = seed),
                    output_file = if (temporaire) basename(tempfile(
                      pattern = paste0(notion, "-", support, "-"),
                      tmpdir = dossier, fileext = paste0(".", format)))
                    else paste0(notion, "-", support, ".", format),
                    output_dir = normalizePath(dossier),
                    envir = new.env(parent = globalenv()), quiet = TRUE)
  if (isTRUE(ouvrir)) {
    if (identical(format, "pdf") && identical(Sys.info()[["sysname"]], "Linux")) {
      system2("xdg-open", shQuote(normalizePath(fichier)), wait = FALSE)
    } else {
      utils::browseURL(fichier)
    }
  }
  message("Fichier g\u00e9n\u00e9r\u00e9 : ", normalizePath(fichier),
          if (temporaire) " (temporaire : pr\u00e9ciser dossier pour le conserver)" else "")
  invisible(normalizePath(fichier))
}
