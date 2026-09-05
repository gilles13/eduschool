# Explorer les choix d'orientation

Sans argument, \`orientation()\` retourne le graphe d'orientation
complet. Avec un niveau ou un noeud de parcours, elle retourne les choix
immediats modelises dans eduschool.

## Usage

``` r
orientation(niveau = NULL)
```

## Arguments

- niveau:

  Niveau ou noeud de depart, par exemple \`"3E"\`, \`"2GT"\` ou
  \`"TG"\`. Si \`NULL\`, retourne le graphe complet.

## Value

Une liste \`noeuds\`/\`liens\`, ou un data.frame des choix immediats.
