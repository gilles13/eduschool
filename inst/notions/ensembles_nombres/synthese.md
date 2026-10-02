# Ensembles de nombres : l'essentiel

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **ensemble** est une collection d'objets appelés **éléments**.
:::

Les accolades permettent d'énumérer les éléments de certains ensembles ; elles ne définissent pas à elles seules ce qu'est un ensemble. Dans un ensemble, l'ordre ne compte pas et répéter un élément ne change pas l'ensemble :

$$\{a,b\}=\{b,a\}=\{a,a,b\}.$$

- $x\in A$ : on regarde **un objet et un ensemble** ; $x$ est-il un élément de $A$ ?
- $A\subseteq B$ : on compare **deux ensembles** ; tous les éléments de $A$ appartiennent-ils à $B$ ?
- Un ensemble peut lui-même être l'élément d'un autre ensemble. Par exemple, si $F=\{1,\{2,3\},4\}$, alors $\{2,3\}\in F$.
- $x$ et $\{x\}$ sont deux objets différents : $x$ est un objet, $\{x\}$ est un ensemble qui contient cet objet.
- Écrire $E=\{1,2,3\}$ énumère les **éléments** de $E$, pas ses sous-ensembles : $\{1,2\}\subseteq E$ mais $\{1,2\}\notin E$.
- Tout ensemble est inclus dans lui-même : $A\subseteq A$.
- L'ensemble vide $\varnothing$ est bien un ensemble : il ne contient aucun élément. $\{\varnothing\}$ est un autre ensemble, qui contient un élément : $\varnothing$.
- L'ensemble vide est inclus dans tout ensemble : $\varnothing\subseteq A$.
- $\varnothing\subseteq A$ ne signifie pas $\varnothing\in A$ : inclusion et appartenance sont deux relations différentes.
- $\mathcal{P}(A)$ est l'ensemble des parties de $A$ : ses éléments sont tous les sous-ensembles de $A$.

À retenir : $\in$ demande **« est-ce un élément ? »** ; $\subseteq$ demande **« tous les éléments du premier ensemble sont-ils dans le second ? »**.

<!-- graphique: ensembles_nombres -->

$\mathbb{N}\subseteq\mathbb{Z}\subseteq\mathbb{Q}\subseteq\mathbb{R}$.
