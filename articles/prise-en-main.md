# Prise en main de eduschool

![Du référentiel à une fiche de
révision](../reference/figures/prise_en_main.svg)

Du référentiel à une fiche de révision

## Objectif

Cette vignette présente le chemin le plus court pour utiliser le
package.

``` r

library(eduschool)
niveaux()
capacites("6E")
chercher_notions("fraction")
```

### Une fiche de révision

``` r

notions_capacite("ITM_MAT_C3_6E_C09")
cat(obtenir_rappel("MAT_FRACTION_ADD"))
fiche = generer_fiche("6E", "ITM_MAT_C3_6E_C09", n = 5, seed = 2026)
```

### DuckDB seulement si nécessaire

``` r

con = ouvrir_base()
DBI::dbListTables(con)
DBI::dbDisconnect(con)
```
