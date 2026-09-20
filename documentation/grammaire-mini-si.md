# Grammaire du mini-SI eduschool

## Objet

Le mini-SI eduschool ne se réduit pas à un ensemble de fichiers CSV
reliés par des clés. Il représente des objets du domaine scolaire,
documentaire, pédagogique et mathématique, ainsi que les relations qui
existent entre eux.

> **Une table dit de quoi l'on parle. Une relation dit ce qui relie les
> choses. La grammaire dit ce que cette relation signifie.**

Cette grammaire rend explicites les conventions du mini-SI avant sa
croissance. Elle ne cherche ni à renommer systématiquement les tables
existantes, ni à créer une nouvelle couche d'abstraction. Elle sert
d'abord à comprendre le modèle, à nommer précisément ses objets et à
empêcher qu'une convention implicite devienne une dette structurelle.

Trois statuts sont utilisés :

-   **ÉTABLI** : garanti par le modèle, les données ou un contrat
    existant ;
-   **À CLARIFIER** : structure existante dont la sémantique mérite
    d'être précisée ;
-   **À DÉCIDER** : choix d'architecture qui n'a pas encore été arrêté.

Une hypothèse d'audit ne devient jamais une règle simplement parce
qu'elle semble naturelle.

## 1. Les mots du mini-SI

### 1.1 Référents et entités

Objets relativement stables auxquels d'autres objets peuvent se
rattacher : niveau, cycle, voie, série, discipline, enseignement,
programme, notion, concept mathématique, méthode, ressource, examen,
etc.

Ils répondent principalement à la question : **de quoi parlons-nous ?**

### 1.2 Contenus structurés

Objets qui existent comme parties organisées d'un autre objet : objets
de programme, blocs de révision, parties d'examen, questions d'un
exercice composé, paramètres d'un gabarit, etc.

### 1.3 Faits contextualisés

Tables décrivant le fait qu'une chose vaut ou s'applique dans un
contexte : application d'un programme à un niveau et une version,
horaire, offre d'enseignement, événement d'une campagne Parcoursup, etc.
Le contexte fait partie de leur sens.

### 1.4 Associations

Une association matérialise une relation entre plusieurs objets : fiche
et notion, modèle d'exercice et capacité, ressource et usage, concept et
objet de programme, etc.

Une association peut porter ses propres propriétés : rôle, ordre,
importance, poids, statut ou autre qualificatif.

### 1.5 Objet physique et objet métier

Un objet métier n'a pas nécessairement sa propre table.

**ÉTABLI ---** une capacité est actuellement un objet de programme dont
`programme_items$type == "CAPACITE"`. Elle n'est pas une entité physique
indépendante.

## 2. Une relation est une phrase

Toute relation importante doit pouvoir être lue comme une phrase métier
:

> **sujet --- verbe --- objet**

Exemples établis ou directement lisibles dans les métadonnées :

-   un programme **contient** des objets de programme ;
-   un objet de programme **peut avoir pour parent** un autre objet de
    programme ;
-   un programme **s'applique à** un niveau dans une version ;
-   une fiche de révision **contient** des blocs ;
-   une fiche de révision **couvre** des notions ;
-   une fiche de révision **travaille** des concepts mathématiques ;
-   un modèle d'exercice **exerce** des capacités ;
-   un patron d'exercice **mobilise** des concepts et des méthodes ;
-   une notion **requiert** éventuellement une autre notion ;
-   un gabarit composé **est compatible avec** un contexte.

Le nom physique de la table n'a pas besoin d'incorporer le verbe.
`fiche_notions` peut rester concise si le dictionnaire établit
clairement que la relation signifie « une fiche couvre une notion ».

**À CLARIFIER ---** le verbe canonique de certaines relations dépend
encore de leurs valeurs de `role`, notamment `notions_capacites` et
`concepts_items_math`.

## 3. Les vocabulaires contrôlés

### 3.1 `type`

`type` est, par défaut, un discriminant local à l'objet qui le porte.
Les domaines observés diffèrent selon les tables : `CAPACITE` /
`DOMAINE` / `THEME` pour les objets de programme ; `ESSENTIEL` /
`THEMATIQUE` pour les fiches ; `AUTOMATISME`, `DEFINITION`, `FORMULE`,
`METHODE`, `OUVERTURE`, etc. pour les blocs.

Il n'existe donc pas, par principe, de référentiel global des types.

### 3.2 `role`

`role` qualifie localement une relation. Des valeurs comme `PRINCIPALE`,
`CENTRAL`, `MOBILISE`, `PREREQUIS`, `PROLONGEMENT` ou `ASSOCIE` existent
dans des relations différentes.

Le partage du nom de colonne ne suffit pas à établir un vocabulaire
commun.

### 3.3 `statut`

