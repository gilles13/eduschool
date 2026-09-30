# Opérations sur les ensembles : l'essentiel

- $A\cap B$ : **intersection** ; éléments qui appartiennent à $A$ **ET** à $B$.
- $A\cup B$ : **réunion** ; éléments qui appartiennent à $A$ **OU** à $B$.
- $E\setminus A$ : éléments de l'ensemble de référence $E$ qui n'appartiennent pas à $A$.

Le résultat d'une intersection ou d'une réunion est un **ensemble**. Si le seul élément commun est $3$, alors $A\cap B=\{3\}$, et non $3$.

Avec l'ensemble vide :

$$A\cap\varnothing=\varnothing,\qquad A\cup\varnothing=A,\qquad A\setminus A=\varnothing.$$

Attention :

$$\varnothing\neq\{\varnothing\}.$$

Le premier ensemble ne contient rien ; le second contient un élément, qui est l'ensemble vide.

Pour aller plus loin, les lois de De Morgan relient complémentaire, intersection et réunion :

$$E\setminus(A\cap B)=(E\setminus A)\cup(E\setminus B),$$

$$E\setminus(A\cup B)=(E\setminus A)\cap(E\setminus B).$$
