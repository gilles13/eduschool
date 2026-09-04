# Consulter les programmes et capacités

Filtre les programmes et les éléments de type capacité à partir des
référentiels installés.

## Usage

``` r
programmes(discipline_id = NULL, niveau_id = NULL)
capacites(niveau_id = NULL, discipline_id = "MAT", version_id = NULL)
```

## Arguments

- discipline_id:

  Identifiant de discipline, par exemple `"MAT"`.

- niveau_id:

  Identifiant de niveau, par exemple `"6E"`.

- version_id:

  Version d'application facultative, par exemple `"2026_2027"`.

## Value

Un `data.frame`.

## Examples

``` r
programmes("MAT")
#>            programme_id discipline_id cycle_id niveau_id date_publication
#> 1       PRG_MAT_C4_2026           MAT       C4                 2026-03-05
#> 2       PRG_MAT_C3_2025           MAT       C3                 2025-04-17
#> 3      PRG_MAT_2GT_2026           MAT                2GT       2026-02-26
#> 4  PRG_MATH_SCI_1G_2026           MAT                 1G       2026-02-26
#> 5  PRG_MAT_SPEC_1G_2026           MAT                 1G       2026-02-26
#> 6   PRG_MAT_TERM_G_2026           MAT                 TG       2026-02-26
#> 7     PRG_MAT_COMP_2026           MAT                 TG       2026-02-26
#> 8      PRG_MAT_EXP_2026           MAT                 TG       2026-02-26
#> 9       PRG_MAT_1T_2026           MAT                 1T       2026-02-26
#> 10      PRG_MAT_TT_2026           MAT                 TT       2026-02-26
#> 11  PRG_MAT_TERM_G_2019           MAT                 TG       2019-07-25
#> 12    PRG_MAT_COMP_2019           MAT                 TG       2019-07-25
#> 13     PRG_MAT_EXP_2019           MAT                 TG       2019-07-25
#> 14      PRG_MAT_TT_2019           MAT                 TT       2019-07-25
#>                      source_id
#> 1  SRC_BO_2026_10_MENE2602912A
#> 2       SRC_BO_2025_16_MATH_C3
#> 3    SRC_BO_2026_14_MATH_LYCEE
#> 4    SRC_BO_2026_14_MATH_LYCEE
#> 5    SRC_BO_2026_14_MATH_LYCEE
#> 6    SRC_BO_2026_14_MATH_LYCEE
#> 7    SRC_BO_2026_14_MATH_LYCEE
#> 8    SRC_BO_2026_14_MATH_LYCEE
#> 9    SRC_BO_2026_14_MATH_LYCEE
#> 10   SRC_BO_2026_14_MATH_LYCEE
#> 11 SRC_BO_2019_08_MATH_OPTIONS
#> 12 SRC_BO_2019_08_MATH_OPTIONS
#> 13 SRC_BO_2019_08_MATH_OPTIONS
#> 14 SRC_BO_2019_08_MATH_OPTIONS
capacites("6E")
#>       programme_id           item_id   parent_item_id niveau ordre     type
#> 1  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C01 ITM_MAT_C3_6E_01     6E     1 CAPACITE
#> 2  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C02 ITM_MAT_C3_6E_01     6E     2 CAPACITE
#> 3  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C03 ITM_MAT_C3_6E_01     6E     3 CAPACITE
#> 4  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C04 ITM_MAT_C3_6E_01     6E     4 CAPACITE
#> 5  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C05 ITM_MAT_C3_6E_02     6E     5 CAPACITE
#> 6  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C06 ITM_MAT_C3_6E_02     6E     6 CAPACITE
#> 7  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C07 ITM_MAT_C3_6E_02     6E     7 CAPACITE
#> 8  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C08 ITM_MAT_C3_6E_02     6E     8 CAPACITE
#> 9  PRG_MAT_C3_2025 ITM_MAT_C3_6E_C09 ITM_MAT_C3_6E_02     6E     9 CAPACITE
#> 10 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C10 ITM_MAT_C3_6E_02     6E    10 CAPACITE
#> 11 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C11 ITM_MAT_C3_6E_02     6E    11 CAPACITE
#> 12 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C12 ITM_MAT_C3_6E_03     6E    12 CAPACITE
#> 13 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C13 ITM_MAT_C3_6E_03     6E    13 CAPACITE
#> 14 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C14 ITM_MAT_C3_6E_04     6E    14 CAPACITE
#> 15 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C15 ITM_MAT_C3_6E_04     6E    15 CAPACITE
#> 16 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C16 ITM_MAT_C3_6E_04     6E    16 CAPACITE
#> 17 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C17 ITM_MAT_C3_6E_05     6E    17 CAPACITE
#> 18 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C18 ITM_MAT_C3_6E_05     6E    18 CAPACITE
#> 19 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C19 ITM_MAT_C3_6E_06     6E    19 CAPACITE
#> 20 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C20 ITM_MAT_C3_6E_07     6E    20 CAPACITE
#> 21 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C21 ITM_MAT_C3_6E_08     6E    21 CAPACITE
#> 22 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C22 ITM_MAT_C3_6E_08     6E    22 CAPACITE
#> 23 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C23 ITM_MAT_C3_6E_08     6E    23 CAPACITE
#> 24 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C24 ITM_MAT_C3_6E_08     6E    24 CAPACITE
#> 25 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C25 ITM_MAT_C3_6E_09     6E    25 CAPACITE
#> 26 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C26 ITM_MAT_C3_6E_10     6E    26 CAPACITE
#> 27 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C27 ITM_MAT_C3_6E_10     6E    27 CAPACITE
#> 28 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C28 ITM_MAT_C3_6E_11     6E    28 CAPACITE
#> 29 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C29 ITM_MAT_C3_6E_11     6E    29 CAPACITE
#> 30 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C30 ITM_MAT_C3_6E_12     6E    30 CAPACITE
#> 31 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C31 ITM_MAT_C3_6E_12     6E    31 CAPACITE
#> 32 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C32 ITM_MAT_C3_6E_12     6E    32 CAPACITE
#> 33 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C33 ITM_MAT_C3_6E_12     6E    33 CAPACITE
#> 34 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C34 ITM_MAT_C3_6E_13     6E    34 CAPACITE
#> 35 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C35 ITM_MAT_C3_6E_13     6E    35 CAPACITE
#> 36 PRG_MAT_C3_2025 ITM_MAT_C3_6E_C36 ITM_MAT_C3_6E_13     6E    36 CAPACITE
#>                                               libelle
#> 1          Lire, écrire et comparer de grands nombres
#> 2  Utiliser différentes écritures d’un nombre décimal
#> 3                     Multiplier des nombres décimaux
#> 4         Choisir une opération adaptée à un problème
#> 5             Interpréter une fraction comme quotient
#> 6     Placer une fraction sur une demi-droite graduée
#> 7                  Appliquer une fraction à un entier
#> 8                  Comparer et encadrer des fractions
#> 9             Additionner et soustraire des fractions
#> 10              Multiplier une fraction par un entier
#> 11              Comprendre et utiliser un pourcentage
#> 12              Résoudre un problème à nombre inconnu
#> 13   Identifier une régularité dans un motif évolutif
#> 14                  Calculer le périmètre d’un disque
#> 15        Calculer le périmètre d’une figure composée
#> 16                Résoudre des problèmes de longueurs
#> 17                        Convertir des unités d’aire
#> 18                Calculer l’aire de figures usuelles
#> 19                        Déterminer un volume en cm³
#> 20                   Calculer et convertir des durées
#> 21          Construire et raisonner sur des triangles
#> 22              Construire et utiliser une médiatrice
#> 23     Construire le cercle circonscrit à un triangle
#> 24       Construire un symétrique par symétrie axiale
#> 25   Lire une représentation d’un assemblage de cubes
#> 26    Planifier une enquête et recueillir des données
#> 27        Construire et filtrer un tableau de données
#> 28        Calculer une probabilité en équiprobabilité
#> 29         Comparer fréquence observée et probabilité
#> 30      Reconnaître une situation de proportionnalité
#> 31           Résoudre un problème de proportionnalité
#> 32      Représenter une situation de proportionnalité
#> 33              Résoudre un problème simple d’échelle
#> 34 Identifier et exécuter une séquence d’instructions
#> 35               Produire une séquence d’instructions
#> 36                     Utiliser une répétition simple
#>                                                                                                          description
#> 1                           Lire, écrire, décomposer, comparer et ordonner des entiers, notamment jusqu’au milliard.
#> 2                                         Passer entre écriture décimale, décomposition et représentations adaptées.
#> 3           Effectuer et contrôler une multiplication impliquant des nombres décimaux dans un calcul ou un problème.
#> 4                                   Identifier le sens des opérations et construire une chaîne de calculs cohérente.
#> 5  Relier une fraction au résultat exact d’une division et comprendre le quotient d’un entier par un entier non nul.
#> 6                        Repérer et placer des fractions dans des cas simples en choisissant une graduation adaptée.
#> 7                                         Utiliser une multiplication pour calculer une fraction d’un nombre entier.
#> 8                           Établir des égalités de fractions, comparer, encadrer et ordonner des fractions simples.
#> 9                      Effectuer des additions et soustractions de fractions dans des situations adaptées au niveau.
#> 10                               Calculer le produit d’une fraction par un nombre entier et interpréter le résultat.
#> 11                     Relier pourcentage, proportion et fraction, puis calculer ou appliquer un pourcentage simple.
#> 12            Utiliser un schéma, une égalité à trou ou un autre modèle pré-algébrique pour déterminer une inconnue.
#> 13                                             Repérer et formuler la structure d’une suite de nombres ou de motifs.
#> 14                            Utiliser la proportionnalité entre diamètre et périmètre et la formule correspondante.
#> 15                                                   Décomposer une figure et additionner les longueurs nécessaires.
#> 16              Choisir les unités, convertir si nécessaire et résoudre des problèmes de longueurs ou de périmètres.
#> 17                                          Utiliser les relations entre cm², dm² et m² dans des situations simples.
#> 18                   Calculer notamment l’aire d’un carré ou d’un rectangle et exploiter des décompositions simples.
#> 19                                        Dénombrer des cubes unités et déterminer le volume d’un assemblage simple.
#> 20                               Effectuer des calculs sur horaires et durées, puis convertir entre unités de temps.
#> 21                            Construire des triangles, utiliser leurs propriétés angulaires et la somme des angles.
#> 22                   Reconnaître et construire une médiatrice, puis mobiliser ses propriétés dans une configuration.
#> 23                          Utiliser la concurrence des médiatrices pour déterminer le centre du cercle circonscrit.
#> 24                       Utiliser les propriétés de la symétrie axiale pour effectuer et justifier une construction.
#> 25                             Passer entre une configuration spatiale simple et différentes représentations planes.
#> 26                     Définir les informations à collecter, effectuer des mesures ou observations et les organiser.
#> 27                   Présenter des données dans un tableau simple et sélectionner les lignes répondant à un critère.
#> 28                    Déterminer une probabilité simple et l’exprimer comme fraction, nombre décimal ou pourcentage.
#> 29         Répéter une expérience aléatoire simple et confronter les fréquences obtenues à une probabilité calculée.
#> 30                         Décider si deux grandeurs relèvent d’un modèle de proportionnalité et justifier le choix.
#> 31                                   Choisir entre linéarité multiplicative, linéarité additive ou retour à l’unité.
#> 32                      Utiliser un tableau ou des notations symboliques en explicitant les grandeurs et les unités.
#> 33                                         Interpréter une échelle et déterminer une longueur réelle ou représentée.
#> 34                         Reconnaître une instruction, exécuter une suite d’instructions et anticiper son résultat.
#> 35                                        Écrire une suite d’instructions permettant d’atteindre un résultat imposé.
#> 36                    Répéter une séquence d’instructions pour automatiser une tâche ou construire un chemin simple.
#>                 source_id niveau_id version_id
#> 1  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 2  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 3  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 4  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 5  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 6  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 7  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 8  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 9  SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 10 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 11 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 12 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 13 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 14 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 15 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 16 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 17 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 18 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 19 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 20 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 21 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 22 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 23 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 24 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 25 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 26 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 27 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 28 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 29 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 30 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 31 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 32 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 33 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 34 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 35 SRC_BO_2025_16_MATH_C3        6E  2026_2027
#> 36 SRC_BO_2025_16_MATH_C3        6E  2026_2027
```
