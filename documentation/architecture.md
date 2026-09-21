# Architecture

## Règle 000

> **Simplicité absolue.**

eduschool utilise le format le plus simple adapté au résultat attendu. Une
abstraction, une table, une relation ou un moteur supplémentaire doit avoir un
besoin réel à servir.

Avant d'ajouter une structure, poser la question :

> **Est-ce qu'un `.md`, un `.Rmd` ou une petite fonction R suffit ?**

Si oui, on s'arrête là.

## Les formats ont un travail simple

- **Exercices** : Markdown simple. Le Markdown porte les formulations ; R
  fabrique les valeurs, calcule les réponses et vérifie la vérité mathématique.
- **Fiches** : R Markdown simple (`.Rmd`) pour les synthèses, découvertes,
  révisions et autres supports pédagogiques.
- **Quiz** : un moteur de rendu commun produit HTML et PDF et porte le feedback.
  Le navigateur n'est pas un second moteur de mathématiques.
- **Sorties** : une charte graphique eduschool commune rationalise l'apparence
  des productions sans imposer un moteur unique à leurs contenus.
- **Produits utiles** : R Markdown tant que cela suffit, par exemple une carte
  des mathématiques. On ne construit un moteur générique qu'après plusieurs
  usages réels.

## Une frontière simple

> **R sait. Le Markdown parle.**

R porte les calculs, les tirages contrôlés et les vérifications. Les ressources
éditoriales portent les mots. Une réponse mathématique ne doit jamais être
stockée dans un patron Markdown lorsqu'elle peut être calculée et vérifiée par R.

## Ressources persistantes

Les CSV restent adaptés aux vrais référentiels et aux données relationnelles qui
ont besoin de l'être. Ils ne sont pas le format par défaut d'un texte
pédagogique.

Les anciens contenus de `inst/exercices/`, `inst/fiches-decouverte/` et
`inst/fiches-essentielles/` constituent un **gisement à récupérer**, pas une
architecture à reproduire. Tant qu'un contenu ancien est encore utilisé par le
code, il reste en place. Les nouveaux développements suivent les règles simples
ci-dessus et l'ancien monde disparaît au rythme de sa récupération.

## Humour

L'humour fait partie d'eduschool. Il reste volontairement minuscule : un petit
`data.frame`, un texte et un niveau.

- `0` : possible, mais déconseillé ;
- `1` : tout public, **niveau par défaut** ;
- `2` : taquin ;
- `3` : plus libre, toujours sous contrôle éditorial.

Le sérieux porte sur les mathématiques, pas sur le ton. L'humour ne modifie
jamais la vérité mathématique et ne vise jamais l'élève, ses difficultés ou les
personnes concernées par les données.

## Règle de dépendance

Le code métier ne dépend pas du répertoire courant. Toute ressource installée
passe par `eduschool_path()`.
