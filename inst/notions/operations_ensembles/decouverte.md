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

Un complémentaire n'a donc de sens qu'avec un **ensemble de référence** clairement identifié. Lorsque cet ensemble est fixé par le contexte, on rencontre aussi la notation $A^c$.

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

## 5. Composer les opérations

Avec

$$E=\{1,2,3,4,5,6,7,8\},\quad A=\{1,2,3,4\},\quad B=\{3,4,5,6\},$$

on a d'abord

$$A\cap B=\{3,4\},$$

puis

$$E\setminus(A\cap B)=\{1,2,5,6,7,8\}.$$

On peut aussi calculer séparément les éléments qui ne sont pas dans $A$ et ceux qui ne sont pas dans $B$ :

$$E\setminus A=\{5,6,7,8\},\qquad E\setminus B=\{1,2,7,8\}.$$

Leur réunion donne le même résultat :

$$(E\setminus A)\cup(E\setminus B)=\{1,2,5,6,7,8\}.$$

Ce n'est pas un hasard : **ne pas être dans $A$ ET $B$ à la fois**, c'est **ne pas être dans $A$ OU ne pas être dans $B$**.

## Pour aller plus loin : les lois de De Morgan

L'observation précédente se généralise :

$$E\setminus(A\cap B)=(E\setminus A)\cup(E\setminus B),$$

et

$$E\setminus(A\cup B)=(E\setminus A)\cap(E\setminus B).$$

Autrement dit :

- NON $(A\ \text{ET}\ B)$ devient $(\text{NON }A)\ \text{OU}\ (\text{NON }B)$ ;
- NON $(A\ \text{OU}\ B)$ devient $(\text{NON }A)\ \text{ET}\ (\text{NON }B)$.

Le nom vient après l'idée : ce sont les **lois de De Morgan**.
