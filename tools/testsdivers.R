# testsdivers.R - exploration transversale des banques eduschool

library("dplyr")
library("tidyr")

setwd("~/repogit/eduschool/")

devtools::load_all()

racine = system.file("notions", package = "eduschool")

# 1. Fichiers (recherche par nom exact).
fichiers_questions = function(racine) {
  x = list.files(racine, recursive = TRUE, full.names = TRUE)
  x[basename(x) == "questions.json"]
}

fichiers = fichiers_questions(racine)

length(fichiers)
basename(dirname(fichiers))

# 2. Charger un fichier, par chemin ou par index.
# charger_questions = function(fichier) {
#   if (is.numeric(fichier)) fichier = fichiers[[fichier]]
#   jsonlite::read_json(fichier, simplifyVector = FALSE)
# }

charger_questions = function(fichier) {
  if (is.numeric(fichier)) fichier = fichiers[[fichier]]
  if (file.exists(fichier)) {
    return(jsonlite::read_json(fichier, simplifyVector = FALSE))
  }
  id = fichier
  for (f in fichiers) {
    x = jsonlite::read_json(f, simplifyVector = FALSE)
    i = which(vapply(x$questions, \(q) identical(q$id, id), logical(1)))
    if (length(i) == 1L) return(x$questions[[i]])
  }
  stop("Question introuvable : ", id)
}

banque = charger_questions(fichiers[1L])
str(banque, max.level = 2)

# 3. Inventaire global, sans modifier les banques.
inventaire = do.call(rbind, lapply(fichiers, function(f) {
  b = charger_questions(f)
  q = b$questions
  data.frame(famille = basename(dirname(f)), fichier = f,
    modeles = length(q),
    variantes = sum(vapply(q, function(m) length(m$variantes), integer(1))),
    sans_variantes = sum(vapply(q, function(m) length(m$variantes) == 0L, logical(1))))
}))

colSums(inventaire[c("modeles", "variantes", "sans_variantes")])
inventaire[order(-inventaire$variantes), c("famille", "modeles", "variantes", "sans_variantes")]

# Repartition par type de capacite (une ligne par modele).
modeles = do.call(rbind, lapply(fichiers, function(f) {
  b = charger_questions(f)
  do.call(rbind, lapply(b$questions, function(m) {
    data.frame(
      famille = basename(dirname(f)),
      id = m$id,
      capacite = if (is.null(m$capacite)) NA_character_ else m$capacite,
      variantes = length(m$variantes))
  }))
}))

modeles |> count(capacite, .drop = FALSE)

xtabs(~ famille + capacite, data = modeles)
xtabs(variantes ~ capacite, data = modeles)

modeles |> 
    group_by(capacite) |> 
    count(variantes) |> 
    mutate(tot = variantes*n) |> 
    ungroup() |> 
    group_by(capacite) |> 
    summarise(tot = sum(tot), .groups = "drop")

# 4. Une famille de proprietes generiques pour TOUS les QCM.
# Les marqueurs [[nom]] sont substitues par correspondance litterale.
# Pas de regex, pas d'interpretation mathematique des textes.
substituer = function(texte, parametres) {
  stopifnot(is.character(texte), length(texte) == 1L)
  for (nom in names(parametres)) {
    valeur = parametres[[nom]]
    if (length(valeur) != 1L || !is.atomic(valeur) || is.na(valeur)) next
    marqueur = paste0("[[", nom, "]]")
    avec_bords = paste0("x", texte, "x")
    morceaux = strsplit(avec_bords, marqueur, fixed = TRUE)[[1L]]
    nouveau = paste(morceaux, collapse = as.character(valeur))
    texte = substr(nouveau, 2L, nchar(nouveau) - 1L)
  }
  texte
}

verifier_qcm = function(m, p) {
  reponse = substituer(m$reponse, p)
  propositions = vapply(m$propositions, substituer, character(1), parametres = p)
  c(
    reponse_presente = reponse %in% propositions,
    reponse_unique = sum(propositions == reponse) == 1L,
    propositions_distinctes = anyDuplicated(propositions) == 0L,
    propositions_suffisantes = length(propositions) >= 2L,
    aucun_marqueur = !any(grepl("[[", c(reponse, propositions), fixed = TRUE))
  )
}

