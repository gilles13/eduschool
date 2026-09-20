# ============================================================
# Boussole interne du package
# ============================================================

.normaliser_recherche_outils = function(x) {
  x = iconv(as.character(x), from = "", to = "ASCII//TRANSLIT")
  x = tolower(x)
  gsub("[^a-z0-9]+", " ", x)
}

.tests_outils_eduschool = function(root, fonctions) {
  repertoire = file.path(root, "tests", "testthat")
  fichiers = sort(list.files(repertoire, pattern = "^test.*[.]R$", full.names = TRUE))
  if (!length(fichiers)) return(rep("", length(fonctions)))

  appels = lapply(fichiers, function(fichier) {
    tryCatch(
      unique(all.names(parse(fichier), functions = TRUE)),
      error = function(e) character()
    )
  })

  vapply(fonctions, function(fonction) {
    trouves = basename(fichiers[vapply(
      appels,
      function(x) fonction %in% x,
      logical(1)
    )])
    paste(trouves, collapse = "; ")
  }, character(1))
}

.ressources_outils_eduschool = function(root, fichier, indices, fonctions) {
  repertoire = file.path(root, "inst")
  if (!dir.exists(repertoire)) return(rep("", length(fonctions)))

  ressources = sort(list.files(repertoire, recursive = TRUE, full.names = FALSE))
  if (!length(ressources)) return(rep("", length(fonctions)))

  lignes = readLines(fichier, warn = FALSE, encoding = "UTF-8")
  fins = c(indices[-1L] - 1L, length(lignes))

  vapply(seq_along(fonctions), function(j) {
    bloc = paste(lignes[indices[[j]]:fins[[j]]], collapse = "\n")
    chaines = regmatches(
      bloc,
      gregexpr('(["\'])([^"\'\n]+)\\1', bloc, perl = TRUE)
    )[[1L]]
    if (!length(chaines) || identical(chaines, character(0))) return("")

    chaines = substring(chaines, 2L, nchar(chaines) - 1L)
    trouvees = ressources[vapply(ressources, function(ressource) {
      any(
        chaines == basename(ressource) |
          chaines == ressource |
          endsWith(ressource, paste0("/", chaines))
      )
    }, logical(1))]
    paste(trouvees, collapse = "; ")
  }, character(1))
}

.inventaire_outils_eduschool = function(root) {
  fichiers = sort(list.files(file.path(root, "R"), pattern = "\\.R$", full.names = TRUE))
  namespace = readLines(file.path(root, "NAMESPACE"), warn = FALSE, encoding = "UTF-8")
  exports = sub("^export\\(([^)]+)\\)$", "\\1", grep("^export\\([^)]+\\)$", namespace, value = TRUE))

  morceaux = lapply(fichiers, function(fichier) {
    lignes = readLines(fichier, warn = FALSE, encoding = "UTF-8")
    indices = grep("^[.]?[[:alnum:]_]+[[:space:]]*=[[:space:]]*function\\b", lignes)
    if (!length(indices)) return(NULL)

    fonctions = sub("[[:space:]]*=.*$", "", lignes[indices])
    ressources = .ressources_outils_eduschool(root, fichier, indices, fonctions)

    lapply(seq_along(indices), function(j) {
      i = indices[[j]]
      fonction = fonctions[[j]]
      debut = i - 1L
      while (debut >= 1L && grepl("^#'", lignes[[debut]])) debut = debut - 1L
      bloc = if (debut < i - 1L) lignes[(debut + 1L):(i - 1L)] else character()
      titre = bloc[grepl("^#'[^@]", bloc)]
      usage = if (length(titre)) trimws(sub("^#'[[:space:]]?", "", titre[[1L]])) else ""
      data.frame(
        fonction = fonction,
        fichier = file.path("R", basename(fichier)),
        usage = usage,
        publique = fonction %in% exports,
        ressources = ressources[[j]],
        stringsAsFactors = FALSE
      )
    })
  })

  morceaux = unlist(morceaux, recursive = FALSE)
  if (!length(morceaux)) {
    return(data.frame(
      fonction = character(), fichier = character(), usage = character(),
      publique = logical(), ressources = character(), tests = character(),
      stringsAsFactors = FALSE
    ))
  }
  x = do.call(rbind, morceaux)
  x$tests = .tests_outils_eduschool(root, x$fonction)
  x
}

.chercher_outils_eduschool = function(x, texte = NULL, internes = FALSE) {
  if (!isTRUE(internes)) x = x[x$publique, , drop = FALSE]

  if (!is.null(texte)) {
    if (!length(texte) || anyNA(texte) || !all(nzchar(trimws(as.character(texte))))) {
      stop("`texte` doit contenir au moins un fragment non vide.", call. = FALSE)
    }
    corpus = .normaliser_recherche_outils(paste(
      x$fonction, x$fichier, x$usage, x$ressources, x$tests
    ))
    motifs = .normaliser_recherche_outils(texte)
    keep = Reduce(`|`, lapply(motifs, function(motif) {
      mots = strsplit(trimws(motif), " +")[[1L]]
      Reduce(`&`, lapply(mots, function(mot) grepl(mot, corpus, fixed = TRUE)))
    }))
    x = x[keep, , drop = FALSE]
  }

  x = x[order(x$fichier, x$fonction), , drop = FALSE]
  rownames(x) = NULL
  x
}

#' Retrouver les outils eduschool dans le code source
#'
#' `outils_eduschool()` sert de boussole dans l'arbre source du package. Elle
#' retrouve les fonctions a partir de leur nom, de leur fichier ou du premier
#' titre roxygen qui les documente. L'inventaire est derive du code et du
#' `NAMESPACE` : il n'ajoute donc pas de catalogue manuel a maintenir.
#'
#' Sans texte, la fonction retourne l'inventaire des fonctions publiques.
#'
#' @param texte Mot ou fragment a rechercher, par exemple `"ensembles"`,
#'   `"quiz"` ou `"revision"`. `NULL` retourne tout l'inventaire demande.
#' @param internes Inclure les fonctions internes. `FALSE` par defaut.
#' @return Un `data.frame` avec la fonction, son fichier source, son usage
#'   documentaire, son caractere public ou interne, les ressources de `inst/`
#'   qu'elle reference et les fichiers de tests qui l'appellent explicitement.
#' @examples
#' \dontrun{
#' outils_eduschool("ensembles")
#' outils_eduschool("quiz", internes = TRUE)
#' }
#' @export
outils_eduschool = function(texte = NULL, internes = FALSE) {
  root = .eduschool_dev_root()
  if (is.null(root)) {
    stop(
      "`outils_eduschool()` s'utilise depuis l'arbre source du package eduschool.",
      call. = FALSE
    )
  }
  x = .inventaire_outils_eduschool(root)
  .chercher_outils_eduschool(x, texte = texte, internes = internes)
}

#' @rdname outils_eduschool
#' @export
jairangeoubordel = function(texte = NULL, internes = FALSE) {
  outils_eduschool(texte = texte, internes = internes)
}
