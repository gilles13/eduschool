expect_html_contains = function(html, text, info) {
  expect_true(grepl(text, html, fixed = TRUE), info = info)
}

.quiz_html = function() {
  x = exercices("6E", "proportionnalite", n = 1, seed = 2026)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  paste(readLines(sortie, warn = FALSE), collapse = "\n")
}

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
  expect_html_contains(html, "Valider le quiz", "Le quiz doit afficher son bouton de validation.")
  expect_html_contains(html, 'type="radio"', "Le quiz doit rendre des choix radio.")
  expect_html_contains(html, "Reessayer", "Le quiz doit proposer de reessayer apres validation.")
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

test_that("humour_ratio dose l'humour de facon reproductible", {
  sobre = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0)
  drole = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0.2)
  drole_bis = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0.2)

  est_drole = function(ex) isTRUE(ex$qcm$humour)
  expect_false(any(vapply(sobre, est_drole, logical(1))))
  expect_equal(sum(vapply(drole, est_drole, logical(1))), 3L)
  expect_identical(
    vapply(drole, est_drole, logical(1)),
    vapply(drole_bis, est_drole, logical(1))
  )
})

test_that("un quiz autonome embarque un pool et peut etre relance", {
  x = exercices("5E", "proportionnalite", n = 15, seed = 2026, humour_ratio = 0.2)
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

  expect_html_contains(html, 'class="pool-questions" hidden', "Le pool de questions doit rester masque.")
  expect_html_contains(html, 'class="questions-actives"', "Le quiz doit contenir une zone de questions actives.")
  expect_html_contains(html, "Lancer un nouveau quiz", "Le quiz doit proposer un nouveau tirage.")
  expect_html_contains(html, "const QUESTIONS_PAR_QUIZ=5;", "Le HTML doit embarquer la taille du quiz.")
  expect_html_contains(html, "function afficherQuiz(nouveau=true)", "Le HTML doit embarquer la fonction de tirage.")
  expect_html_contains(
    html,
    "Math.min(QUESTIONS_PAR_QUIZ,disponibles.length)",
    "Le tirage doit respecter la taille maximale du quiz."
  )
  expect_html_contains(
    html,
    'lot.querySelector(".relancer-quiz").addEventListener',
    "Le bouton de relance doit etre branche au tirage."
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


test_that("les fractions 6e proposent dix gestes mathematiques distincts", {
  x = exercices("6E", "fractions", n = 10, seed = 2026, humour_ratio = 0)
  modeles = vapply(x, function(ex) ex$modele_id, character(1))
  intentions = vapply(x, function(ex) ex$qcm$intention, character(1))

  expect_length(unique(modeles), 10L)
  expect_setequal(
    modeles,
    c(
      "FRAC_ADD_001", "FRAC_QTE_001", "FRAC_QUOT_001", "FRAC_DROITE_001",
      "FRAC_EQUIV_001", "FRAC_COMP_001", "FRAC_ENCADR_001", "FRAC_SUB_001",
      "FRAC_MANQ_001", "FRAC_MULT_ENT_001"
    )
  )
  expect_setequal(
    intentions,
    c(
      "calculer", "appliquer", "interpreter", "placer", "reconnaitre_equivalence",
      "comparer", "encadrer", "soustraire", "completer", "multiplier"
    )
  )
})

test_that("les nouveaux modeles de fractions gardent des QCM fermes", {
  modeles = c(
    "FRAC_QUOT_001", "FRAC_DROITE_001", "FRAC_EQUIV_001", "FRAC_COMP_001",
    "FRAC_ENCADR_001", "FRAC_SUB_001", "FRAC_MANQ_001", "FRAC_MULT_ENT_001"
  )

  for (modele in modeles) {
    for (seed in 1:40) {
      ex = generer_exercice(modele, "6E", seed = seed)
      expect_length(ex$qcm$propositions, 4L)
      expect_length(unique(ex$qcm$propositions), 4L)
      expect_length(ex$qcm$feedback, 4L)
      expect_identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
    }
  }
})

test_that("les fractions 5e couvrent cinq familles pedagogiques distinctes", {
  x = exercices("5E", "fractions", n = 5, seed = 2026, humour_ratio = 0)
  modeles = vapply(x, function(ex) ex$modele_id, character(1))

  expect_length(unique(modeles), 5L)
  expect_setequal(
    modeles,
    c("FRAC_ADD_001", "FRAC_QTE_001", "FRAC_MULT_001", "FRAC_DIV_001", "FRAC_SUB_001")
  )
})

test_that("un grand pool de fractions 5e conserve la diversite des familles", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  modeles = vapply(x, function(ex) ex$modele_id, character(1))

  expect_equal(length(unique(modeles)), 5L)
  expect_true(all(table(modeles) == 3L))
})

test_that("le quiz privilegie des familles distinctes lors du tirage", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_html_contains(html, 'data-modele="FRAC_ADD_001"', "Le pool doit exposer le modele de fraction.")
  expect_html_contains(html, 'const familles=new Set()', "Le tirage doit suivre les familles deja retenues.")
  expect_html_contains(
    html,
    "!familles.has(toutesQuestions[i].dataset.modele)",
    "Le tirage doit privilegier des familles distinctes."
  )
})

test_that("multiplication et division de fractions gardent des QCM fermes", {
  for (modele in c("FRAC_MULT_001", "FRAC_DIV_001")) {
    for (seed in 1:40) {
      ex = generer_exercice(modele, "5E", seed = seed)
      expect_length(ex$qcm$propositions, 4L)
      expect_length(unique(ex$qcm$propositions), 4L)
      expect_length(ex$qcm$feedback, 4L)
      expect_identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
    }
  }
})


test_that("les fractions 5e distinguent les formes de questions", {
  x = exercices("5E", "fractions", n = 5, seed = 2026, humour_ratio = 0)
  formes = vapply(x, function(ex) ex$qcm$forme_question, character(1))

  expect_length(formes, 5L)
  expect_true(all(nzchar(formes)))
  expect_true(length(unique(formes)) >= 3L)
})

test_that("la division de fractions utilise une ecriture non ambigue", {
  x = generer_division_fractions(seed = 2026)

  expect_match(x$enonce, " \u00f7 ", fixed = TRUE)
  expect_false(grepl(" / ", x$enonce, fixed = TRUE))
  expect_identical(x$qcm$forme_question, "transformation_equivalente")
})

test_that("le quiz privilegie les formes avant les familles", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  sortie = produire_quiz(x, fichier = fichier, ouvrir = FALSE)
  html = paste(readLines(sortie, warn = FALSE), collapse = "\n")

  expect_html_contains(html, "data-forme=", "Le HTML doit exposer la forme de question.")
  expect_html_contains(html, "const formes=new Set()", "Le tirage doit suivre les formes deja retenues.")
  expect_html_contains(html, "dataset.forme", "Le tirage doit lire la forme des questions.")
})

