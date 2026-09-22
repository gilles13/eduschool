# Examens et composition de sujets

#' Examens modelises
#'
#' @param code Code d'examen facultatif, par exemple `"DNB"`.
#' @param session Session facultative.
#' @return Un data.frame.
#' @export
examens = function(code = NULL, session = NULL) {
  x = .lire_csv("examens", "examens.csv")
  if (!is.null(code)) x = x[x$code %in% code, , drop = FALSE]
  if (!is.null(session)) x = x[x$session %in% as.character(session), , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Decrire un examen
#'
#' @param code Code de l'examen.
#' @param session Session de l'examen.
#' @return Une ligne du referentiel des examens.
#' @export
examen = function(code, session) {
  x = examens(code = code, session = session)
  if (!nrow(x)) {
    stop("Examen inconnu : ", code, " (session ", session, ")", call. = FALSE)
  }
  if (nrow(x) > 1L) {
    stop("Plusieurs examens correspondent a cette selection.", call. = FALSE)
  }
  x
}

#' Structure d'un examen
#'
#' Retourne l'examen et ses parties officielles modelisees dans eduschool.
#'
#' @param code Code de l'examen.
#' @param session Session de l'examen.
#' @return Une liste contenant `examen` et `parties`.
#' @export
structure_examen = function(code, session) {
  ex = examen(code, session)
  parties = .lire_csv("examens", "parties_examen.csv")
  parties = parties[parties$examen_id == ex$examen_id[[1]], , drop = FALSE]
  parties = parties[order(as.integer(parties$ordre)), , drop = FALSE]
  rownames(parties) = NULL

  list(examen = ex, parties = parties)
}
