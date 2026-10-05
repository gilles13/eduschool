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
  jsonlite::fromJSON(.chemin_edu("notions", notion, "questions.json"),
                     simplifyVector = FALSE)
}

# Mathematical display is delegated to Yacas: Hold preserves the source expression.
.math_tex_edu = function(expression) {
  if (!is.character(expression) || length(expression) != 1L ||
      is.na(expression) || !nzchar(expression) ||
      !grepl("^[A-Za-z0-9_+*/^(). <>=-]+$", expression))
    stop("Expression mathematique invalide")
  resultat = Ryacas::yac_str(paste0("TeXForm(Hold(", expression, "))"))
  if (length(resultat) != 1L || is.na(resultat) || !nzchar(trimws(resultat)))
    stop("Ryacas n'a pas produit de TeX")
  trimws(resultat)
}

.math_inline_edu = function(expression) paste0("\\(", .math_tex_edu(expression), "\\)")

# Fixed arithmetic only: the same two literals produce the question and answer.
.calcul_fixe_edu = function(calcul) {
  operations = c("addition", "soustraction", "multiplication", "division",
                 "hypotenuse", "proportion", "reste", "angle")
  if (!is.list(calcul) || !identical(calcul$moteur, "Ryacas") ||
      !calcul$operation %in% operations) stop("Calcul fixe invalide")
  termes = unlist(calcul$termes, use.names = FALSE)
  if (length(termes) != 2L || !is.character(termes))
    stop("Deux termes fixes requis")
  # The input language is limited to integer and rational literals.
  litteral = function(x) {
    morceaux = strsplit(x, "/", fixed = TRUE)[[1L]]
    if (length(morceaux) > 2L || any(!grepl("^[0-9]+$", morceaux)))
      return(FALSE)
    length(morceaux) == 1L || as.numeric(morceaux[[2L]]) > 0
  }
  if (!all(vapply(termes, litteral, logical(1))))
    stop("Operandes fixes invalides")
  x = paste0("(", termes[[1L]], ")")
  y = paste0("(", termes[[2L]], ")")
  expr = switch(calcul$operation,
    addition = paste0(x, "+", y),
    soustraction = paste0(x, "-", y),
    multiplication = paste0(x, "*", y),
    division = paste0(x, "/", y),
    proportion = paste0(x, "*", y),
    reste = paste0(x, "*(1-", y, ")"),
    angle = paste0("180-", x, "-", y),
    hypotenuse = paste0("Sqrt(", x, "^2+", y, "^2)"))
  resultat = Ryacas::yac_str(paste0("Simplify(", expr, ")"))
  if (length(resultat) != 1L || is.na(resultat) || !nzchar(resultat))
    stop("Ryacas n'a pas produit de resultat")
  # Decimal presentation is restricted to rational Ryacas results.
  nombre = function(texte) {
    if (!grepl("^[0-9]+(/[0-9]+)?$", texte))
      stop("Resultat Ryacas non rationnel pour ce format : ", texte)
    morceaux = strsplit(texte, "/", fixed = TRUE)[[1L]]
    as.numeric(morceaux[[1L]]) /
      if (length(morceaux) == 2L) as.numeric(morceaux[[2L]]) else 1
  }
  fmt = if (is.null(calcul$format)) "fraction" else calcul$format
  unite = if (is.null(calcul$unite)) "" else calcul$unite
  if (fmt %in% c("integer", "decimal", "h_min")) {
    valeur = nombre(resultat)
    if (identical(fmt, "integer") && valeur != trunc(valeur))
      stop("Resultat non entier")
    if (identical(fmt, "h_min")) {
      if (valeur != trunc(valeur)) stop("Duree non entiere")
      resultat = paste0(valeur %/% 60, " h ", valeur %% 60, " min")
    } else {
      resultat = format(valeur, scientific = FALSE, trim = TRUE,
                        big.mark = " ", decimal.mark = ",")
    }
  }
  if (nzchar(unite)) resultat = if (identical(unite, "\u00B0")) paste0(resultat, unite) else paste(resultat, unite)
  quantite = NULL
  if (!is.null(calcul$source_format)) {
    if (!calcul$source_format %in% c("decimal", "h_min"))
      stop("Format source interdit")
    val = nombre(termes[[1L]])
    if (identical(calcul$source_format, "h_min")) {
      if (val != trunc(val)) stop("Duree source non entiere")
      quantite = paste0(val %/% 60, " h ", val %% 60, " min")
    } else {
      quantite = format(val, scientific = FALSE, trim = TRUE,
                        big.mark = " ", decimal.mark = ",")
    }
  }
  list(termes = termes, reponse = resultat, quantite = quantite)
}

