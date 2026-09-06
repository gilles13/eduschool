# Données réelles et provenance

## Invariants de la 0.21.0

La version 0.21.0 ouvre `eduschool` à des données publiques récupérées à la
demande. Cette ouverture ne transforme pas le package en entrepôt de données ni
en collection d'API. Elle fixe au contraire quelques règles simples.

**Les données sont réelles. L'exercice est fabriqué. Le graphique est joli. La source est obligatoire.**

**Dans eduschool, une donnée dont on ne sait pas d'où elle vient est une donnée qui n'est pas encore prête à être utilisée.**

**« Source : Internet » n'est pas une source. C'est un appel à l'aide.**

**Une nouvelle abstraction n'entre dans eduschool que lorsqu'elle a trouvé du travail.**

Les données sensibles ne deviennent jamais un prétexte ludique : **l'humour peut viser eduschool, les maths et nos habitudes de développeurs, jamais les personnes concernées par les données.**

Enfin :

> **eduschool ne collectionne pas les API. Il les appelle quand il a quelque chose d'intelligent à leur demander.**

Cette dernière règle doit notamment éviter que le petit package de maths ne se
transforme accidentellement en réplique miniature de l'administration française.

## Premier adaptateur : Insee / Melodi

Le premier prototype vertical utilise l'API Melodi de l'Insee. Le choix est
volontairement modeste : une source est décrite, vérifiée, appelée, puis sa
provenance accompagne le `data.frame` jusqu'à sa citation ou au graphique.

Le package `melodi` reste optionnel. Décrire une source ou construire sa citation
ne nécessite ni connexion Internet ni nouvelle copie des données dans `inst/`.
L'accès réseau n'a lieu que lors de `recuperer_donnees()` ou d'une vérification
distante explicite.

```r
src = source_insee_melodi(
  "DS_POPULATIONS_REFERENCE",
  filtres = list(GEO = "FRANCE-F"),
  titre = "Populations de référence"
)

decrire_source(src)
verifier_source(src)
```

Lorsque le package optionnel `melodi` est installé et qu'Internet est disponible :

```r
donnees = recuperer_donnees(src)
provenance_donnees(donnees)
citer_source(donnees)
```

L'absence de réseau n'entraîne jamais la substitution silencieuse d'une valeur
locale ou inventée. L'appel échoue avec un message explicite. Une fiche ou un
exercice peut alors être produit autrement, mais il ne doit pas faire passer une
donnée fabriquée pour une statistique officielle.

## Jusqu'au graphique

La provenance peut être reportée directement dans le `caption` d'un graphique
`ggplot2` :

```r
p = ggplot2::ggplot(donnees, ggplot2::aes(TIME_PERIOD, OBS_VALUE)) +
  ggplot2::geom_col()

annoter_source(p, donnees)
```

Le principe est volontairement simple : la provenance est un attribut du jeu de
données, et les fonctions de sortie la lisent au moment où elles en ont besoin.
Pas de registre global, pas de cache caché, pas de framework de fournisseurs de
données dont le principal utilisateur serait son propre diagramme d'architecture.

## Généraliser seulement après usage

L'interface `source_insee_melodi()` / `recuperer_donnees()` / `citer_source()`
constitue un premier cas réel. D'autres producteurs officiels pourront suivre
(Éducation nationale, Météo-France, IGN/API Géo, etc.) lorsque des usages
pédagogiques précis le justifieront.

L'architecture sera alors généralisée à partir de plusieurs cas qui fonctionnent,
et non à partir de l'idée très séduisante qu'un jour quelqu'un pourrait peut-être
avoir besoin d'une fabrique abstraite de connecteurs abstraits.
