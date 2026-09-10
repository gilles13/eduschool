# Le guide d'or d'eduschool

## Bienvenue dans le guide d’or

`eduschool` est un projet extrêmement sérieux.

Les données sont contrôlées, les sources sont documentées, les
mathématiques sont vérifiées et `R CMD check` est regardé avec le
respect dû aux grandes institutions.

Le reste, beaucoup moins.

Ce document rassemble quelques principes, avertissements, accidents
éditoriaux et plaisanteries qui se sont progressivement imposés dans le
projet.

Certaines sont mauvaises.

C’est précisément pour cette raison qu’elles ont été conservées.

## Pourquoi eduschool existe

Au commencement, il y avait un parent.

Ce parent voulait simplement comprendre ce que ses enfants apprenaient à
l’école.

Puis il a essayé de comprendre les programmes.

Puis les mathématiques.

Puis d’expliquer les mathématiques.

Le problème est qu’il ne comprend pas grand-chose aux mathématiques et
qu’il doit quand même aider ses propres enfants.

**HELP PLIZ.**

C’est à peu près à ce moment-là que créer un package R a semblé
constituer une solution raisonnable au problème.

Nous n’avons toujours pas déterminé pourquoi.

## Le principe fondamental

Le but d’`eduschool` n’est pas de construire une plateforme éducative
universelle.

Il est beaucoup plus modeste :

> **expliquer un truc de maths à quelqu’un qui ne l’avait pas compris.**

Si vous pouvez nous aider à y parvenir, bienvenue.

Si vous êtes justement la personne qui n’a pas compris, bienvenue aussi.

Nous avons besoin des deux.

Mais `eduschool` ne prétend pas détenir la bonne méthode.

> **Voir les maths autrement. Toujours avec rigueur.**

> **Il n’existe pas une seule bonne façon d’apprendre.**

Une formule, un dessin, un exemple, un graphique ou une autre
explication peuvent fonctionner différemment selon les personnes et les
moments. Le projet propose des pistes ; il ne prétend pas apprendre les
mathématiques à la place de quelqu’un.

Et lorsque l’essai ne fonctionne pas :

> **L’erreur n’est pas un échec. C’est une étape pour comprendre et
> progresser.**

Cette règle vaut aussi pour les retours produits par le logiciel :

> **eduschool évalue une réponse, jamais la personne qui l’a donnée.**

Un distracteur de QCM peut représenter un raisonnement plausible et
permettre d’en expliquer le point de blocage. Il ne permet jamais
d’affirmer que l’on sait ce que l’élève a pensé. Le commentaire reste
donc factuel, neutre et utile : il ouvre une piste pour la tentative
suivante, sans blâme ni rabaissement.

Et lorsque l’on a fini par comprendre :

> **Un savoir prend toute sa valeur lorsqu’il est partagé.**

`eduschool` préfère donc une connaissance expliquée, discutée et
transmise à un savoir conservé dans son coin. Comprendre est une étape.
Aider quelqu’un d’autre à comprendre est déjà la suivante.

## Les données

Les données ne sont pas là pour faire joli.

Enfin, le graphique peut être joli.

Mais la source reste obligatoire.

La règle est donc :

> **Les données sont réelles. L’exercice est fabriqué. Le graphique est
> joli. La source est obligatoire.**

Et aussi :

> **Dans eduschool, une donnée dont on ne sait pas d’où elle vient est
> une donnée qui n’est pas encore prête à être utilisée.**

Une conséquence immédiate en découle :

> **“Source : Internet” n’est pas une source. C’est un appel à l’aide.**

`eduschool` préfère donc les sources publiques identifiées, documentées
et reproductibles.

Insee, Éducation nationale et autres producteurs publics sont les
bienvenus.

Internet en général devra remplir un formulaire.

## Les API

Une API est un outil.

Pas un animal de compagnie.

`eduschool` n’a donc aucune ambition de collectionner les connexions
simplement parce qu’elles existent.

> **eduschool ne collectionne pas les API. Il les appelle quand il a
> quelque chose d’intelligent à leur demander.**

Même principe pour les données embarquées dans le package :

> **Les données embarquées sont un échantillon, pas un musée.**

Les petits jeux de données locaux servent aux exemples, tests et
vignettes reproductibles.

Les données fraîches restent chez leurs producteurs.

Et surtout :

> **Le réseau sert à actualiser les données. Il ne sert jamais à prouver
> que le package fonctionne.**

