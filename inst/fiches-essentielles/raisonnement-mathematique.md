---
title: "Fiche d’or — Le vocabulaire du raisonnement mathématique"
niveau: "Transversal"
notions:
  - Raisonnement mathématique
  - Logique
  - Ensembles
---

Cette fiche est à connaître **par cœur**. Elle vaut pour l'élève, le parent et,
par mesure de sécurité, pour le développeur d'eduschool.

> **Règle d'or : un élément appartient à un ensemble ; un ensemble est inclus
> dans un autre ensemble.**
>
> On écrit $3 \in \mathbb{N}$ et $\mathbb{N} \subset \mathbb{Z}$.
> Dire qu'« un nombre est inclus dans un ensemble » est désormais un bug.

## Les mots essentiels

| Mot | Définition à retenir | Exemple ou vigilance |
|---|---|---|
| **Élément / appartenance** $\in$ | Un objet est un **élément** d'un ensemble lorsqu'il lui appartient. | $-3 \in \mathbb{Z}$. |
| **Ensemble / inclusion** $\subset$ | Un ensemble est **inclus** dans un autre lorsque chacun de ses éléments appartient à l'autre. | $\mathbb{N} \subset \mathbb{Z}$. |
| **Définition** | Elle fixe précisément le sens d'un mot ou d'un objet mathématique. | Un entier pair est un entier de la forme $2k$, avec $k \in \mathbb{Z}$. |
| **Hypothèse** | Information admise au départ d'un raisonnement et sur laquelle celui-ci peut s'appuyer. | « Soit $n$ un entier pair. » |
| **Conclusion** | Affirmation que l'on cherche à établir à partir des hypothèses. | « Alors $n^2$ est pair. » |
| **Propriété / théorème** | Résultat mathématique démontré, utilisable lorsque ses hypothèses sont satisfaites. | Le théorème de Pythagore ne s'applique pas à n'importe quel triangle. |
| **Conjecture** | Affirmation que l'on pense vraie mais qui n'est pas encore démontrée. | Beaucoup d'exemples concordants peuvent soutenir une conjecture, pas la transformer en preuve. |
| **Preuve / démonstration** | Raisonnement logique qui établit qu'une affirmation est vraie à partir d'éléments admis ou déjà établis. | Chaque étape doit être justifiée. |
| **Contre-exemple** | Exemple qui suffit à montrer qu'une affirmation générale est fausse. | « Tous les nombres premiers sont impairs » : $2$ suffit à réfuter l'affirmation. |
| **Implication** $\Rightarrow$ | « Si A est vraie, alors B est vraie. » | $n$ multiple de 4 $\Rightarrow n$ pair. Cela ne donne pas automatiquement la réciproque. |
| **Réciproque** | On échange l'hypothèse et la conclusion d'une implication. | La réciproque de « multiple de 4 $\Rightarrow$ pair » est fausse : $6$ est pair sans être multiple de 4. |
| **Équivalence** $\Leftrightarrow$ | Les deux implications sont vraies : A implique B **et** B implique A. | $n$ pair $\Leftrightarrow$ il existe $k \in \mathbb{Z}$ tel que $n=2k$. |

## Trois phrases à graver

**Un élément appartient ; un ensemble est inclus.**

**Un exemple illustre. Un contre-exemple réfute. Une démonstration établit.**

**Une implication n'est pas automatiquement une équivalence.**

## Mini-démonstration à relire jusqu'à usure de la fiche

**Hypothèse :** $n$ est un entier pair.

Par définition, il existe donc un entier $k$ tel que $n=2k$.

Alors

$$
n^2=(2k)^2=4k^2=2(2k^2).
$$

Or $2k^2$ est un entier. Ainsi $n^2$ est de la forme $2m$ avec
$m \in \mathbb{Z}$.

**Conclusion :** $n^2$ est pair.

Ce petit raisonnement contient déjà l'essentiel : une hypothèse, une définition,
un enchaînement justifié et une conclusion.

## Le test anti-bug du développeur

- $3 \in \mathbb{N}$ : **oui**, 3 appartient à $\mathbb{N}$ ;
- $\mathbb{N} \subset \mathbb{Z}$ : **oui**, $\mathbb{N}$ est inclus dans $\mathbb{Z}$ ;
- « 3 est inclus dans $\mathbb{N}$ » : **non** ;
- « $\mathbb{N}$ appartient à $\mathbb{Z}$ » : **non**.

Dans eduschool, on utilise ici $\subset$ pour noter l'inclusion. D'autres ouvrages
peuvent distinguer explicitement inclusion et inclusion stricte avec des
conventions de symboles différentes : il faut toujours vérifier la convention
annoncée.

## Ouvrir la porte suivante

Une fois ces mots maîtrisés, on peut commencer à jouer sérieusement avec la
**logique** : négation, « et », « ou », quantificateurs, raisonnement par
contraposée, raisonnement par l'absurde et démonstration par récurrence.

Pas besoin de tout franchir maintenant. Il suffit de savoir que la porte existe.