.calculer_parametres_yacas_edu = function(calculs, valeurs, id) {
  if (is.null(calculs)) return(list(valeurs = valeurs, affichages = list()))
  if (!is.list(calculs) || !length(calculs) || is.null(names(calculs)) ||
      any(!nzchar(names(calculs))) || anyDuplicated(names(calculs)) ||
      any(names(calculs) %in% names(valeurs)))
    stop("Calculs Yacas invalides : ", id)
  affichages = list()
  rendus = list()
  for (nom in names(calculs)) {
    calcul = calculs[[nom]]
    if (!is.list(calcul) || !identical(calcul$moteur, "Ryacas") ||
        !is.character(calcul$expression) || length(calcul$expression) != 1L ||
        is.na(calcul$expression)) stop("Calcul Yacas invalide : ", id)
    expression = .remplacer_parametres_edu(calcul$expression, valeurs)
    if (!grepl("^[A-Za-z0-9_+*/^()., <>=-]+$", expression))
      stop("Expression Yacas invalide : ", id)
    format = if (is.null(calcul$format)) "valeur" else calcul$format
    if (identical(format, "math_hold")) {
      valeurs[[nom]] = expression
      rendus[[nom]] = .math_inline_edu(expression)
      affichages[[expression]] = rendus[[nom]]
      next
    }
    resultat = Ryacas::yac_str(expression)
    if (length(resultat) != 1L || is.na(resultat) || !nzchar(trimws(resultat)))
      stop("Ryacas n'a pas produit de resultat : ", id)
    if (identical(format, "liste_entiers")) {
      if (!grepl("^\\{[0-9]+(,[0-9]+)*\\}$", resultat))
        stop("Liste Ryacas invalide : ", id)
      resultat = substring(resultat, 2L, nchar(resultat) - 1L)
      resultat = gsub(",", ", ", resultat, fixed = TRUE)
    } else if (!identical(format, "valeur")) {
      stop("Format Yacas invalide : ", id)
    }
    valeurs[[nom]] = trimws(resultat)
  }
  list(valeurs = valeurs, affichages = affichages, rendus = rendus)
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
  if (length(definition$parametres))
    stop("Parametres dynamiques interdits : ", definition$id)
  if (!length(definition$variantes))
    return(list(definition = definition, parametres = list(), progression = NULL))
  variantes = definition$variantes
  if (!is.list(variantes) || !length(variantes))
    stop("Variantes invalides : ", definition$id)
  variante = variantes[[sample.int(length(variantes), 1L)]]
  valeurs = variante$parametres
  progression = variante$progression
  if (!is.list(valeurs) || !length(valeurs) || is.null(names(valeurs)) ||
      any(!nzchar(names(valeurs))) || anyDuplicated(names(valeurs)) ||
      any(!vapply(valeurs, function(x) length(x) == 1L &&
        (is.character(x) || is.numeric(x)) && !is.na(x), logical(1))))
    stop("Parametres de variante invalides : ", definition$id)
  if (!is.null(progression) &&
      (!is.numeric(progression) || length(progression) != 1L ||
       is.na(progression) || progression < 1 || progression %% 1 != 0))
    stop("Progression de variante invalide : ", definition$id)
  calcules = .calculer_parametres_yacas_edu(definition$calculs, valeurs, definition$id)
  valeurs = calcules$valeurs
  definition$calculs = NULL
  math = unlist(definition$presentation$math, use.names = FALSE)
  if (length(math) && (any(!math %in% names(valeurs)) || anyDuplicated(math)))
    stop("Parametres mathematiques invalides : ", definition$id)
  enonce = definition$enonce
  correction = definition$correction
  affichages = calcules$affichages
  for (nom in names(calcules$rendus)) {
    enonce = gsub(paste0("[[", nom, "]]"), calcules$rendus[[nom]], enonce, fixed = TRUE)
    correction = gsub(paste0("[[", nom, "]]"), calcules$rendus[[nom]], correction, fixed = TRUE)
  }
  for (nom in math) {
    valeur = as.character(valeurs[[nom]])
    affichage = .math_inline_edu(valeur)
    enonce = gsub(paste0("[[", nom, "]]"), affichage, enonce, fixed = TRUE)
    correction = gsub(paste0("[[", nom, "]]"), affichage, correction, fixed = TRUE)
    affichages[[valeur]] = affichage
  }
  definition$variantes = NULL
  definition = .remplacer_parametres_edu(definition, valeurs)
  definition$enonce = .remplacer_parametres_edu(enonce, valeurs)
  definition$correction = .remplacer_parametres_edu(correction, valeurs)
  list(definition = definition, parametres = valeurs, progression = progression,
       affichages = affichages)
}

