# Structure d'un examen

Retourne les contraintes officielles et les profils pedagogiques
utilises pour composer une epreuve. Les profils sont des choix de
modelisation eduschool et ne doivent pas etre interpretes comme des
obligations reglementaires.

## Usage

``` r
structure_examen(code, session)
```

## Arguments

- code:

  Code de l'examen.

- session:

  Session de l'examen.

## Value

Une liste contenant examen, parties, profils et concepts.
