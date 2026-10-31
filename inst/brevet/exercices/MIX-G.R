construire_exercice = function(env, dossier, sujet) {
  source("inst/brevet/charger.R", local = TRUE)
  e = charger_exercice_brevet(sujet)
  d = e$donnees
  r = e$resultats
  points = e$points
  jl = d$juniors_licencies
  jn = d$juniors_non_licencies
  sl = d$seniors_licencies
  sn = d$seniors_non_licencies
  donnees = data.frame(categorie = rep(c("Juniors", "Seniors"), each = 2), statut = rep(c("Licenci\u00e9s", "Non licenci\u00e9s"), 2), effectif = c(jl, jn, sl, sn))
  p = ggplot2::ggplot(donnees, ggplot2::aes(x = categorie, y = effectif, fill = statut)) + ggplot2::geom_col(position = ggplot2::position_dodge(width = .8), width = .7) + ggplot2::geom_text(ggplot2::aes(label = effectif), position = ggplot2::position_dodge(width = .8), vjust = -.4) + ggplot2::labs(title = "R\u00e9partition du tournoi", x = "Cat\u00e9gorie", y = "Participants", fill = "Statut") + ggplot2::theme_minimal(base_size = 14)
  figure = file.path(dossier, paste0(sujet, ".png"))
  dir.create(dossier, recursive = TRUE, showWarnings = FALSE)
  ragg::agg_png(figure, width = 1200, height = 750, res = 150)
  tryCatch(print(p), finally = grDevices::dev.off())
  enonce = sprintf("Un tournoi compte deux cat\u00e9gories. Voici les inscrits :\n\n| Cat\u00e9gorie | Licenci\u00e9s | Non licenci\u00e9s |\n|:--|--:|--:|\n| Juniors | %s | %s |\n| Seniors | %s | %s |", jl, jn, sl, sn)
  q = c("Compl\u00e9ter les totaux par ligne, par colonne et le total g\u00e9n\u00e9ral du tableau.", "On choisit au hasard un participant parmi tous les inscrits. Quelle est la probabilit\u00e9 qu'il soit licenci\u00e9 ?", "On choisit maintenant au hasard un participant parmi les juniors uniquement. Quelle est la probabilit\u00e9 qu'il soit licenci\u00e9 ?", "Comparer la proportion de licenci\u00e9s chez les juniors et chez les seniors. Un organisateur affirme qu'elles sont identiques. A-t-il raison ? Justifier.")
  correction = paste("## Corrig\u00e9 - MIX-G", sprintf("1. Juniors : %s ; seniors : %s ; licenci\u00e9s : %s ; non licenci\u00e9s : %s ; total : %s.", jl+jn, sl+sn, jl+sl, jn+sn, r$total), sprintf("2. $$P=\\frac{%s}{%s}.$$", r$licencies, r$total), sprintf("3. Parmi les juniors : $$P=\\frac{%s}{%s}.$$", jl, jl+jn), sprintf("4. Juniors : %s %% ; seniors : %s %%. L'affirmation est fausse.", r$part_junior, r$part_senior), sep = "\n\n")
  questions = paste0(seq_along(q), ". ", q, " **(", points, " point", ifelse(points == 1, "", "s"), ")**", collapse = "\n\n")
  list(id = sujet, enonce = enonce, questions = questions, correction = correction, points = points, total_points = e$total_points, figure = figure)
}
