# Contribuer et partager

## Un projet ouvert, mais avec un périmètre clair

`eduschool` cartographie la scolarité au collège et au lycée en France
et produit des outils de révision et d’exercices centrés sur les
mathématiques.

Son architecture relationnelle est suffisamment générique pour
accueillir des extensions, mais cette extensibilité ne doit pas diluer
l’objectif principal du projet.

## Mutualiser les connaissances

Une contribution peut prendre des formes très différentes : corriger un
lien entre deux référentiels, actualiser une source, proposer une
ressource externe, améliorer une visualisation, enrichir une fiche ou
ajouter un modèle d’exercice.

Les données institutionnelles et les contenus pédagogiques gardent
toutefois des statuts différents. Les premières doivent rester traçables
vers les sources de référence ; les seconds peuvent être créés, adaptés
et discutés par la communauté.

## Une API commune pour les fiches du package et les fiches personnelles

La direction fonctionnelle d’`eduschool` est la suivante : une fiche
fournie par le package ne doit pas utiliser un moteur inaccessible à
l’utilisateur. Elle doit être construite avec les mêmes briques
publiques que celles disponibles pour une fiche personnelle.

Le vocabulaire cible est volontairement simple :

``` r

ebauche = creer_fiche(
  niveau = "6E",
  titre = "Fractions - révision rapide"
)

ebauche |>
  ajouter_notions(c("fraction", "pourcentage")) |>
  ajouter_graphique(...) |>
  ajouter_exercices(...) |>
  produire_fiche(...)
```

Ces fonctions de composition sont une **direction d’API** : elles ne
sont pas encore toutes implémentées. Elles seront introduites
progressivement après stabilisation des objets et des conventions, afin
d’éviter de figer trop tôt une interface difficile à faire évoluer.

## Commencer dès maintenant avec les verbes simples

La version 0.12.0 introduit une première façade de consultation :

``` r

parcours("3E")
orientation("2GT")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

Les fonctions historiques restent disponibles pour les usages plus fins.

## Proposer une contribution

Le fichier `documentation/CONTRIBUTING.md` du dépôt précise les
principes techniques. Une contribution pédagogique doit idéalement
indiquer le niveau concerné, les notions ou capacités visées, l’objectif
du support et les liens avec les données existantes.

L’objectif n’est pas de multiplier des fichiers isolés, mais de
construire des briques réutilisables et partageables.
