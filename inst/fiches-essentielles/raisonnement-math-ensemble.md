## Appartenance et inclusion : une petite phrase, plusieurs étages

À retenir d'abord :

> **Un élément appartient ; un ensemble est inclus.**

C'est la règle essentielle.

Si $x$ est un élément de l'ensemble $A$, on écrit

$$
x \in A.
$$

Par exemple,

$$
3 \in \mathbb{N}.
$$

Si tous les éléments d'un ensemble $A$ appartiennent aussi à un ensemble $E$,
alors $A$ est inclus dans $E$. On écrit

$$
A \subseteq E.
$$

Par exemple,

$$
\mathbb{N} \subseteq \mathbb{Z}.
$$

Un élément **appartient** donc à un ensemble ; un ensemble est **inclus** dans
un autre ensemble.

Dire qu'« un nombre est inclus dans un ensemble » reste un bug.

### Un étage plus haut

Prenons maintenant un ensemble très simple :

$$
E = \{1,2\}.
$$

Quels sont ses sous-ensembles ?

$$
\varnothing,\quad \{1\},\quad \{2\},\quad \{1,2\}.
$$

On peut rassembler tous ces sous-ensembles dans un nouvel ensemble :

$$
\mathcal{P}(E)
=
\{\varnothing,\{1\},\{2\},\{1,2\}\}.
$$

Cet ensemble s'appelle **l'ensemble des parties de $E$**.

Et voici le lien important :

$$
A \subseteq E
\quad\Longleftrightarrow\quad
A \in \mathcal{P}(E).
$$

Autrement dit, lorsqu'un ensemble $A$ est inclus dans $E$, il devient lui-même
un élément de l'ensemble des parties de $E$.

La petite phrase n'a pas changé :

> **Un élément appartient ; un ensemble est inclus.**

Mais nous venons de changer d'étage.

### Encore un étage ?

$\mathcal{P}(E)$ est lui-même un ensemble.

Rien ne nous empêche donc de chercher l'ensemble de ses parties :

$$
\mathcal{P}(\mathcal{P}(E)).
$$

Puis, si l'envie nous prend, de recommencer :

$$
\mathcal{P}(\mathcal{P}(\mathcal{P}(E))).
$$

Et encore...

$$
E
\longrightarrow
\mathcal{P}(E)
\longrightarrow
\mathcal{P}(\mathcal{P}(E))
\longrightarrow
\mathcal{P}(\mathcal{P}(\mathcal{P}(E)))
\longrightarrow
\cdots
$$

Il n'est pas nécessaire d'aller jusque-là pour savoir utiliser correctement
$\in$ et $\subseteq$.

Le premier étage suffit pour cela.

Mais si la question suivante t'intéresse, la porte est ouverte.

> **Une fiche eduschool peut se lire en entier ou seulement en partie.**
>
> Comprendre ce dont on a besoin aujourd'hui n'interdit jamais d'aller voir
> ce qu'il y a à l'étage suivant.