test_that("un meme modele de fractions sait changer de forme", {
  formes = vapply(1:6, function(seed) {
    generer_exercice("FRAC_ADD_001", "5E", seed = seed)$qcm$forme_question
  }, character(1))
  expect_gte(length(unique(formes)), 3L)
  expect_true("boite_a_trou" %in% formes)
  expect_true("raisonnement_inverse" %in% formes)
})

test_that("les boites a trou apparaissent vraiment dans les fractions", {
  ids = c("FRAC_ADD_001", "FRAC_SUB_001", "FRAC_MULT_001", "FRAC_DIV_001", "FRAC_QTE_001")
  for (id in ids) {
    ex = generer_exercice(id, "5E", seed = 2)
    expect_identical(ex$qcm$forme_question, "boite_a_trou")
    expect_match(ex$enonce, "□", fixed = TRUE)
    expect_length(ex$qcm$propositions, 4L)
    expect_length(unique(ex$qcm$propositions), 4L)
  }
})

test_that("la diversite des fractions porte sur les couples modele et forme", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  couples = vapply(x, function(ex) paste(ex$modele_id, ex$qcm$forme_question, sep = "::"), character(1))
  formes = vapply(x, function(ex) ex$qcm$forme_question, character(1))
  expect_gte(length(unique(couples)), 10L)
  expect_true("boite_a_trou" %in% formes)
  expect_true("raisonnement_inverse" %in% formes)
})

