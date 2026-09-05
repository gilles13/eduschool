# Changelog

## eduschool 0.11.0

### Orientation au lycee et apres le bac

- ajout d une couche relationnelle consacree aux principales
  bifurcations d orientation, aux grandes filieres post-bac et a
  Parcoursup ;
- separation entre les etapes durables de Parcoursup et les jalons dates
  propres a chaque campagne, afin de conserver un modele evolutif ;
- integration de la huitieme serie technologique `STAV`, relevant de l
  enseignement agricole, afin de presenter un panorama complet des
  orientations apres la seconde ;
- ajout de fonctions pour consulter series technologiques, specialites,
  options du lycee, filieres post-bac, etapes, campagnes et calendriers
  Parcoursup ;
- ajout de schemas SVG generes dynamiquement depuis les donnees :
  bifurcations scolaires, etapes Parcoursup et frise chronologique d une
  campagne ;
- ajout de la vignette « S orienter au lycee et apres le bac » et d un
  repere historique sur Admission Post-Bac (APB), remplace par
  Parcoursup en 2018.

### Ressources pedagogiques en mathematiques

- ajout d un catalogue relationnel de ressources pedagogiques externes,
  separe des sources officielles du SI ;
- classement des ressources par usages pedagogiques et niveaux
  scolaires, sans liste de niveaux codee dans une seule cellule ;
