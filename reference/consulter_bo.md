# Consulter un programme officiel de mathematiques

Les programmes sont selectionnes dans le referentiel existant. Lorsque
plusieurs PDF correspondent, un tableau de choix est retourne.

## Usage

``` r
consulter_bo(niveau, programme = NULL, annee = NULL, ouvrir = interactive())
```

## Arguments

- niveau:

  Identifiant de cycle ("C3", "C4") ou niveau du lycee (par exemple
  "TG").

- programme:

  Identifiant de programme facultatif (programme_id).

- annee:

  Annee de publication facultative.

- ouvrir:

  Ouvrir le PDF lorsque le choix est unique.

## Value

Chemin du PDF, ou tableau des programmes disponibles.
