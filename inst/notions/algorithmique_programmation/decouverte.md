# Découvrir : Algorithmique et programmation

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **algorithme** est une suite d'instructions précises permettant d'accomplir une tâche. Un **programme** est une traduction de ces instructions dans un langage exécutable.
:::

Une recette de cuisine est une bonne image : l'ordre des étapes et les conditions peuvent changer le résultat.

## Première idée

Considérons : « choisir un nombre ; le multiplier par 3 ; ajouter 2 ». Avec 4, on obtient 14. Changer l'ordre des deux opérations donnerait 18 : l'ordre est important.

## Comprendre la méthode

Une **variable** conserve une valeur qui peut changer. Une **condition** choisit une action selon un test ; une **boucle** répète des instructions.

Exemple en pseudo-code :

```text
nombre = 4
resultat = 3 * nombre + 2
afficher(resultat)
```

Pour comprendre un programme, on peut faire une **trace** : noter la valeur des variables après chaque instruction.

Pour lire un programme avec des blocs, on observe aussi leur **indentation** : les instructions décalées vers la droite sont placées à l'intérieur d'un même cadre. Ce décalage montre quelles instructions appartiennent à une boucle ou à une condition. Dans Scratch, c'est l'emboîtement des blocs qui définit ce groupe ; dans certains langages textuels, comme Python, l'indentation a directement ce rôle.

**Exemple :**

<!-- graphique: algo_scratch exemple=boucle -->

Ici, seule l'instruction « Remplacer x par 2 × x - 1 » est à l'intérieur de « Répéter 3 fois » : elle est exécutée trois fois. Les instructions à l'extérieur sont exécutées une seule fois.

## Vérifier

Tester l'algorithme avec plusieurs entrées, notamment une valeur simple et une valeur limite. Relire chaque instruction dans l'ordre : un résultat correct pour un seul exemple ne prouve pas qu'un programme fonctionne toujours.

## À essayer

**À essayer 1 — Exécuter :** On choisit 5, on multiplie par 2, puis on soustrait 3. Quel résultat s'affiche ?

**À essayer 2 — Ordre :** Que donne « ajouter 3 puis multiplier par 2 » avec 5 ? Est-ce le même résultat ?

**À essayer 3 — Condition :** Si un programme affiche « positif » lorsque le nombre est strictement supérieur à 0 et « non positif » sinon, que donne-t-il pour 0 ?

## À retenir

Un algorithme doit être précis. Variables, conditions et boucles servent à mémoriser, choisir et répéter des actions. On vérifie en suivant les étapes.

## Pour vérifier tes découvertes

1. **Exécuter :** 5 × 2 − 3 = **7**.
2. **Ordre :** (5 + 3) × 2 = **16**, différent de 7.
3. **Condition :** **Non positif**, car 0 n'est pas strictement supérieur à 0.
