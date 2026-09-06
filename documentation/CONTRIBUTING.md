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


## Qui peut contribuer ?

Il n'est pas nécessaire de savoir développer un package R pour contribuer.
Plusieurs regards sont explicitement utiles :

- **« Je connais les maths »** : corriger une formule, une démonstration ou une
  explication, ou proposer une représentation plus claire ;
- **« J'enseigne les maths »** : proposer une progression, un automatisme, un
  exercice ou signaler une présentation pédagogiquement maladroite ;
- **« Je suis parent et je n'ai rien compris non plus »** : indiquer précisément
  où l'explication cesse d'être compréhensible. C'est une contribution à part
  entière ;
- **« Je connais R »** : améliorer les fonctions, graphiques, tests, contrôles,
  performances ou la documentation technique.

**Ne pas comprendre est un cas d'utilisation, pas une erreur utilisateur.** Une
issue qui décrit clairement une difficulté peut donc être aussi utile qu'une
pull request qui apporte déjà sa solution.

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
proposée sous forme de pull request. Des modèles sont fournis pour les
incompréhensions, les exercices, les corrections pédagogiques et les
améliorations techniques. Ils servent à donner quelques repères, pas à demander
un formulaire Cerfa pour corriger une fraction. Pour un nouveau contenu pédagogique, il est
préférable d'expliquer le niveau, la notion ou capacité concernée, l'objectif de
la fiche ou de l'exercice et les données auxquelles le contenu doit se relier.

Le périmètre principal reste volontairement centré sur les mathématiques. Une
extension à une autre discipline est possible grâce à l'architecture générique,
mais elle doit rester clairement identifiable comme une extension du projet.


## Avant de construire une plateforme de contribution

Les issues et pull requests GitHub constituent volontairement le premier système
d'échange du projet. Si elles deviennent insuffisantes, `eduschool` ajoutera un
outillage plus structuré. Pas avant.

> Une nouvelle abstraction n'entre dans `eduschool` que lorsqu'elle a trouvé du
> travail.

Créer un `ContributionProposalFactoryManager` pour éviter quatre modèles d'issues
serait une démonstration particulièrement convaincante du problème que cette
règle cherche à éviter.
