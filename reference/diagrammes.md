# Diagrammes HTML et SVG de eduschool

Fonctions de génération de diagrammes autonomes à partir d'un modèle de
graphe interne à eduschool. Les SVG sont produits directement en R, sans
Mermaid, Node, npm ou autre moteur externe.

## Usage

``` r
diagrammes_disponibles()

produire_diagramme_html(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
)

produire_diagramme_svg(type = "parcours_scolaire", fichier = NULL)

diagramme_parcours_scolaire(fichier = NULL, ouvrir = FALSE)

diagramme_package(
  type = c("architecture_si", "tests_package"),
  fichier = NULL,
  ouvrir = FALSE
)

generer_diagrammes_documentation(repertoire = NULL)

generer_documentation_visuelle(
  repertoire_svg = NULL,
  repertoire_html = NULL
)
```

## Arguments

- type:

  Identifiant du diagramme. Voir `diagrammes_disponibles()`.

- fichier:

  Chemin du fichier HTML ou SVG à produire.

- ouvrir:

  Ouvrir la page HTML dans le navigateur après sa création.

- repertoire:

  Répertoire de destination des SVG documentaires. Par défaut,
  `man/figures` dans l'arbre source du package.

- repertoire_svg:

  Répertoire des SVG documentaires.

- repertoire_html:

  Répertoire des pages HTML.

## Value

`diagrammes_disponibles()` retourne un `data.frame`. Les fonctions de
production retournent invisiblement le chemin du fichier créé.
`generer_documentation_visuelle()` retourne invisiblement une liste de
chemins SVG et HTML.

## Details

Les sorties HTML embarquent directement le SVG généré par eduschool.
Elles ne chargent aucun script distant. Les SVG de `man/figures` peuvent
être versionnés et réutilisés par pkgdown et les vignettes.

## Examples

``` r
diagrammes_disponibles()
#>                diagramme_id     categorie
#> 1         parcours_scolaire      parcours
#> 2             prise_en_main documentation
#> 3      programmes_capacites documentation
#> 4           architecture_si       package
#> 5 documentation_pedagogique documentation
#> 6       exercices_revisions documentation
#> 7             tests_package       package
#> 8             developpement       package
#>                                             titre
#> 1     Parcours scolaires modélisés dans eduschool
#> 2                      Prise en main de eduschool
#> 3                Programmes, capacités et notions
#> 4 Architecture du système d'information eduschool
#> 5             Chaîne de documentation pédagogique
#> 6                 Exercices et fiches de révision
#> 7        Chaîne de contrôle et de test du package
#> 8                    Développement et publication
#>                                                                                    description
#> 1          Collège, seconde générale et technologique, voie générale et séries technologiques.
#> 2  Chemin court entre les référentiels, la consultation, les rappels, les exercices et DuckDB.
#> 3                        Relations entre programmes, capacités, notions, rappels et exercices.
#> 4        Relations entre référentiels CSV, API R, DuckDB, documentation, exercices et sorties.
#> 5 Séparation entre sources officielles, capacités, notions, prérequis et rappels pédagogiques.
#> 6             Du choix d'une capacité à la génération déterministe d'exercices et de rapports.
#> 7            Contrôles des données, tests unitaires, construction du package et documentation.
#> 8        Cycle de travail depuis une modification jusqu'au commit et à la publication pkgdown.

f = tempfile(fileext = ".svg")
produire_diagramme_svg("architecture_si", fichier = f)
```
