# Opérations sur les ensembles : l'essentiel

- $A\cap B$ : **intersection** ; éléments qui appartiennent à $A$ **ET** à $B$.
- $A\cup B$ : **réunion** ; éléments qui appartiennent à $A$ **OU** à $B$.
- $E\setminus A$ : éléments de l'ensemble de référence $E$ qui n'appartiennent pas à $A$.
- Si $E$ est déjà fixé par le contexte, $A^c$ est une écriture compacte de $E\setminus A$. Le $c$ en hauteur signifie ici **complémentaire**, pas puissance. Une fois cette notation comprise, sa concision peut rendre certaines expressions plus faciles à lire.

Le résultat d'une intersection ou d'une réunion est un **ensemble**. Si le seul élément commun est $3$, alors $A\cap B=\{3\}$, et non $3$.

Avec l'ensemble vide :

$$A\cap\varnothing=\varnothing,\qquad A\cup\varnothing=A,\qquad A\setminus A=\varnothing.$$

Attention :

$$\varnothing\neq\{\varnothing\}.$$

Le premier ensemble ne contient rien ; le second contient un élément, qui est l'ensemble vide.


Une traduction utile : **« ni dans $A$ ni dans $B$ » signifie « pas dans $A$ ET pas dans $B$ »**. Dans $E$ :

$$x\notin A\ \text{ET}\ x\notin B\quad\Longleftrightarrow\quad x\in E\setminus(A\cup B).$$

Pour aller plus loin, les lois de De Morgan relient complémentaire, intersection et réunion. L'idée à retenir est que, lorsque l'on prend le complémentaire, **réunion et intersection s'échangent** :

$$E\setminus(A\cap B)=(E\setminus A)\cup(E\setminus B),$$

$$E\setminus(A\cup B)=(E\setminus A)\cap(E\setminus B).$$

Avec la notation compacte, lorsque $E$ est fixé :

$$(A\cap B)^c=A^c\cup B^c,\qquad (A\cup B)^c=A^c\cap B^c.$$
