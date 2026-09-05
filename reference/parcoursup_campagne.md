# Campagnes Parcoursup

Retourne l'identite d'une campagne sans figer ses jalons dates dans le
schema. Les dates sont accessibles separement avec
\[parcoursup_calendrier()\].

## Usage

``` r
parcoursup_campagne(campagne_id = "PS2026")
```

## Arguments

- campagne_id:

  Identifiant de campagne, par defaut \`PS2026\`.

## Value

Un data.frame d'une ligne si la campagne existe.
