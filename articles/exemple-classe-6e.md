# Explorer une classe de 6e avec eduschool

Cette vignette montre quelques usages simples d’`eduschool` en prenant
la **sixième** comme exemple.

``` r

library(eduschool)
```

## Résumer une classe

La fonction
[`genere_resume()`](https://gilles13.github.io/eduschool/reference/genere_resume.md)
donne directement les informations les plus utiles : les matières, les
horaires, les grands thèmes et quelques notions essentielles.

``` r

genere_resume("6E") |>
  knitr::kable(row.names = FALSE)
```

| matiere | horaire | themes | notions |
|:---|:---|:---|:---|
| Éducation physique et sportive | 4 h | S’exprimer devant les autres par une prestation artistique ou acrobatique ; Conduire et maîtriser un affrontement collectif ou interindividuel ; Produire une performance optimale, mesurable ; Adapter ses déplacements à des environnements variés | Expression artistique et acrobatique ; Affrontement collectif ou individuel ; Performance mesurable ; Déplacements en environnement varié |
| Arts plastiques | 1 h | La matérialité de la production plastique et la sensibilité aux constituants de l’œuvre ; La représentation plastique et les dispositifs de présentation ; Les fabrications et la relation entre l’objet et l’espace | Matérialité et œuvre ; Représentation plastique ; Objet et espace |
| Éducation musicale | 1 h | Chanter et interpréter ; Écouter, comparer et commenter ; Explorer, imaginer et créer ; Échanger, partager et argumenter | Chanter et interpréter ; Écoute musicale ; Création musicale ; Échange et argumentation musicale |
| Français | 4 h 30 | Lecture et compréhension ; Culture littéraire et artistique ; Écriture ; Oral ; Vocabulaire ; … | Lecture et compréhension ; Culture littéraire ; Écriture ; Expression orale ; Vocabulaire ; Grammaire et orthographe |
| Histoire-géographie et enseignement moral et civique | 3 h | La laïcité à l’École ; Droits de la personne et vie privée ; Représenter les autres et servir l’intérêt général ; La longue histoire de l’humanité et des migrations ; Récits fondateurs, croyances et citoyenneté dans la Méditerranée antique ; … | Laïcité ; Droits et vie privée ; Intérêt général et représentation ; Préhistoire et migrations ; Méditerranée antique ; Empire romain ; … |
| Langue vivante | 4 h | Repères culturels ; Compréhension ; Expression et interaction ; Outils linguistiques | Repères culturels ; Compréhension en langue vivante ; Expression et interaction ; Outils linguistiques |
| Mathématiques | 4 h 30 | Nombres entiers et décimaux ; Fractions et pourcentages ; Premiers raisonnements algébriques ; Longueurs et périmètres ; Aires ; … | Nombres entiers et décimaux ; Fractions : sens et représentations ; Addition et soustraction de fractions ; Fraction d’une quantité ; Pourcentages ; Premiers raisonnements algébriques ; … |
| SVT et physique-chimie | 3 h | Matière, mouvement, énergie, information ; Le vivant, sa diversité et les fonctions qui le caractérisent ; Les objets techniques au cœur de la société ; La Terre, une planète peuplée par des êtres vivants | Matière et énergie ; Le vivant ; Objets techniques ; Terre et environnement |

On peut limiter immédiatement la synthèse à une matière :

``` r

genere_resume("6E", matiere = "maths") |>
  knitr::kable(row.names = FALSE)
```

| matiere | horaire | themes | notions |
|:---|:---|:---|:---|
| Mathématiques | 4 h 30 | Nombres entiers et décimaux ; Fractions et pourcentages ; Premiers raisonnements algébriques ; Longueurs et périmètres ; Aires ; … | Nombres entiers et décimaux ; Fractions : sens et représentations ; Addition et soustraction de fractions ; Fraction d’une quantité ; Pourcentages ; Premiers raisonnements algébriques ; … |

## Explorer sans afficher des tableaux trop longs

Les fonctions détaillées restent disponibles. Dans une vignette, il est
souvent plus lisible de n’en montrer qu’un aperçu.

Par exemple, les premières lignes des horaires :

``` r

horaires_niveau("6E")[, c("libelle", "volume", "unite")] |>
  head(6) |>
  knitr::kable(row.names = FALSE)
```

| libelle                                              | volume | unite         |
|:-----------------------------------------------------|:-------|:--------------|
| Éducation physique et sportive                       | 4.0    | HEURE_SEMAINE |
| Arts plastiques                                      | 1.0    | HEURE_SEMAINE |
| Éducation musicale                                   | 1.0    | HEURE_SEMAINE |
| Français                                             | 4.5    | HEURE_SEMAINE |
| Histoire-géographie et enseignement moral et civique | 3.0    | HEURE_SEMAINE |
| Langue vivante                                       | 4.0    | HEURE_SEMAINE |

Ou quelques thèmes du programme :

``` r

themes_niveau("6E")[, c("discipline_id", "libelle")] |>
  head(8) |>
  knitr::kable(row.names = FALSE)
```

| discipline_id | libelle                                            |
|:--------------|:---------------------------------------------------|
| LVE           | Repères culturels                                  |
| LVE           | Compréhension                                      |
| LVE           | Expression et interaction                          |
| LVE           | Outils linguistiques                               |
| EMC           | La laïcité à l’École                               |
| EMC           | Droits de la personne et vie privée                |
| EMC           | Représenter les autres et servir l’intérêt général |
| MAT           | Nombres entiers et décimaux                        |

Les tableaux complets restent accessibles en appelant directement les
fonctions sans [`head()`](https://rdrr.io/r/utils/head.html).

## Aller un peu plus loin en mathématiques

On peut consulter quelques capacités de mathématiques de 6e :

``` r

capacites("6E", discipline_id = "MAT", version_id = "2026_2027")[, c("item_id", "libelle")] |>
  head(6) |>
  knitr::kable(row.names = FALSE)
```

| item_id           | libelle                                            |
|:------------------|:---------------------------------------------------|
| ITM_MAT_C3_6E_C01 | Lire, écrire et comparer de grands nombres         |
| ITM_MAT_C3_6E_C02 | Utiliser différentes écritures d’un nombre décimal |
| ITM_MAT_C3_6E_C03 | Multiplier des nombres décimaux                    |
| ITM_MAT_C3_6E_C04 | Choisir une opération adaptée à un problème        |
| ITM_MAT_C3_6E_C05 | Interpréter une fraction comme quotient            |
| ITM_MAT_C3_6E_C06 | Placer une fraction sur une demi-droite graduée    |

Pour une capacité donnée, `eduschool` permet ensuite de retrouver les
notions et les prérequis associés :

``` r

notions_capacite("ITM_MAT_C3_6E_C31") |>
  head(6) |>
  knitr::kable(row.names = FALSE)
```

| notion_id | capacite_id | role | discipline_id | libelle | description | document |
|:---|:---|:---|:---|:---|:---|:---|
| MAT_PROP | ITM_MAT_C3_6E_C31 | PRINCIPALE | MAT | Proportionnalité | Reconnaître et traiter une situation de proportionnalité. | rappels/mathematiques/proportionnalite.md |

``` r

prerequis_capacite("ITM_MAT_C3_6E_C31", recursif = TRUE) |>
  head(6) |>
  knitr::kable(row.names = FALSE)
```

| notion_id | discipline_id | libelle | description | document |
|:---|:---|:---|:---|:---|
| MAT_NOMBRES_ENTIERS_ET_DECIMAUX | MAT | Nombres entiers et décimaux | Repères, méthodes et automatismes essentiels sur : Nombres entiers et décimaux. | rappels/mathematiques/nombres_entiers_et_decimaux.md |

## Générer directement des exercices

Pour un premier usage, il n’est pas nécessaire d’affecter la sortie à un
objet. Avec `afficher = TRUE`, les énoncés sont imprimés immédiatement :

``` r

generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 3,
  difficulte = 1,
  seed = 2026,
  afficher = TRUE
)
#> Exercice 1
#> Calculer et simplifier : 1/6 + 1/6
#> 
#> Exercice 2
#> Calculer et simplifier : 7/12 + 11/12
#> 
#> Exercice 3
#> Calculer et simplifier : 3/6 + 1/6
```

Pour obtenir directement une fiche imprimable, on peut envoyer la même
génération dans
[`produire_fiche()`](https://gilles13.github.io/eduschool/reference/produire_fiche.md)
:

``` r

generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 5,
  seed = 2026
) |>
  produire_fiche("fiche_6e", format = "auto")
```

Le format `"auto"` choisit le PDF lorsque LaTeX est disponible et le
HTML sinon. Pour garantir une sortie sans dépendance LaTeX, utiliser
explicitement `format = "html"`. Un corrigé se produit de la même
manière avec
[`produire_corrige()`](https://gilles13.github.io/eduschool/reference/produire_corrige.md).

## Et ensuite ?

La vignette de prise en main et les autres articles du site présentent
les programmes, les rappels pédagogiques, les exercices et les outils
plus avancés.