test_that("l habillage narratif partage diversifie les personnages", {
  personnages = vapply(1:20, function(seed) {
    set.seed(seed)
    .tirer_personnage_exercice()
  }, character(1))
  expect_gte(length(unique(personnages)), 5L)
  expect_true(all(personnages %in% .personnages_exercices))
})

test_that("une fraction de quantite sait questionner le complement", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 3)
  expect_identical(ex$qcm$forme_question, "raisonnement_inverse")
  expect_match(ex$enonce, "Combien en reste-t-il ?", fixed = TRUE)
  expect_match(ex$correction, "distributivit\u00e9", fixed = TRUE)
  expect_match(ex$correction, "1 -", fixed = TRUE)
  expect_identical(ex$qcm$propositions[[ex$qcm$correcte]], ex$reponse)
})

test_that("le quiz ne recycle que les questions non traitees", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(x, fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")

  expect_true(grepl("const questionsVues=new Set()", html, fixed = TRUE))
  expect_true(grepl("const questionsTraitees=new Set()", html, fixed = TRUE))
  expect_true(grepl("questionsVues.add(i)", html, fixed = TRUE))
  expect_true(grepl("questionsTraitees.add(Number(q.dataset.question)-1)", html, fixed = TRUE))
  expect_true(grepl("filter(i=>!questionsVues.has(i))", html, fixed = TRUE))
  expect_true(grepl("Math.min(QUESTIONS_PAR_QUIZ,disponibles.length)", html, fixed = TRUE))
  expect_true(grepl("Tu as parcouru toutes les questions disponibles", html, fixed = TRUE))
  expect_false(grepl("cycleBanque", html, fixed = TRUE))
  expect_false(grepl("banque finie de", html, fixed = TRUE))
  expect_false(grepl("etat-banque", html, fixed = TRUE))
})

test_that("une question d ouverture est placee en dernier lorsqu elle est tiree", {
  x = exercices("5E", "fractions", n = 15, seed = 2026, humour_ratio = 0)
  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(x, fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")

  expect_html_contains(
    html,
    'const ouvertures=selection.filter(i=>toutesQuestions[i].dataset.forme==="nommer_notion")',
    "Le quiz doit identifier les questions d ouverture deja presentes dans le tirage."
  )
  expect_html_contains(
    html,
    'tirageCourant=[...normales,...ouvertures]',
    "Une question d ouverture tiree doit etre placee a la fin du quiz."
  )
})

test_that("l humour devient un aparte et ne modifie plus l enonce", {
  sobre = generer_exercice("FRAC_ADD_001", "5E", seed = 2026)
  drole = .ajouter_humour(sobre)

  expect_identical(drole$enonce, sobre$enonce)
  expect_true(isTRUE(drole$qcm$humour))
  expect_true(nzchar(drole$qcm$apart_humour))

  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(list(drole), fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")
  expect_html_contains(html, "apart-humour", "Le HTML doit rendre l aparte humoristique separement.")
  expect_html_contains(html, "&#128518;", "L aparte humoristique doit afficher son emoji.")
  expect_false(grepl("Aparte eduschool", html, fixed = TRUE), info = "Le libelle Aparte eduschool ne doit plus encombrer le quiz.")
})


test_that("le quiz rend les fractions verticalement et place l humour apres les choix", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 4)
  ex$enonce = "Calculer : 4/6"
  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(list(ex), fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")

  expect_html_contains(
    html,
    'class="fraction"',
    "Une ecriture fractionnaire numerique doit etre rendue comme une vraie fraction."
  )
  expect_html_contains(
    html,
    'class="numerateur">4</span><span class="denominateur">6</span>',
    "La fraction 4/6 doit conserver son numerateur et son denominateur."
  )

  pos_enonce = regexpr('class="enonce"', html, fixed = TRUE)[1L]
  pos_proposition = regexpr('class="proposition"', html, fixed = TRUE)[1L]
  pos_humour = regexpr('class="apart-humour"', html, fixed = TRUE)[1L]

  expect_true(pos_enonce > 0L, info = "L enonce doit etre present dans le HTML.")
  expect_true(pos_proposition > pos_enonce, info = "Les propositions doivent venir apres l enonce.")
  expect_true(pos_humour > pos_proposition, info = "La blague doit venir apres les propositions, jamais avant l enonce ou les choix.")
})

test_that("nommer une notion devient un QCM masque et un peu chelou", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 4)

  expect_identical(ex$qcm$forme_question, "nommer_notion")
  expect_identical(ex$qcm$interaction, "qcm")
  expect_length(ex$qcm$propositions, 4L)
  expect_true(all(grepl("^[[:alpha:]]_+[[:alpha:]]$", ex$qcm$propositions)))
  expect_true(any(grepl("^d_+é$", ex$qcm$propositions)))
  expect_true(any(grepl("^Z_+Z$", ex$qcm$propositions)))
  expect_match(ex$qcm$apart_humour, "chelou", fixed = TRUE)
  expect_match(ex$enonce, "Quel mot se cache", fixed = TRUE)
  expect_false(grepl("propri\u00e9t\u00e9", ex$enonce, fixed = TRUE))
  expect_match(ex$correction, "TKT", fixed = TRUE)
  expect_match(ex$correction, "propri\u00e9t\u00e9 math\u00e9matique", fixed = TRUE)
  expect_match(ex$enonce, "\n= ", fixed = TRUE)

  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(list(ex), fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")
  expect_html_contains(html, 'data-interaction="qcm"', "Nommer une notion doit utiliser l interaction QCM.")
  expect_html_contains(html, 'data-forme="nommer_notion"', "Le HTML doit identifier la forme nommer_notion.")
  expect_html_contains(html, "white-space:pre-line", "Le rendu doit conserver les retours a la ligne de l enonce.")
  expect_html_contains(html, "chelou", "Le QCM masque doit conserver son indice humoristique.")
  expect_false(grepl('class="saisie-notion"', html, fixed = TRUE))
  expect_false(grepl("data-answer-b64=", html, fixed = TRUE))
})


