# Ajouter les variations mensuelles et annuelles de l'IPC

Conserve la provenance attachee aux donnees. La variation annuelle
compare chaque mois au meme mois de l'annee precedente.

## Usage

``` r
ajouter_variations_ipc(x = ipc_exemple())
```

## Arguments

- x:

  Donnees contenant les colonnes \`date\` et \`indice\`.

## Value

Les donnees completees par \`variation_mensuelle_pct\` et
\`variation_annuelle_pct\`.
