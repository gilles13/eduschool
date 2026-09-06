# Produire le corrige d'un examen redige

Produire le corrige d'un examen redige

## Usage

``` r
produire_corrige_examen(
  examen,
  fichier = NULL,
  ouvrir = FALSE,
  detaille = FALSE
)
```

## Arguments

- examen:

  Objet produit par \[rediger_examen()\].

- fichier:

  Chemin de sortie. Si \`NULL\`, un nom est construit automatiquement.

- ouvrir:

  Ouvrir le PDF apres creation.

- detaille:

  Pour un corrige, afficher les etapes de raisonnement detaillees lorsqu
  elles sont disponibles.

## Value

Invisiblement, le chemin absolu du PDF produit.
