#' Lister les fiches de revision disponibles
#' @param niveau Niveau facultatif, par exemple "6E" ou "2GT".
#' @return Un data.frame avec niveau, fiche et fichier.
#' @export
fiches = function(niveau = NULL) {
  dossier = .chemin_eduschool("revision")
  fichiers = list.files(dossier, pattern = "\\.Rmd$", full.names = TRUE)
  noms = tools::file_path_sans_ext(basename(fichiers))
  niveaux = toupper(sub("-.*$", "", noms))
  x = data.frame(niveau = niveaux, fiche = sub("^[^-]+-", "", noms),
                 fichier = fichiers, stringsAsFactors = FALSE)
  if (!is.null(niveau)) x = x[x$niveau == toupper(niveau), , drop = FALSE]
  rownames(x) = NULL
  x
}

.banque_questions = function() {
  dossier = .chemin_eduschool("mathematiques", "exercices")
  fichiers = list.files(dossier, pattern = "\\.md$", full.names = TRUE)
  fichiers = fichiers[basename(fichiers) != "README.md"]

  banques = lapply(fichiers, function(fichier) {
    banque = tools::file_path_sans_ext(basename(fichier))
    x = parser_questions(fichier)

    lapply(x, function(q) {
      q$banque = banque
      q
    })
  })

  unlist(banques, recursive = FALSE)
}

.rattachements_questions = function() {
  fichier = .chemin_eduschool("mathematiques", "rattachements_questions.csv")
  x = read.csv(fichier, sep = ";", stringsAsFactors = FALSE, check.names = FALSE)
  x[x$statut == "exact" & nzchar(x$notion_id), , drop = FALSE]
}

#' Explorer la banque de questions
#'
#' Parse les banques Markdown et retourne les questions sous forme structuree.
#' Les filtres sont tous facultatifs.
#'
#' @param niveau Filtre facultatif sur le niveau scolaire.
#' @param theme Filtre facultatif sur le theme mathematique.
#' @param notion Filtre facultatif sur une notion du referentiel ou de la banque.
#' @param type Filtre facultatif sur le type de question.
#' @param banque Filtre facultatif sur le nom de banque.
#' @return Une liste contenant les filtres, un resume et les questions.
#' @export
questions = function(niveau = NULL, theme = NULL, notion = NULL,
                      type = NULL, banque = NULL) {
  x = .banque_questions()

  rattachements = .rattachements_questions()
  fichier_notions = .chemin_eduschool("mathematiques", "notions.csv")
  notions = read.csv(
    fichier_notions, sep = ";", stringsAsFactors = FALSE, check.names = FALSE
  )

  notion_id = setNames(rattachements$notion_id, rattachements$notion_banque)
  notion_libelle = setNames(notions$libelle, notions$notion_id)

  x = lapply(x, function(q) {
    q$notion_banque = q$notion

    id = unname(notion_id[q$notion_banque])
    if (!length(id) || is.na(id)) id = NA_character_

    libelle = unname(notion_libelle[id])
    if (!length(libelle) || is.na(libelle)) libelle = NA_character_

    q$notion_id = id
    q$notion = libelle
    q
  })

  referentiel = .donnees_choix()

  if (!is.null(niveau) || !is.null(theme)) {
    ref = referentiel
    if (!is.null(niveau)) ref = ref[ref$niveau %in% niveau, , drop = FALSE]
    if (!is.null(theme)) ref = ref[ref$theme %in% theme, , drop = FALSE]
    notions_valides = unique(ref$notion)

    x = Filter(
      function(q) !is.na(q$notion) && q$notion %in% notions_valides,
      x
    )
  }

  if (!is.null(notion)) {
    x = Filter(
      function(q) {
        q$notion_banque %in% notion ||
          (!is.na(q$notion) && q$notion %in% notion)
      },
      x
    )
  }

  if (!is.null(type)) {
    x = Filter(function(q) q$type %in% type, x)
  }

  if (!is.null(banque)) {
    x = Filter(function(q) q$banque %in% banque, x)
  }

  toutes = .banque_questions()
  notions_banque = unique(vapply(toutes, `[[`, character(1), "notion"))
  notions_rattachees = unique(rattachements$notion_banque)

  list(
    titre = "Questions",
    filtres = list(
      niveau = niveau,
      theme = theme,
      notion = notion,
      type = type,
      banque = banque
    ),
    resume = list(
      n = length(x),
      banques = sort(unique(vapply(x, `[[`, character(1), "banque"))),
      notions_banque = length(notions_banque),
      notions_rattachees = length(notions_rattachees),
      notions_a_rattacher = length(setdiff(notions_banque, notions_rattachees)),
      types = sort(unique(vapply(x, `[[`, character(1), "type")))
    ),
    donnees = x
  )
}

.evaluer_parametres_question = function(parametres) {
  valeurs = list()
  environnement = new.env(parent = baseenv())

  for (nom in names(parametres)) {
    valeur = eval(parse(text = parametres[[nom]]), envir = environnement)
    assign(nom, valeur, envir = environnement)
    valeurs[[nom]] = valeur
  }

  valeurs
}

.remplir_enonce_question = function(enonce, valeurs) {
  positions = gregexpr(
    "\\{[A-Za-z_][A-Za-z0-9_]*\\}",
    enonce,
    perl = TRUE
  )[[1L]]

  if (identical(positions, -1L)) return(enonce)

  marqueurs = regmatches(enonce, list(positions))[[1L]]
  noms = unique(substring(
    marqueurs,
    first = 2L,
    last = nchar(marqueurs) - 1L
  ))

  inconnus = setdiff(noms, names(valeurs))
  if (length(inconnus)) {
    stop(
      "Parametre d'enonce inconnu : ",
      paste(inconnus, collapse = ", "),
      call. = FALSE
    )
  }

  for (nom in noms) {
    valeur = valeurs[[nom]]
    if (length(valeur) != 1L) {
      stop(
        "Le parametre d'enonce '", nom, "' doit contenir une seule valeur.",
        call. = FALSE
      )
    }

    enonce = gsub(
      paste0("{", nom, "}"),
      as.character(valeur),
      enonce,
      fixed = TRUE
    )
  }

  enonce
}

