# Documentation pédagogique

![Organisation de la documentation
pédagogique](../reference/figures/documentation_pedagogique.svg)

Organisation de la documentation pédagogique

La documentation est séparée des programmes officiels. Une notion
pédagogique peut être reliée à plusieurs capacités.

``` r

chercher_notions("proportion")
notions_capacite("ITM_MAT_C3_6E_C31")
prerequis_capacite("ITM_MAT_C3_6E_C31", recursif = TRUE)
```

Les rappels sont des fichiers Markdown installés avec le package et
accessibles par
[`obtenir_rappel()`](https://gilles13.github.io/eduschool/reference/documentation.md).
Cette séparation permettra ultérieurement une personnalisation sans
modifier les référentiels officiels.