# 5. Verifier toutes les questions avec propositions.
proprietes = 
    c("reponse_presente",
      "reponse_unique",
      "propositions_distinctes",
      "propositions_suffisantes",
      "aucun_marqueur")

resultats = list()

for (f in fichiers) {
  b = charger_questions(f)
  for (m in b$questions) {
    if (is.null(m$reponse) || is.null(m$propositions)) next
    variantes = m$variantes
    if (!length(variantes)) variantes = list(list(parametres = list()))
    for (i in seq_along(variantes)) {
      p = variantes[[i]]$parametres
      if (is.null(p)) p = list()
      v = tryCatch(verifier_qcm(m, p), error = function(e)
        setNames(rep(FALSE, length(proprietes)), proprietes))
      resultats[[length(resultats) + 1L]] = data.frame(
        famille = basename(dirname(f)), id = m$id, variante = i,
        t(v), check.names = FALSE)
    }
  }
}

resultats = do.call(rbind, resultats)

data.frame(
  propriete = proprietes,
  controles = colSums(!is.na(resultats[proprietes])),
  conformes = colSums(resultats[proprietes], na.rm = TRUE),
  anomalies = colSums(!resultats[proprietes], na.rm = TRUE)
)

nrow(resultats)
length(unique(resultats$id))
length(unique(resultats$famille))

modeles |>
  dplyr::filter(duplicated(id) | duplicated(id, fromLast = TRUE))

# stat desc
data.frame(
  indicateur = c("Modeles", "Modeles avec variantes", "Modeles sans variantes", "Variantes"),
  nombre = c(nrow(modeles), sum(modeles$variantes > 0L),
    sum(modeles$variantes == 0L), sum(modeles$variantes))
)

# verif params des variantes
parametres_valides = unlist(lapply(fichiers, function(f) {
  b = charger_questions(f)
  unlist(lapply(b$questions, function(m) {
    vapply(m$variantes, function(v) {
      is.list(v$parametres) &&
        !is.null(names(v$parametres)) &&
        all(nzchar(names(v$parametres)))
    }, logical(1))
  }))
}))

data.frame(
  propriete = "Parametres des variantes renseignes",
  controles = length(parametres_valides),
  conformes = sum(parametres_valides),
  anomalies = sum(!parametres_valides)
)

# 7. Marqueurs non resolus dans les questions
marqueurs = list()

for (f in fichiers) {
  b = charger_questions(f)
  for (m in b$questions) {
    variantes = m$variantes
    if (!length(variantes)) variantes = list(list(parametres = list()))
    for (i in seq_along(variantes)) {
      p = variantes[[i]]$parametres
      if (is.null(p)) p = list()
      champs = c("enonce", "reponse", "correction")
      for (champ in champs) {
        valeur = m[[champ]]
        if (!is.character(valeur) || length(valeur) != 1L) next
        texte = substituer(valeur, p)
        if (!grepl("[[", texte, fixed = TRUE)) next
        marqueurs[[length(marqueurs) + 1L]] = data.frame(
          famille = basename(dirname(f)),
          id = m$id,
          variante = i,
          champ = champ,
          contenu = texte
        )
      }
    }
  }
}

marqueurs = if (length(marqueurs)) do.call(rbind, marqueurs) else
  data.frame(famille = character(), id = character(),
    variante = integer(), champ = character(), contenu = character())

marqueurs

# champs des questions : communs / distinct / ...

questions =
    lapply(fichiers, \(f) jsonlite::fromJSON(f, simplifyVector = FALSE)$questions) |>
    unlist(recursive = FALSE)

champs = lapply(questions, names)

stats = 
    data.frame(champ = sort(unique(unlist(champs)))) |>
    dplyr::mutate(
                  modeles = vapply(champ, \(x) sum(vapply(champs, \(y) x %in% y, logical(1))), integer(1)),
                  pourcentage = round(100 * modeles / length(questions), 1),
                  statut = dplyr::if_else(modeles == length(questions), "Systématique", "Facultatif")) |>
    dplyr::arrange(dplyr::desc(modeles), champ)

stats |> knitr::kable()

modeles |> tibble()

# champs humour/apart_humour
selection = Filter(\(q) "apart_humour" %in% names(q), questions)
vapply(selection, \(q) q$id, character(1))
lapply(selection, \(q) q$apart_humour)