test_that("les questions de proportionnalite evitent les irritants de lecture", {
  coefficient = NULL
  tableau = NULL
  for (seed in 1:200) {
    ex = generer_proportion_reconnaitre(seed = seed)
    if (identical(ex$parametres$cas, "coefficient") && is.null(coefficient)) coefficient = ex
    if (identical(ex$parametres$cas, "tableau") && is.null(tableau)) tableau = ex
    if (!is.null(coefficient) && !is.null(tableau)) break
  }
  expect_true(grepl("Par quoi faut-il multiplier le nombre de places", coefficient$enonce, fixed = TRUE))
  expect_false(grepl("Par quel nombre multiplie-t-on toujours le nombre de places", coefficient$enonce, fixed = TRUE))
  expect_identical(tableau$enonce, "Que peut-on dire de ce tableau ?")
  expect_length(tableau$qcm$tableau$lignes, 3L)
  expect_true(all(vapply(tableau$qcm$tableau$lignes, length, integer(1)) == 2L))
})

test_that("le quiz rend les donnees tabulaires en vrai tableau vertical", {
  lot = lapply(1:100, function(seed) generer_proportion_reconnaitre(seed = seed))
  ex = lot[[which(vapply(lot, function(x) identical(x$parametres$cas, "tableau"), logical(1)))[1L]]]
  html = tempfile(fileext = ".html")
  contenu = paste(readLines(produire_quiz(list(ex), fichier = html, ouvrir = FALSE), warn = FALSE), collapse = "\n")
  expect_true(grepl('<table class="tableau-question">', contenu, fixed = TRUE))
  expect_true(grepl('<th>Valeur 1</th><th>Valeur 2</th>', contenu, fixed = TRUE))
  expect_false(grepl("1 -&gt;", contenu, fixed = TRUE))
})

test_that("le tirage du quiz tient compte du contexte", {
  src = .quiz_html()
  expect_true(grepl("const contextes=new Set()", src, fixed = TRUE))
  expect_true(grepl("dataset.contexte", src, fixed = TRUE))
  expect_true(grepl("data-contexte=", src, fixed = TRUE))
})