- ajout de
  [`usages_ressources()`](https://gilles13.github.io/eduschool/reference/usages_ressources.md)
  et
  [`ressources_pedagogiques()`](https://gilles13.github.io/eduschool/reference/ressources_pedagogiques.md)
  ;
- ajout de la vignette « Approfondir ses connaissances en mathematiques
  ».

### Charte graphique et sorties de revision

- mise en place d’une charte graphique commune aux fiches pedagogiques,
  avec une couleur d’identification stable par cycle ;
- ajout d’un bandeau d’identite affichant automatiquement le cycle, la
  classe, la discipline, le type de fiche et le logo `eduschool` ;
- ajout de
  [`charte_eduschool()`](https://gilles13.github.io/eduschool/reference/charte_eduschool.md),
  [`couleur_cycle()`](https://gilles13.github.io/eduschool/reference/couleur_cycle.md),
  [`identite_revision()`](https://gilles13.github.io/eduschool/reference/identite_revision.md)
  et
  [`theme_eduschool()`](https://gilles13.github.io/eduschool/reference/theme_eduschool.md)
  pour reutiliser la charte depuis R et dans les graphiques `ggplot2` ;
- ajout de `documentation/charte-graphique.md` pour documenter les
  principes visuels du package ;
- les fiches HTML utilisent des ressources externes dans un repertoire
  `<nom>_files/` au lieu d’encoder le logo en base64, afin d’alleger les
  fichiers HTML et leur generation ;
- la synthese pedagogique et les representations visuelles utiles
  priment desormais sur une contrainte fixe de pagination des fiches.

### Consolidation du mini-SI

- ajout de metadonnees relationnelles explicites dans
  `inst/metadata/tables.csv`, `colonnes.csv` et `relations.csv` ;
- ajout de controles generiques des schemas, cles primaires, cles
  etrangeres et domaines structurants ;
- ajout d une seconde couche de controles semantiques :
  niveau/voie/serie, portee des horaires, programmes/niveaux et
  coherence temporelle des versions ;
- lecture deterministe des CSV comme donnees textuelles brutes, avec
  conversions metier explicites ;
- ajout d un schema relationnel SVG genere dynamiquement depuis les
  metadonnees ;
- ajout de la vignette technique « Rentrer en profondeur dans eduschool
  » ;
- correction du millesime 2025-2026 du programme de mathematiques de
  cycle 3 en sixieme et ajout de la version manquante au referentiel
  temporel.

### Fiches de revision mathematiques

- ajout d’un moteur de fiches de revision structurees, distinct du
  moteur d’exercices ;
- ajout de
  [`familles_revision()`](https://gilles13.github.io/eduschool/reference/familles_revision.md),
  [`fiches_revision()`](https://gilles13.github.io/eduschool/reference/fiches_revision.md),
  [`generer_revision()`](https://gilles13.github.io/eduschool/reference/generer_revision.md),
  [`generer_essentiel()`](https://gilles13.github.io/eduschool/reference/generer_essentiel.md)
  et
  [`produire_revision()`](https://gilles13.github.io/eduschool/reference/produire_revision.md)
  ;
- premiere couverture complete de la seconde generale et technologique :
  logique, algorithmique, nombres et algebre, geometrie, fonctions,
  statistiques-probabilites et automatismes ;
- ajout d’une fiche `ESSENTIEL` volontairement tres compacte ;
- liaison des fiches aux notions pedagogiques existantes afin d’eviter
  une seconde source de verite ;
- ajout de schemas generes avec les capacites graphiques de R, sans
  nouvelle dependance graphique obligatoire ;
- rendu HTML/PDF suivant le meme principe que les fiches d’exercices.
- ajout d un index pkgdown dedie aux fiches essentielles de
  mathematiques et d une premiere fiche 6e ;
- suppression du graphique de comptage des themes dans la vignette 2de,
  qui refletait surtout la granularite inegale du referentiel ;
- preparation d une future API publique de composition de fiches
  personnalisees a partir de templates simples.

## eduschool 0.10.9

### Consolidation documentaire et ergonomie

- noms de fichiers automatiques pour
  [`produire_fiche()`](https://gilles13.github.io/eduschool/reference/produire_fiche.md)
  et
  [`produire_corrige()`](https://gilles13.github.io/eduschool/reference/produire_corrige.md),
  avec conservation de la possibilite de fournir un nom explicite ;
- rendu des fiches allege : logo plus discret, aligne a gauche, et titre
  HTML transmis proprement a Pandoc ;
- ajout d’une vignette complete consacree a la seconde generale et
  technologique (`2GT`) : enseignements, couverture pedagogique, focus
  mathematiques et orientations vers la premiere ;
- harmonisation des vignettes existantes sans fusionner leurs roles
  respectifs ;
- mise a jour de la navigation pkgdown, du README et des exemples de
  generation de fiches ;
- exclusion des fiches et corriges generes a la racine du depot afin
  d’eviter de versionner des artefacts de rendu.

## eduschool 0.10.8

### Fiches HTML et PDF

- ajout de
  [`produire_fiche()`](https://gilles13.github.io/eduschool/reference/produire_fiche.md)
  et
  [`produire_corrige()`](https://gilles13.github.io/eduschool/reference/produire_corrige.md)
  pour envoyer directement la sortie de
  [`generer_fiche()`](https://gilles13.github.io/eduschool/reference/exercices.md)
  vers un document ;
- ajout d’un template R Markdown commun aux sorties HTML et PDF ;
- ajout de `format = "auto"` : PDF lorsque LaTeX est disponible, HTML
  sinon ;
- mise a jour du README et des vignettes pour presenter le nouveau flux
  avec le pipe natif `|>`.

## eduschool 0.10.7

### Premiers pas

- simplification du README et de la vignette de sixieme autour des
  usages immediats ;
- limitation des tableaux affiches dans la vignette afin de conserver
  une lecture confortable sur le site pkgdown ;
- ajout de l argument `afficher` aux fonctions de generation d exercices
  pour afficher directement les enonces sans devoir affecter le resultat
  a un objet.

## eduschool 0.10.6

### Experience utilisateur

- ajout de
  [`genere_resume()`](https://gilles13.github.io/eduschool/reference/genere_resume.md)
  pour produire une synthese courte et directement affichable dans les
  vignettes et le site pkgdown ;
- filtrage facultatif par matiere avec `matiere = "all"` par defaut et
  prise en charge d’identifiants ou d’alias usuels ;
- limitation configurable du nombre de themes et de notions afin de
  conserver des tableaux lisibles.

## eduschool 0.10.5

### Collège — couverture transdisciplinaire

- extension des synthèses pédagogiques aux classes de 5e, 4e et 3e pour
  l’ensemble des enseignements obligatoires ;
- prise en compte des millésimes effectivement applicables en 2026-2027,
  notamment pour le français, les mathématiques et les langues vivantes
  ;
- ajout de thèmes et de capacités représentatives en
  histoire-géographie, EMC, physique-chimie, SVT, technologie, EPS, arts
  plastiques et éducation musicale ;
- ajout de notions documentaires transdisciplinaires permettant à
  [`resume_niveau()`](https://gilles13.github.io/eduschool/reference/resume_niveau.md)
  de produire des sorties utiles sur tout le collège.

### Sixième transdisciplinaire

- enrichissement des programmes de 6e dans l’ensemble des enseignements
  obligatoires ;
- ajout de thèmes et de quelques capacités représentatives hors
  mathématiques ;
- ajout de notions pédagogiques reliées aux capacités ;
- ajout des fonctions
  [`horaires_niveau()`](https://gilles13.github.io/eduschool/reference/horaires_niveau.md),
  [`themes_niveau()`](https://gilles13.github.io/eduschool/reference/themes_niveau.md),
  [`notions_niveau()`](https://gilles13.github.io/eduschool/reference/notions_niveau.md)
  et
  [`resume_niveau()`](https://gilles13.github.io/eduschool/reference/resume_niveau.md)
  ;
- ajout de la vignette vitrine « Explorer une classe de 6e avec
  eduschool » ;
- premiers enrichissements du graphe de prérequis en mathématiques.

### Graphe de prérequis de sixième

- enrichissement raisonné des prérequis mathématiques de 6e ;
- ajout de relations sur les fractions, grandeurs, géométrie, données,
  probabilités et algorithmique ;
- distinction entre prérequis requis et notions simplement utiles ;
- ajout de contrôles de cohérence des références et de l’absence de
  cycle dans le graphe.

## eduschool 0.10.4

### Programmes du lycée — lot 1

- Détail du programme de spécialité de mathématiques de terminale
  générale applicable en 2026-2027.
- Ajout de 16 sous-thèmes et de 53 capacités attendues, structurés sous
  les domaines existants.
- Liaison des nouvelles capacités aux notions pédagogiques
  correspondantes.
- Référencement explicite du BO spécial n°8 du 25 juillet 2019
  (MENE1921246A).

### Terminale générale — consolidation

- Enrichissement pédagogique des notions mobilisées par la spécialité
  mathématiques.
- Détail des capacités de l’option mathématiques complémentaires
  (programme 2019 applicable en 2026-2027).
- Détail des capacités de l’option mathématiques expertes : nombres
  complexes, arithmétique, graphes et matrices.
- Ajout des relations entre capacités et notions et de fiches de
  révision dédiées aux nombres complexes ainsi qu’aux graphes et
  matrices.
- Contrôle de cohérence de la couverture de la terminale générale avant
  les nouveaux programmes applicables en terminale en 2027-2028.

### Documentation pédagogique — lot 2

- Enrichissement des 16 fiches de révision associées aux capacités de
  terminale générale spécialité mathématiques.
- Ajout de définitions, méthodes, exemples, vérifications, automatismes
  et erreurs fréquentes adaptés au niveau terminale.
- Précision des descriptions des notions utilisées par le programme de
  terminale.

## eduschool 0.10.3

### Ergonomie des sorties

- Ajout de l’ouverture optionnelle des fichiers générés avec
  `ouvrir = TRUE`.
- Prise en charge de Linux, macOS et Windows avec l’application associée
  au type de fichier.
- Harmonisation du comportement des sorties PDF, HTML et SVG.
- Amélioration du diagnostic lorsque l’environnement LaTeX est
  incomplet.

## eduschool 0.10.2

### Documentation visuelle

- Ajout de diagrammes HTML et SVG pour représenter les parcours
  scolaires et l’architecture du package.
- Ajout d’un moteur SVG natif en R, sans dépendance à Node.js, npm ou
  Mermaid CLI.
- Ajout de la représentation des cycles scolaires dans le diagramme des
  parcours.
- Ajout de visuels réutilisables dans `man/figures/`.

### Vignettes et documentation

- Illustration des vignettes avec les nouveaux diagrammes SVG.
- Ajout de vignettes consacrées aux parcours scolaires et au
  développement du package.
- Réorganisation de la documentation pkgdown.
- Simplification du README et de l’installation depuis RStudio avec
  `remotes::install_github()`.

### Maintenance du projet

- Nettoyage de l’ancienne infrastructure de chargement du projet.
- Suppression de `launcher.R` et de `dev/session.R`.
- Conservation d’un workflow de contrôle avec `dev/check.R`.

### Documentation pédagogique

- Poursuite de l’enrichissement des fiches de révision du collège.

## eduschool 0.10.1

### Documentation pédagogique

- Enrichissement d’un premier noyau de fiches de révision de 6e et 5e.
- Ajout de méthodes, exemples travaillés, automatismes, contrôles de
  cohérence et erreurs fréquentes.
- Ajout de conventions de rédaction pour guider les futures fiches
  pédagogiques.

## eduschool 0.10.0

- Première architecture de package R.

- Ressources déplacées sous `inst/`.

- Nouvelle résolution des chemins avec
  [`eduschool_path()`](https://gilles13.github.io/eduschool/reference/eduschool_path.md).

- Consultation des référentiels et de la documentation sans état global.

- DuckDB devient une couche optionnelle de requête.

- Ajout d’une documentation utilisateur, de documentation mainteneur et
  de tests `testthat`.

- Ajout d’une stratégie de transition vers un développement piloté par
  Git. \## eduschool 0.10.5 — lot 4 : lycée complet

- couverture synthétique des enseignements communs de seconde, première
  et terminale ;

- couverture représentative des principales spécialités de la voie
  générale ;

- couverture du tronc commun de la voie technologique ;

- ajout de thèmes, capacités et notions documentaires pour les
  disciplines hors mathématiques ;

- [`resume_niveau()`](https://gilles13.github.io/eduschool/reference/resume_niveau.md)
  distingue désormais les programmes par enseignement, ce qui évite de
  mélanger histoire-géographie et HGGSP, par exemple ;

- ajout de la version 2026-2027 des horaires de terminale afin que les
  synthèses par défaut couvrent bien l’année scolaire courante.
