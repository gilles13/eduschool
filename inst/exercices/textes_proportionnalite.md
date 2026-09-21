# Textes d’exercices — proportionnalite

<!-- Source éditoriale simple. R calcule et vérifie ; Markdown formule. -->

## PROP_001 / enonce

%d %s coûtent %d euros. Combien coûtent %d %s au même prix unitaire ?

## PROP_001 / correction

Prix d'un objet : %d / %d = %d euros. Donc %d objets coûtent %d x %d = %d euros.

## PROP_001 / feedback_ecart

Ajouter ou retirer seulement 1 euro par objet d'écart ne conserve pas le même prix unitaire.

## PROP_001 / feedback_total

%d euros est déjà le prix de %d objets. Le multiplier directement par %d compte beaucoup trop d'objets.

## PROP_001 / feedback_moins

Ce prix correspond à %d objets, pas à %d.

## PROP_001 / feedback_plus

Ce prix correspond à %d objets, pas à %d.

## PROP_RECON_001 / coefficient_enonce

Une place de cinéma coûte %d euros. Deux places coûtent %d euros et trois places coûtent %d euros. Par quoi faut-il multiplier le nombre de places pour obtenir le prix total ?

## PROP_RECON_001 / coefficient_correction

On multiplie toujours le nombre de places par %d :
2 x %d = %d
3 x %d = %d
Ce nombre est le [[coefficient de proportionnalité]].

## PROP_RECON_001 / coefficient_feedback_plus

Avec %d, 2 x %d = %d, pas %d euros.

## PROP_RECON_001 / coefficient_feedback_deux

%d est le prix de deux places, pas le nombre qui transforme le nombre de places en prix.

## PROP_RECON_001 / coefficient_feedback_trois

%d est le prix de trois places. Le nombre cherché est le prix d'une place : %d.

## PROP_RECON_001 / taxi_enonce

Un taxi demande %d euros au départ puis 1 euro par kilomètre. Pour 2 km, le trajet coûte %d euros ; pour 4 km, il coûte %d euros. Quelle observation montre que le prix n'est pas proportionnel à la distance ?

## PROP_RECON_001 / taxi_reponse

La distance double, mais le prix ne double pas : %d x 2 = %d, pas %d.

## PROP_RECON_001 / taxi_correction

Si le prix était proportionnel, doubler la distance ferait doubler le prix. Or %d x 2 = %d alors que 4 km coûtent %d euros. Les %d euros fixes empêchent la proportionnalité.

## PROP_RECON_001 / taxi_prop_augmente

Le prix augmente avec la distance, donc il n'est pas proportionnel.

## PROP_RECON_001 / taxi_prop_unites

La distance est en kilomètres et le prix en euros, donc ils ne peuvent pas être proportionnels.

## PROP_RECON_001 / taxi_prop_ecart

Le prix augmente toujours de 2 euros, donc il est proportionnel.

## PROP_RECON_001 / taxi_feedback_augmente

Deux grandeurs peuvent augmenter ensemble sans être proportionnelles. Il faut vérifier un même multiplicateur.

## PROP_RECON_001 / taxi_feedback_unites

Deux grandeurs d'unités différentes peuvent être proportionnelles. L'unité n'est pas le critère.

## PROP_RECON_001 / taxi_feedback_ecart

Un même écart ne suffit pas : la proportionnalité demande un même multiplicateur.

## PROP_RECON_001 / tableau_enonce

Que peut-on dire de ce tableau ?

## PROP_RECON_001 / tableau_reponse

On multiplie toujours par %d : les deux grandeurs sont proportionnelles.

## PROP_RECON_001 / tableau_correction

1 x %d = %d
2 x %d = %d
3 x %d = %d
Le même multiplicateur %d fonctionne partout.

## PROP_RECON_001 / tableau_prop_augmente

Les nombres de droite augmentent, donc cela suffit à prouver la proportionnalité.

## PROP_RECON_001 / tableau_prop_addition

On ajoute toujours le même nombre de gauche à droite.

## PROP_RECON_001 / tableau_prop_unites

On ne peut rien conclure sans connaître les unités.

## PROP_RECON_001 / tableau_feedback_augmente

Augmenter ensemble ne suffit pas. Ici, ce qui prouve la proportionnalité est le même multiplicateur.

## PROP_RECON_001 / tableau_feedback_addition

Le passage de gauche à droite se fait ici par multiplication, pas par une addition constante.

## PROP_RECON_001 / tableau_feedback_unites

Les unités ne sont pas nécessaires pour vérifier que le même multiplicateur relie les valeurs.

## PROP_TABLE_001 / cahiers_enonce

%d cahiers coûtent %d euros. Chaque cahier coûte le même prix. Combien coûtent %d cahiers ?

## PROP_TABLE_001 / boisson_enonce

%d bouteilles contiennent ensemble %d litres. Chaque bouteille contient la même quantité. Combien de litres contiennent %d bouteilles ?

## PROP_TABLE_001 / distance_enonce

%s parcourt %d km en %d heures à vitesse constante. Quelle distance parcourt %s en %d heures ?

## PROP_TABLE_001 / correction

