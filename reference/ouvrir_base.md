# Ouvrir une base DuckDB eduschool

La base peut être en mémoire ou persistante. Si \`importer\` vaut TRUE,
les principaux CSV du package sont copiés dans DuckDB.

## Usage

``` r
ouvrir_base(fichier = ":memory:", importer = TRUE)
```

## Arguments

- fichier:

  Chemin du fichier DuckDB, ou \`:memory:\`.

- importer:

  Importer les tables distribuées avec le package.
