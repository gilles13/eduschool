source("inst/brevet/controles/audit_trigo.R")
source("inst/brevet/controles/audit_fonc.R")
source("inst/brevet/controles/audit_fonc_b.R")
source("inst/brevet/controles/audit_algo.R")
source("inst/brevet/controles/audit_algo_b.R")
source("inst/brevet/controles/audit_prop.R")
source("inst/brevet/controles/audit_prop_b.R")
source("inst/brevet/controles/audit_geo_a.R")
source("inst/brevet/controles/audit_stat.R")
source("inst/brevet/controles/audit_proba.R")
source("inst/brevet/controles/audit_eq.R")
source("inst/brevet/controles/audit_mix.R")
source("inst/brevet/controles/audit_mix_b.R")
source("inst/brevet/controles/audit_mix_c.R")
source("inst/brevet/controles/audit_mix_d.R")
source("inst/brevet/controles/audit_mix_d.R")
audit_brevet = function(racine = "inst/brevet/data") {
  fichiers = list.files(racine, pattern = "\\.json$", full.names = TRUE)
  if (!length(fichiers)) stop("Aucun JSON de brevet")
  lignes = list()
  ajouter = function(id, famille, controle, attendu, calcule, statut, message = "") {
    lignes[[length(lignes) + 1L]] <<- data.frame(id = id, famille = famille, controle = controle, attendu = as.character(attendu), calcule = as.character(calcule), statut = statut, message = message)
  }
  comparer = function(id, famille, controle, attendu, calcule) {
    valide = length(attendu) == 1L && length(calcule) == 1L && !is.null(attendu) && !is.null(calcule) && !is.na(attendu) && !is.na(calcule)
    ok = valide && if (is.numeric(attendu) && is.numeric(calcule)) isTRUE(all.equal(attendu, calcule, tolerance = 1e-9)) else identical(attendu, calcule)
    ajouter(id, famille, controle, if (length(attendu) == 1L) attendu else NA, if (length(calcule) == 1L) calcule else NA, if (ok) "OK" else "ERREUR")
  }
  ids = character()
  for (fichier in fichiers) {
    x = jsonlite::read_json(fichier, simplifyVector = FALSE)
    famille = x$famille
    if (is.null(famille) || is.null(x$exercices)) {
      ajouter(basename(fichier), "", "structure", NA, NA, "ERREUR")
      next
    }
    for (e in x$exercices) {
      id = e$id
      if (is.null(id)) {
        ajouter(basename(fichier), famille, "identifiant", NA, NA, "ERREUR")
        next
      }
      # Contrat commun : donnees = parametres nommes, valeurs atomiques ou tableaux simples.
      if (!is.list(e$donnees) || is.null(names(e$donnees)) || any(!nzchar(names(e$donnees))) || anyDuplicated(names(e$donnees))) {
        ajouter(id, famille, "donnees_nommees", "noms uniques et non vides", "invalide", "ERREUR")
      } else {
        for (cle in names(e$donnees)) {
          valeur = e$donnees[[cle]]
          if (is.list(valeur) && (!is.null(names(valeur)) || any(vapply(valeur, is.list, logical(1))))) {
            ajouter(id, famille, paste0("donnee_structure_", cle), "scalaire ou tableau simple", "objet ou tableau imbrique", "ERREUR")
          } else if (is.list(valeur) && length(valeur) && length(unique(vapply(valeur, typeof, character(1)))) != 1L) {
            ajouter(id, famille, paste0("donnee_type_", cle), "tableau homogene", "types melanges", "ERREUR")
          }
        }
      }
      if (!is.list(e$resultats) || is.null(names(e$resultats)) || any(!nzchar(names(e$resultats))) || anyDuplicated(names(e$resultats))) ajouter(id, famille, "resultats_nommes", "noms uniques et non vides", "invalide", "ERREUR")
      if (id %in% ids) ajouter(id, famille, "collision_identifiant", "unique", "doublon", "ERREUR")
      ids = c(ids, id)
      if (!startsWith(id, paste0(famille, "-"))) ajouter(id, famille, "famille_identifiant", famille, id, "ERREUR")
      refs = unlist(lapply(e$questions, function(q) c(q$resultat, unlist(q$resultats))), use.names = FALSE)
      for (cle in setdiff(refs, names(e$resultats))) ajouter(id, famille, paste0("reference_", cle), "presente", "absente", "ERREUR")
      for (cle in setdiff(names(e$resultats), refs)) ajouter(id, famille, paste0("resultat_auxiliaire_", cle), "", "", "INFO")
      numeros = vapply(e$questions, function(q) as.integer(q$numero), integer(1))
      if (!identical(numeros, seq_along(numeros))) ajouter(id, famille, "numerotation", "1..n", paste(numeros, collapse = ","), "ERREUR")
      bareme = vapply(e$questions, \(q) if (is.null(q$points)) NA_real_ else as.numeric(q$points), numeric(1))
      if (any(!is.finite(bareme)) || any(bareme < 0)) ajouter(id, famille, "bareme", "points positifs ou nuls", paste(bareme, collapse = ","), "ERREUR")
      if (sum(bareme, na.rm = TRUE) <= 0) ajouter(id, famille, "total_points", "strictement positif", sum(bareme, na.rm = TRUE), "ERREUR")
      if (identical(famille, "MIX-A")) audit_mix(e, comparer, ajouter) else if (identical(famille, "MIX-B")) audit_mix_b(e, comparer, ajouter) else if (identical(famille, "MIX-C")) audit_mix_c(e, comparer, ajouter) else if (identical(famille, "MIX-D")) audit_mix_d(e, comparer, ajouter) else if (identical(famille, "MIX-D")) audit_mix_d(e, comparer, ajouter) else if (grepl("^EQ-[ABC]$", famille)) audit_eq(e, comparer, ajouter) else if (grepl("^TRIGO-[ABC]$", famille)) audit_trigo(e, comparer, ajouter) else if (grepl("^GEO-[A-Z]$", famille)) audit_geo_a(e, comparer, ajouter) else if (grepl("^STAT-[A-Z]$", famille)) audit_stat(e, comparer, ajouter) else if (grepl("^PROBA-[A-Z]$", famille)) audit_proba(e, comparer, ajouter) else if (identical(famille, "ALGO-A")) audit_algo(e, comparer, ajouter) else if (identical(famille, "ALGO-B")) audit_algo_b(e, comparer, ajouter) else if (identical(famille, "PROP-A")) audit_prop(e, comparer, ajouter) else if (identical(famille, "PROP-B")) audit_prop_b(e, comparer, ajouter) else if (identical(famille, "FONC-A")) audit_fonc(e, comparer, ajouter) else if (identical(famille, "FONC-B")) audit_fonc_b(e, comparer, ajouter) else ajouter(id, famille, "couverture", NA, NA, "NON_VERIFIE")
    }
  }
  if (!length(lignes)) return(data.frame())
  resultat = do.call(rbind, lignes)
  rownames(resultat) = NULL
  resultat
}