Parce qu’un test qui dépend d’Internet teste aussi le Wi-Fi, les DNS, le
proxy, l’Insee et la patience du mainteneur.

Cela commence à faire beaucoup pour un test unitaire.

## Les mathématiques

Les mathématiques occupent une place importante dans `eduschool`.

Ce qui est une décision éditoriale courageuse compte tenu des
compétences initiales du mainteneur.

Nous ne comprenons peut-être toujours pas les maths, mais :

> **nous ne les comprenons plus de manière reproductible.**

C’est déjà un progrès.

Lorsqu’une formule apparaît, la question suivante est donc parfaitement
légitime :

> **Pourquoi cette formule fonctionne-t-elle ?**

Excellente question.

C’est précisément pour éviter d’y répondre par « parce que c’est dans le
cours » qu’`eduschool` existe.

## Les mathématiques et l’économie

Un jour, quelqu’un a eu l’idée d’utiliser des données économiques
réelles pour donner du sens aux mathématiques.

Cette personne n’avait manifestement pas assez de problèmes.

`eduschool` explore donc désormais les pourcentages, indices,
évolutions, moyennes et statistiques au moyen de données économiques.

Avec un avantage pédagogique incontestable :

> **Vous trouviez les pourcentages déprimants ? Attendez de les
> appliquer à l’inflation.**

Un avertissement officiel s’impose.

### Avertissement pédagogique

L’utilisation de données économiques réelles peut provoquer une
compréhension soudaine de l’actualité.

`eduschool` décline toute responsabilité concernant les conséquences sur
le moral du lecteur.

Heureusement :

> **Les mathématiques nous apprennent que tous les problèmes sont
> relatifs. L’économie fournit les données permettant de le vérifier.**

L’économie fournit donc le contexte.

Les mathématiques restent l’objet d’apprentissage.

`eduschool` ne deviendra pas un ministère de l’Économie miniature.

Normalement.

## L’usine à gaz

Une nouvelle abstraction n’est pas automatiquement une amélioration.

Elle doit avoir une raison d’exister.

La règle officielle est donc :

> **Une nouvelle abstraction n’entre dans eduschool que lorsqu’elle a
> trouvé du travail.**

Ce principe protège notamment le projet contre l’apparition du
redoutable :

`ContributionProposalFactoryManager`

Son rôle exact reste inconnu.

Cela constitue probablement sa meilleure caractéristique.

Si quatre types de contribution peuvent être représentés par quatre
fichiers simples, nous utiliserons quatre fichiers simples.

Le jour où douze niveaux d’héritage seront indispensables pour expliquer
une fraction à un élève de sixième, nous réexaminerons la question.

## Le contrôle technique

`eduschool` applique une politique qualité extrêmement sophistiquée :

**0 erreur.  
0 warning.  
0 note.**

Voilà.

Un WARNING n’est pas une décoration de Noël.

Et dans `eduschool` :

> **une NOTE n’est pas une information. C’est un problème qui n’a pas
> encore suffisamment insisté.**

Même la documentation passe donc le contrôle technique.

Même le règlement intérieur.

Même cette vignette.

Surtout cette vignette.

Les fichiers `.Rd` orphelins sont, quant à eux, considérés comme une
forme de poltergeist CRAN.

## Le versionnage

Le versionnage constitue l’une des premières applications concrètes des
mathématiques dans le projet.

Nous avons ainsi découvert successivement que :

- après `0.22.1`, on peut écrire `0.22.2` ;
- le nombre `3` semble également exister ;
- sa présence ouvre des perspectives inquiétantes.

Une feuille de route pédagogique officieuse a été établie :

- `0.22.2` : comprendre 2 ;
- `0.23.0` : découvrir 3 ;
- `0.50.0` : envisager l’addition ;
- `0.99.0` : multiplication ;
- `1.0.0` : regarder la division de loin ;
- `2.0.0` : tenter la division, sous réserve de financement et de
  supervision adulte.

Les mathématiques sont beaucoup plus faciles quand elles servent à
éviter d’écraser un tag Git.

## L’humour

L’humour d’`eduschool` peut viser :

- `eduschool` ;
- son auteur ;
- les mathématiques ;
- l’économie ;
- R ;
- Git ;
- nos habitudes de développeurs ;
- les abstractions inutiles ;
- les erreurs parfaitement évitables découvertes cinq minutes après un
  tag.

Il ne vise jamais les personnes concernées par les données.

La règle est simple :

> **L’humour peut viser eduschool, les maths et nos habitudes de
> développeurs, jamais les personnes concernées par les données.**

