# Charte graphique des fiches eduschool

Cette charte constitue la base visuelle commune des fiches de revision, des
fiches d'exercices et, a terme, des documents composes par les utilisateurs.

## Principes

- la couleur identifie un cycle mais ne porte jamais seule l'information ;
- le bandeau d'identite reste stable d'une fiche a l'autre ;
- le logo eduschool existant est l'unique logo de reference ;
- le fond reste majoritairement blanc afin de conserver une bonne impression ;
- les graphiques pedagogiques utilisent la meme couleur d'accent via
  `theme_eduschool()` ;
- les blocs pedagogiques se distinguent d'abord par leur titre et leur fonction,
  et non par une multiplication de couleurs.

## Palette v0.1

| Identifiant | Perimetre | Couleur |
| --- | --- | --- |
| C3 | Cycle 3 | `#2F6B9A` |
| C4 | Cycle 4 | `#3F7D58` |
| LYCEE | Seconde | `#8A3D5D` |
| CYCLE_TERMINAL | Premiere et terminale | `#8A3D5D` |
| NEUTRE | Usage generique | `#59636E` |

La palette est stockee dans `inst/themes/charte.csv`. Les fonctions de rendu la
lisent au lieu de dupliquer les couleurs dans le code.

## Bandeau d'identite

Le bandeau affiche, dans un ordre stable : cycle, classe, matiere, type de fiche,
titre et logo eduschool. Les informations de niveau et de cycle proviennent du
SI lorsque la fiche est une fiche eduschool.

Pour les sorties HTML, le logo n'est pas encode en base64. Il est copie dans le
repertoire de ressources `<nom>_files/` produit avec la fiche. Le package ne
conserve donc toujours qu'un seul logo de reference ; cette copie est uniquement
un artefact de rendu. Les sorties PDF continuent a integrer directement le logo.

## Graphiques

`theme_eduschool()` fournit le socle ggplot2. Les fonctions graphiques
pedagogiques futures devront retourner des objets ggplot modifiables afin qu'un
utilisateur avance puisse conserver la charte tout en personnalisant son rendu.
