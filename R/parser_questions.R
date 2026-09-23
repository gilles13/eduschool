#' Lire une banque de questions
#'
#' @param fichier Fichier Markdown contenant les questions.
#'
#' @return Une liste de questions structurees.
#' @export
parser_questions = function(fichier) {
  lignes = readLines(fichier, encoding = "UTF-8")

  i_notion = grep("^# NOTION\\s*:", lignes)
  i_type = grep("^## TYPE\\s*:", lignes)
  i_question = grep("^### QUESTION\\b", lignes)

  lire_bloc = function(debut, fin, titre) {
    i = seq.int(debut + 1L, fin)
    entete = grep(paste0("^#### ", titre, "\\s*$"), lignes[i])

    if (!length(entete)) return(NA_character_)

    debut_bloc = i[entete[1L]] + 1L
    suivants = grep("^#### ", lignes)
    suivants = suivants[suivants > debut_bloc & suivants <= fin]
    fin_bloc = if (length(suivants)) suivants[1L] - 1L else fin

    contenu = trimws(lignes[seq.int(debut_bloc, fin_bloc)])
    contenu = contenu[nzchar(contenu)]
    if (!length(contenu)) return(NA_character_)

    paste(contenu, collapse = "\n")
  }

  lire_parametres = function(debut, fin) {
    texte = lire_bloc(debut, fin, "PARAMETRES")
    if (is.na(texte)) return(list())

    expressions = parse(text = texte)

    setNames(
      lapply(expressions, function(x) {
        paste(deparse(x[[3L]]), collapse = "\n")
      }),
      vapply(expressions, function(x) as.character(x[[2L]]), character(1))
    )
  }

  lire_distracteurs = function(debut, fin) {
    texte = lire_bloc(debut, fin, "DISTRACTEURS")
    if (is.na(texte)) return(character())

    lignes = trimws(strsplit(texte, "\n", fixed = TRUE)[[1L]])
    lignes[nzchar(lignes)]
  }

  i_structure = grep("^#{1,3} ", lignes)
  fins = vapply(i_question, function(i) {
    suivant = i_structure[i_structure > i]
    if (length(suivant)) suivant[1L] - 1L else length(lignes)
  }, integer(1))

  lapply(seq_along(i_question), function(k) {
    i = i_question[k]
    fin = fins[k]
    apres = which(seq_along(lignes) > i & nzchar(trimws(lignes)))

    list(
      notion = sub(
        "^# NOTION\\s*:\\s*", "",
        lignes[i_notion[findInterval(i, i_notion)]]
      ),
      type = sub(
        "^## TYPE\\s*:\\s*", "",
        lignes[i_type[findInterval(i, i_type)]]
      ),
      question = trimws(lignes[min(apres)]),
      parametres = lire_parametres(i, fin),
      calcul = lire_bloc(i, fin, "CALCUL"),
      moteur = lire_bloc(i, fin, "MOTEUR"),
      distracteurs = lire_distracteurs(i, fin)
    )
  })
}
