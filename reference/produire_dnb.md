# Produire un DNB complet et ses corriges

Compose une variante parametree du DNB 2026, redige les deux parties et
produit les sujets et leurs corriges. Les deux parties restent separees
afin de respecter la logique de l epreuve, dont la partie 1 est ramassee
avant la partie 2.

## Usage

``` r
produire_dnb(
  seed = NULL,
  repertoire = ".",
  detaille = FALSE,
  format = c("auto", "html", "pdf"),
  ouvrir = c("examen", "les_deux", "aucun")
)
```

## Arguments

- seed:

  Graine pseudo-aleatoire utilisee pour controler les tirages de la
  generation.

- repertoire:

  Repertoire de sortie.

- detaille:

  Produire des corriges detailles avec etapes de raisonnement.

- format:

  \`"auto"\`, \`"html"\` ou \`"pdf"\`.

- ouvrir:

  Document(s) a ouvrir : \`"examen"\`, \`"les_deux"\` ou \`"aucun"\`.

## Value

Un vecteur nomme contenant les quatre chemins produits.
