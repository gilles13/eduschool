# Decouvrir une notion mathematique

\`notion()\` est une porte d'entree en langage courant vers les concepts
mathematiques d'eduschool. Elle retrouve une notion a partir de son nom,
donne sa definition et montre les notions qui l'entourent dans le
parcours mathematique.

## Usage

``` r
notion(nom)
```

## Arguments

- nom:

  Nom de la notion en langage courant, par exemple
  \`"proportionnalite"\`, \`"fractions"\` ou \`"pythagore"\`.

## Value

Une liste contenant la notion et ses relations pedagogiques.

## Details

Les relations sont classees en \`"amont"\`, \`"autour"\` et \`"aval"\` a
partir du niveau auquel les concepts sont introduits. Cette lecture est
volontairement pedagogique : elle ne remplace pas la relation semantique
detaillee conservee dans \`relation\` et \`commentaire\`.
