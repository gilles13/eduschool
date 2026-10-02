# Découvrir les opérations sur les ensembles

On part de deux ensembles très simples :

$$A=\{1,2,3\}\qquad\text{et}\qquad B=\{3,4,5\}.$$

## 1. L'intersection : chercher ce qui est dans les deux ensembles

L'intersection de $A$ et $B$ rassemble les éléments qui appartiennent **à $A$ ET à $B$**.

Ici, le seul élément commun est $3$ :

$$A\cap B=\{3\}.$$

Attention aux accolades : on cherche l'élément $3$, mais le résultat d'une intersection est **un ensemble**. On écrit donc $\{3\}$, pas $3$. L'ensemble $\{3\}$ contient exactement un élément : on l'appelle un **singleton**.

À retenir :

$$x\in A\cap B\quad\Longleftrightarrow\quad x\in A\ \text{ET}\ x\in B.$$

## 2. La réunion : chercher ce qui est dans au moins un ensemble

La réunion de $A$ et $B$ rassemble les éléments qui appartiennent **à $A$ OU à $B$** :

$$A\cup B=\{1,2,3,4,5\}.$$

Le mot **OU** est inclusif : un élément peut appartenir à $A$, à $B$, ou aux deux. On n'écrit pas deux fois $3$ : dans un ensemble, chaque élément ne compte qu'une fois. Le répéter dans l'écriture ne change pas l'ensemble.

À retenir :

$$x\in A\cup B\quad\Longleftrightarrow\quad x\in A\ \text{OU}\ x\in B.$$

## 3. Le complémentaire : il faut savoir par rapport à quoi

Prenons maintenant un ensemble de référence :

$$E=\{1,2,3,4,5,6\}\qquad\text{et}\qquad A=\{1,2,3\}.$$

Les éléments de $E$ qui ne sont pas dans $A$ sont $4$, $5$ et $6$ :

$$E\setminus A=\{4,5,6\}.$$

Si l'ensemble de référence change, le résultat peut changer. Avec

$$F=\{0,1,2,3,4,5,6,7\},$$

on obtient

$$F\setminus A=\{0,4,5,6,7\}.$$

Un complémentaire n'a donc de sens qu'avec un **ensemble de référence** clairement identifié. L'écriture $E\setminus A$ a l'avantage de montrer directement cet ensemble de référence : on part de $E$ et on retire les éléments de $A$.

Lorsque l'ensemble de référence est déjà fixé par le contexte, on rencontre aussi une écriture plus compacte :

$$A^c.$$

Le petit $c$ placé en haut **n'est pas une puissance** : il signifie ici « complémentaire de $A$ ». Ainsi, lorsque $E$ est l'ensemble de référence,

$$A^c=E\setminus A.$$

Si cette notation compacte gêne au début, on peut continuer à écrire $E\setminus A$ : les deux écritures désignent le même ensemble lorsque la référence $E$ est connue. Une fois le sens du complémentaire installé, la notation $A^c$ peut au contraire devenir pratique : elle allège les expressions et permet parfois de mieux voir les opérations qui s'y échangent.

## 4. Quand l'ensemble vide revient rôder

Ces égalités se comprennent directement avec les définitions :

$$A\cap\varnothing=\varnothing$$

car aucun élément ne peut appartenir à la fois à $A$ et à un ensemble qui ne contient rien ;

$$A\cup\varnothing=A$$

car l'ensemble vide n'ajoute aucun élément ;

$$A\cap A=A\qquad\text{et}\qquad A\cup A=A$$

car comparer $A$ avec lui-même ne crée ni ne retire d'élément ;

$$A\setminus A=\varnothing$$

car on retire de $A$ tous les éléments de $A$.

Et voici le piège des accolades qui mérite d'être vu une deuxième fois :

$$\boxed{\varnothing\neq\{\varnothing\}}.$$

- $\varnothing$ ne contient **aucun élément** ;
- $\{\varnothing\}$ contient **un élément** : l'ensemble vide.

Ainsi $A\cup\varnothing=A$, tandis que si $B=\{\varnothing\}$, alors $A\cup B$ contient bien $\varnothing$ comme élément.

## 5. Composer les opérations : deux chemins vers le même ensemble

Reprenons un seul ensemble de référence et gardons-le visible :

$$E=\{1,2,3,4,5,6\},\quad A=\{1,2,3\},\quad B=\{3,4,5\}.$$

Commençons par la réunion :

$$A\cup B=\{1,2,3,4,5\},$$

puis retirons-la de $E$ :

$$E\setminus(A\cup B)=\{6\}.$$

Essayons maintenant un autre chemin. On calcule séparément :

$$E\setminus A=\{4,5,6\},\qquad E\setminus B=\{1,2,6\}.$$

Le seul élément commun à ces deux ensembles est $6$ :

$$(E\setminus A)\cap(E\setminus B)=\{6\}.$$

Les deux chemins donnent donc le même ensemble :

$$E\setminus(A\cup B)=(E\setminus A)\cap(E\setminus B).$$

On peut faire le trajet symétrique en partant de l'intersection :

$$A\cap B=\{3\},$$

puis

$$E\setminus(A\cap B)=\{1,2,4,5,6\}.$$

De l'autre côté,

$$(E\setminus A)\cup(E\setminus B)=\{1,2,4,5,6\}.$$

Cette fois encore, les deux chemins donnent le même ensemble :

$$E\setminus(A\cap B)=(E\setminus A)\cup(E\setminus B).$$

Ce que l'on peut d'abord retenir visuellement est très simple : **quand on prend le complémentaire, réunion et intersection s'échangent**.

$$\cup\quad\longleftrightarrow\quad\cap$$

## Pour aller plus loin : les lois de De Morgan

L'observation précédente se généralise :

$$E\setminus(A\cap B)=(E\setminus A)\cup(E\setminus B),$$

et

$$E\setminus(A\cup B)=(E\setminus A)\cap(E\setminus B).$$

Autrement dit :

- NON $(A\ \text{ET}\ B)$ devient $(\text{NON }A)\ \text{OU}\ (\text{NON }B)$ ;
- NON $(A\ \text{OU}\ B)$ devient $(\text{NON }A)\ \text{ET}\ (\text{NON }B)$.

Une formulation en français mérite d'être rendue explicite : **« ni dans $A$ ni dans $B$ » signifie « pas dans $A$ ET pas dans $B$ »**. Ce n'est pas « pas dans $A$ OU pas dans $B$ ». Ainsi, dans l'ensemble de référence $E$ :

$$
x\notin A\ \text{ET}\ x\notin B
\quad\Longleftrightarrow\quad
x\in E\setminus(A\cup B).
$$

Le nom vient après l'idée : ce sont les **lois de De Morgan**.

Une fois cette idée comprise, on peut retrouver la notation compacte. Si $E$ est fixé comme ensemble de référence, $A^c$ signifie $E\setminus A$ et $B^c$ signifie $E\setminus B$. Les mêmes lois s'écrivent alors :

$$(A\cup B)^c=A^c\cap B^c,$$

$$(A\cap B)^c=A^c\cup B^c.$$

Ici encore, le $c$ en hauteur ne désigne pas une puissance : il indique le complémentaire.
