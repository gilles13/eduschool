test_that("les proportions fournissent un QCM ferme et non ambigu", {
  x = generer_proportion(seed = 2026)
  expect_length(x$qcm$propositions, 4L)
  expect_length(unique(x$qcm$propositions), 4L)
  expect_length(x$qcm$feedback, 4L)
  expect_true(x$qcm$correcte %in% 1:4)
  expect_identical(x$qcm$propositions[[x$qcm$correcte]], x$reponse)
})

test_that("produire_quiz cree un HTML autonome sans bibliotheque externe", {
  x = exercices("6E", "proportionnalite", n = 5, seed = 2026)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_true(file.exists(sortie))
  expect_match(html, "Valider le quiz", fixed = TRUE)
  expect_match(html, 'type="radio"', fixed = TRUE)
  expect_match(html, "Reessayer", fixed = TRUE)
  expect_false(grepl("<script[^>]+src=", html))
  expect_false(grepl("<link[^>]+href=", html))
})

test_that("les productions par defaut sont rangees dans rapports", {
  x = exercices("6E", "proportionnalite", n = 1, seed = 2026)
  fichier = eduschool:::.chemin_fichier_document(x, "quiz")

  expect_identical(dirname(fichier), "rapports")
  expect_match(basename(fichier), "^quiz_6e_")
})

test_that("produire_quiz refuse clairement un exercice sans propositions", {
  x = list(generer_fraction_quantite(seed = 2026))
  x[[1L]]$qcm = NULL

  expect_error(
    produire_quiz(x, fichier = tempfile(fileext = ".html"), ouvrir = FALSE),
    "ne propose pas encore de QCM"
  )
})

test_that("un entrainement de proportionnalite sert cinq intentions pedagogiques", {
  x = exercices("6E", "proportionnalite", n = 5, seed = 2026)
  intentions = vapply(x, function(ex) ex$qcm$intention, character(1))

  expect_setequal(
    intentions,
    c("appliquer", "reconnaitre", "raisonner", "se_mefier", "transferer")
  )
  expect_length(unique(vapply(x, function(ex) ex$modele_id, character(1))), 5L)
})

test_that("les proportions offrent quinze situations sans sacrifier les QCM", {
  generateurs = list(
    generer_proportion,
    generer_proportion_reconnaitre,
    generer_proportion_tableau,
    generer_proportion_piege,
    generer_proportion_transfert
  )

  cas_attendus = list(
    c("cookies", "chaussettes", "crayons"),
    c("coefficient", "taxi", "tableau"),
    c("cahiers", "boisson", "distance"),
    c("prix_unitaire", "doublement", "addition"),
    c("riz", "peinture", "jus")
  )

  for (i in seq_along(generateurs)) {
    lot = lapply(1:100, function(seed) {
      generateurs[[i]](niveau_id = "5E", seed = seed)
    })
    cas = unique(vapply(lot, function(ex) ex$parametres$cas, character(1)))

    expect_setequal(cas, cas_attendus[[i]])
    expect_true(all(vapply(lot, function(ex) {
      length(ex$qcm$propositions) == 4L &&
        length(unique(ex$qcm$propositions)) == 4L &&
        identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
    }, logical(1))))
  }
})

test_that("l'humour est optionnel et dose a une question sur cinq", {
  sobre = exercices("5E", "proportionnalite", n = 15, seed = 2026)
  drole = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour = TRUE)

  est_drole = function(ex) isTRUE(ex$qcm$humour)
  expect_false(any(vapply(sobre, est_drole, logical(1))))

  par_bloc = split(drole, ceiling(seq_along(drole) / 5L))
  expect_true(all(vapply(par_bloc, function(bloc) {
    sum(vapply(bloc, est_drole, logical(1))) == 1L
  }, logical(1))))
})

test_that("un quiz autonome embarque un pool et peut etre relance", {
  x = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour = TRUE)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  lots = gregexpr('class="quiz-lot"', html, fixed = TRUE)[[1L]]
  pools = gregexpr('class="pool-questions"', html, fixed = TRUE)[[1L]]
  questions = gregexpr('<section class="question"', html, fixed = TRUE)[[1L]]
  relances = gregexpr('class="relancer-quiz"', html, fixed = TRUE)[[1L]]

  expect_length(lots[lots > 0L], 1L)
  expect_length(pools[pools > 0L], 1L)
  expect_length(relances[relances > 0L], 1L)
  expect_length(questions[questions > 0L], length(x))

  expect_match(html, 'class="pool-questions" hidden', fixed = TRUE)
  expect_match(html, 'class="questions-actives"', fixed = TRUE)
  expect_match(html, "Lancer un nouveau quiz", fixed = TRUE)
  expect_match(html, "const QUESTIONS_PAR_QUIZ=5;", fixed = TRUE)
  expect_match(html, "function afficherQuiz(nouveau=true)", fixed = TRUE)
  expect_match(
    html,
    "Math.min(QUESTIONS_PAR_QUIZ,toutesQuestions.length)",
    fixed = TRUE
  )
  expect_match(
    html,
    'lot.querySelector(".relancer-quiz").addEventListener',
    fixed = TRUE
  )
})

test_that("produire_quiz valide la taille des defis", {
  x = exercices("5E", "proportionnalite", n = 5, seed = 2026)
  expect_error(
    produire_quiz(
      x,
      fichier = tempfile(fileext = ".html"),
      questions_par_quiz = 0,
      ouvrir = FALSE
    ),
    "entier strictement positif"
  )
})
