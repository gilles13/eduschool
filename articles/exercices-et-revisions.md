# Exercices et révisions

![Chaîne de génération des exercices et
révisions](../reference/figures/exercices_revisions.svg)

Chaîne de génération des exercices et révisions

Le moteur d’exercices est déterministe lorsqu’un `seed` est fourni.

``` r

x = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 10, difficulte = 1, seed = 123)
```

Pour une sortie imprimable :

``` r

produire_rapport_exercices("6E", "ITM_MAT_C3_6E_C09", n = 10, seed = 123)
```

La compilation PDF dépend de `pdflatex`; les fichiers `.tex` peuvent
être produits sans celui-ci.
