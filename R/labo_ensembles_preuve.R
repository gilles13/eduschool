#' Labo : de la conjecture a la demonstration
#'
#' Propose cinq QCM pour distinguer exemple, conjecture, contre-exemple et
#' demonstration. Le parcours part de la reflexivite de l'inclusion puis
#' demande ce qui permet, ou non, d'etablir une affirmation universelle.
#'
#' @param seed Graine facultative utilisee pour melanger les propositions.
#' @return Une liste de cinq exercices eduschool munis d'un QCM.
#' @examples
#' \dontrun{
#' exercices_ensembles_preuve(seed = 2026) |>
#'   produire_quiz(titre = "Comment sais-tu que c'est vrai ?")
#' }
#' @export
exercices_ensembles_preuve = function(seed = NULL) {
  graines = if (is.null(seed)) rep(list(NULL), 5L) else as.list(seed + 0:4)

  qcm = function(modele_id, enonce, reponse, propositions, feedback,
                 intention, graine) {
    x = .qcm_ensembles(
      modele_id = modele_id,
      enonce = enonce,
      reponse = reponse,
      propositions = propositions,
      feedback = feedback,
      intention = intention,
      seed = graine
    )
    x$qcm$notion = "Conjecturer, verifier, demontrer"
    x$qcm$rappel = paste0(
      "Un exemple permet d'observer. Une conjecture demande encore a etre ",
      "mise a l'epreuve."
    )
    x
  }

  list(
    qcm(
      "ENS_PREUVE_CONJECTURE_001",
      paste0(
        "Mister Peniblou observe A = {1, 2, 3}, B = {4, 7}, C = {} et D = {42}. ",
        "Dans chaque cas, il constate E \u2286 E. Qu'a-t-il etabli a ce stade ?"
      ),
      "Une conjecture appuyee par plusieurs exemples",
      c(
        "Une conjecture appuyee par plusieurs exemples",
        "Une demonstration valable pour tout ensemble",
        "Un contre-exemple a E \u2286 E",
        "La preuve que seuls ces quatre ensembles verifient E \u2286 E"
      ),
      c(
        "Les exemples soutiennent l'idee generale, mais ils ne couvrent pas tous les ensembles : on peut conjecturer.",
        "Quatre cas, meme tous vrais, ne suffisent pas a etablir une affirmation portant sur tous les ensembles.",
        "Un contre-exemple devrait etre un ensemble pour lequel E \u2286 E est faux ; aucun n'a ete trouve ici.",
        "Observer quatre ensembles ne permet pas d'affirmer que les autres ne verifient pas la propriete."
      ),
      "observer-puis-conjecturer", graines[[1L]]
    ),
    qcm(
      "ENS_PREUVE_MILLE_001",
      "Il teste ensuite 1000 ensembles differents et trouve encore E \u2286 E a chaque fois. Que peut-il conclure ?",
      "Il a davantage d'indices, mais toujours pas une demonstration generale",
      c(
        "Il a davantage d'indices, mais toujours pas une demonstration generale",
        "1000 exemples transforment automatiquement la conjecture en theoreme",
        "Il suffit maintenant de tester un dernier ensemble",
        "La propriete est vraie parce qu'aucun contre-exemple n'a ete trouve"
      ),
      c(
        "Multiplier les exemples renforce l'observation, mais une affirmation universelle concerne aussi les cas non testes.",
        "Le nombre d'exemples ne transforme pas a lui seul une verification finie en demonstration universelle.",
        "Apres 1001 exemples, il resterait encore des ensembles non testes : le probleme logique serait le meme.",
        "Ne pas avoir trouve de contre-exemple dans une liste finie ne prouve pas qu'il n'en existe aucun."
      ),
      "distinguer-verification-preuve", graines[[2L]]
    ),
    qcm(
      "ENS_PREUVE_DEFINITION_001",
      paste0(
        "On veut maintenant demontrer que tout ensemble E est inclus dans lui-meme. ",
        "Quelle idee utilise directement la definition de l'inclusion ?"
      ),
      "Prendre un element quelconque x de E et constater que x appartient a E",
      c(
        "Prendre un element quelconque x de E et constater que x appartient a E",
        "Tester beaucoup d'ensembles E choisis au hasard",
        "Verifier seulement E = {1, 2, 3}",
        "Chercher un ensemble ayant le plus grand nombre possible d'elements"
      ),
      c(
        "Pour montrer E \u2286 E, il faut montrer que tout element de E appartient a E. Un element quelconque x de E satisfait precisement cette condition.",
        "Des essais supplementaires donnent des exemples, pas une justification valable pour un ensemble quelconque.",
        "Ce cas particulier verifie la propriete, mais ne traite pas un ensemble E quelconque.",
        "La taille de E n'intervient pas dans la definition : l'inclusion se verifie element par element."
      ),
      "demontrer-par-definition", graines[[3L]]
    ),
    qcm(
      "ENS_PREUVE_CONTREEXEMPLE_001",
      "Mister Peniblou affirme : tout entier naturel strictement superieur a 1 est premier. Quel nombre suffit a refuter cette affirmation ?",
      "4",
      c("4", "2", "3", "5"),
      c(
        "4 est strictement superieur a 1 et n'est pas premier, car 4 = 2 \u00d7 2. C'est un contre-exemple.",
        "2 est strictement superieur a 1, mais il est premier : il confirme l'affirmation dans ce cas.",
        "3 est strictement superieur a 1, mais il est premier : il ne refute pas l'affirmation.",
        "5 est strictement superieur a 1, mais il est premier : il ne refute pas l'affirmation."
      ),
      "chercher-un-contre-exemple", graines[[4L]]
    ),
    qcm(
      "ENS_PREUVE_ASYMETRIE_001",
      "Quelle phrase decrit correctement le role d'un contre-exemple face a une affirmation portant sur tous les objets ?",
      "Un seul contre-exemple suffit a montrer que l'affirmation universelle est fausse",
      c(
        "Un seul contre-exemple suffit a montrer que l'affirmation universelle est fausse",
        "Un seul exemple favorable suffit a montrer que l'affirmation universelle est vraie",
        "Un contre-exemple montre seulement que l'affirmation est probablement fausse",
        "Il faut autant de contre-exemples que d'exemples favorables"
      ),
      c(
        "Une affirmation universelle dit que la propriete vaut pour chaque objet : un seul objet qui ne la verifie pas suffit donc a la refuter.",
        "Un exemple favorable ne traite qu'un cas ; il ne dit rien, a lui seul, sur tous les autres.",
        "Si l'objet respecte les conditions de l'affirmation et contredit sa conclusion, la refutation est certaine, pas seulement probable.",
        "Le nombre d'exemples favorables ne fixe pas un quota de contre-exemples : un seul cas valide qui contredit l'affirmation suffit."
      ),
      "comprendre-le-contre-exemple", graines[[5L]]
    )
  )
}
