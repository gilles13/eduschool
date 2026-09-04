# Explorer une classe de 6e avec eduschool

Cette vignette utilise la **sixième** comme fil conducteur pour montrer
comment interroger `eduschool`. Les mêmes fonctions sont conçues pour
les autres niveaux à mesure que leur couverture documentaire est
enrichie.

``` r

library(eduschool)
```

## La carte d’identité pédagogique de la 6e

La fonction
[`genere_resume()`](https://gilles13.github.io/eduschool/reference/genere_resume.md)
fournit une vue volontairement courte : matière, horaire, grands thèmes
et notions essentielles. Elle est conçue pour être lue directement dans
une vignette ou dans le site pkgdown.

``` r

r = genere_resume("6E")
knitr::kable(r, row.names = FALSE)
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

Cette synthèse est construite à partir des CSV du package : elle n’est
pas un tableau écrit spécialement pour cette vignette. Les fonctions
plus techniques comme
[`resume_niveau()`](https://gilles13.github.io/eduschool/reference/resume_niveau.md),
[`themes_niveau()`](https://gilles13.github.io/eduschool/reference/themes_niveau.md)
et
[`notions_niveau()`](https://gilles13.github.io/eduschool/reference/notions_niveau.md)
restent disponibles lorsque l’on souhaite explorer les données en
détail.

On peut aussi se concentrer immédiatement sur une matière :

``` r

genere_resume("6E", matiere = "MAT") |>
  knitr::kable(row.names = FALSE)
```

| matiere | horaire | themes | notions |
|:---|:---|:---|:---|
| Mathématiques | 4 h 30 | Nombres entiers et décimaux ; Fractions et pourcentages ; Premiers raisonnements algébriques ; Longueurs et périmètres ; Aires ; … | Nombres entiers et décimaux ; Fractions : sens et représentations ; Addition et soustraction de fractions ; Fraction d’une quantité ; Pourcentages ; Premiers raisonnements algébriques ; … |

## Les horaires

``` r

h = horaires_niveau("6E")
knitr::kable(h[, c("libelle", "volume", "unite")], row.names = FALSE)
```

| libelle                                              | volume | unite         |
|:-----------------------------------------------------|:-------|:--------------|
| Éducation physique et sportive                       | 4.0    | HEURE_SEMAINE |
| Arts plastiques                                      | 1.0    | HEURE_SEMAINE |
| Éducation musicale                                   | 1.0    | HEURE_SEMAINE |
| Français                                             | 4.5    | HEURE_SEMAINE |
| Histoire-géographie et enseignement moral et civique | 3.0    | HEURE_SEMAINE |
| Langue vivante                                       | 4.0    | HEURE_SEMAINE |
| Mathématiques                                        | 4.5    | HEURE_SEMAINE |
| SVT et physique-chimie                               | 3.0    | HEURE_SEMAINE |

## Les grands thèmes étudiés

``` r

t = themes_niveau("6E")
knitr::kable(t[, c("discipline_id", "libelle")], row.names = FALSE)
```

| discipline_id | libelle |
|:---|:---|
| LVE | Repères culturels |
| LVE | Compréhension |
| LVE | Expression et interaction |
| LVE | Outils linguistiques |
| EMC | La laïcité à l’École |
| EMC | Droits de la personne et vie privée |
| EMC | Représenter les autres et servir l’intérêt général |
| MAT | Nombres entiers et décimaux |
| MAT | Fractions et pourcentages |
| MAT | Premiers raisonnements algébriques |
| MAT | Longueurs et périmètres |
| MAT | Aires |
| MAT | Volumes |
| MAT | Horaires et durées |
| MAT | Configurations planes |
| MAT | Vision dans l’espace |
| MAT | Organisation et gestion de données |
| MAT | Probabilités |
| MAT | Proportionnalité en contexte |
| MAT | Instructions, séquences et répétitions |
| FRA | Lecture et compréhension |
| FRA | Culture littéraire et artistique |
| FRA | Écriture |
| FRA | Oral |
| FRA | Vocabulaire |
| FRA | Grammaire et orthographe |
| HG | La longue histoire de l’humanité et des migrations |
| HG | Récits fondateurs, croyances et citoyenneté dans la Méditerranée antique |
| HG | L’empire romain dans le monde antique |
| HG | Habiter une métropole |
| HG | Habiter un espace de faible densité |
| HG | Habiter les littoraux |
| HG | Le monde habité |
| SCI | Matière, mouvement, énergie, information |
| SCI | Le vivant, sa diversité et les fonctions qui le caractérisent |
| SCI | Les objets techniques au cœur de la société |
| SCI | La Terre, une planète peuplée par des êtres vivants |
| ARTS | La matérialité de la production plastique et la sensibilité aux constituants de l’œuvre |
| MUS | Chanter et interpréter |
| MUS | Écouter, comparer et commenter |
| MUS | Explorer, imaginer et créer |
| MUS | Échanger, partager et argumenter |
| EPS | S’exprimer devant les autres par une prestation artistique ou acrobatique |
| EPS | Conduire et maîtriser un affrontement collectif ou interindividuel |
| EPS | Produire une performance optimale, mesurable |
| EPS | Adapter ses déplacements à des environnements variés |
| ARTS | La représentation plastique et les dispositifs de présentation |
| ARTS | Les fabrications et la relation entre l’objet et l’espace |

## Les notions à connaître

``` r

n = notions_niveau("6E")
knitr::kable(unique(n[, c("discipline_id", "libelle")]), row.names = FALSE)
```

| discipline_id | libelle                                |
|:--------------|:---------------------------------------|
| LVE           | Repères culturels                      |
| LVE           | Compréhension en langue vivante        |
| LVE           | Expression et interaction              |
| LVE           | Outils linguistiques                   |
| EMC           | Laïcité                                |
| EMC           | Droits et vie privée                   |
| EMC           | Intérêt général et représentation      |
| MAT           | Nombres entiers et décimaux            |
| MAT           | Fractions : sens et représentations    |
| MAT           | Addition et soustraction de fractions  |
| MAT           | Fraction d’une quantité                |
| MAT           | Pourcentages                           |
| MAT           | Premiers raisonnements algébriques     |
| MAT           | Longueurs et périmètres                |
| MAT           | Aires                                  |
| MAT           | Volumes                                |
| MAT           | Horaires et durées                     |
| MAT           | Configurations planes                  |
| MAT           | Vision dans l’espace                   |
| MAT           | Organisation et gestion de données     |
| MAT           | Probabilités                           |
| MAT           | Proportionnalité                       |
| MAT           | Instructions, séquences et répétitions |
| FRA           | Lecture et compréhension               |
| FRA           | Culture littéraire                     |
| FRA           | Écriture                               |
| FRA           | Expression orale                       |
| FRA           | Vocabulaire                            |
| FRA           | Grammaire et orthographe               |
| HG            | Préhistoire et migrations              |
| HG            | Méditerranée antique                   |
| HG            | Empire romain                          |
| HG            | Habiter une métropole                  |
| HG            | Espaces de faible densité              |
| HG            | Littoraux                              |
| HG            | Répartition de la population           |
| SCI           | Matière et énergie                     |
| SCI           | Le vivant                              |
| SCI           | Objets techniques                      |
| SCI           | Terre et environnement                 |
| ARTS          | Matérialité et œuvre                   |
| MUS           | Chanter et interpréter                 |
| MUS           | Écoute musicale                        |
| MUS           | Création musicale                      |
| MUS           | Échange et argumentation musicale      |
| EPS           | Expression artistique et acrobatique   |
| EPS           | Affrontement collectif ou individuel   |
| EPS           | Performance mesurable                  |
| EPS           | Déplacements en environnement varié    |
| ARTS          | Représentation plastique               |
| ARTS          | Objet et espace                        |

## Aller plus loin en mathématiques

Les mathématiques disposent d’une granularité plus fine. On peut
consulter les capacités, retrouver les notions qui leur sont associées,
puis remonter leurs prérequis.

``` r

x = capacites("6E", discipline_id = "MAT", version_id = "2026_2027")
head(x[, c("item_id", "libelle")])
#>             item_id                                            libelle
#> 1 ITM_MAT_C3_6E_C01         Lire, écrire et comparer de grands nombres
#> 2 ITM_MAT_C3_6E_C02 Utiliser différentes écritures d’un nombre décimal
#> 3 ITM_MAT_C3_6E_C03                    Multiplier des nombres décimaux
#> 4 ITM_MAT_C3_6E_C04        Choisir une opération adaptée à un problème
#> 5 ITM_MAT_C3_6E_C05            Interpréter une fraction comme quotient
#> 6 ITM_MAT_C3_6E_C06    Placer une fraction sur une demi-droite graduée
```

Pour une capacité liée à la proportionnalité :

``` r

notions_capacite("ITM_MAT_C3_6E_C31")
#>   notion_id       capacite_id       role discipline_id          libelle
#> 1  MAT_PROP ITM_MAT_C3_6E_C31 PRINCIPALE           MAT Proportionnalité
#>                                                 description
#> 1 Reconnaître et traiter une situation de proportionnalité.
#>                                    document
#> 1 rappels/mathematiques/proportionnalite.md
prerequis_capacite("ITM_MAT_C3_6E_C31", recursif = TRUE)
#>                          notion_id discipline_id                     libelle
#> 63 MAT_NOMBRES_ENTIERS_ET_DECIMAUX           MAT Nombres entiers et décimaux
#>                                                                        description
#> 63 Repères, méthodes et automatismes essentiels sur : Nombres entiers et décimaux.
#>                                                document
#> 63 rappels/mathematiques/nombres_entiers_et_decimaux.md
```

Le mode récursif remonte toute la chaîne de prérequis connue dans le
graphe pédagogique du package.

## Consulter un rappel

``` r

chercher_notions("fraction", discipline_id = "MAT")
#>            notion_id discipline_id                               libelle
#> 40  MAT_FRACTION_ADD           MAT Addition et soustraction de fractions
#> 41  MAT_FRACTION_QTE           MAT               Fraction d’une quantité
#> 42 MAT_FRACTION_SENS           MAT   Fractions : sens et représentations
#> 76   MAT_POURCENTAGE           MAT                          Pourcentages
#>                                                                         description
#> 40 Additionner et soustraire des fractions en utilisant des écritures équivalentes.
#> 41                             Calculer et interpréter une fraction d’une quantité.
#> 42                     Comprendre une fraction comme nombre, quotient et opérateur.
#> 76                            Relier pourcentage, fraction, proportion et quantité.
#>                                       document
#> 40 rappels/mathematiques/addition_fractions.md
#> 41  rappels/mathematiques/fraction_quantite.md
#> 42     rappels/mathematiques/fractions_sens.md
#> 76       rappels/mathematiques/pourcentages.md
```

Un rappel peut ensuite être lu avec
[`obtenir_rappel()`](https://gilles13.github.io/eduschool/reference/obtenir_rappel.md).

## Générer des exercices

``` r

fiche = generer_fiche(
  niveau_id = "6E",
  capacite_id = "ITM_MAT_C3_6E_C09",
  n = 5,
  difficulte = 1,
  seed = 2026
)
```

## Requêtes relationnelles avancées

Pour les analyses qui dépassent les fonctions de consultation, les mêmes
CSV peuvent être chargés dans DuckDB.

``` r

con = ouvrir_base()
DBI::dbListTables(con)
DBI::dbDisconnect(con)
```

La sixième constitue ici un exemple : l’objectif d’`eduschool` est que
cette même démarche puisse progressivement être appliquée à chaque
niveau scolaire.
