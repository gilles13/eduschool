---
title: "Je te crois. Mais prouve-le !"
niveau: "Découverte"
notions:
  - Raisonnement
  - Conjecture
  - Preuve
  - Démonstration
  - Contre-exemple
  - Quantificateurs
---

## Je te crois

Commençons par une affirmation qui ne devrait déclencher aucune dispute :

\[
2 + 2 = 4
\]

Je le sais.

Tu le sais.

La calculatrice le sait.

R le sait aussi.

Tout le monde est d'accord.

Très bien.

Mais faisons un pas de côté.

> **Pourquoi est-ce vrai ?**

« Parce que \(2+2=4\). »

Certes.

Mais ce n'est pas vraiment une explication.

Alors essayons autre chose.

## Voir n'est pas démontrer

Prenons deux objets.

Puis encore deux objets.

On compte :

\[
\bullet\ \bullet
\qquad+\qquad
\bullet\ \bullet
\]

et on obtient quatre objets :

\[
\bullet\ \bullet\ \bullet\ \bullet
\]

Cela semble déjà plus convaincant.

Nous venons de **vérifier** que \(2+2=4\) avec quatre objets.

Recommençons avec des pommes.

Puis des cailloux.

Puis des bonbons.

Toujours :

\[
2+2=4
\]

Après mille essais, nous serions probablement très confiants.

Mais avons-nous vraiment **démontré** quelque chose ?

Ou avons-nous seulement accumulé des exemples ?

La distinction paraît subtile.

Elle est pourtant au cœur des mathématiques.

## Observer, puis imaginer

Regardons maintenant cette suite :

\[
2,\quad 4,\quad 6,\quad 8,\quad 10,\quad 12
\]

Tous ces nombres sont pairs.

Et leur carré ?

\[
2^2=4
\]

\[
4^2=16
\]

\[
6^2=36
\]

\[
8^2=64
\]

Ils sont encore pairs.

Tiens...

On pourrait commencer à penser :

> **Le carré d'un nombre pair est toujours pair.**

Nous venons de faire quelque chose de très mathématique.

Nous avons observé plusieurs cas puis formulé une affirmation générale.

Une affirmation que l'on pense vraie, mais que l'on n'a pas encore démontrée, s'appelle une **conjecture**.

Nous avons donc un nouveau chemin :

\[
\text{observer}
\longrightarrow
\text{conjecturer}
\]

Mais attention.

Une conjecture peut être vraie.

Elle peut aussi être fausse.

## Testons !

Nous pourrions continuer :

\[
10^2=100
\]

pair.

\[
100^2=10\,000
\]

pair.

Nous pourrions même demander à R de tester les 500 000 premiers nombres pairs.

Imaginons qu'il réponde :

`TRUE`

Excellent.

Alors maintenant, c'est démontré ?

...

**Non.**

Nous avons seulement beaucoup, beaucoup, beaucoup vérifié.

Et pourtant, aucun test n'a échoué.

Voilà quelque chose d'étrange :

> **Une énorme quantité d'exemples peut donner confiance sans constituer une démonstration.**

Notre programme n'a vérifié qu'un nombre fini de cas.

Mais notre affirmation dit :

> **tous les nombres pairs.**

Et il y en a une infinité.

\[
\infty
\]

Nous n'allons tout de même pas attendre que R termine.

Il aurait un léger problème de deadline.

## Il faut trouver autre chose

Au lieu de tester les nombres pairs un par un, demandons-nous :

> **Qu'est-ce qu'un nombre pair ?**

Un nombre pair est un entier qui peut s'écrire :

\[
2k
\]

où \(k\) est un entier.

Par exemple :

\[
8 = 2\times4
\]

\[
26 = 2\times13
\]

\[
100 = 2\times50
\]

Mais \(2k\) ne représente pas **un** nombre pair particulier.

Il peut représenter **n'importe quel nombre pair**.

C'est peut-être exactement l'outil qu'il nous fallait.

Prenons donc un nombre pair quelconque :

\[
n=2k
\]

Calculons son carré :

\[
n^2=(2k)^2
\]

donc :

\[
n^2=4k^2
\]