Les données et les personnes restent sérieuses.

Nous pouvons nous moquer du reste.

## La navigation

Une documentation doit aider à trouver l’information, pas demander au
lecteur de reconstituer l’arborescence mentale du développeur.

> **Quand le développeur ne sait plus comment naviguer dans son propre
> site, l’utilisateur n’a aucune chance.**

Une conséquence éditoriale en découle :

> **Une page d’index doit aider à choisir où aller, pas prouver qu’on
> possède beaucoup de fichiers.**

Et une vignette parfaitement construite mais introuvable mérite son
propre statut administratif :

> **Une vignette non liée dans la navbar existe techniquement.
> Pédagogiquement, c’est une légende urbaine.**

## Les contraintes utiles

Une fiche essentielle doit rester synthétique. Cela ne signifie pas
qu’une même limite arbitraire convient à la sixième et à la terminale.

> **Une fiche essentielle doit rester synthétique, mais le nombre de
> notions dépend du niveau, pas d’une limite arbitraire fixée trop
> tôt.**

D’où la règle technique correspondante :

> **Une contrainte qui oblige à simplifier le programme plutôt que le
> code est probablement placée au mauvais endroit.**

## La Sainte Trinité

Le contrôle technique possède désormais sa formulation liturgique :

> **La Sainte Trinité d’eduschool : 0 erreur, 0 warning, 0 note.**

Et `R CMD check` vit que cela était bon.

## La récursivité

La récursivité est une notion informatique abstraite. `eduschool`
dispose d’un exemple plus concret :

> **La récursivité, c’est demander régulièrement comment créer l’archive
> qui contient la documentation expliquant comment créer l’archive.**

Ce qui rappelle un principe plus général :

> **Ne pas retenir une commande est un cas d’utilisation, pas une erreur
> utilisateur.**

## Les découvertes tardives

Tout projet logiciel connaît ce moment particulier où une lacune
évidente est découverte juste après avoir terminé une version.

`eduschool` dispose d’une terminologie officielle pour ce phénomène :

> **Un oubli découvert cinq minutes après un tag n’est pas un bug. C’est
> la roadmap de la version suivante.**

Cette méthode de gestion de projet présente l’avantage considérable de
transformer immédiatement tout oubli en stratégie.

## HELP PLIZ

`HELP PLIZ` n’est finalement pas seulement une plaisanterie.

C’est probablement la meilleure description du projet.

Le parent demande de l’aide aux mathématiques.

Les mathématiques demandent parfois de l’aide à R.

R demande de l’aide aux données.

Les données demandent qu’on cite leur source.

Et Git demande régulièrement qu’on arrête de faire n’importe quoi avec
les numéros de version.

Tout le monde a donc besoin d’aide.

Ce qui tombe bien : `eduschool` est un projet collaboratif.

## Se perdre dans son propre site

Une documentation peut contenir toutes les bonnes informations et rester
inutilisable si personne ne sait où elles se trouvent.

`eduschool` a acquis ce savoir de manière expérimentale.

> **Une vignette non liée dans la navbar existe techniquement.
> Pédagogiquement, c’est une légende urbaine.**

Le principe général est encore plus simple :

> **Quand le développeur ne sait plus comment naviguer dans son propre
> site, l’utilisateur n’a aucune chance.**

Quand le développeur commence à se perdre dans le HTML qu’il a lui-même
généré, le projet donne donc quelques signes de faiblesse structurelle.
Avant de rajouter une couche de navigation, `eduschool` préfère
désormais en supprimer deux.

## La récursivité du ZIP

Certaines commandes sont si importantes qu’il faut régulièrement
demander comment les retrouver.

> **La récursivité, c’est demander régulièrement comment créer l’archive
> qui contient la documentation expliquant comment créer l’archive.**

Ne pas retenir la commande n’est pas une erreur utilisateur. Nous avons
déjà un principe pour cela.

## En conclusion

`eduschool` traite sérieusement les données, les mathématiques, leurs
sources et leur reproductibilité.

Il essaie simplement de ne pas se prendre lui-même trop au sérieux.

Si vous savez quelque chose qu’`eduschool` explique mal, dites-le.

Si vous ne comprenez pas quelque chose qu’`eduschool` prétend expliquer,
dites-le encore plus fort.

Et si vous comprenez enfin quelque chose grâce à `eduschool` :

prévenez-nous.

Cela voudra dire que le système fonctionne.

**HELP PLIZ.**
