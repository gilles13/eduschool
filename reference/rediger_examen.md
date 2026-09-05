# Rediger une partie d'un examen compose

Transforme un squelette produit par \`composer_examen()\` en objet
intermediaire contenant les enonces, reponses, corrections et
specifications de ressources graphiques. Cette fonction ne produit pas
encore de document PDF.

## Usage

``` r
rediger_examen(sujet, partie = 1)
```

## Arguments

- sujet:

  Objet produit par \`composer_examen()\`.

- partie:

  Numero d'ordre ou identifiant de la partie a rediger.

## Value

Un objet \`eduschool_examen_redige\`.