selection = Filter(\(q) "portee" %in% names(q), questions)
vapply(selection, \(q) q$id, character(1))

transversales = Filter(\(q) startsWith(q$id, "TRANSVERSAL_"), questions)
sans_portee = Filter(\(q) !"portee" %in% names(q), transversales)
length(transversales)
length(sans_portee)
vapply(sans_portee, \(q) q$id, character(1))

# champs presentation
selection = Filter(\(q) "presentation" %in% names(q), questions)
vapply(selection, \(q) q$id, character(1))
lapply(selection, \(q) q$presentation)

# Classer les réponses des json par nature (interprétable, texte, ...)
classer_reponse = function(x) {
  if (!is.character(x) || length(x) != 1L || is.na(x)) return("autre")
  x = trimws(x)
  if (!nzchar(x)) return("vide")
  expr = tryCatch(parse(text = x, keep.source = FALSE), error = \(e) NULL)
  if (is.null(expr) || length(expr) != 1L) return("texte")
  valide = function(e) {
    if (is.numeric(e)) return(TRUE)
    if (!is.call(e)) return(FALSE)
    op = as.character(e[[1]])
    if (!op %in% c("+", "-", "*", "/", "^", "(")) return(FALSE)
    all(vapply(as.list(e)[-1], valide, logical(1)))
  }
  e = expr[[1]]
  if (!valide(e)) return("texte")
  if (is.numeric(e) && e == trunc(e)) return("entier")
  if (is.call(e) && identical(e[[1]], as.name("/"))) return("fraction")
  "numerique"
}

stats_reponses = data.frame(
  id = vapply(questions, \(q) q$id, character(1)),
  reponse = vapply(questions, \(q) q$reponse, character(1))) |>
  dplyr::mutate(classe = vapply(reponse, classer_reponse, character(1)))

table(stats_reponses$classe)

stats_reponses |>
  dplyr::filter(classe == "texte") |> 
  dplyr::count(reponse, sort = TRUE) |> 
  as_tibble()

reponses = lapply(questions, \(q) {
  variantes = q$variantes
  if (is.null(variantes) || length(variantes) == 0L) variantes = list(list())
  data.frame(
    id = q$id,
    reponse = vapply(variantes, \(p) substituer(q$reponse, p), character(1))
  )}) |> dplyr::bind_rows() |>
  dplyr::mutate(classe = vapply(reponse, classer_reponse, character(1)))

reponses |>
  dplyr::count(classe, sort = TRUE)

reponses |>
    as_tibble() |> 
    dplyr::count(reponse, sort = TRUE) |>
    print(n = 30)

q = questions[[which(vapply(questions, \(q) q$reponse == "[[reponse]]", logical(1)))[1]]]
str(q, max.level = 3)

reponses = lapply(questions, \(q) {
  variantes = q$variantes
  if (is.null(variantes) || length(variantes) == 0L) variantes = list(list(parametres = list()))
  data.frame(
    id = q$id,
    reponse = vapply(variantes, \(v) substituer(q$reponse, v$parametres), character(1))
  )
}) |>
  dplyr::bind_rows() |>
  dplyr::mutate(classe = vapply(reponse, classer_reponse, character(1)))

reponses |> 
    as_tibble() |> 
    dplyr::count(classe, sort = TRUE)

reponses |>
    as_tibble() |> 
    dplyr::count(reponse, sort = TRUE) |>
    head(20)

reponses |>
  dplyr::as_tibble() |>
  dplyr::count(classe, sort = TRUE)

reponses |>
  dplyr::filter(grepl("[[", reponse, fixed = TRUE))

reponses |>
  dplyr::as_tibble() |>
  dplyr::filter(classe == "texte") |>
  dplyr::count(reponse, sort = TRUE) |>
  print(n = 50)

readr::read_lines("inst/notions/decimaux_fractions/questions.json") |>
  tibble::enframe(name = "ligne", value = "texte") |>
  dplyr::filter(stringr::str_detect(texte, stringr::fixed('\\"')))

# questions dont moteur == null