et donc :

\[
n^2=2(2k^2)
\]

Or \(2k^2\) est encore un entier.

Le carré de \(n\) peut donc s'écrire sous la forme :

\[
2\times\text{un entier}
\]

Il est donc pair.

Et cette fois, nous n'avons pas testé :

\[
2,\quad4,\quad6,\quad8,\quad\ldots
\]

un par un.

Nous avons raisonné sur **n'importe quel nombre pair**.

Voilà notre première petite démonstration.

## Un symbole entre en scène

Les mathématiciens disposent d'un symbole pour dire :

> **« pour tout »**

Le voici :

\[
\forall
\]

C'est le **quantificateur universel**.

Nous pouvons commencer à écrire notre affirmation ainsi :

\[
\forall n\in\mathbb{Z},
\]

si \(n\) est pair, alors \(n^2\) est pair.

Le symbole

\[
\mathbb{Z}
\]

désigne l'ensemble des nombres entiers :

\[
\ldots,-3,-2,-1,0,1,2,3,\ldots
\]

Tiens.

Encore un nouvel ensemble.

Encore un nouveau lien.

## Mais comment montrer qu'une affirmation est fausse ?

Essayons maintenant celle-ci :

> **Tous les nombres premiers sont impairs.**

Quelques essais :

\[
3,\quad5,\quad7,\quad11,\quad13,\quad17
\]

Tous impairs.

Ça commence bien.

On pourrait en tester cent.

Mille.

Un million.

Mais il existe un petit problème.

Un tout petit problème.

\[
2
\]

Deux est un nombre premier.

Et deux est pair.

**BOUM.**

Notre affirmation est fausse.

Nous n'avons pas eu besoin de tester tous les nombres premiers.

Un seul exemple a suffi à détruire une affirmation qui prétendait être vraie **pour tous**.

Cet exemple particulier porte un nom :

> **un contre-exemple.**

Et voici quelque chose de magnifique.

Pour démontrer une affirmation universelle, il faut montrer qu'elle fonctionne dans tous les cas concernés.

Mais pour montrer qu'elle est fausse...

**un seul contre-exemple peut suffire.**

## Deux symboles se rencontrent

Nous connaissons maintenant :

\[
\forall
\]

**pour tout**

et :

\[
\exists
\]

**il existe**

Supposons que quelqu'un affirme :

\[
\forall n,\ P(n)
\]

Cela signifie :

> pour tout \(n\), la propriété \(P(n)\) est vraie.

Pour montrer que cette affirmation est fausse, nous pouvons chercher un \(n\) pour lequel \(P(n)\) est fausse :

\[
\exists n\quad \text{tel que}\quad \neg P(n)
\]

Le symbole

\[
\neg
\]

signifie ici **« non »** ou **« n'est pas vraie »**.

Autrement dit :

> « Tu prétends que cela fonctionne toujours ? »

Très bien.

**Il me suffit peut-être de trouver une seule fois où cela ne fonctionne pas.**

Le quantificateur existentiel vient de trouver du travail.

\[
\exists
\]

## Prouver ou démontrer ?

Dans la vie courante, une **preuve** peut être une photographie, un document, une mesure, une trace ou un témoignage.

En mathématiques, on emploie également le mot *preuve*, mais on parle très souvent de **démonstration**.

Une démonstration est un raisonnement qui part de définitions, de propriétés déjà établies et d'étapes logiques pour montrer qu'une affirmation est nécessairement vraie dans le cadre considéré.

Elle ne dit pas seulement :

> « J'ai essayé et ça marche. »

Elle cherche à dire :

> **« Voilà pourquoi cela doit marcher. »**

C'est une différence considérable.

## Et nos tests alors ?

Revenons à `eduschool`.

Lorsque nous lançons `devtools::test()` et que tous les tests passent, nous apprenons quelque chose d'important.

Les comportements que nous avons décidé de tester ont produit les résultats attendus dans les cas testés.

C'est très utile.

Cela augmente notre confiance.

Mais cela ne signifie pas :

> « eduschool ne contient aucune erreur possible. »

