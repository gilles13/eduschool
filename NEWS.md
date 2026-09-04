# eduschool 0.10.4

## Programmes du lycée — lot 1

- Détail du programme de spécialité de mathématiques de terminale générale applicable en 2026-2027.
- Ajout de 16 sous-thèmes et de 53 capacités attendues, structurés sous les domaines existants.
- Liaison des nouvelles capacités aux notions pédagogiques correspondantes.
- Référencement explicite du BO spécial n°8 du 25 juillet 2019 (MENE1921246A).


## Terminale générale — consolidation

- Enrichissement pédagogique des notions mobilisées par la spécialité mathématiques.
- Détail des capacités de l’option mathématiques complémentaires (programme 2019 applicable en 2026-2027).
- Détail des capacités de l’option mathématiques expertes : nombres complexes, arithmétique, graphes et matrices.
- Ajout des relations entre capacités et notions et de fiches de révision dédiées aux nombres complexes ainsi qu’aux graphes et matrices.
- Contrôle de cohérence de la couverture de la terminale générale avant les nouveaux programmes applicables en terminale en 2027-2028.

## Documentation pédagogique — lot 2

- Enrichissement des 16 fiches de révision associées aux capacités de terminale générale spécialité mathématiques.
- Ajout de définitions, méthodes, exemples, vérifications, automatismes et erreurs fréquentes adaptés au niveau terminale.
- Précision des descriptions des notions utilisées par le programme de terminale.

# eduschool 0.10.3

## Ergonomie des sorties

- Ajout de l'ouverture optionnelle des fichiers générés avec `ouvrir = TRUE`.
- Prise en charge de Linux, macOS et Windows avec l'application associée au type de fichier.
- Harmonisation du comportement des sorties PDF, HTML et SVG.
- Amélioration du diagnostic lorsque l'environnement LaTeX est incomplet.

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
