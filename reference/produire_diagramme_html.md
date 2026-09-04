# Produire un diagramme HTML

Génère une page HTML autonome qui embarque directement le SVG produit
par eduschool. Aucun script externe n'est chargé.

## Usage

``` r
produire_diagramme_html(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
)
```

## Arguments

- type:

  Identifiant du diagramme. Voir \[diagrammes_disponibles()\].

- fichier:

  Chemin du fichier HTML à produire. Si \`NULL\`, le fichier est créé
  sous \`rapports/sorties/diagrammes/\` dans le répertoire de travail.

- ouvrir:

  Ouvrir le fichier avec l'application associée après sa création.

## Value

Invisiblement, le chemin absolu du fichier HTML produit.