.expression_ryacas = function(calcul, valeurs) {
  expression = parse(text = calcul)[[1L]]

  remplacer = function(x) {
    if (is.integer(x)) return(as.numeric(x))
    if (is.symbol(x)) {
      nom = as.character(x)
      if (nom %in% names(valeurs)) {
          valeur = valeurs[[nom]]
          if (is.integer(valeur)) valeur = as.numeric(valeur)
          return(valeur)
      }
      return(x)
    }
    if (is.call(x)) {
      return(as.call(lapply(as.list(x), remplacer)))
    }
    x
  }

  paste(deparse(remplacer(expression)), collapse = "")
}

.calculer_reponse_question = function(calcul, moteur, valeurs) {
  if (is.na(calcul) || !nzchar(calcul)) return(NULL)

  if (identical(moteur, "Ryacas")) {
    expression = .expression_ryacas(calcul, valeurs)
    return(Ryacas::yac_str(paste0("Simplify(", expression, ")")))
  }

  environnement = list2env(valeurs, parent = baseenv())
  eval(parse(text = calcul), envir = environnement)
}

.calculer_propositions_question = function(reponse, distracteurs, moteur, valeurs) {
  if (!length(distracteurs)) return(as.character(reponse))

  fausses = vapply(
    distracteurs,
    function(calcul) {
      as.character(.calculer_reponse_question(calcul, moteur, valeurs))
    },
    character(1)
  )

  propositions = unique(c(as.character(reponse), fausses))
  propositions = propositions[nzchar(propositions)]
  sample(propositions)
}

#' Tirer une formulation de question
#'
#' @param niveau Filtre facultatif sur le niveau scolaire.
#' @param theme Filtre facultatif sur le theme mathematique.
#' @param notion Filtre facultatif.
#' @param type Filtre facultatif.
#' @param banque Filtre facultatif.
#' @return Une question structuree.
#' @export
question = function(niveau = NULL, theme = NULL, notion = NULL,
                     type = NULL, banque = NULL) {
  x = questions(
    niveau = niveau,
    theme = theme,
    notion = notion,
    type = type,
    banque = banque
  )$donnees

  if (!length(x)) {
    stop("Aucune question disponible pour ce choix.", call. = FALSE)
  }

  q = x[[sample.int(length(x), 1L)]]

  if (!length(q$parametres)) {
    q$enonce = q$question
    return(q)
  }

  valeurs = .evaluer_parametres_question(q$parametres)
  q$enonce = .remplir_enonce_question(q$question, valeurs)
  q$parametres = valeurs
  q$reponse = .calculer_reponse_question(q$calcul, q$moteur, valeurs)

  if (is.logical(q$reponse) && length(q$reponse) == 1L && !is.na(q$reponse)) {
    q$reponse = if (q$reponse) "Oui" else "Non"
    q$propositions = sample(c("Oui", "Non"))
    return(q)
  }

  if (identical(q$notion_banque, "Comparer des fractions")) {
    signes = c("-1" = "<", "0" = "=", "1" = ">")
    q$reponse = unname(signes[as.character(q$reponse)])
    q$propositions = sample(c("<", "=", ">"))
    return(q)
  }

  if (identical(q$notion_banque, "Encadrer une fraction")) {
    bornes = as.integer(q$reponse)
    q$reponse = paste0(bornes[[1L]], " < ", valeurs$fraction, " < ", bornes[[2L]])
    q$propositions = sample(c(
      q$reponse,
      paste0(bornes[[1L]] - 1L, " < ", valeurs$fraction, " < ", bornes[[1L]]),
      paste0(bornes[[2L]], " < ", valeurs$fraction, " < ", bornes[[2L]] + 1L)
    ))
    return(q)
  }

  if (identical(q$banque, "decimaux") && length(q$reponse) == 2L) {
    bornes = q$reponse
    pas = valeurs$pas
    q$reponse = paste0(bornes[[1L]], " < ", valeurs$x, " < ", bornes[[2L]])
    q$propositions = sample(c(
      q$reponse,
      paste0(bornes[[1L]] - pas, " < ", valeurs$x, " < ", bornes[[1L]]),
      paste0(bornes[[2L]], " < ", valeurs$x, " < ", bornes[[2L]] + pas)
    ))
    return(q)
  }

  q$propositions = .calculer_propositions_question(
    q$reponse, q$distracteurs, q$moteur, valeurs
  )
  q
}

#' Tirer un quiz dans la banque de questions
#'
#' @param n Nombre de questions.
#' @param niveau Filtre facultatif sur le niveau scolaire.
#' @param theme Filtre facultatif sur le theme mathematique.
#' @param notion Filtre facultatif.
#' @param type Filtre facultatif.
#' @param banque Filtre facultatif.
#' @return Une liste de questions structurees.
#' @export
quiz = function(n = 5L, niveau = NULL, theme = NULL, notion = NULL,
                 type = NULL, banque = NULL) {
  if (length(n) != 1L || is.na(n) || n < 1L || n != as.integer(n)) {
    stop("n doit etre un entier strictement positif.", call. = FALSE)
  }

  lapply(seq_len(as.integer(n)), function(i) {
    question(
      niveau = niveau,
      theme = theme,
      notion = notion,
      type = type,
      banque = banque
    )
  })
}