rapport_audit_brevet = function(
  resultats = audit_brevet(),
  fichier = "/tmp/eduschool-audit-brevet.html",
  ouvrir = TRUE
) {
  if (!nrow(resultats)) stop("Aucun resultat d'audit")
  statuts = table(factor(resultats$statut, levels = c("OK", "ERREUR", "NON_VERIFIE", "INFO")))
  resume = paste(sprintf("%s : %s", names(statuts), as.integer(statuts)), collapse = " | ")
  tableau = DT::datatable(
    resultats,
    rownames = FALSE,
    filter = "top",
    extensions = "Buttons",
    caption = htmltools::tags$caption(
      style = "caption-side:top;text-align:left;font-size:16px;padding:12px;",
      htmltools::tags$strong("Audit des exercices du brevet"),
      htmltools::tags$div(resume)
    ),
    options = list(
      pageLength = 25,
      autoWidth = TRUE,
      scrollX = TRUE,
      dom = "Bfrtip",
      buttons = c("copy", "csv"),
      order = list(list(0, "asc"), list(2, "asc"))
    )
  )
  tableau = DT::formatStyle(
    tableau,
    "statut",
    target = "row",
    backgroundColor = DT::styleEqual(
      c("OK", "ERREUR", "NON_VERIFIE", "INFO"),
      c("#edf7ed", "#fce8e6", "#fff4d6", "#eef2f7")
    )
  )
  dir.create(dirname(fichier), recursive = TRUE, showWarnings = FALSE)
  htmlwidgets::saveWidget(tableau, fichier, selfcontained = TRUE)
  if (ouvrir) utils::browseURL(fichier)
  invisible(resultats)
}
