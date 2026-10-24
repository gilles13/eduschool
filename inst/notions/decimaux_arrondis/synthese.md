# L'essentiel : Arrondir des nombres décimaux

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **arrondi** est une valeur approchée à une précision donnée.
:::

## Arrondir au plus proche

Pour arrondir au centième, on regarde le chiffre des millièmes. S'il vaut 5 ou davantage, on augmente le centième ; sinon, on le conserve.

<!-- graphique: tableau_numeration nombre=12.347 rang=2 -->

**Exemple :** 12,347 ≈ 12,35 au centième. Attention aux retenues : 12,997 ≈ 13,00 au centième.

## Ne pas confondre

Pour **7,468 au centième** :

| Procédé | Résultat |
|---|---:|
| Arrondi au plus proche | 7,47 |
| Troncature (on coupe après le centième) | 7,46 |
| Approximation par défaut | 7,46 |
| Approximation par excès | 7,47 |

Pour un nombre négatif, troncature et approximation par défaut ne coïncident pas nécessairement.

**À retenir :** Le procédé choisi compte autant que la précision demandée. Un arrondi au plus proche n'est pas une troncature.
