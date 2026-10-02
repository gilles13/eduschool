# Découvrir les intervalles

::: {.edu-definition}
**De quoi parle-t-on ?**

Un **intervalle** est un ensemble de nombres réels **sans trou** : si deux nombres appartiennent à l'intervalle, tous les nombres réels situés entre eux lui appartiennent aussi.
:::

Tu as déjà rencontré les **ensembles** et les **nombres réels** dans la fiche sur les ensembles de nombres. Ici, on assemble simplement ces deux idées.

Par exemple, l'intervalle

$$
[1;7]
$$

contient $1$, $7$ et **tous les nombres réels entre les deux** : $1{,}5$, $2$, $\pi$, $6{,}999$, etc.

En revanche,

$$
\{1,3,7\}
$$

est bien un ensemble de nombres réels, mais ce n'est pas un intervalle : $1$ et $3$ lui appartiennent alors que $2$, situé entre les deux, ne lui appartient pas. Il y a un trou.

**À essayer 1 — Ensemble ou intervalle :** parmi $\{1,2,3\}$ et $[1;3]$, lequel est un intervalle ? Les deux sont-ils des ensembles ?

## 1. Voir les nombres sur une droite

Tu as déjà rencontré la **droite graduée** : les nombres y sont représentés par des points. Avec les nombres réels, on peut prolonger cette idée sans laisser de trou ; on parle aussi de **droite numérique**.

Plaçons les nombres $2$ et $5$. En géométrie, la portion de droite comprise entre ces deux points est un **segment**. Ici, ce segment permet de représenter tous les nombres de l'intervalle $[2;5]$ :

<!-- graphique: intervalles_droite variante=1 -->

Les nombres $2$ et $5$ sont les **bornes** de l'intervalle. Le segment dessiné n'est pas l'intervalle lui-même : l'intervalle est un **ensemble de nombres**, et le segment en est une représentation sur la droite numérique.

Cette représentation donne aussi un sens très concret à « sans trou » : entre $2$ et $5$, on ne choisit pas quelques points. **Tous les points de la portion de droite sont pris.**

C'est donc très différent de l'ensemble $\{2,5\}$, qui contient exactement deux éléments.

## 2. Les extrémités : la borne appartient-elle à l'intervalle ?

Comparons maintenant $[2;5]$ et $[2;5[$. Dans le second cas, $2$ appartient toujours à l'intervalle, mais $5$ en est exclu :

<!-- graphique: intervalles_droite variante=2 -->

Le trait ne s'arrête **pas « juste avant 5 »**. Il va jusqu'au point d'abscisse $5$, représenté par un cercle vide pour indiquer que $5$ lui-même n'appartient pas à l'ensemble.

Pourquoi ? Parce qu'il n'existe pas de dernier nombre réel juste avant $5$. Après $4{,}9$, on peut prendre $4{,}99$, puis $4{,}999$, et ainsi de suite ; quel que soit le réel choisi inférieur à $5$, on peut encore en trouver un autre entre lui et $5$.

Sur nos figures :

- un **point plein** indique que la borne appartient à l'intervalle ;
- un **point vide** indique que la borne n'appartient pas à l'intervalle.

La notation avec les crochets raconte exactement la même chose :

- $[2;5]$ : $2$ et $5$ sont inclus ;
- $[2;5[$ : $2$ est inclus et $5$ est exclu ;
- $]2;5]$ : $2$ est exclu et $5$ est inclus ;
- $]2;5[$ : les deux bornes sont exclues.

Une fois le dessin compris, on peut lire le crochet comme un rappel : tourné **vers l'intérieur** de la portion représentée, la borne est incluse ; tourné **vers l'extérieur**, elle est exclue.

**À essayer 2 — Lire les crochets :** dans $]3;8]$, les nombres $3$ et $8$ appartiennent-ils à l'intervalle ?

## 3. Un intervalle peut aussi se lire comme une inégalité

Tu as rencontré les signes $<$, $>$, $\leq$ et $\geq$ avant les intervalles. Ils permettent de décrire exactement les mêmes nombres.

Dire

$$
x\in[2;5]
$$

revient à dire

$$
2\leq x\leq5.
$$

Dans les deux cas, $x$ peut être **n'importe quel nombre réel compris entre $2$ et $5$, bornes comprises**.

