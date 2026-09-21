# Concentration et loi des grands nombres

## Idée centrale

Les inégalités de concentration quantifient le fait qu'une variable aléatoire est souvent proche de son espérance. Pour une moyenne d'un grand nombre d'expériences indépendantes identiquement distribuées, la dispersion diminue : c'est le mécanisme de la loi des grands nombres.

## À connaître

L'inégalité de Bienaymé-Tchebychev donne, pour $a>0$, $P(|X-E(X)|\geq a)\leq V(X)/a^2$. Pour la moyenne $M_n$ de variables indépendantes de même espérance $m$ et de même variance $v$, $V(M_n)=v/n$ ; la probabilité d'un écart fixé à $m$ est donc majorée par une quantité qui tend vers $0$.

## Méthode

Identifier l'espérance et la variance, traduire l'événement sous la forme d'un écart à l'espérance, puis appliquer l'inégalité avec le seuil approprié.

## Exemple

Si $E(X)=10$ et $V(X)=4$, alors $P(|X-10|\geq3)\leq4/9$.

## Vérification

Une majoration n'est pas nécessairement la probabilité exacte. Si la borne calculée dépasse 1, la borne triviale 1 reste la seule information utile.

## Automatismes à maîtriser

- calculer espérance et variance d'une moyenne ;
- traduire un intervalle en écart absolu ;
- distinguer valeur exacte et majoration ;
- interpréter la décroissance en $1/n$ de la variance d'une moyenne.

## Erreurs fréquentes

- présenter la borne de Tchebychev comme une égalité ;
- oublier de mettre le seuil au carré ;
- confondre convergence probabiliste et certitude pour un échantillon fini.