questions = tibble(fichier = fs::dir_ls("inst/notions", recurse = TRUE, glob = "*/questions.json")) |>
  mutate(contenu = purrr::map(fichier, \(f) jsonlite::fromJSON(f, simplifyVector = FALSE)$questions)) |>
  tidyr::unnest_longer(contenu) |>
  mutate(id = purrr::map_chr(contenu, "id"),
    moteur = purrr::map_chr(contenu, \(q) if (is.null(q$moteur)) NA_character_ else q$moteur)) |>
  select(fichier, id, moteur)

questions |>
  count(moteur, .drop = FALSE)

questions |>
  filter(is.na(moteur)) |>
  select(fichier, id) |>
  print(n = Inf)

# tests divers

banquevol = charger_questions(fichiers[86L])
str(banque, max.level = 2)

f = "inst/notions/volumes/questions.json"
q = jsonlite::fromJSON(f, simplifyVector = FALSE)$questions

controle = tibble(question = q) |>
  mutate(
    id = purrr::map_chr(question, "id"),
    moteur = purrr::map_chr(question, \(x) if (is.null(x$moteur)) NA_character_ else x$moteur),
    expression = purrr::map_chr(question, \(x) if (is.null(x$enonce_exploitable)) NA_character_ else x$enonce_exploitable),
    attendu = purrr::map_chr(question, \(x) if (is.null(x$reponse_exploitable)) NA_character_ else x$reponse_exploitable),
    variantes = purrr::map(question, "variantes")
  ) |>
  filter(moteur == "R", !is.na(expression), !is.na(attendu)) |>
  unnest_longer(variantes) |>
  group_by(id) |>
  mutate(variante = row_number()) |>
  ungroup() |>
  mutate(parametres = purrr::map(variantes, "parametres")) |>
  select(id, variante, expression, attendu, parametres)

substituer = function(expr, p) {
  for (nom in names(p)) {
    if (is.numeric(p[[nom]]) && length(p[[nom]]) == 1) {
      expr = stringr::str_replace_all(expr, stringr::fixed(paste0("[[", nom, "]]")), as.character(p[[nom]]))
      expr = stringr::str_replace_all(expr, paste0("\\b", nom, "\\b"), as.character(p[[nom]]))
    }
  }
  expr
}

controle = controle |>
  mutate(
    calcul = purrr::map2_chr(expression, parametres, substituer),
    reponse = purrr::map2_chr(attendu, parametres, substituer),
    ecart = purrr::map2_chr(calcul, reponse, \(a, b) Ryacas::yac_str(paste0("(", a, ")-(", b, ")"))),
    valide = ecart == "0")

controle |>
  select(id, variante, calcul, reponse, ecart, valide) |>
  print(n = Inf)

# Controle COMP-STAT

f = "inst/notions/statistiques_comparaison_series/questions.json"
questions = jsonlite::fromJSON(f, simplifyVector = FALSE)$questions
q = Filter(\(x) identical(x$id, "COMP-STAT-001"), questions)[[1]]
q$enonce_exploitable
q$reponse_exploitable
length(q$variantes)

controle = do.call(rbind, lapply(seq_along(q$variantes), \(i) {
  p = q$variantes[[i]]$parametres
  data.frame(
    variante = i,
    etendue_a = p$etendue_a,
    etendue_b = p$etendue_b,
    calcule = as.numeric(p$etendue_b > p$etendue_a),
    attendu = as.numeric(q$reponse_exploitable)
  )
}))

controle$valide = controle$calcule == controle$attendu

table(controle$valide)

# mot a trou et mot masque : moteur == "aucun" ?

questions = lapply(fichiers, function(f) {
  x = jsonlite::fromJSON(f, simplifyVector = FALSE)
  lapply(x$questions, function(q) {
    data.frame(
      fichier = f,
      id = q$id,
      type_question = q$type_question,
      moteur = if (is.null(q$moteur)) NA_character_ else q$moteur
    )
  }) |> dplyr::bind_rows()
}) |> dplyr::bind_rows()

questions |>
  dplyr::filter(type_question %in% c("mot_a_trou", "mot_masque"), is.na(moteur) | moteur != "aucun")

charger_questions("TRIG-RAP-001")
# charger_questions("ENS-017")
# charger_questions("FCAR-003")
# charger_questions("TRI-ISO-ANGLES-001")
charger_questions("INEQ-1D-SENS")
charger_questions("ANALYSE-SYNTHESE-EQUIVALENCE")
charger_questions("ENS-010")
