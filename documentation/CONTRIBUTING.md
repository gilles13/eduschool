# Contribuer à eduschool

`eduschool` est un projet open source consacré à deux objectifs : cartographier
la scolarité des collégiens et lycéens en France, et proposer des outils de
révision et d'exercices en mathématiques.

## Ce qui peut être mutualisé

Les contributions peuvent notamment concerner :

- la correction ou l'actualisation d'un référentiel scolaire ;
- l'amélioration des relations entre niveaux, programmes, orientation et sources ;
- une ressource pédagogique externe utile en mathématiques ;
- une fiche de révision, un exemple ou une représentation graphique ;
- un modèle d'exercice reproductible ;
- l'ergonomie de l'API, du site ou de la documentation ;
- les contrôles de cohérence et les tests.

## Un socle commun, des usages libres

Les sources officielles restent distinctes des productions pédagogiques. Les
contributions ne doivent donc pas transformer `eduschool` en source de vérité :
elles doivent préserver la traçabilité et le caractère relationnel des données.

Pour les contenus pédagogiques, la direction du projet est de construire une
API publique de composition. Les fiches officielles d'`eduschool` et les fiches
personnelles devront utiliser les mêmes briques, afin qu'un support puisse être
créé localement, adapté puis partagé sans réécriture spécifique.

## Principes techniques

- privilégier les données structurées aux valeurs codées dans les fonctions ;
- conserver des identifiants stables et des relations explicites ;
- éviter les dépendances supplémentaires lorsqu'elles ne sont pas nécessaires ;
- accompagner toute nouvelle logique métier de tests ;
- générer les diagrammes depuis les données plutôt que maintenir des copies
  statiques ;
- ne pas modifier `docs/` manuellement : le site pkgdown y est généré.

## Proposer une contribution

Une contribution peut commencer par une issue décrivant le besoin, puis être
proposée sous forme de pull request. Pour un nouveau contenu pédagogique, il est
préférable d'expliquer le niveau, la notion ou capacité concernée, l'objectif de
la fiche ou de l'exercice et les données auxquelles le contenu doit se relier.

Le périmètre principal reste volontairement centré sur les mathématiques. Une
extension à une autre discipline est possible grâce à l'architecture générique,
mais elle doit rester clairement identifiable comme une extension du projet.
