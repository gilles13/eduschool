# L'essentiel : Raisonnement par analyse-synthèse

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **raisonnement par analyse-synthèse** cherche d’abord les valeurs qui pourraient être solutions, puis vérifie lesquelles le sont réellement.
:::

## Principe

**Analyse :** on suppose que $x$ est solution et on en déduit des conditions nécessaires. On obtient un ou plusieurs **candidats**.

**Synthèse :** on teste chaque candidat dans l’équation de départ. On conserve exactement ceux qui la vérifient.

## Méthode

1. supposer que $x$ est solution ;
2. transformer l’équation pour obtenir des candidats ;
3. ne pas écrire $\Longleftrightarrow$ si la réciproque n’est pas justifiée ;
4. vérifier chaque candidat dans l’équation de départ ;
5. conclure avec les seules valeurs réellement solutions.

## Exemple

Pour

$$
\sqrt{x+6}=x,
$$

l’analyse donne :

$$
x+6=x^2,
$$

puis

$$
(x-3)(x+2)=0.
$$

Les candidats sont $3$ et $-2$.

La synthèse donne :

$$
\sqrt{3+6}=3,
$$

mais

$$
\sqrt{-2+6}=2\neq-2.
$$

Donc :

$$
\boxed{x=3}.
$$

## Vérification

Dans une analyse-synthèse, revenir à l’équation de départ n’est pas seulement une précaution : c’est ce qui transforme les candidats en solutions démontrées.

## À retenir

**Analyse = chercher les candidats. Synthèse = vérifier et conclure.**

Deux équations sont **équivalentes** seulement si elles ont exactement les mêmes solutions. Une implication seule ne justifie pas le symbole $\Longleftrightarrow$.
