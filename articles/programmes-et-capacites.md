# Programmes et capacités

![Relations entre programmes, capacités et
notions](../reference/figures/programmes_capacites.svg)

Relations entre programmes, capacités et notions

Les référentiels sont consultables sans connexion préalable.
[`programmes()`](https://gilles13.github.io/eduschool/reference/programmes.md)
filtre les programmes et
[`capacites()`](https://gilles13.github.io/eduschool/reference/capacites.md)
retourne les éléments explicitement modélisés comme capacités.

``` r

programmes("MAT")
programmes("MAT", niveau_id = "2GT")
capacites("5E", version_id = "2026_2027")
```

## Lire un niveau dans son ensemble

Pour parcourir un niveau, les fonctions de synthèse évitent d’avoir à
reconstruire les jointures entre programmes et applications :

``` r

horaires_niveau("2GT")
themes_niveau("2GT")
notions_niveau("2GT")
resume_niveau("2GT")
```

[`genere_resume()`](https://gilles13.github.io/eduschool/reference/genere_resume.md)
fournit une vue plus compacte destinée à la lecture directe :

``` r

genere_resume("2GT")
genere_resume("2GT", matiere = "maths")
```

Les identifiants sont stables dans le projet et servent de clés dans les
relations documentaires et les modèles d’exercices. Les programmes
officiels et la documentation pédagogique restent séparés : une notion
peut ainsi être réutilisée par plusieurs capacités ou plusieurs niveaux.
