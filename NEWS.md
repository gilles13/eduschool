# eduschool 0.11.0

## Consolidation du mini-SI

- ajout de metadonnees relationnelles explicites dans `inst/metadata/tables.csv`, `colonnes.csv` et `relations.csv` ;
- ajout de controles generiques des schemas, cles primaires, cles etrangeres et domaines structurants ;
- ajout d une seconde couche de controles semantiques : niveau/voie/serie, portee des horaires, programmes/niveaux et coherence temporelle des versions ;
- lecture deterministe des CSV comme donnees textuelles brutes, avec conversions metier explicites ;
- ajout d un schema relationnel SVG genere dynamiquement depuis les metadonnees ;
- ajout de la vignette technique « Rentrer en profondeur dans eduschool » ;
- correction du millesime 2025-2026 du programme de mathematiques de cycle 3 en sixieme et ajout de la version manquante au referentiel temporel.

## Fiches de revision mathematiques

- ajout d'un moteur de fiches de revision structurees, distinct du moteur d'exercices ;
- ajout de `familles_revision()`, `fiches_revision()`, `generer_revision()`, `generer_essentiel()` et `produire_revision()` ;
- premiere couverture complete de la seconde generale et technologique : logique, algorithmique, nombres et algebre, geometrie, fonctions, statistiques-probabilites et automatismes ;
- ajout d'une fiche `ESSENTIEL` volontairement tres compacte ;
- liaison des fiches aux notions pedagogiques existantes afin d'eviter une seconde source de verite ;
- ajout de schemas generes avec les capacites graphiques de R, sans nouvelle dependance graphique obligatoire ;
- rendu HTML/PDF suivant le meme principe que les fiches d'exercices.

# eduschool 0.10.9

## Consolidation documentaire et ergonomie

- noms de fichiers automatiques pour `produire_fiche()` et `produire_corrige()`, avec conservation de la possibilite de fournir un nom explicite ;
- rendu des fiches allege : logo plus discret, aligne a gauche, et titre HTML transmis proprement a Pandoc ;
- ajout d'une vignette complete consacree a la seconde generale et technologique (`2GT`) : enseignements, couverture pedagogique, focus mathematiques et orientations vers la premiere ;
- harmonisation des vignettes existantes sans fusionner leurs roles respectifs ;
- mise a jour de la navigation pkgdown, du README et des exemples de generation de fiches ;
- exclusion des fiches et corriges generes a la racine du depot afin d'eviter de versionner des artefacts de rendu.

# eduschool 0.10.8

## Fiches HTML et PDF

- ajout de `produire_fiche()` et `produire_corrige()` pour envoyer directement la sortie de `generer_fiche()` vers un document ;
- ajout d'un template R Markdown commun aux sorties HTML et PDF ;
- ajout de `format = "auto"` : PDF lorsque LaTeX est disponible, HTML sinon ;
- mise a jour du README et des vignettes pour presenter le nouveau flux avec le pipe natif `|>`.

# eduschool 0.10.7

## Premiers pas

- simplification du README et de la vignette de sixieme autour des usages immediats ;
- limitation des tableaux affiches dans la vignette afin de conserver une lecture confortable sur le site pkgdown ;
- ajout de l argument `afficher` aux fonctions de generation d exercices pour afficher directement les enonces sans devoir affecter le resultat a un objet.

# eduschool 0.10.6

## Experience utilisateur

- ajout de `genere_resume()` pour produire une synthese courte et directement affichable dans les vignettes et le site pkgdown ;
- filtrage facultatif par matiere avec `matiere = "all"` par defaut et prise en charge d'identifiants ou d'alias usuels ;
- limitation configurable du nombre de themes et de notions afin de conserver des tableaux lisibles.

# eduschool 0.10.5

## Collège — couverture transdisciplinaire

- extension des synthèses pédagogiques aux classes de 5e, 4e et 3e pour l’ensemble des enseignements obligatoires ;
- prise en compte des millésimes effectivement applicables en 2026-2027, notamment pour le français, les mathématiques et les langues vivantes ;
- ajout de thèmes et de capacités représentatives en histoire-géographie, EMC, physique-chimie, SVT, technologie, EPS, arts plastiques et éducation musicale ;
- ajout de notions documentaires transdisciplinaires permettant à `resume_niveau()` de produire des sorties utiles sur tout le collège.

## Sixième transdisciplinaire

- enrichissement des programmes de 6e dans l’ensemble des enseignements obligatoires ;
- ajout de thèmes et de quelques capacités représentatives hors mathématiques ;
- ajout de notions pédagogiques reliées aux capacités ;
- ajout des fonctions `horaires_niveau()`, `themes_niveau()`, `notions_niveau()` et `resume_niveau()` ;
- ajout de la vignette vitrine « Explorer une classe de 6e avec eduschool » ;
- premiers enrichissements du graphe de prérequis en mathématiques.

## Graphe de prérequis de sixième

- enrichissement raisonné des prérequis mathématiques de 6e ;
- ajout de relations sur les fractions, grandeurs, géométrie, données, probabilités et algorithmique ;
- distinction entre prérequis requis et notions simplement utiles ;
- ajout de contrôles de cohérence des références et de l’absence de cycle dans le graphe.

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
## eduschool 0.10.5 — lot 4 : lycée complet

- couverture synthétique des enseignements communs de seconde, première et terminale ;
- couverture représentative des principales spécialités de la voie générale ;
- couverture du tronc commun de la voie technologique ;
- ajout de thèmes, capacités et notions documentaires pour les disciplines hors mathématiques ;
- `resume_niveau()` distingue désormais les programmes par enseignement, ce qui évite de mélanger histoire-géographie et HGGSP, par exemple ;
- ajout de la version 2026-2027 des horaires de terminale afin que les synthèses par défaut couvrent bien l'année scolaire courante.