test_that("la question de quantite evite les irritants de langue", {
  lot = lapply(1:60, function(seed) .varier_forme_fraction(generer_fraction_quantite(seed = seed)))
  complements = lot[vapply(lot, function(x) grepl("Combien en reste-t-il ?", x$enonce, fixed = TRUE), logical(1))]
  expect_true(length(complements) > 0L)
  expect_true(all(vapply(complements, function(x) !grepl("Combien de objets", x$enonce, fixed = TRUE), logical(1))))
  expect_true(all(vapply(complements, function(x) grepl("utilisés", x$correction, fixed = TRUE), logical(1))))
})

test_that("la fin de banque distingue questions vues et traitees", {
  src = .quiz_html()
  expect_html_contains(src, 'const questionsVues=new Set()', "Le quiz doit memoriser les questions deja presentees.")
  expect_html_contains(src, 'filter(i=>!questionsVues.has(i))', "Un nouveau quiz doit d abord puiser parmi les questions jamais vues.")
  expect_html_contains(src, 'tirageCourant.forEach(i=>questionsVues.add(i))', "Une question affichee doit devenir vue meme sans reponse.")
  expect_html_contains(src, 'boutonNouveau.disabled=toutesVues', "Le bouton nouveau quiz doit disparaitre lorsque toute la banque a ete parcourue.")
  expect_html_contains(src, 'if(questionsVues.size>=toutesQuestions.length)return;', "Un clic ne doit jamais recycler silencieusement une banque deja parcourue.")
  expect_html_contains(src, 'Certaines restent sans réponse', "La fin de parcours doit distinguer une question vue d une question traitee.")
})


test_that("le feedback conserve le rendu semantique des fractions", {
  rendu = .html_math("(1/2) x (8/2)")
  expect_html_contains(rendu, '<span class="numerateur">1</span><span class="denominateur">2</span>', "La premiere fraction doit rester 1 sur 2.")
  expect_html_contains(rendu, '<span class="numerateur">8</span><span class="denominateur">2</span>', "La seconde fraction doit rester 8 sur 2.")

  src = .quiz_html()
  expect_html_contains(src, 'querySelector("span").innerHTML', "Le feedback doit reutiliser le HTML mathematique et non aplatir une fraction en 12.")
  expect_false(grepl('querySelector("span").textContent', src, fixed = TRUE))
})

