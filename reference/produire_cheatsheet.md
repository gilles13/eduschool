# Produire la cheatsheet eduschool

Genere une cheatsheet HTML autonome au format A4 paysage. La fiche
presente les principales portes d'entree publiques d'eduschool en trois
colonnes, avec des exemples directement copiables dans R.

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
