# Ligne éditoriale eduschool

## Principe général

`eduschool` traite sérieusement les données et les mathématiques, mais ne se
prend pas lui-même trop au sérieux.

La documentation peut utiliser l'humour, y compris l'auto-dérision sur le
projet, son architecture, ses contrôles et son ambition. Cet humour doit aider à
lire, mémoriser ou dédramatiser. Il ne doit jamais masquer une règle
mathématique ni se moquer d'un élève, d'un parent ou d'une difficulté réelle.

## Trois règles

1. Une définition, une formule, une consigne et une correction restent exactes.
2. On plaisante sur les situations, le système scolaire et `eduschool` lui-même,
   jamais sur la personne qui apprend.
3. Une blague doit rester courte et laisser immédiatement revenir le contenu
   utile.

## Auto-dérision

L'auto-dérision fait partie de l'identité du projet. Quelques formulations
servent de repères de ton :

> `eduschool` repose sur un petit système relationnel volontairement frugal.
> « Petit » est ici un terme affectueux.

> Les contrôles servent à vérifier que les données restent cohérentes. Ils
> servent aussi à rappeler au développeur que lui, en revanche, ne l'est pas
> toujours.

> Vous n'avez pas besoin de DuckDB pour utiliser `eduschool`. Vous pouvez
> toutefois l'utiliser si consulter trois CSV séparément vous paraît désormais
> beaucoup trop reposant.

## Humour mathématique

L'humour peut renforcer un point de vigilance :

> Le théorème de Pythagore ne fonctionne que dans un triangle rectangle. Même si
> vous y croyez très fort.

> Une fraction n'est pas forcément une division à effectuer. Elle peut très bien
> vivre sa vie tranquillement sous forme de fraction.

Le ton recherché est complice, jamais sarcastique envers l'apprenant.

## Données sensibles

Les données sensibles ne deviennent jamais un prétexte ludique. **L'humour peut
viser `eduschool`, les maths et nos habitudes de développeurs, jamais les
personnes concernées par les données.** Une source statistique réelle peut être
utilisée pour construire un exercice ; la situation fabriquée ne doit jamais
transformer les personnes décrites par cette source en ressort comique.

## Frugalité éditoriale

L'humour suit la même philosophie que les données : inutile d'en stocker des
tonnes. Quelques formulations bien placées valent mieux qu'une plaisanterie à
chaque paragraphe.

Le *Guide d'or* joue le rôle de mémoire complète de cet humour. Ailleurs dans la
documentation, une plaisanterie n'est répétée que lorsqu'elle sert directement
le propos de la page. `HELP PLIZ`, le principe « l'erreur n'est pas un échec » et la règle de
qualité 0 / 0 / 0 peuvent revenir comme motifs d'identité ; les autres formulations ont, autant que possible, un domicile
principal.

## Le droit à l'erreur

Un principe complète désormais la ligne éditoriale :

> **L'erreur n'est pas un échec. C'est une étape pour comprendre et progresser.**

Se tromper, ne pas comprendre du premier coup ou choisir une méthode qui ne
fonctionne pas ne doit pas être présenté comme un échec de l'apprenant. Une
erreur peut révéler une définition trop rapide, un exemple insuffisant, un saut
de raisonnement ou simplement la nécessité d'essayer une autre représentation.

Ce principe en accompagne deux autres :

> **Un savoir prend toute sa valeur lorsqu'il est partagé.**

Comprendre n'est pas seulement accumuler une connaissance. `eduschool` valorise
sa transmission : expliquer, documenter, discuter et partager ce qui a été
appris afin que d'autres puissent à leur tour s'en emparer.

> **Il n'existe pas une seule bonne façon d'apprendre.**

`eduschool` propose donc des pistes, des représentations et des outils. Il ne
prétend ni détenir une méthode pédagogique universelle, ni apprendre les
mathématiques à la place de l'élève, du professeur ou du travail personnel.

La documentation peut l'assumer avec humour :

> **Pourquoi cette formule fonctionne-t-elle ?**
>
> Excellente question. C'est précisément pour éviter d'y répondre par « parce
> que c'est dans le cours » qu'`eduschool` existe.

Et dans les espaces de contribution :

> **Qu'est-ce que vous n'avez pas compris ?**
>
> N'ayez aucune honte. L'auteur du package n'a probablement pas compris non
> plus.

Cette auto-dérision vise l'auteur et le projet, jamais la personne qui demande
de l'aide.

## Navigation et simplicité

La documentation suit la même règle de frugalité que le code. La barre de
navigation indique quelques portes d'entrée ; l'index des guides porte la
structure éditoriale détaillée. La même hiérarchie ne doit pas être reconstruite
à plusieurs endroits sans nécessité.

> **Quand le développeur ne sait plus comment naviguer dans son propre site,
> l'utilisateur n'a aucune chance.**

Une navigation difficile à expliquer doit d'abord être simplifiée avant d'être
enrichie.