Pour 1 %s, on calcule %d / %d = %d%s.
Pour %d %ss, cela revient à faire %d x %d = %d%s.

## PROP_TABLE_001 / feedback_addition

Additionner la nouvelle quantité et le coefficient ne conserve pas le même rapport.

## PROP_TABLE_001 / feedback_ecart

Ajouter seulement l’écart entre les deux quantités ne conserve pas le même multiplicateur.

## PROP_TABLE_001 / feedback_unite

La valeur connue correspond déjà à plusieurs unités. Il faut d’abord retrouver la valeur pour une unité.

## PROP_PIEGE_001 / prix_enonce

Deux bouteilles coûtent %d euros et quatre bouteilles coûtent %d euros. Elles ont toutes le même prix. Quelle phrase explique correctement le calcul ?

## PROP_PIEGE_001 / prix_reponse

Une bouteille coûte %d euros, donc 4 bouteilles coûtent 4 x %d = %d euros.

## PROP_PIEGE_001 / prix_correction

%d / 2 = %d : une bouteille coûte %d euros. On garde ce même prix : 4 x %d = %d euros.

## PROP_PIEGE_001 / prix_prop_ajout

On ajoute 2 au prix de deux bouteilles : %d + 2 = %d euros.

## PROP_PIEGE_001 / prix_prop_mult

On multiplie le prix de deux bouteilles par 4 : %d x 4 = %d euros.

## PROP_PIEGE_001 / prix_prop_mix

On additionne 4 bouteilles et %d euros : 4 + %d = %d.

## PROP_PIEGE_001 / prix_feedback_ajout

Ajouter le nombre de bouteilles ne conserve pas le même prix par bouteille.

## PROP_PIEGE_001 / prix_feedback_mult

Le prix de deux bouteilles contient déjà deux prix unitaires. Le multiplier par 4 en compterait huit.

## PROP_PIEGE_001 / prix_feedback_mix

Additionner une quantité d'objets et un prix ne calcule pas un prix total.

## PROP_PIEGE_001 / double_enonce

%d objets coûtent %d euros. Combien doivent coûter %d objets si le prix est proportionnel au nombre d'objets ?

## PROP_PIEGE_001 / double_correction

Le nombre d'objets double de %d à %d. Le prix doit donc doubler aussi : %d x 2 = %d euros.

## PROP_PIEGE_001 / double_feedback_plus

Quand la quantité double, ajouter 2 au prix ne reproduit pas le même changement.

## PROP_PIEGE_001 / double_feedback_mix

Additionner le nombre d'objets au prix ne conserve pas le même prix unitaire.

## PROP_PIEGE_001 / double_feedback_mult

Multiplier le prix par le nouveau nombre d'objets compte beaucoup trop de prix unitaires.

## PROP_PIEGE_001 / addition_enonce

Une suite de valeurs donne %d -> %d puis %d -> %d. On a ajouté %d des deux côtés. Cela suffit-il à prouver une proportionnalité ?

## PROP_PIEGE_001 / addition_reponse

Non. Ajouter toujours le même nombre n'est pas le critère d'une proportionnalité.

## PROP_PIEGE_001 / addition_correction

Une proportionnalité se reconnaît avec un même multiplicateur, pas avec une même addition.

## PROP_PIEGE_001 / addition_prop_oui

Oui. Une même addition suffit toujours à prouver une proportionnalité.

## PROP_PIEGE_001 / addition_prop_augmente

Oui, parce que les deux valeurs augmentent ensemble.

## PROP_PIEGE_001 / addition_prop_diff

Non, uniquement parce que les nombres sont différents.

## PROP_PIEGE_001 / addition_feedback_oui

Une addition constante décrit une autre relation. Pour une proportionnalité, on cherche un même multiplicateur.

## PROP_PIEGE_001 / addition_feedback_augmente

Deux grandeurs peuvent augmenter ensemble sans être proportionnelles.

## PROP_PIEGE_001 / addition_feedback_diff

Des nombres différents peuvent tout à fait être proportionnels. Ce n'est pas le critère.

## PROP_TRANSF_001 / riz_enonce

Une recette prévoit %d g de riz pour %d personnes. En gardant les mêmes proportions, combien faut-il de riz pour %d personnes ?

## PROP_TRANSF_001 / peinture_enonce

Pour peindre %d panneaux identiques, il faut %d mL de peinture. Combien faut-il de peinture pour %d panneaux ?

## PROP_TRANSF_001 / jus_enonce

Pour préparer %d verres identiques, il faut %d mL de jus. Combien faut-il de jus pour %d verres ?

## PROP_TRANSF_001 / correction

Pour 1 %s, on calcule %d / %d = %d%s.
Pour %d %ss, cela revient à faire %d x %d = %d%s.

## PROP_TRANSF_001 / feedback_difference

Ajouter seulement la différence du nombre d'unités ne conserve pas la quantité par unité.

## PROP_TRANSF_001 / feedback_total

Multiplier directement la quantité totale connue par le nouveau nombre oublie que cette quantité correspond déjà à plusieurs unités.

## PROP_TRANSF_001 / feedback_moins

Cette quantité conviendrait à %d %ss, pas à %d.
