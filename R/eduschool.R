# Point d'entree pour decouvrir le projet et ses principales fonctions.

#' Decouvrir eduschool
#'
#' Presente les principales portes d'entree du package.
#' Les ressources scolaires historiques ne garantissent pas l'actualite
#' des programmes officiels.
#' @return Invisiblement, une liste des fonctions par usage.
#' @export
eduschool = function() {
  groupes = list(
    "D\u00e9couvrir eduschool" = c("eduschool()", "produire_cheatsheet()"),
    "Explorer le syst\u00e8me scolaire" = c("voies()", "series()",
      "maths_programmes()", "maths_parcours()"),
    "Produire des maths" = c("notions()", "questions()", "question()",
      "produire()", "graphique()", "illustrer_question()",
      "table_multiplication()")
  )
  cat("eduschool : comprendre, explorer et pratiquer les math\u00e9matiques\n")
  cat("Projet libre, gratuit et ouvert. Toujours ouvrir des portes.\n\n")
  for (nom in names(groupes)) {
    cat(nom, ":\n", sep = "")
    cat("  ", paste(groupes[[nom]], collapse = "  |  "), "\n\n", sep = "")
  }
  cat("Pour commencer : notions() puis produire(notion = \"addition_fractions\",\n",
      "  support = \"quiz\", format = \"html\")\n", sep = "")
  cat("Guide imprimable : produire_cheatsheet()\n")
  invisible(groupes)
}
