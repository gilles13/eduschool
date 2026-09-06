# Instancier un gabarit d'examen

Genere un enonce et sa reponse a partir d'un gabarit parametrique. La
graine permet de reproduire exactement la meme variante.

## Usage

``` r
generer_gabarit_examen(gabarit_id, seed = NULL)
```

## Arguments

- gabarit_id:

  Identifiant du gabarit.

- seed:

  Graine aleatoire facultative.

## Value

Une liste avec metadonnees, enonce, reponse et parametres tires.
