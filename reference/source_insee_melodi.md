# Declarer une source Insee Melodi

Construit une description legere d'un jeu de donnees Insee accessible
via l'API Melodi. Aucun appel reseau n'est effectue par cette fonction.

## Usage

``` r
source_insee_melodi(dataset, filtres = NULL, titre = NULL)
```

## Arguments

- dataset:

  Identifiant Melodi du jeu de donnees.

- filtres:

  Filtres Melodi sous forme de liste nommee, ou chaine de requete deja
  assemblee.

- titre:

  Titre humain facultatif de la source.

## Value

Un objet \`eduschool_source\`.
