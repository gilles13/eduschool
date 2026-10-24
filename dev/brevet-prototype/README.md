# Trois prototypes de problemes de brevet

Fichier `prototype.R` : R de base, sans dependance, six variantes de trois configurations.

Execution : `Rscript prototype.R` ou `source("prototype.R")` dans une session R.

- **GEO-A** : triangles emboites, Pythagore, paralleles, Thales, aire.
- **GEO-B** : configuration en papillon, Pythagore, paralleles, Thales, aire.
- **GEO-C** : triangle rectangle, Pythagore, trigonometrie, decision sous contrainte.

Chaque fonction construit des coordonnees, calcule les reponses selon une methode scolaire, puis verifie les resultats par des calculs de coordonnees (distance, produit scalaire, determinant, aire). Le script arrete l'execution si un controle echoue.

**Limites assumees :** ce sont des modeles mathematiques, pas encore des enonces rediges, figures ou PDF. Les controles portent sur les grandeurs et relations ; pas sur la correction redigee ni sur la lisibilite des figures. Les controles n'ont pas ete executes dans R dans cet environnement, faute de Rscript installe.

**A decider apres essai :** qualite pedagogique des enchainements, pertinence des variantes, interet de conserver un modele par configuration, format de stockage des problemes.
