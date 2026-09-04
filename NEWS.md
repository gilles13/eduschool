# eduschool 0.10.2

## Documentation visuelle

- Ajout de diagrammes HTML et SVG pour représenter les parcours scolaires et l'architecture du package.
- Ajout d'un moteur SVG natif en R, sans dépendance à Node.js, npm ou Mermaid CLI.
- Ajout de la représentation des cycles scolaires dans le diagramme des parcours.
- Ajout de visuels réutilisables dans `man/figures/`.

## Vignettes et documentation

- Illustration des vignettes avec les nouveaux diagrammes SVG.
- Ajout de vignettes consacrées aux parcours scolaires et au développement du package.
- Réorganisation de la documentation pkgdown.
- Simplification du README et de l'installation depuis RStudio avec `remotes::install_github()`.

## Maintenance du projet

- Nettoyage de l'ancienne infrastructure de chargement du projet.
- Suppression de `launcher.R` et de `dev/session.R`.
- Conservation d'un workflow de contrôle avec `dev/check.R`.

## Documentation pédagogique

- Poursuite de l'enrichissement des fiches de révision du collège.

# eduschool 0.10.1

## Documentation pédagogique

- Enrichissement d’un premier noyau de fiches de révision de 6e et 5e.
- Ajout de méthodes, exemples travaillés, automatismes, contrôles de cohérence et erreurs fréquentes.
- Ajout de conventions de rédaction pour guider les futures fiches pédagogiques.

# eduschool 0.10.0

- Première architecture de package R.
- Ressources déplacées sous `inst/`.
- Nouvelle résolution des chemins avec `eduschool_path()`.
- Consultation des référentiels et de la documentation sans état global.
- DuckDB devient une couche optionnelle de requête.
- Ajout d'une documentation utilisateur, de documentation mainteneur et de tests `testthat`.
- Ajout d'une stratégie de transition vers un développement piloté par Git.
