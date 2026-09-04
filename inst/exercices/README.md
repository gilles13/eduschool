# Générateur d’exercices de mathématiques

La V0.9.5 introduit un premier moteur volontairement simple et reproductible. R reste la couche d’orchestration : les paramètres sont construits de façon contrôlée, la réponse est connue par construction, puis la correction est générée. Aucun CAS n’est requis pour ces premiers modèles.

Le catalogue `modeles.csv` décrit les modèles et `modeles_capacites.csv` les rattache à des `item_id` de type `CAPACITE`. Les fonctions sont dans `R/30_exercices/`.

Exemples après `source("R/97_session_dev.R")` :

```r
selectionner_modeles("6E")

ex = generer_exercice(
  modele_id = "FRAC_QTE_001",
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C07",
  difficulte = 1,
  seed = 42
)

ex$enonce
ex$correction

fiche = generer_fiche("6E", n = 12, difficulte = 1, seed = 2026)
rendre_tex_exercices(fiche, "fiche_6e.tex")
rendre_tex_exercices(fiche, "corrige_6e.tex", corriges = TRUE, titre = "Corrigé")
```

`compiler_tex()` utilise `pdflatex` s’il est installé. Le `.tex` reste toujours disponible, ce qui maintient le projet indépendant de Quarto.
