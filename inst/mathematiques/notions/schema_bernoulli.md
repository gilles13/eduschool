# Succession d'épreuves indépendantes et schéma de Bernoulli

## Idée centrale

Un schéma de Bernoulli répète de façon indépendante une même épreuve à deux issues. Le nombre de succès suit alors une loi binomiale.

## À connaître

Si $X$ compte les succès dans $n$ épreuves indépendantes de probabilité de succès $p$, alors $X\sim\mathcal{B}(n,p)$ et $P(X=k)=\binom{n}{k}p^k(1-p)^{n-k}$. Son espérance vaut $np$ et sa variance $np(1-p)$.

## Méthode

Vérifier les trois éléments : nombre fixé d'épreuves, deux issues succès/échec, indépendance avec probabilité $p$ constante. Identifier ensuite l'événement demandé : exactement, au plus, au moins.

## Exemple

Pour 10 essais indépendants avec $p=0{,}3$, la probabilité d'obtenir exactement 2 succès est $\binom{10}{2}0{,}3^2 0{,}7^8$.

## Vérification

Une probabilité doit être comprise entre 0 et 1. Pour « au moins un succès », le complément $1-(1-p)^n$ est souvent plus simple.

## Automatismes à maîtriser

- reconnaître une situation binomiale ;
- traduire « au plus » et « au moins » ;
- calculer espérance et variance ;
- utiliser le complément d'un événement.

## Erreurs fréquentes

- appliquer la loi binomiale sans indépendance ;
- oublier le coefficient binomial ;
- confondre $P(X=k)$ et $P(X\leq k)$.
