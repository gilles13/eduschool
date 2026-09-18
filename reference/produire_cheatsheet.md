# Produire la cheatsheet eduschool

Genere une cheatsheet HTML autonome au format A4 paysage. La fiche sert
de boussole : trois gestes essentiels pour reviser, s'entrainer et
jouer, puis quelques portes pour se reperer et aller plus loin.

## Usage

``` r
produire_cheatsheet(fichier = NULL, ouvrir = TRUE)
```

## Arguments

- fichier:

  Chemin du fichier HTML a produire. Si \`NULL\`, le fichier
  \`eduschool-cheatsheet.html\` est cree dans le repertoire courant.

- ouvrir:

  Ouvrir la cheatsheet dans le navigateur apres sa creation.

## Value

Invisiblement, le chemin absolu du fichier HTML produit.

## Examples

``` r
if (FALSE) { # \dontrun{
produire_cheatsheet()
} # }
```
