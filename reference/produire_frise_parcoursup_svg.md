# Produire une frise chronologique Parcoursup

La frise est generee depuis les jalons de la campagne, et non codee dans
la vignette.

## Usage

``` r
produire_frise_parcoursup_svg(campagne_id = "PS2026", fichier = NULL)
```

## Arguments

- campagne_id:

  Identifiant de campagne.

- fichier:

  Chemin du SVG. Si \`NULL\`, utilise un fichier temporaire.

## Value

Invisiblement, le chemin absolu du SVG produit.
