# Run after devtools::load_all(".") from the repository root.
# Fixed-bank structural checks. Pedagogical review remains a separate task.
stopifnot(requireNamespace("jsonlite", quietly = TRUE))
fichiers = list.files("inst/notions", "questions.json", recursive = TRUE,
                      full.names = TRUE)
stopifnot(length(fichiers) == 26L)
banques = lapply(fichiers, jsonlite::fromJSON, simplifyVector = FALSE)
definitions = unlist(lapply(banques, `[[`, "questions"), recursive = FALSE)
stopifnot(length(definitions) == 85L)
for (definition in definitions) {
  stopifnot(!length(definition$parametres),
            !length(definition$distracteurs$expressions),
            definition$reponse$mode %in% c("editoriale", "calcul_fixe", "symbolique_fixe", "relation_fixe"))
  q = question(definition)
  stopifnot(nzchar(q$enonce), nzchar(q$correction),
            !length(q$parametres))
  if (identical(definition$reponse$mode, "editoriale"))
    stopifnot(identical(q$reponse, definition$reponse$valeur))
  stopifnot(length(q$propositions) >= 2L,
            sum(q$propositions == q$reponse) == 1L)
  if (!is.null(q$presentation$masques)) {
    masques = unlist(q$presentation$masques)
    stopifnot(all(q$propositions %in% names(masques)),
              !anyDuplicated(unname(masques[q$propositions])))
  }
}
# Reject reintroduction of dynamic questions.
sonde = definitions[[1L]]
sonde$parametres = list(x = "sample(1:10, 1)")
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))
sonde = definitions[[1L]]
sonde$reponse = list(mode = "calcul", moteur = "R", expression = "1+1")
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))
cat("Audit P0 des banques fixes :", length(definitions), "questions.\n")

# Fixed arithmetic questions use Ryacas, with no stored answer or dynamic inputs.
calculees = Filter(function(d) identical(d$reponse$mode, "calcul_fixe"), definitions)
stopifnot(length(calculees) == 44L)
for (d in calculees) {
  stopifnot(identical(d$reponse$moteur, "Ryacas"),
            is.null(d$reponse$valeur), is.null(d$reponse$attendue))
  q = question(d)
  stopifnot(!grepl("[[terme1]]", q$enonce, fixed = TRUE),
            !grepl("[[terme2]]", q$enonce, fixed = TRUE),
            !grepl("[[quantite]]", q$enonce, fixed = TRUE))
}
# No dynamic inputs can enter the fixed calculation path.
sonde = calculees[[1L]]
sonde$reponse$termes = list("sample(1:10,1)", "1/3")
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))

# Reject a second, independently stored result in a calculated question.
sonde = calculees[[1L]]
sonde$reponse$valeur = "999"
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))
cat("Ryacas :", length(calculees), "definitions de calcul fixe.\n")

# Audit the editorial questions separately. No editorial answer is labelled
# Ryacas-verified: these assertions are fixed regression fixtures.
editoriales = Filter(function(d) identical(d$reponse$mode, "editoriale"),
                     definitions)
stopifnot(length(editoriales) == 24L)
# Duplicate IDs in different banks must agree on their fixed mathematical
# content. This prevents silent divergence between general and targeted quizzes.
cles = vapply(editoriales, `[[`, character(1), "id")
for (cle in unique(cles[duplicated(cles)])) {
  copies = editoriales[cles == cle]
  stopifnot(all(vapply(copies, function(d)
    identical(d$enonce, copies[[1L]]$enonce) &&
    identical(d$reponse, copies[[1L]]$reponse) &&
    identical(d$propositions, copies[[1L]]$propositions), logical(1))))
}
# Fixed editorial content must remain a genuinely unambiguous QCM.
for (d in editoriales) {
  choix = unlist(d$propositions, use.names = FALSE)
  stopifnot(length(choix) >= 2L, !anyDuplicated(choix),
            sum(choix == d$reponse$valeur) == 1L)
}
cat("Questions editoriales :", length(editoriales),
    "definitions, controle structurel uniquement.\n")

# Symbolic fixed questions: Ryacas must select exactly one mathematically
# equivalent candidate from the single fixed expression.
symboliques = Filter(function(d) identical(d$reponse$mode, "symbolique_fixe"),
                     definitions)
stopifnot(length(symboliques) == 9L)
for (d in symboliques) {
  q = question(d)
  stopifnot(!grepl("[[expression]]", q$enonce, fixed = TRUE),
            q$reponse %in% q$propositions)
}
# Fail closed when two candidates are mathematically equivalent.
sonde = symboliques[[1L]]
sonde$reponse$candidats[[2L]] = sonde$reponse$candidats[[1L]]
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))
cat("Ryacas symbolique :", length(symboliques), "definitions.\n")

# Fixed mathematical relations: the unique correct option comes from Ryacas.
relations = Filter(function(d) identical(d$reponse$mode, "relation_fixe"),
                   definitions)
stopifnot(length(relations) == 8L)
for (d in relations) {
  stopifnot(identical(d$reponse$moteur, "Ryacas"),
            is.null(d$reponse$valeur), is.null(d$reponse$attendue))
  q = question(d)
  stopifnot(sum(q$propositions == q$reponse) == 1L,
            !grepl("[[source]]", q$enonce, fixed = TRUE))
}
# A duplicated mathematically correct candidate must fail closed.
sonde = relations[[1L]]
sonde$reponse$candidats[[2L]] = sonde$reponse$candidats[[1L]]
stopifnot(inherits(try(question(sonde), silent = TRUE), "try-error"))
cat("Ryacas relations :", length(relations), "definitions.\n")
