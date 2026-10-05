# Découvrir : Raisonnement par analyse-synthèse

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **raisonnement par analyse-synthèse** sépare la recherche en deux temps. Dans l’**analyse**, on suppose qu’une solution existe et on cherche ce qu’elle doit nécessairement vérifier. Dans la **synthèse**, on revient au problème de départ pour vérifier lesquels des candidats obtenus sont réellement des solutions.
:::

Cette méthode est utile lorsqu’une transformation permet de trouver des candidats sans garantir que toutes les étapes sont réversibles. Elle évite de confondre « cette valeur est possible » avec « cette valeur est solution ».

## Première idée : une transformation peut seulement donner des candidats

Considérons :

$$
\sqrt{x+6}=x.
$$

Supposons que $x$ soit une solution. Alors :

$$
x+6=x^2.
$$

Donc :

$$
x^2-x-6=0,
$$

puis :

$$
(x-3)(x+2)=0.
$$

Toute solution de l’équation de départ doit donc être parmi les deux candidats :

$$
x=3\qquad\text{ou}\qquad x=-2.
$$

C’est l’**analyse**. Elle a réduit la recherche, mais elle n’a pas encore prouvé que les deux candidats conviennent.

## Comprendre la synthèse

On teste maintenant chaque candidat dans l’équation de départ.

Pour $x=3$ :

$$
\sqrt{3+6}=3.
$$

L’égalité est vraie.

Pour $x=-2$ :

$$
\sqrt{-2+6}=2\neq-2.
$$

L’égalité est fausse.

La **synthèse** permet donc de conclure :

$$
\boxed{x=3}.
$$

Le candidat $-2$ est apparu pendant l’analyse, mais ce n’est pas une solution.

## Équivalence ou analyse-synthèse ?

Deux équations sont **équivalentes** lorsqu’elles ont exactement les mêmes solutions. Dans ce cas, on peut passer de l’une à l’autre dans les deux sens.

Ici, on peut écrire :

$$
\sqrt{x+6}=x \Longrightarrow x+6=x^2,
$$

mais on ne peut pas remplacer cette implication par une équivalence sans justification : l’équation $x+6=x^2$ admet aussi $-2$, qui n’est pas solution de l’équation de départ.

L’analyse-synthèse est donc une manière rigoureuse de travailler lorsque les transformations utilisées donnent des **conditions nécessaires** sans assurer immédiatement la réciproque.

## Vérifier

À la fin d’une analyse-synthèse, la vérification n’est pas un simple contrôle facultatif : elle constitue la **synthèse** et permet de décider quels candidats sont réellement solutions.

**À essayer 1 — distinguer candidat et solution :**

Pour l’équation

$$
\sqrt{2x+3}=x,
$$

l’analyse conduit à

$$
x^2-2x-3=0=(x-3)(x+1),
$$

donc aux candidats $3$ et $-1$. Lesquels sont réellement solutions ?

**À essayer 2 — reconnaître le raisonnement :**

Un élève transforme une équation, obtient trois valeurs possibles, puis remplace chacune d’elles dans l’équation de départ avant de conclure. Quelle partie correspond à l’analyse ? Quelle partie correspond à la synthèse ?

## À retenir

L’**analyse** répond à la question : « si une solution existe, que doit-elle nécessairement vérifier ? »

La **synthèse** répond ensuite : « parmi les candidats obtenus, lesquels vérifient réellement le problème de départ ? »

Une suite d’implications n’est pas automatiquement une suite d’équivalences.

## Pour vérifier tes découvertes

**1. distinguer candidat et solution**

Les candidats sont $3$ et $-1$. On revient à l’équation de départ :

$$
\sqrt{2\times3+3}=3,
$$

donc $3$ est solution. Pour $-1$ :

$$
\sqrt{2\times(-1)+3}=1\neq-1.
$$

Ainsi, seule la valeur $3$ est solution.

**2. reconnaître le raisonnement**

La transformation de l’équation et la recherche des trois valeurs possibles constituent l’**analyse** : elles produisent des candidats. Le retour à l’équation de départ pour tester ces valeurs constitue la **synthèse**.
