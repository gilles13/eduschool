# Ressources pedagogiques externes

Les ressources sont maintenues dans des tables relationnelles distinctes
des sources officielles utilisees pour documenter les programmes. Les
filtres portent sur le niveau, l'usage et la discipline.

## Usage

``` r
ressources_pedagogiques(
  niveau_id = NULL,
  usage_id = NULL,
  discipline_id = "MAT"
)
```

## Arguments

- niveau_id:

  Identifiant de niveau facultatif, par exemple \`"6E"\`.

- usage_id:

  Usage facultatif, par exemple \`"EXERCICES"\` ou \`"ANNALES"\`.

- discipline_id:

  Discipline facultative. Par defaut \`"MAT"\`.

## Value

Un data.frame avec une ligne par ressource et des colonnes de synthese
pour les usages et niveaux couverts.
