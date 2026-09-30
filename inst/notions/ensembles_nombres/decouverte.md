# Découvrir les ensembles de nombres

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **ensemble** est une collection d'objets appelés **éléments**.
:::

Prenons un exemple très simple :

$$
E=\{a,b\}.
$$

$E$ est l'ensemble ; $a$ et $b$ sont ses éléments. Les accolades $\{\}$ indiquent que l'on écrit un ensemble.

Dans un ensemble, **l'ordre ne compte pas** et **répéter un élément ne change pas l'ensemble**. Ainsi :

$$
\{a,b\}=\{b,a\}=\{a,a,b\}.
$$

Nous pouvons maintenant regarder plus précisément ce que signifient un élément, un ensemble, l'appartenance et l'inclusion.

## 1. $a$ et $\{a\}$ ne sont pas la même chose

C'est le premier repère à garder en tête, car les accolades changent complètement l'objet dont on parle.

- $a$ est un **élément** ;
- $\{a\}$ est un **ensemble** qui contient un seul élément : $a$.

Autrement dit, $a$ est l'objet et $\{a\}$ est l'ensemble qui contient cet objet. On a donc :

$$
a\neq\{a\}.
$$

Cette distinction permet de comprendre les deux symboles qui arrivent maintenant. Quand on regarde un élément et un ensemble, on parlera d'**appartenance**. Quand on compare deux ensembles, on parlera d'**inclusion**.

## 2. Appartenance : regarder un élément

Le symbole $\in$ se lit **« appartient à »** ou **« est un élément de »**.

Comme $a$ est l'un des éléments contenus dans $E$, on écrit :

$$
a\in E.
$$

En revanche, si $c$ n'est pas dans $E$, on écrit :

$$
c\notin E.
$$

Devant le symbole $\in$, la question à se poser est donc : **cet objet est-il un élément de l'ensemble ?**

## 3. Inclusion : comparer deux ensembles

À partir de $E=\{a,b\}$, considérons maintenant l'ensemble $\{a\}$, qui contient seulement l'élément $a$.

Tous les éléments de $\{a\}$ appartiennent à $E$. On dit que $\{a\}$ **est inclus dans** $E$ et on écrit :

$$
\{a\}\subseteq E.
$$

Le symbole $\subseteq$ relie donc deux ensembles. Devant ce symbole, la question à se poser est : **tous les éléments du premier ensemble appartiennent-ils au second ?**

Il faut bien distinguer :

- $a\in E$ : $a$ est un **élément** de $E$ ;
- $\{a\}\subseteq E$ : $\{a\}$ est un **ensemble inclus** dans $E$.

Les accolades changent l'objet : $a$ et $\{a\}$ ne désignent pas la même chose.

## 4. Un ensemble est inclus dans lui-même

Demandons-nous si $E\subseteq E$.

Tous les éléments de $E$ appartiennent-ils à $E$ ? Oui : $a$ et $b$ appartiennent tous les deux à $E$.

Donc :

$$
E\subseteq E.
$$

Ainsi, parmi les sous-ensembles de $E=\{a,b\}$, il y a $E$ lui-même, c'est-à-dire $\{a,b\}$.

## 5. Le cas particulier de l'ensemble vide

L'ensemble vide, noté $\varnothing$, est l'ensemble qui ne contient **aucun élément**.

Pour savoir si $\varnothing\subseteq E$, appliquons exactement la même règle : tous les éléments de $\varnothing$ appartiennent-ils à $E$ ?

Il n'y a aucun élément à vérifier. Il est donc impossible d'en trouver un qui n'appartienne pas à $E$.

C'est pourquoi l'ensemble vide est inclus dans tout ensemble :

$$
\varnothing\subseteq E.
$$

Attention : cela ne signifie pas que $\varnothing$ est un élément de $E$. Avec $E=\{a,b\}$, les seuls éléments de $E$ sont $a$ et $b$, donc :

$$
\varnothing\notin E.
$$

On peut donc avoir en même temps $\varnothing\subseteq E$ et $\varnothing\notin E$. Il n'y a pas de contradiction : $\subseteq$ compare le contenu de deux ensembles, tandis que $\in$ demande si un objet est un élément d'un ensemble.

## 6. Tous les sous-ensembles de $E$

Nous pouvons maintenant les énumérer :

$$
\varnothing,\qquad \{a\},\qquad \{b\},\qquad \{a,b\}.
$$

Il y en a donc quatre. L'ensemble vide compte, et $E=\{a,b\}$ lui-même compte aussi.

## 7. L'ensemble des parties

On peut enfin rassembler tous les sous-ensembles de $E$ dans un nouvel ensemble. On l'appelle **l'ensemble des parties de $E$** et on le note $\mathcal{P}(E)$.

Pour $E=\{a,b\}$ :

$$
\mathcal{P}(E)=\{\varnothing,\{a\},\{b\},\{a,b\}\}.
$$

Cette fois, $\varnothing\in\mathcal{P}(E)$ : l'ensemble vide est bien l'un des éléments de $\mathcal{P}(E)$, puisque c'est l'un des sous-ensembles de $E$.

## Une toute petite porte : Cantor

En anglais, **cantor** désigne notamment une personne qui conduit le chant. C’est aussi le nom de **Georg Cantor**, l’un des fondateurs de la théorie des ensembles.

En étudiant les ensembles, Cantor a ouvert une question étonnante : **tous les infinis ont-ils la même taille ?**

Pas besoin d’y répondre ici. La porte est simplement entrouverte.

<!-- graphique: ensembles_nombres -->
