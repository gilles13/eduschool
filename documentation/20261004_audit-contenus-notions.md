# Audit des contenus des notions

Ce document conserve les conclusions de l'audit transversal des contenus
d'eduschool.

Il ne constitue ni une nouvelle spécification ni une obligation de
migration. Son objectif principal est d'éviter de recommencer
l'exploration globale du catalogue lors d'une prochaine reprise.

> **Ne pas recommencer l'audit global en REPL. Partir des conclusions
> ci-dessous et des retours obtenus en utilisant réellement les fiches,
> quiz et questions.**

## État observé

L'audit porte sur les 78 notions actuellement présentes dans
`inst/notions/`.

Les 78 fichiers `questions.json` contiennent au total 399 gabarits de
questions.

Types structurels observés : 394 `qcm`, 3 `exercice` et 2
`comprehension`.

Modes de réponse observés : 334 `editoriale`, 44 `calcul_fixe`, 13
`symbolique_fixe` et 8 `relation_fixe`.

65 gabarits utilisent Ryacas. 42 gabarits utilisent des `variantes`,
répartis entre 35 notions. 33 notions utilisent au moins une
présentation alternative, notamment `boite`, `mot_a_trou` et
`mot_masque`.

La distinction entre le `type` structurel d'une question et sa
`presentation` est importante. Un gabarit de type `qcm` peut être
présenté pédagogiquement sous une autre forme.

## Ancien et nouveau contenus

L'absence de `variantes` ne signifie pas qu'une notion est ancienne,
pauvre ou à refaire.

Certaines banques sans variantes sont déjà riches par le nombre et la
diversité de leurs questions, leurs illustrations, leurs distracteurs ou
leurs corrections. Par exemple, `cercle` possède 7 questions toutes
illustrées et corrigées avec des présentations alternatives ; `thales`
possède 12 gabarits dont 9 illustrés ;
`trigonometrie_triangle_rectangle` possède 15 gabarits dont 13 illustrés
; `puissances_exposant_positif` possède 14 gabarits et plusieurs
présentations alternatives.

Il ne faut donc pas chercher à convertir systématiquement les contenus
existants vers une architecture unique. Le nouveau framework est un
moyen de produire de meilleurs contenus lorsque cela est utile, pas une
norme imposant de réécrire ce qui fonctionne déjà.

## Variantes

Les variantes sont particulièrement utiles lorsqu'une notion doit
permettre l'entraînement et l'acquisition d'automatismes.

Une question calculatoire fondée sur une seule combinaison numérique
peut être pédagogiquement correcte tout en étant trop pauvre pour des
quiz répétés. Les variantes doivent permettre de conserver un même
objectif pédagogique avec plusieurs situations mathématiques
pertinentes.

La démarche retenue est :

1.  explorer les paramètres avec des helpers locaux et jetables ;
2.  sélectionner un ensemble fini de situations pédagogiquement
    intéressantes ;
3.  vérifier les résultats ;
4.  construire des distracteurs plausibles et sans collision ;
5.  stocker le contenu contrôlé dans le JSON ;
6.  laisser le runtime choisir parmi ce contenu fini.

Le nombre de variantes dépend de la notion et du besoin pédagogique. Il
n'existe pas d'objectif tel que « 50 variantes par question ».

## Cas étudié : `fractions_addition`

`fractions_addition` constitue un bon exemple de contenu à enrichir sans
le reconstruire.

La notion contient quatre gabarits pédagogiquement différents : calcul
direct, recherche d'un terme manquant, identification d'une égalité
erronée et raisonnement progressif conduisant au résultat.

Les quatre gabarits disposent de corrections et de distracteurs
pertinents. Ryacas est déjà utilisé pour les réponses calculées ou les
relations. En revanche, les valeurs mathématiques sont actuellement
fixes, par exemple `1/2 + 1/3`, `□ + 1/3 = 5/6` ou `1/4 + 1/2`.

La bonne évolution consiste donc à conserver les angles pédagogiques
existants et à enrichir leurs banques de situations.

Pour l'addition de fractions, les variantes pourront notamment couvrir :
mêmes dénominateurs ; un dénominateur multiple de l'autre ; recherche
d'un dénominateur commun ; résultat nécessitant une simplification ;
résultat déjà irréductible ; résultat inférieur, égal ou supérieur à 1
lorsque cela est pertinent.

