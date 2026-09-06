# Verifier une source de donnees

Par defaut, la verification reste locale : structure, producteur, jeu de
donnees et URL. Avec \`connexion = TRUE\`, la fonction demande egalement
les metadonnees du jeu a Melodi. Le package \`melodi\` reste une
dependance optionnelle.

## Usage

``` r
verifier_source(source, connexion = FALSE)
```

## Arguments

- source:

  Objet \`eduschool_source\`.

- connexion:

  Effectuer aussi une verification distante.

## Value

\`TRUE\` si la verification reussit.
