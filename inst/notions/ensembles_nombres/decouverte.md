# Découvrir les ensembles de nombres

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **ensemble** est une collection d'objets appelés **éléments**.
:::

Prenons un exemple très simple :

$$
E=\{1,2,3\}.
$$

$E$ est l'ensemble ; $1$, $2$ et $3$ sont ses éléments. Les accolades permettent ici **d'énumérer les éléments** de $E$.

Dans un ensemble, **l'ordre ne compte pas** et **répéter un élément ne change pas l'ensemble**. Ainsi :

$$
\{1,2,3\}=\{3,2,1\}=\{1,1,2,3,3\}.
$$

Un premier repère est essentiel : **les accolades sont une façon de décrire certains ensembles ; elles ne sont pas ce qui fait qu'un objet est un ensemble.** Nous rencontrerons plus loin des ensembles qui disposent d'autres notations.

## 1. Un objet peut être un élément d'un ensemble

Comme $1$ est l'un des objets contenus dans $E$, on écrit :

$$
1\in E.
$$

Le symbole $\in$ se lit **« appartient à »** ou **« est un élément de »**.

Il répond à une seule question :

> **Cet objet est-il un élément de cet ensemble ?**

Par exemple, $4$ n'est pas un élément de $E$, donc :

$$
4\notin E.
$$

## 2. Un élément peut lui-même être un ensemble

C'est une marche importante. Considérons :

$$
F=\{1,\{2,3\},4\}.
$$

$F$ contient **trois éléments** :

- le nombre $1$ ;
- l'ensemble $\{2,3\}$ ;
- le nombre $4$.

Ainsi :

$$
\{2,3\}\in F.
$$

Il n'y a pas de contradiction : $\{2,3\}$ est **un ensemble en lui-même**, et cet ensemble est aussi **un élément de $F$**.

C'est comme une boîte qui peut elle-même être placée dans une autre boîte : sa nature ne change pas parce qu'elle devient un élément d'un ensemble plus grand.

## 3. Appartenance et inclusion ne posent pas la même question

Revenons à :

$$
E=\{1,2,3\}.
$$

Nous savons déjà écrire :

$$
1\in E.
$$

Ici, on regarde **un objet et un ensemble** : est-ce que l'objet $1$ est un élément de $E$ ? Oui.

Considérons maintenant l'ensemble $A=\{1,2\}$. Tous les éléments de $A$ appartiennent aussi à $E$. On écrit :

$$
A\subseteq E.
$$

Le symbole $\subseteq$ se lit **« est inclus dans »**. Il compare **deux ensembles** et répond à une autre question :

> **Tous les éléments du premier ensemble appartiennent-ils au second ?**

Le repère à garder est donc :

- $\in$ : **un objet face à un ensemble** — « est-il dedans ? » ;
- $\subseteq$ : **un ensemble face à un ensemble** — « tout ce que contient le premier est-il aussi dans le second ? ».

Par exemple :

$$
1\in E
\qquad\text{mais}\qquad
\{1\}\subseteq E.
$$

Le nombre $1$ et l'ensemble $\{1\}$ ne sont pas le même objet.

Il faut aussi résister à une autre confusion : écrire

$$
E=\{1,2,3\}
$$

énumère **les éléments de $E$**, pas tous ses sous-ensembles. Ainsi :

$$
\{1,2\}\subseteq E
\qquad\text{mais}\qquad
\{1,2\}\notin E.
$$

L'ensemble $\{1,2\}$ est bien inclus dans $E$ parce que ses deux éléments appartiennent à $E$ ; mais il n'apparaît pas lui-même comme un élément de $E$. Cette distinction prépare le cas, plus déroutant, de l'ensemble vide.

## 4. Un ensemble est inclus dans lui-même

Demandons-nous si $E\subseteq E$.

Tous les éléments de $E$ appartiennent-ils à $E$ ? Oui : $a$ et $b$ appartiennent tous les deux à $E$.

Donc :

$$
E\subseteq E.
$$

Ainsi, parmi les sous-ensembles de $E=\{a,b\}$, il y a $E$ lui-même, c'est-à-dire $\{a,b\}$.

## 5. Le cas particulier de l'ensemble vide

L'ensemble vide, noté $\varnothing$, est **un ensemble** qui ne contient aucun élément. Le symbole $\varnothing$ est une notation particulière pour cet ensemble : l'absence d'accolades ne l'empêche pas d'être un ensemble.

Il faut maintenant distinguer deux objets :

- $\varnothing$ : un ensemble qui ne contient aucun élément ;
- $\{\varnothing\}$ : un ensemble qui contient **un élément**, et cet élément est l'ensemble vide.

Autrement dit, $\varnothing$ ressemble à une boîte vide, tandis que $\{\varnothing\}$ ressemble à une boîte qui contient une boîte vide.

Prenons par exemple :

$$
G=\{\varnothing,1,2\}.
$$

Cette fois, l'ensemble vide est explicitement l'un des éléments de $G$, donc :

$$
\varnothing\in G.
$$

Cela n'empêche pas $\varnothing$ d'être lui-même un ensemble.

Pour savoir maintenant si $\varnothing\subseteq E$, appliquons exactement la règle de l'inclusion : tous les éléments de $\varnothing$ appartiennent-ils à $E$ ?

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