test_that("nommer une notion produit un seul feedback pedagogique", {
  ex = generer_exercice("FRAC_QTE_001", "5E", seed = 4)
  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(list(ex), fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")

  expect_html_contains(html, 'data-reponse="distributivit', "Le vrai mot doit etre disponible pour la revelation apres validation.")
  expect_identical(lengths(regmatches(html, gregexpr('class="feedback-notion"', html, fixed = TRUE))), 1L)
  expect_false(grepl('class="feedback-option"', html, fixed = TRUE))
  expect_html_contains(html, "TKT", "La phrase qui fixe le vocabulaire de propriete doit rester dans le feedback.")
  expect_html_contains(html, 'if(q.dataset.forme==="nommer_notion")', "Le QCM masque doit avoir une branche de feedback dediee.")
  expect_html_contains(html, 'Pas cette fois. Le mot', "Une erreur doit reveler le mot sans proces-verbal du masque choisi.")
})


test_that("la boite de quantite utilise une equation explicite", {
  lot = lapply(1:60, function(seed) .varier_forme_fraction(generer_fraction_quantite(seed = seed)))
  boites = lot[vapply(lot, function(x) identical(x$qcm$forme_question, "boite_a_trou"), logical(1))]
  expect_true(length(boites) > 0L)
  expect_true(all(vapply(boites, function(x) grepl("× □ =", x$enonce, fixed = TRUE), logical(1))))
  expect_true(all(vapply(boites, function(x) !grepl(" de □ =", x$enonce, fixed = TRUE), logical(1))))
  expect_true(all(vapply(boites, function(x) grepl("[[l'\u00e9quation]]", x$correction, fixed = TRUE), logical(1))))
  expect_true(all(vapply(boites, function(x) grepl(".\nPuis on utilise l'op\u00e9ration inverse :\n□ =", x$correction, fixed = TRUE), logical(1))))
})

test_that("une correction peut attirer le regard sur le seul concept mathematique", {
  rendu = .html_correction("Pour r\u00e9pondre, il faut poser [[l'\u00e9quation]] 8/10 x □ = 96.")
  expect_html_contains(rendu, "il faut poser <strong>l'\u00e9quation</strong>", "Seul le concept mathematique doit etre mis en gras.")
  expect_false(grepl("<strong>Pour", rendu, fixed = TRUE))
  expect_html_contains(rendu, 'class="fraction"', "La mise en valeur pedagogique ne doit pas casser le rendu des fractions.")
})

test_that("la division de fractions nomme inverse sans ambiguite typographique", {
  ex = generer_division_fractions(seed = 1)
  expect_true(grepl("\u00e9quivalente \u00e0", ex$enonce, fixed = TRUE))
  expect_true(grepl("[[inverse]]", ex$correction, fixed = TRUE))
  expect_true(grepl("\nCela revient \u00e0 calculer\n", ex$correction, fixed = TRUE))
  expect_false(grepl(" : ", ex$correction, fixed = TRUE))

  rendu = .html_correction(ex$correction)
  expect_html_contains(rendu, "<strong>inverse</strong>", "Le concept inverse doit attirer le regard.")
  expect_html_contains(rendu, 'class="fraction"', "Les fractions doivent conserver leur rendu mathematique.")
})

test_that("une mauvaise reponse affiche une seule explication pedagogique", {
  src = .quiz_html()
  expect_html_contains(src, 'const fExplication=q.querySelector', "Une seule explication doit etre choisie apres validation.")
  expect_html_contains(src, 'if(fExplication)fExplication.style.display="block"', "L explication correcte doit etre affichee une seule fois.")
  expect_false(grepl("choisie-fausse", src, fixed = TRUE))
  expect_false(grepl("feedback-option.attendue", src, fixed = TRUE))
})

test_that("les textes visibles de la division utilisent un francais soigne", {
  ex = generer_division_fractions(seed = 2)
  visible = paste(c(ex$enonce, ex$correction, ex$qcm$rappel, ex$qcm$feedback), collapse = "\n")
  interdits = c("equivalente a", "revient a", "premiere fraction", "doit etre inversee")
  expect_false(any(vapply(interdits, function(x) grepl(x, visible, fixed = TRUE), logical(1))))
  expect_true(grepl("\u00e9quivalente \u00e0", ex$enonce, fixed = TRUE))
  expect_true(grepl("revient \u00e0", ex$correction, fixed = TRUE))
  expect_true(grepl("premi\u00e8re", paste(ex$qcm$feedback, collapse = " "), fixed = TRUE))
})



test_that("l addition de fractions explique sans ponctuation punitive", {
  ex = generer_addition_fractions(seed = 1)
  expect_true(grepl("[[d\u00e9nominateur commun]]", ex$correction, fixed = TRUE))
  expect_true(grepl(".\n(", ex$correction, fixed = TRUE))
  expect_false(grepl("commun :", ex$correction, fixed = TRUE))

  rendu = .html_correction(ex$correction)
  expect_html_contains(rendu, "<strong>d\u00e9nominateur commun</strong>", "Le concept de denominateur commun doit attirer le regard.")
})

test_that("une mauvaise reponse ne repete pas la proposition attendue", {
  src = .quiz_html()
  expect_html_contains(src, '`Pas cette fois.`', "Le feedback negatif doit rester neutre avant l explication pedagogique.")
  expect_false(grepl("La r\\u00e9ponse attendue est ${correcte}", src, fixed = TRUE))
})

test_that("les propositions et blagues de fractions gardent leurs accents", {
  ex = generer_addition_fractions(seed = 1)
  visible = paste(c(ex$enonce, ex$reponse, ex$correction, ex$qcm$propositions, ex$qcm$feedback), collapse = "\n")
  expect_false(grepl("denominateur", visible, fixed = TRUE))
  expect_true(grepl("d\u00e9nominateur", visible, fixed = TRUE))

  humour = paste(unlist(.catalogue_humour, use.names = FALSE), collapse = "\n")
  expect_false(grepl("numerateurs", humour, fixed = TRUE))
  expect_false(grepl("piege", humour, fixed = TRUE))
  expect_false(grepl("idee", humour, fixed = TRUE))
  expect_true(grepl("num\u00e9rateurs", humour, fixed = TRUE))
  expect_true(grepl("pi\u00e8ge", humour, fixed = TRUE))
  expect_true(grepl("id\u00e9e", humour, fixed = TRUE))
})

test_that("une fraction composee est rendue comme une seule fraction visuelle", {
  rendu = .html_math("(1 x 1)/(2 x 2) = 1/4")
  expect_html_contains(rendu, '<span class="numerateur">(1 x 1)</span>', "Le produit du numerateur doit rester au-dessus de la barre.")
  expect_html_contains(rendu, '<span class="denominateur">(2 x 2)</span>', "Le produit du denominateur doit rester sous la barre.")
  expect_identical(lengths(regmatches(rendu, gregexpr('class="fraction"', rendu, fixed = TRUE))), 2L)
  expect_false(grepl("(1 x 1)/(2 x 2)", rendu, fixed = TRUE))
})

test_that("la correction du produit separe explication et calcul", {
  ex = generer_multiplication_fractions(seed = 1)
  expect_true(grepl("d\u00e9nominateurs.\n", ex$correction, fixed = TRUE))
  expect_false(grepl("d\u00e9nominateurs :", ex$correction, fixed = TRUE))
  rendu = .html_correction(ex$correction)
  expect_html_contains(rendu, 'class="numerateur">(', "Le calcul compose doit etre structure comme une fraction.")
})

test_that("les textes enfant du parcours fractions conservent accents et apostrophes", {
  notion = generer_exercice("FRAC_QTE_001", "5E", seed = 4)
  expect_match(notion$enonce, "derrière l'idée mathématique utilisée", fixed = TRUE)
  expect_match(notion$correction, "C'est le nom d'une propriété mathématique", fixed = TRUE)
  expect_match(notion$correction, "ce qu'est une propriété mathématique", fixed = TRUE)

  equivalence = generer_fraction_equivalente(seed = 1)
  expect_match(equivalence$enonce, "égale à", fixed = TRUE)

  comparaison = generer_fraction_comparer(seed = 1)
  expect_match(comparaison$enonce, "complète correctement", fixed = TRUE)
  expect_true(any(grepl("données", comparaison$qcm$feedback, fixed = TRUE)))
})

test_that("le rendu mathematique commun transforme les exposants entiers simples", {
  rendu = .html_math("x^2 + 10^-3 + 1/2")
  expect_html_contains(rendu, "x<sup>2</sup>", "Un carre doit etre rendu comme un exposant HTML.")
  expect_html_contains(rendu, "10<sup>-3</sup>", "Un exposant entier negatif doit etre rendu en HTML.")
  expect_html_contains(rendu, 'class="fraction"', "Le rendu des exposants ne doit pas casser celui des fractions.")
})


test_that("le RETEX fractions garde Lea et reclamer correctement accentues", {
  expect_true("L\u00e9a" %in% .personnages_exercices)

  humour = paste(unlist(.catalogue_humour["FRAC_QTE_001"], use.names = FALSE), collapse = "\n")
  expect_match(humour, "r\u00e9clamer", fixed = TRUE)
})


test_that("le pilote Pythagore rend visible voir sans confondre avec savoir", {
  ex = generer_exercice("PYTH_APPL_001", "4E", seed = 123)
  fichier = tempfile(fileext = ".html")
  html = paste(readLines(produire_quiz(list(ex), fichier = fichier, ouvrir = FALSE), warn = FALSE), collapse = "\n")

  expect_gte(length(gregexpr("figure-qcm", html, fixed = TRUE)[[1L]]), 2L)
  expect_match(html, "angle droit codé en A", fixed = TRUE)
  expect_match(html, "Le codage indique", fixed = TRUE)
  expect_match(html, "son apparence ne suffit pas.\n<strong>Je sais</strong>", fixed = TRUE)
  expect_match(html, 'aria-label="Question 1">1.</span>', fixed = TRUE)
  expect_match(html, "La r\u00e9ponse \u00e9tait donc : &laquo; Le codage indique", fixed = TRUE)
})
