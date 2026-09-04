# Ouvrir une base DuckDB

Ouvre une connexion DuckDB et, si demandé, y importe les référentiels du
package.

## Usage

``` r
ouvrir_base(fichier = ":memory:", importer = TRUE)
eduschool_init(fichier_base = ":memory:", importer = TRUE)
```

## Arguments

- fichier:

  Chemin du fichier DuckDB ou `":memory:"`.

- fichier_base:

  Chemin du fichier DuckDB ou `":memory:"`.

- importer:

  Importer les CSV distribués dans DuckDB.

## Value

`ouvrir_base()` retourne une connexion DBI ; `eduschool_init()` retourne
un contexte contenant cette connexion.