Nos tests ne peuvent pas automatiquement vérifier toutes les utilisations imaginables, toutes les données possibles et tous les états futurs du programme.

Un test logiciel et une démonstration mathématique ne répondent donc pas exactement à la même question.

Et voilà pourquoi notre fameux :

`0 errors — 0 warnings — 0 notes`

est une excellente nouvelle...

mais pas une preuve que le développeur d'`eduschool` est devenu infaillible.

Ouf.

Nous avons eu chaud.

## Et si la démonstration elle-même était fausse ?

Voilà maintenant une question légèrement inquiétante.

Nous pouvons faire une erreur dans un calcul.

Nous pouvons faire une erreur dans un programme.

Alors...

> **peut-on faire une erreur dans une démonstration ?**

Bien sûr.

Une étape peut sembler logique alors qu'elle ne l'est pas.

Une hypothèse peut être oubliée.

Une division peut être effectuée par une quantité qui pourrait être nulle.

Un raisonnement peut tourner en rond.

Une propriété peut être utilisée alors qu'elle n'a pas encore été établie.

Autrement dit :

> **écrire une démonstration ne suffit pas à avoir raison.**

Il faut encore pouvoir la lire, la vérifier, la discuter et éventuellement la corriger.

Tiens donc.

Observer.

Essayer.

Se tromper.

Comprendre.

Corriger.

Recommencer.

Nous connaissons déjà ce chemin.

## Peut-on tout démontrer ?

Nous avons maintenant une méthode formidable.

Alors une dernière question paraît naturelle :

> **Toute affirmation mathématique vraie peut-elle être démontrée ?**

...

Cette porte est beaucoup plus lourde.

Derrière elle se trouvent la logique mathématique, les axiomes, les systèmes formels et quelques résultats qui ont profondément changé notre manière de penser les mathématiques.

Un certain Kurt Gödel a notamment montré, au XXe siècle, que dans des systèmes formels suffisamment puissants pour exprimer l'arithmétique, il existe des limites profondes à ce qui peut être démontré à l'intérieur du système.

Cela ne signifie pas :

> « On ne peut rien démontrer. »

Ni :

> « Les mathématiques sont fausses. »

Cela signifie quelque chose de beaucoup plus subtil.

Et pour aujourd'hui...

nous pouvons parfaitement laisser cette porte entrouverte.

## Alors, qu'avons-nous découvert ?

Peut-être moins de certitudes que prévu.

Mais nous avons commencé à distinguer :

\[
\text{observer}
\longrightarrow
\text{conjecturer}
\longrightarrow
\text{tester}
\longrightarrow
\text{raisonner}
\longrightarrow
\text{démontrer}
\]

Et nous avons découvert qu'un autre chemin pouvait surgir à tout moment :

\[
\text{contre-exemple}
\longrightarrow
\text{conjecture détruite}
\]

Ce n'est pas un échec.

C'est une information.

Une très bonne information, même.

## Une dernière expérience

Je te propose maintenant trois affirmations.

### A

\[
1+3+5+7=16
\]

Tu peux la **vérifier**.

### B

> La somme de deux nombres impairs est toujours paire.

Tu peux essayer quelques exemples.

Puis peut-être chercher à la **démontrer**.

### C

> Tous les nombres de la forme

\[
n^2+n+41
\]

> sont premiers.

Teste :

\[
n=0,\quad1,\quad2,\quad3,\ldots
\]

Cela fonctionne étonnamment longtemps.

Alors ?

**Vrai ?**

**Vérifié ?**

**Démontré ?**

Ou sommes-nous simplement en train d'attendre...

**le bon contre-exemple ?**

Ne cherche pas trop vite la réponse.

Cette fois, la porte est à toi.

---

Je pensais que comprendre les mathématiques consistait à trouver des réponses.

Je découvre peu à peu que cela consiste aussi à apprendre :

> **Pourquoi ai-je le droit de croire que cette réponse est vraie ?**

Et forcément...

cela ouvre encore quelques **liens**.

\[
\forall
\qquad
\exists
\qquad
?
\]

*Un débutant qui commence à se méfier sérieusement des phrases contenant « toujours » et « jamais ».*