**À CLARIFIER ---** `statut` est employé pour plusieurs dimensions :
état de vie (`ACTIF`), modalité (`OBLIGATOIRE`, `OPTIONNEL`,
`SPECIALITE`), position temporelle (`ACTUEL`, `HISTORIQUE`), caractère
institutionnel (`OFFICIEL`), état d'une campagne (`CLOTUREE`), etc.

Ces domaines ne doivent pas être confondus ni réunis artificiellement.

### 3.4 Autres qualificatifs

`importance`, `portee`, `ordre`, `poids` et les autres propriétés
restent locaux par défaut.

Deux colonnes portant le même nom ne partagent un vocabulaire contrôlé
que si eduschool leur donne explicitement le même sens.

## 4. Modèle physique et règles métier

Une clé étrangère décrit une contrainte du modèle relationnel. Elle ne
suffit pas à exprimer toute la règle métier.

Il faut distinguer :

-   la clé étrangère ;
-   sa nullabilité ;
-   la cardinalité physique ;
-   la cardinalité métier ;
-   les éventuels minimums et maximums métier.

**À DÉCIDER ---** les cardinalités métier ne sont pas encore
contractualisées systématiquement. Elles ne doivent pas être déduites
automatiquement des seules clés étrangères.

## 5. Hiérarchies et relations réflexives

### 5.1 Hiérarchie des objets de programme

**ÉTABLI ---** `programme_items.parent_item_id` permet à un objet de
programme d'avoir un autre objet de programme pour parent. Cette
hiérarchie participe au fonctionnement du SI.

### 5.2 Prérequis

`prerequis` relie une notion à une autre notion requise. La relation est
orientée : « A requiert B » n'implique pas « B requiert A ».

### 5.3 Relations entre concepts

`relations_concepts_math` possède un vocabulaire riche : `PREREQUIS`,
`GENERALISE`, `SPECIALISE`, `EQUIVALENCE`, `PROLONGE`, `REPOSE_SUR`,
`REPRESENTE`, `UTILISE`, etc.

**À CLARIFIER ---** chaque type de relation doit préciser, lorsque cela
est pertinent, s'il est orienté, symétrique ou hiérarchique. Cette
propriété ne doit pas être déduite uniquement du libellé.

Les couples proches `EQUIVALENCE` / `EQUIVALENCE_LOCALE`, `PROLONGE` /
`PROLONGEMENT`, `SPECIALISE` / `SPECIALISATION` et `MODELISATION` /
`MODELISE` devront être vérifiés avant toute normalisation.

## 6. La granularité fait partie du sens

**ÉTABLI ---** `programme_applications` exprime l'application d'un
programme à un niveau et une version, éventuellement sur une période.

**ÉTABLI ---** `programme_items_applications` exprime l'application d'un
objet précis d'un programme à un niveau et une version.

La seconde relation travaille à une granularité plus fine. Une
rationalisation ne doit jamais fusionner deux relations simplement parce
qu'elles partagent plusieurs clés.

## 7. Relation principale et relations mobilisées

Certains objets portent directement un concept principal tout en
possédant parallèlement une association vers plusieurs concepts
mobilisés.

Cette coexistence n'est pas nécessairement une duplication : le concept
principal structure l'identité ou l'intention première de l'objet ; les
concepts mobilisés décrivent les connaissances auxquelles il fait
également appel.

## 8. Règles fondamentales de la grammaire

### G1 --- Distinguer objet physique et objet métier

Un concept métier n'a pas nécessairement sa propre table. Sa
représentation physique doit être documentée.

### G2 --- Toute relation doit pouvoir être exprimée par une phrase métier

Si sujet, verbe et objet restent impossibles à formuler clairement, la
relation n'est probablement pas encore assez comprise.

### G3 --- Le nom physique n'a pas à contenir le verbe

Le nom de table identifie les objets reliés ; le dictionnaire sémantique
porte le sens de la relation.

### G4 --- Une relation principale n'est pas une relation secondaire

« Concept principal » et « concept mobilisé » représentent des rôles
différents.

### G5 --- Un nom de colonne commun ne prouve pas une sémantique commune

Deux colonnes homonymes peuvent appartenir à des vocabulaires métier
différents.

### G6 --- `role` appartient à sa relation par défaut

Un vocabulaire transversal de rôles n'est créé que si plusieurs
relations partagent réellement le même contrat.

### G7 --- `type` appartient à son entité par défaut

Il décrit une classification locale, sauf contrat contraire explicite.

### G8 --- `statut` doit réellement désigner un état identifiable

Une modalité, une portée, une nature institutionnelle ou une position
temporelle ne devient pas un « statut » par simple commodité.

### G9 --- Un vocabulaire contrôlé est local par défaut

Il ne devient transversal que lorsqu'eduschool lui attribue
explicitement le même sens dans plusieurs territoires.

### G10 --- Cardinalité physique et cardinalité métier sont distinctes

Les clés étrangères décrivent le modèle physique ; les contraintes
métier sont établies séparément.

### G11 --- La granularité fait partie du contrat

