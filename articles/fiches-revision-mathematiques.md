# Fiches de révision – Mathématiques

``` r

library(eduschool)
```

Cette section rassemble des **fiches essentielles de mathématiques par
classe**. Leur objectif est de rassembler les **formules, repères,
méthodes et réflexes à maîtriser** dans un document synthétique et
visuel, sans imposer une pagination artificielle. Des représentations
graphiques pourront compléter les notions lorsqu’elles apportent un
véritable gain pédagogique.

Les fiches sont produites à partir du même référentiel que les fonctions
R du package. Le site n’est donc qu’une vue de ces données, et non une
seconde source à maintenir séparément.

## Accès par classe

[Choisir directement un niveau, de la 6e à la
Terminale](https://gilles13.github.io/eduschool/articles/mathematiques-par-niveau.md).

## Fiches disponibles

- [6e — L’essentiel des
  mathématiques](https://gilles13.github.io/eduschool/articles/fiche-mathematiques-6e.md)
- [1re spécialité — Dérivation, fiche
  pilote](https://gilles13.github.io/eduschool/articles/fiche-derivation-premiere.md)

Les niveaux 5e, 4e, 3e, 2de, 1re générale spécialité mathématiques et
Terminale générale spécialité mathématiques seront ajoutés
progressivement sur le même modèle.

## Depuis R

La même fiche peut être construite comme objet R :

``` r

r = generer_essentiel("6E")
r
#> $fiche_id
#> [1] "REV_6E_ESSENTIEL"
#> 
#> $niveau_id
#> [1] "6E"
#> 
#> $famille_id
#> [1] ""
#> 
#> $famille
#> [1] NA
#> 
#> $type
#> [1] "ESSENTIEL"
#> 
#> $titre
#> [1] "L'essentiel des mathématiques en 6e"
#> 
#> $description
#> [1] "Formules repères et réflexes essentiels à maîtriser en fin de sixième."
#> 
#> $blocs
#>        bloc_id         fiche_id ordre      type                          titre
#> 44 B_6E_ESS_01 REV_6E_ESSENTIEL    10    REPERE              Nombres et calcul
#> 53 B_6E_ESS_11 REV_6E_ESSENTIEL   100    REPERE            Repérage et solides
#> 54 B_6E_ESS_09 REV_6E_ESSENTIEL   110 VIGILANCE                       Réflexes
#> 45 B_6E_ESS_02 REV_6E_ESSENTIEL    20   FORMULE      Fractions et pourcentages
#> 46 B_6E_ESS_03 REV_6E_ESSENTIEL    30   METHODE               Proportionnalité
#> 47 B_6E_ESS_04 REV_6E_ESSENTIEL    40   FORMULE                     Périmètres
#> 48 B_6E_ESS_05 REV_6E_ESSENTIEL    50   FORMULE                          Aires
#> 49 B_6E_ESS_06 REV_6E_ESSENTIEL    60    REPERE                      Géométrie
#> 50 B_6E_ESS_07 REV_6E_ESSENTIEL    70   FORMULE              Volumes et durées
#> 51 B_6E_ESS_08 REV_6E_ESSENTIEL    80   FORMULE        Données et probabilités
#> 52 B_6E_ESS_10 REV_6E_ESSENTIEL    90    REPERE Algèbre et pensée informatique
#>                                                                                                                                                                                                                                                              contenu
#> 44                                                                                                          Savoir lire écrire comparer et ordonner des nombres entiers ou décimaux. Estimer l'ordre de grandeur d'un résultat et respecter les priorités de calcul.
#> 53                                                                                                       Savoir lire les coordonnées d'un point se repérer sur un plan reconnaître cube et pavé droit et relier un solide à certaines de ses représentations planes.
#> 54                                                                                    Avant de calculer identifier les données utiles choisir l'opération et vérifier l'unité. Après le calcul contrôler le signe l'ordre de grandeur et la cohérence de la réponse.
#> 45                                                                                                                                                                                     Une fraction représente un quotient. Un pourcentage est une fraction sur 100.
#> 46                                                                                                     Dans une situation proportionnelle on peut multiplier les deux grandeurs par le même nombre ou revenir à l'unité. Toujours écrire les unités dans le tableau.
#> 47                                                                                                                                                                     Le périmètre est la longueur du contour. Pour un disque utiliser le diamètre d ou le rayon r.
#> 48                                                                                                                                                                                                       L'aire mesure une surface. Les unités d'aire sont au carré.
#> 49                                                      Dans un triangle la somme des angles vaut 180 degrés. La médiatrice d'un segment est perpendiculaire au segment et passe par son milieu. Un point de la médiatrice est à égale distance des deux extrémités.
#> 50 Un volume peut se mesurer en cubes unités comme le cm³. Pour un pavé droit on multiplie longueur largeur et hauteur. Pour un cube les trois dimensions sont égales. Repères utiles : 1 dm³ = 1 L et 1 cm³ = 1 mL. Pour les durées : 1 h = 60 min et 1 min = 60 s.
#> 51   Savoir lire et produire un tableau ou un graphique. Une probabilité est comprise entre 0 et 1. En équiprobabilité elle compare les cas favorables aux cas possibles. Une fréquence observée sur de nombreuses répétitions peut aider à estimer une probabilité.
#> 52                                   Une lettre peut représenter un nombre inconnu ou variable. Savoir compléter une égalité simple repérer une régularité et exécuter une suite d'instructions. Une boucle permet de répéter plusieurs fois les mêmes instructions.
#>                                                                       formule
#> 44                                                                           
#> 53                                                                           
#> 54                                                                           
#> 45                           \\frac{a}{b}=a\\div b \\quad t\\%=\\frac{t}{100}
#> 46                                                                           
#> 47  P_{rectangle}=2(L+l) \\quad P_{carre}=4c \\quad P_{disque}=\\pi d=2\\pi r
#> 48                              A_{rectangle}=L\\times l \\quad A_{carre}=c^2
#> 49                                                                           
#> 50                           V_{pave}=L\\times l\\times h \\quad V_{cube}=c^3
#> 51 P(A)=\\frac{nombre\\ de\\ cas\\ favorables}{nombre\\ de\\ cas\\ possibles}
#> 52                                                                           
#>    illustration_id
#> 44                
#> 53                
#> 54                
#> 45                
#> 46                
#> 47                
#> 48                
#> 49                
#> 50                
#> 51                
#> 52                
#> 
#> $notions
#> [1] notion_id     fiche_id      ordre         discipline_id libelle      
#> [6] description   document     
#> <0 rows> (or 0-length row.names)
#> 
#> attr(,"class")
#> [1] "eduschool_revision" "list"
```

Puis rendue en HTML ou en PDF avec
[`produire_revision()`](https://gilles13.github.io/eduschool/reference/produire_revision.md)
:

``` r

produire_revision(r, "revision_6e", format = "html")
produire_revision(r, "revision_6e", format = "pdf")
```

À terme, cette infrastructure servira aussi de socle à une **API
publique de composition** : un utilisateur R pourra partir d’un template
simple pour créer ses propres fiches de révision, d’approfondissement ou
d’exercices, tout en réutilisant les composants fournis par `eduschool`.
L’objectif sera d’éviter de demander aux utilisateurs de dépendre
directement de fonctions internes non documentées.