#' Instancier une question (JSON local de confiance uniquement)
#' @param definition Element de questions(notion)$questions.
#' @export
question = function(definition) {
  instance = .instancier_variante_edu(definition)
  definition = instance$definition
  valeurs = instance$parametres
  progression = instance$progression
  affichages = instance$affichages
  if (is.null(affichages)) affichages = list()
  if (length(definition$distracteurs$expressions))
    stop("Parametres dynamiques interdits : ", definition$id)
  if (identical(definition$reponse$mode, "calcul_fixe")) {
    calcul = .calcul_fixe_edu(definition$reponse)
    if (!is.null(definition$reponse$valeur) ||
        !is.null(definition$reponse$attendue))
      stop("Reponse calculee dupliquee : ", definition$id)
    enonce = definition$enonce
    if (is.null(definition$reponse$source_format) &&
        grepl("[[quantite]]", enonce, fixed = TRUE))
      stop("Quantite non definie : ", definition$id)
    # Literal markers are replaced only for fixed operands declared here.
    enonce = gsub("[[terme1]]", .math_inline_edu(calcul$termes[[1L]]), enonce, fixed = TRUE)
    enonce = gsub("[[terme2]]", .math_inline_edu(calcul$termes[[2L]]), enonce, fixed = TRUE)
    if (grepl("[[terme1]]", enonce, fixed = TRUE) ||
        grepl("[[terme2]]", enonce, fixed = TRUE))
      stop("Enonce incomplet : ", definition$id)
    if (grepl("[[quantite]]", enonce, fixed = TRUE)) {
      if (is.null(calcul$quantite)) stop("Quantite source absente : ", definition$id)
      enonce = gsub("[[quantite]]", calcul$quantite, enonce, fixed = TRUE)
    }
    if (grepl("[[quantite]]", enonce, fixed = TRUE))
      stop("Enonce incomplet : ", definition$id)
    bonne = calcul$reponse
  } else if (identical(definition$reponse$mode, "symbolique_fixe")) {
    source = definition$reponse
    if (!identical(source$moteur, "Ryacas") ||
        length(definition$parametres) || length(definition$distracteurs$expressions) ||
        !is.null(source$valeur) || !is.null(source$attendue))
      stop("Definition symbolique invalide : ", definition$id)
    if (!is.character(source$expression) || length(source$expression) != 1L ||
        !grepl("^[a-z0-9+*/^() -]+$", source$expression) ||
        !is.character(source$affichage) || length(source$affichage) != 1L ||
        !grepl("[[expression]]", definition$enonce, fixed = TRUE))
      stop("Source symbolique absente : ", definition$id)
    candidats = source$candidats
    choix = unlist(definition$propositions, use.names = FALSE)
    if (!is.list(candidats) || !setequal(names(candidats), choix) ||
        anyDuplicated(choix) || length(choix) < 2L)
      stop("Candidats symboliques invalides : ", definition$id)
    # A single Ryacas source determines which candidate is the answer.
    # Subtracting and simplifying must yield exactly zero, not a heuristic
    # comparison of displayed strings.
    equivalence = function(expr) {
      if (!is.character(expr) || length(expr) != 1L ||
          !grepl("^[a-z0-9+*/^() -]+$", expr))
        stop("Expression candidate invalide : ", definition$id)
      resultat = Ryacas::yac_str(paste0("Simplify(Expand((",
        source$expression, ")- (", expr, ")))"))
      identical(trimws(resultat), "0")
    }
    valides = vapply(candidats, equivalence, logical(1))
    if (sum(valides) != 1L)
      stop("QCM symbolique ambigu : ", definition$id)
    bonne = names(candidats)[valides]
    enonce = gsub("[[expression]]", source$affichage,
                  definition$enonce, fixed = TRUE)
  } else if (identical(definition$reponse$mode, "relation_fixe")) {
    source = definition$reponse
    if (!identical(source$moteur, "Ryacas") ||
        !is.null(source$valeur) || !is.null(source$attendue))
      stop("Relation fixe invalide : ", definition$id)
    # All candidate expressions are fixed data. Ryacas decides the result;
    # the stored JSON contains no independent correct answer.
    choix = unlist(definition$propositions, use.names = FALSE)
    candidats = source$candidats
    if (!is.list(candidats) || length(choix) < 2L ||
        anyDuplicated(choix) || !setequal(names(candidats), choix))
      stop("Candidats invalides : ", definition$id)
    valeur = function(expr) {
      if (!is.character(expr) || length(expr) != 1L ||
          !grepl("^[0-9+*/^() -]+$", expr))
        stop("Expression numerique invalide : ", definition$id)
      resultat = Ryacas::yac_str(paste0("Simplify(", expr, ")"))
      if (!grepl("^-?[0-9]+(/[1-9][0-9]*)?$", resultat))
        stop("Resultat Ryacas non rationnel : ", definition$id)
      morceaux = strsplit(resultat, "/", fixed = TRUE)[[1L]]
      as.numeric(morceaux[[1L]]) /
        if (length(morceaux) == 2L) as.numeric(morceaux[[2L]]) else 1
    }
    mode = source$relation
    if (!mode %in% c("egalite_fausse", "equivalent", "comparaison",
                     "encadrement", "nombre"))
      stop("Relation inconnue : ", definition$id)
    if (identical(mode, "egalite_fausse")) {
      valides = vapply(candidats, function(x) {
        if (!is.list(x) || !setequal(names(x), c("gauche", "droite")))
          stop("Egalite invalide : ", definition$id)
        valeur(x$gauche) != valeur(x$droite)
      }, logical(1))
    } else {
      if (!is.character(source$expression) || length(source$expression) != 1L)
        stop("Source absente : ", definition$id)
      cible = valeur(source$expression)
      if (identical(mode, "comparaison")) {
        if (!is.character(source$autre) || length(source$autre) != 1L)
          stop("Deuxieme terme absent : ", definition$id)
        autre = valeur(source$autre)
        valides = vapply(candidats, function(x) {
          switch(x, "<" = cible < autre, ">" = cible > autre,
                 "=" = cible == autre, "\u2265" = cible >= autre,
                 stop("Signe inconnu : ", definition$id))
        }, logical(1))
      } else if (identical(mode, "encadrement")) {
        valides = vapply(candidats, function(x) {
          if (!is.list(x) || !setequal(names(x), c("borne_inf", "borne_sup")))
            stop("Bornes invalides : ", definition$id)
          bas = valeur(x$borne_inf)
          haut = valeur(x$borne_sup)
          bas < cible && cible < haut && haut - bas == 1
        }, logical(1))
      } else {
        valides = vapply(candidats, function(x) valeur(x) == cible, logical(1))
      }
    }
    if (sum(valides) != 1L)
      stop("Relation ambigue : ", definition$id)
    bonne = names(candidats)[valides]
    enonce = definition$enonce
    # Only declared fixed source expressions can appear in the question.
    if (grepl("[[source]]", enonce, fixed = TRUE)) {
      if (identical(mode, "comparaison")) {
        source_affichage = paste(.math_inline_edu(source$expression), "et",
                                 .math_inline_edu(source$autre))
      } else if (identical(mode, "equivalent") && !is.null(source$affichage) &&
                 grepl("\u00F7", source$affichage, fixed = TRUE)) {
        source_affichage = source$affichage
      } else {
        source_affichage = .math_inline_edu(source$expression)
      }
      enonce = gsub("[[source]]", source_affichage, enonce, fixed = TRUE)
    }
  } else if (identical(definition$reponse$mode, "editoriale")) {
    enonce = definition$enonce
    bonne = as.character(definition$reponse$valeur)
  } else stop("Mode de reponse interdit : ", definition$id)
  if (length(bonne) != 1L || is.na(bonne) || !nzchar(bonne))
    stop("Reponse absente : ", definition$id)
  propositions = unlist(definition$propositions, use.names = FALSE)
  # Quiz strictly use QCM: reject any question without alternatives.
  if (!length(propositions)) stop("QCM sans propositions : ", definition$id)
  if (length(propositions)) {
    propositions = unique(c(bonne, propositions))
    propositions = propositions[nzchar(propositions)]
    if (length(propositions) < 2L) stop("QCM sans alternative : ", definition$id)
    propositions = sample(propositions)
  }
  if (identical(definition$reponse$mode, "calcul_fixe") &&
      identical(if (is.null(definition$reponse$format)) "fraction" else definition$reponse$format, "fraction") &&
      !nzchar(if (is.null(definition$reponse$unite)) "" else definition$reponse$unite)) {
    for (valeur in unique(c(bonne, propositions)))
      affichages[[valeur]] = .math_inline_edu(valeur)
  }
  if (identical(definition$reponse$mode, "relation_fixe")) {
    if (identical(definition$reponse$relation, "egalite_fausse")) {
      for (nom in names(definition$reponse$candidats)) {
        candidat = definition$reponse$candidats[[nom]]
        affichages[[nom]] = paste(.math_inline_edu(candidat$gauche), "=",
                                  .math_inline_edu(candidat$droite))
      }
    } else if (identical(definition$reponse$relation, "equivalent")) {
      for (nom in names(definition$reponse$candidats))
        affichages[[nom]] = .math_inline_edu(definition$reponse$candidats[[nom]])
    } else if (identical(definition$reponse$relation, "encadrement")) {
      for (nom in names(definition$reponse$candidats)) affichages[[nom]] = .math_inline_edu(nom)
    }
  }
  # Detect equivalent numerical proposals, not just equivalent answers.
  numerique = function(x) {
    if (!grepl("^-?[0-9]+(/[1-9][0-9]*)?$", x)) return(NA_real_)
    morceaux = strsplit(x, "/", fixed = TRUE)[[1L]]
    as.numeric(morceaux[1L]) / if (length(morceaux) == 2L) as.numeric(morceaux[2L]) else 1
  }
  if (length(propositions)) {
    n = vapply(propositions, numerique, numeric(1))
    chiffres = which(!is.na(n))
    if (anyDuplicated(n[chiffres]))
      stop("Propositions numeriques equivalentes : ", definition$id)
    if (sum(propositions == bonne) != 1L)
      stop("Reponse absente ou multiple : ", definition$id)
  }
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
  propositions_affichage = vapply(propositions, function(x) {
    if (!is.null(affichages[[x]])) affichages[[x]] else x
  }, character(1))
  reponse_affichage = if (!is.null(affichages[[bonne]])) affichages[[bonne]] else bonne
  list(id = definition$id, enonce = enonce, reponse = bonne,
       reponse_affichage = reponse_affichage, propositions = propositions,
       propositions_affichage = propositions_affichage, correction = correction,
       illustration = definition$illustration, parametres = valeurs,
       progression = progression, presentation = definition$presentation,
       humour = definition$humour)
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
        candidats = if (length(variables)) variables else seq_along(definitions)
        if (length(candidats) == 1L) {
          supplementaires = rep(candidats, supplement)
        } else {
          supplementaires = sample(candidats, supplement, replace = TRUE)
        }
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
                    variantes = 5L, ouvrir = TRUE, niveau = "", n = NULL, tirages = NULL,
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
