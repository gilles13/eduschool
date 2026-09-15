# Rediger une partie d'un examen compose

Transforme un squelette produit par \`composer_examen()\` en objet
intermediaire contenant a la fois les enonces, les reponses, les
corrections et les specifications de ressources graphiques. Le meme
objet sert ensuite a produire le sujet et son corrige avec
\[produire_examen()\].

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