De même :

$$
x\in]2;5[\qquad\Longleftrightarrow\qquad2<x<5.
$$

Les crochets et les signes d'inégalité racontent donc la même chose de deux façons différentes.

**À essayer 3 — Changer d'écriture :** quel intervalle correspond à $-2<x\leq6$ ?

## 4. Et quand l'intervalle ne s'arrête pas ?

Considérons tous les réels supérieurs ou égaux à $2$.

Il y en a toujours un plus grand : $10$, $100$, $1\,000$, et on peut continuer sans fin. On écrit :

$$
[2;+\infty[.
$$

Le symbole $+\infty$ se lit **plus l'infini**. Ici, il signifie simplement que l'intervalle continue sans borne vers les nombres de plus en plus grands.

Sur la droite numérique, on le représente par une **demi-droite** :

<!-- graphique: intervalles_droite variante=3 -->

La flèche ne désigne pas un point $+\infty$ : elle indique que la représentation continue dans cette direction.

Point important :

$$
+\infty\notin\mathbb{R}
\qquad\text{et}\qquad
-\infty\notin\mathbb{R}.
$$

Dans cette fiche, $+\infty$ et $-\infty$ **ne sont pas des nombres réels**. Ce sont des symboles qui indiquent que l'intervalle ne s'arrête pas dans une direction. On ne peut donc pas les inclure dans l'intervalle : le crochet est toujours ouvert de leur côté.

Ainsi :

$$
[2;+\infty[
$$

désigne tous les réels $x$ tels que $x\geq2$, tandis que

$$
]-\infty;5[
$$

désigne tous les réels $x$ tels que $x<5$.

Et tous les nombres réels peuvent eux-mêmes s'écrire sous la forme :

$$
\mathbb{R}=]-\infty;+\infty[.
$$

## 5. Un intervalle reste un ensemble

C'est le lien essentiel avec les fiches précédentes : **un intervalle est littéralement un ensemble**. Les symboles déjà rencontrés gardent donc exactement le même sens.

Par exemple :

$$
3\in[2;5]
$$

signifie que $3$ appartient à l'intervalle $[2;5]$.

Et les opérations d'intersection et de réunion sont les mêmes que pour n'importe quels ensembles :

$$
[1;4]\cap]3;7]=]3;4],
$$

car ce sont les nombres qui appartiennent **aux deux** intervalles.

De même :

$$
[1;4]\cup]3;7]=[1;7],
$$

car la réunion rassemble les nombres qui appartiennent **à au moins l'un des deux** intervalles.

Mais attention : le résultat d'une réunion ou d'une intersection est toujours un **ensemble**, pas forcément un intervalle. Par exemple :

$$
[2;4]\cup[6;8]
$$

est bien un ensemble de nombres réels, mais il laisse un trou entre $4$ et $6$ : ce n'est donc pas un intervalle.

**À essayer 4 — Réutiliser les ensembles :** déterminer $[1;4]\cap]3;7]$ puis $[1;4]\cup]3;7]$.

## Pour vérifier tes découvertes

**1. Ensemble ou intervalle.** Les deux écritures désignent des ensembles. $[1;3]$ est un intervalle parce qu'il contient tous les réels entre $1$ et $3$. $\{1,2,3\}$ n'est pas un intervalle : par exemple $1{,}5$ est situé entre $1$ et $2$ mais n'appartient pas à cet ensemble.

**2. Lire les crochets.** Dans $]3;8]$, la borne $3$ est exclue et la borne $8$ est incluse. Donc $3\notin]3;8]$ et $8\in]3;8]$.

**3. Changer d'écriture.** La condition $-2<x\leq6$ correspond à $]-2;6]$. Le nombre $-2$ est exclu puisque $x$ doit être strictement supérieur à $-2$ ; $6$ est inclus puisque $x$ peut être égal à $6$.

**4. Réutiliser les ensembles.** Les nombres communs à $[1;4]$ et $]3;7]$ sont ceux strictement supérieurs à $3$ et inférieurs ou égaux à $4$ :

$$
[1;4]\cap]3;7]=]3;4].
$$

Les deux intervalles se recouvrent, donc leur réunion ne laisse aucun trou de $1$ à $7$ :

$$
[1;4]\cup]3;7]=[1;7].
$$
