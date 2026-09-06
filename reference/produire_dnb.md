# Produire un DNB complet et ses corriges

Compose une variante reproductible du DNB 2026, redige les deux parties
et produit les sujets et leurs corriges. Les deux parties restent
separees afin de respecter la logique de l epreuve, dont la partie 1 est
ramassee avant la partie 2.

## Usage

``` r
produire_dnb(seed = NULL, repertoire = ".", detaille = FALSE, ouvrir = FALSE)
```

## Arguments

- seed:

  Graine aleatoire permettant de reproduire exactement le sujet.

- repertoire:

  Repertoire de sortie.

- detaille:

  Produire des corriges detailles avec etapes de raisonnement.

- ouvrir:

  Ouvrir les PDF produits.

## Value

Un vecteur nomme contenant les quatre chemins PDF.