Deux relations semblables peuvent être nécessaires si elles décrivent le
domaine à des niveaux de précision différents.

### G12 --- Une relation réflexive doit avoir une direction comprise

Orientation, symétrie et hiérarchie doivent être explicites lorsqu'elles
ont une conséquence métier.

### G13 --- On ne renomme pas pour faire joli

Un renommage est justifié lorsqu'un nom contredit le sens métier, crée
une ambiguïté réelle ou empêche une croissance cohérente.

### G14 --- Une relation composite reste une seule relation

Lorsque l'identité de l'objet cible dépend de plusieurs colonnes, la clé
étrangère porte l'ensemble de ces colonnes. La décomposer en plusieurs
relations indépendantes ferait perdre une partie de la règle métier.

## 9. Carte conceptuelle minimale

``` text
programme
    |
    +-- contient --> objet de programme
    |                  |
    |                  +-- peut avoir un parent
    |                  +-- peut être une CAPACITE
    |                  +-- est relié à --> notion
    |                  +-- est ancré par --> concept mathématique
    |
    +-- s'applique à --> niveau + version

notion
    +-- est expliquée par --> rappel documentaire
    +-- peut requérir -----> notion
    +-- peut être couverte par --> fiche de révision

fiche de révision
    +-- travaille ----------> concept mathématique

concept mathématique
    +-- est relié à --> concept mathématique
    +-- structure --> méthodes / formules / erreurs
    +-- est mobilisé par --> exercices / examens / gabarits

modèle d'exercice
    +-- exerce --> capacité
```

La formulation « est relié à » entre objet de programme et notion reste
volontairement prudente tant que le rôle exact de `notions_capacites`
n'est pas contractualisé.

Cette carte est un repère, pas une tentative de représenter toutes les
tables.

## 10. Avant d'ajouter une table

1.  Quel objet métier représente-t-elle ?
2.  Est-ce un référent, un contenu structuré, un fait contextualisé ou
    une association ?
3.  Cet objet existe-t-il déjà sous une autre représentation ?
4.  Quelle est son identité ?
5.  Son nom physique décrit-il correctement ce dont on parle ?
6.  Ses vocabulaires contrôlés sont-ils locaux ou réellement partagés ?

**Une nouvelle abstraction n'entre dans eduschool que lorsqu'elle a
trouvé du travail.**

## 11. Avant d'ajouter une relation

1.  Quelle phrase métier exprime-t-elle ?
2.  Quel est le sujet ?
3.  Quel est le verbe ?
4.  Quel est l'objet ?
5.  Est-elle orientée, symétrique ou hiérarchique ?
6.  Quelle est sa granularité ?
7.  Quelles cardinalités métier sont réellement connues ?
8.  Porte-t-elle des propriétés propres (`role`, `ordre`, `importance`,
    `poids`, etc.) ?
9.  Une relation existante exprime-t-elle déjà le même sens ?

Si la phrase métier reste difficile à écrire, le modèle n'est
probablement pas encore assez compris pour être codé.

## 12. Avant de renommer

Un renommage doit répondre à un problème identifié :

1.  Le nom actuel contredit-il le sens métier ?
2.  Crée-t-il une ambiguïté observable ?
3.  Deux objets différents portent-ils des noms qui les rendent
    artificiellement équivalents ?
4.  Le nom empêche-t-il d'étendre proprement le modèle ?
5.  Le bénéfice justifie-t-il le coût de migration dans les données, le
    code, les tests et la documentation ?

La cohérence esthétique seule n'est pas une raison suffisante.

## 13. Points encore ouverts

Cette première grammaire ne prétend pas résoudre ce qui n'a pas encore
été établi.

Restent notamment à clarifier :

-   l'articulation canonique entre les notions documentaires `MAT_*` et
    les concepts structurants `MATC_*` ;
-   la sémantique complète des valeurs de `role` dans certaines
    associations ;
-   les différents sens actuellement portés par des colonnes nommées
    `statut` ;
-   les cardinalités métier qui méritent réellement d'être
    contractualisées ;
-   la direction ou la symétrie des différents `type_relation` entre
    concepts ;
-   la distinction exacte entre certains couples proches de relations
    mathématiques.

Ces points sont des chantiers identifiés, pas des défauts supposés.

## 14. Principe de maintenance

La grammaire accompagne le mini-SI ; elle ne doit pas devenir une
seconde base de données maintenue à la main.

Lorsqu'une règle peut être déduite de métadonnées fiables, elle doit
autant que possible rester dérivable. Lorsqu'elle exprime une sémantique
métier qui ne peut pas être déduite du modèle physique, elle doit être
explicitement documentée et, lorsque cela devient utile, protégée par
des contrôles ou des tests.

Le processus reste :

> **documenter → observer → comprendre → modéliser → tester → regarder →
> avancer**

Et avant tout patch structurel :

> **RTFM. Puis seulement le bistouri.**
