# Résumé pédagogique d'un niveau

Produit une ligne par enseignement avec l'horaire, les grands thèmes et
les notions documentées. La sixième sert de cas d'usage de référence,
mais la fonction est générique pour les niveaux couverts par les
données.

## Usage

``` r
resume_niveau(niveau_id, version_id = "2026_2027", serie_id = NULL)
```

## Arguments

- niveau_id:

  Identifiant du niveau, par exemple \`6E\`.

- version_id:

  Version scolaire, par exemple \`2026_2027\`.

- serie_id:

  Serie technologique ou generale facultative. Lorsqu'elle est absente,
  seuls les horaires communs au niveau sont retournes. Pour un niveau
  dont la grille est entierement definie par serie (par exemple \`1T\`
  ou \`TT\`), \`serie_id\` est obligatoire.
