# Suites numériques

## Idée centrale

En terminale, l'étude des suites associe comportement global (variation, bornes) et comportement asymptotique (limite). Les raisonnements par récurrence et les comparaisons sont des outils essentiels.

## À connaître

- une suite croissante et majorée converge ; une suite décroissante et minorée converge ;
- une suite géométrique $q^n$ tend vers $0$ si $|q|<1$ ;
- les opérations et comparaisons de limites permettent de traiter de nombreuses suites ;
- la récurrence permet d'établir une propriété vraie pour tout entier à partir d'un rang.

## Méthode

Pour une suite définie par récurrence, chercher d'abord un intervalle stable et le sens de variation. Si la convergence est obtenue, la relation de récurrence peut souvent fournir une équation satisfaite par la limite.

## Exemple

Si $u_{n+1}=(u_n+2)/2$ et $u_0=0$, on peut montrer que $u_n<2$ et que $(u_n)$ est croissante. Elle converge donc ; sa limite $l$ vérifie $l=(l+2)/2$, d'où $l=2$.

## Vérification

Une équation de limite ne prouve pas à elle seule la convergence : il faut d'abord justifier que la suite converge.

## Automatismes à maîtriser

- calculer les premiers termes ;
- reconnaître suites arithmétiques et géométriques ;
- manipuler $u_{n+1}-u_n$ ou un quotient pertinent ;
- rédiger initialisation, hérédité et conclusion d'une récurrence.

## Erreurs fréquentes

- confondre suite bornée et suite convergente ;
- chercher la limite avant d'avoir établi la convergence ;
- oublier le rang de départ dans une récurrence.