Les distracteurs doivent rester liés à des erreurs plausibles. Il ne
faut pas remplacer les distracteurs pédagogiques actuels par des valeurs
aléatoires.

`fractions_addition` est donc classée provisoirement comme :

> **bonne architecture pédagogique, banque mathématique trop figée :
> enrichir, ne pas reconstruire.**

## Famille des fractions

La famille `fractions` constitue la priorité immédiate de l'audit des
contenus.

### Notation mathématique dans les fiches

La fiche `decouverte.md` de `fractions_addition` présente correctement
les fractions sous forme mathématique, avec numérateur et dénominateur
disposés verticalement.

Cette qualité d'affichage n'est pas homogène dans les autres fiches
consacrées aux fractions. Les `decouverte.md` et `synthese.md` de la
famille doivent être examinés afin d'utiliser une notation fractionnaire
mathématique cohérente lorsque des fractions sont présentées à l'élève.

L'objectif est de retenir une convention éditoriale cohérente pour toute
la famille.

### Richesse des quiz

Les quiz doivent permettre de rencontrer plusieurs questions et
plusieurs situations numériques afin de favoriser l'entraînement et le
développement des automatismes.

Les notions `fractions_*` doivent être examinées une par une afin de
déterminer quels gabarits existants doivent être conservés, quelles
questions gagnent réellement à recevoir des variantes, quelles
situations mathématiques doivent être représentées, quels distracteurs
correspondent à des erreurs plausibles et quelles questions
conceptuelles peuvent rester fixes.

La variabilité n'est pas une fin en soi.

## Fiches des notions

`revision.md` a été abandonné volontairement, car son rôle faisait
doublon avec `decouverte.md` et `synthese.md`. 31 fichiers `revision.md`
résiduels ont été supprimés lors de l'audit.

Trois notions ne possèdent actuellement que `questions.json` : `cercle`,
`droites` et `parallelogrammes`. Elles sont correctement rattachées au
SI et leurs banques de questions sont déjà illustrées, corrigées et
relativement riches. L'absence de `decouverte.md` et de `synthese.md`
est donc un problème documentaire distinct de la qualité de leurs
questions.

## Principe retenu pour la suite

Une notion ne doit pas être jugée d'après son âge, le nombre de ses
fichiers ou son appartenance supposée à une ancienne génération
technique.

La question utile est :

> **La banque exploite-t-elle suffisamment ce que la notion permet
> d'apprendre, de comprendre et d'entraîner ?**

Si oui, il n'y a aucune raison de la réécrire pour la conformer
artificiellement au framework récent.

Si non, elle doit être enrichie en conservant autant que possible ce qui
fonctionne déjà.

Les retours issus de l'utilisation réelle des fiches et des quiz
deviennent maintenant prioritaires par rapport à la poursuite d'un audit
structurel global.

## RETEX d'utilisation — famille fractions

Le retour d'utilisation du 4 octobre 2026 fixe trois décisions pour la famille `fractions`.

1. Les fiches `decouverte.md` et `synthese.md` doivent toutes repartir des modèles canoniques `documentation/modeles/decouverte.md` et `documentation/modeles/synthese.md`. La boîte **« De quoi parle-t-on ? »** appartient au framework courant et doit donc être présente dans toute la famille.
2. Les fractions destinées à être lues comme objets mathématiques doivent utiliser un rendu mathématique vertical cohérent. Le bon rendu observé historiquement dans `fractions_addition` est généralisé à la famille ; l'écriture brute `a/b` n'est pas utilisée dans les fiches lorsqu'une vraie fraction est attendue visuellement.
3. Chaque notion de la famille doit offrir une variabilité suffisante pour permettre l'entraînement répété et le développement d'automatismes. Cette variabilité repose sur des banques finies préparées et contrôlées en amont ; elle n'impose pas que chaque gabarit individuel devienne variable.

Pour fabriquer ou enrichir une banque variable, partir de `documentation/modeles/atelier_questions.R` et conserver un atelier spécialisé par notion sous la forme `tools/atelier_fractions_xxx.R`. L'atelier est un outil éditorial reproductible hors runtime ; le JSON contient le contenu fini retenu.
