# eduschool 0.14.0

## Navigation pédagogique et fiche pilote

- ajout d'une entrée directe vers les mathématiques par classe, de la 6e à la Terminale ;
- ajout d'une page-hub légère `Mathématiques par niveau`, construite avec le Markdown et Bootstrap déjà utilisés par pkgdown ;
- ajout d'une fiche pilote `Dérivation — Première spécialité` pour valider une présentation plus conviviale ;
- expérimentation d'annotations de type manuscrit limitée aux rappels et conseils, avec repli sur une police cursive du système et sans dépendance supplémentaire ;
- maintien d'un CSS pkgdown minimal : l'identité pédagogique reste portée par les fiches et non par la structure du site.
- chaque classe dispose désormais de sa propre page d'entrée mathématique, l'index général restant un annuaire des niveaux ;
- le prototype manuscrit est rendu comme un petit objet graphique, notamment pour le PDF, plutôt que par du CSS typographique.

# eduschool 0.13.1

- Finalisation page d accueil, correction des problèmes d affichage.

# eduschool 0.13.0

- Simplification de la page d'accueil pkgdown : remplacement des cartes en tableau par une grille Bootstrap/Pandoc et suppression du CSS spécifique devenu inutile.

- Finalisation du pilote de Première générale spécialité mathématiques : enrichissement du second degré, du produit scalaire, des probabilités conditionnelles et des variables aléatoires.
- Ajout de relations pédagogiques, méthodes, formules, erreurs fréquentes et familles d'exercices multi-concepts pour ces blocs.

- Ajout d’une couche pédagogique fine pour les mathématiques, avec la Première générale spécialité 2026-2027 comme pilote.
- Ajout des concepts, relations entre concepts, méthodes, formules, erreurs fréquentes et types d’exercices.
- Ajout d’une API de consultation : `concepts_math()`, `relations_concepts_math()`, `methodes_math()`, `formules_math()`, `erreurs_math()`, `types_exercices_math()` et `carte_concept_math()`.
- Intégration des nouvelles tables au métamodèle relationnel du SI.
- Enrichissement du bloc dérivation de Première spécialité : sécantes, dérivabilité, extrémums, méthodes, formules, erreurs fréquentes et exercices progressifs.
- Ajout de relations plusieurs-à-plusieurs entre types d’exercices, concepts et méthodes afin de représenter les exercices multi-concepts.
- Enrichissement du bloc suites de Première spécialité : modes de génération, modèles discrets, termes généraux, raisons, sommes, variations, seuils, limite intuitive et pont vers l’exponentielle.

# eduschool 0.12.1

- ajout de visuels
- modification page d accueil du site

# eduschool 0.12.0

## Recentrage, experience utilisateur et contribution

- recentrage explicite du projet sur deux objectifs : cartographier la scolarite des collegiens et lyceens en France et proposer des outils de mathematiques ;
- maintien d une architecture extensible a d autres disciplines sans en faire l objectif principal du package ;
- nouvelle page d accueil pkgdown orientee vers les usages : parcours scolaire, mathematiques, donnees R et comprehension du systeme ;
- introduction d une premiere facade publique a verbes courts : `parcours()`, `orientation()`, `programme()`, `revision()` et `exercices()` ;
- conservation de l API detaillee existante pour les usages avances et la maintenance ;
- ajout d une rubrique « Contribuer et partager » et d un guide de contribution afin de favoriser la mutualisation des corrections, ressources, fiches et modeles d exercices ;
- formalisation de la cible fonctionnelle : les futures fiches eduschool et les fiches personnelles devront utiliser la meme API publique de composition.
- enrichissement visuel de l accueil et des fiches a partir d une bibliotheque de pictogrammes, avec archivage des dix pistes graphiques explorees sans figer encore le futur logo principal.

# eduschool 0.11.0

## Orientation au lycee et apres le bac

- ajout d une couche relationnelle consacree aux principales bifurcations d orientation, aux grandes filieres post-bac et a Parcoursup ;
- separation entre les etapes durables de Parcoursup et les jalons dates propres a chaque campagne, afin de conserver un modele evolutif ;
- integration de la huitieme serie technologique `STAV`, relevant de l enseignement agricole, afin de presenter un panorama complet des orientations apres la seconde ;
- ajout de fonctions pour consulter series technologiques, specialites, options du lycee, filieres post-bac, etapes, campagnes et calendriers Parcoursup ;
- ajout de schemas SVG generes dynamiquement depuis les donnees : bifurcations scolaires, etapes Parcoursup et frise chronologique d une campagne ;
- ajout de la vignette « S orienter au lycee et apres le bac » et d un repere historique sur Admission Post-Bac (APB), remplace par Parcoursup en 2018.

## Ressources pedagogiques en mathematiques

- ajout d un catalogue relationnel de ressources pedagogiques externes, separe des sources officielles du SI ;
- classement des ressources par usages pedagogiques et niveaux scolaires, sans liste de niveaux codee dans une seule cellule ;
- ajout de `usages_ressources()` et `ressources_pedagogiques()` ;
- ajout de la vignette « Approfondir ses connaissances en mathematiques ».

## Charte graphique et sorties de revision

- mise en place d'une charte graphique commune aux fiches pedagogiques, avec une couleur d'identification stable par cycle ;
- ajout d'un bandeau d'identite affichant automatiquement le cycle, la classe, la discipline, le type de fiche et le logo `eduschool` ;
- ajout de `charte_eduschool()`, `couleur_cycle()`, `identite_revision()` et `theme_eduschool()` pour reutiliser la charte depuis R et dans les graphiques `ggplot2` ;
- ajout de `documentation/charte-graphique.md` pour documenter les principes visuels du package ;
- les fiches HTML utilisent des ressources externes dans un repertoire `<nom>_files/` au lieu d'encoder le logo en base64, afin d'alleger les fichiers HTML et leur generation ;
- la synthese pedagogique et les representations visuelles utiles priment desormais sur une contrainte fixe de pagination des fiches.

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
- ajout d un index pkgdown dedie aux fiches essentielles de mathematiques et d une premiere fiche 6e ;
- suppression du graphique de comptage des themes dans la vignette 2de, qui refletait surtout la granularite inegale du referentiel ;
- preparation d une future API publique de composition de fiches personnalisees a partir de templates simples.

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
