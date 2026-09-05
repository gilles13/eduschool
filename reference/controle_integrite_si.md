# Controler l'integrite du mini-SI

Verifie la presence des colonnes declarees, les cles primaires, les cles
etrangeres et quelques domaines structurants. Les controles sont
produits a partir des metadonnees de \`inst/metadata\`.

## Usage

``` r
controle_integrite_si(
  strict = FALSE,
  niveau = c("complet", "structure", "semantique")
)
```

## Arguments

- strict:

  Si \`TRUE\`, leve une erreur lorsqu'au moins un controle echoue.

- niveau:

  Portee des controles : \`"complet"\`, \`"structure"\` ou
  \`"semantique"\`.

## Value

Un data.frame avec une ligne par controle.
