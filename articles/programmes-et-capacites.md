# Programmes et capacités

![Relations entre programmes, capacités et
notions](../reference/figures/programmes_capacites.svg)

Relations entre programmes, capacités et notions

Les référentiels sont consultables sans connexion préalable.
[`programmes()`](https://gilles13.github.io/eduschool/reference/programmes.md)
filtre les programmes et
[`capacites()`](https://gilles13.github.io/eduschool/reference/capacites.md)
retourne les éléments de type `CAPACITE`.

``` r

programmes("MAT")
capacites("5E")
capacites("5E", version_id = "2026_2027")
```

Les identifiants sont stables dans le projet et servent de clés dans les
relations documentaires et les modèles d’exercices.
