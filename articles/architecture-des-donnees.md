# Sous le capot

## Soulevons le capot

`eduschool` est libre, gratuit et ouvert. Il tente également d’être
transparent. Cela suppose de ne pas seulement montrer ce qu’il permet de
faire, mais d’expliquer d’où viennent ses informations, comment elles
sont représentées, comment ses résultats sont construits, comment ils
sont contrôlés et, surtout, quelles sont les limites de ces contrôles.

Soulever le capot d’`eduschool` ne signifie donc pas tout démonter. Cela
signifie regarder suffisamment sa mécanique pour comprendre ce qui se
passe — et ne rien chercher à cacher dessous.

### 1. Qu’est-ce qu’eduschool ?

`eduschool` est un **mini système d’information pédagogique construit
sous la forme d’un package R**.

Il organise une représentation structurée d’informations concernant
notamment les programmes scolaires, les niveaux, les disciplines, les
capacités, les notions, les exercices et les examens. Ces informations
sont conservées dans des fichiers simples, principalement des CSV, puis
interrogées et transformées par des fonctions R.

R est donc l’outil avec lequel le système est construit. Il n’est pas, à
lui seul, la définition d’`eduschool`.

Une chaîne résume assez bien son fonctionnement :

``` text
réalité → source → représentation structurée → traitement → restitution
```

Cette chaîne est importante parce qu’`eduschool` **ne confond pas une
chose avec sa représentation informatique**.

Un programme scolaire n’est pas un fichier CSV. Une notion mathématique
n’est pas une ligne dans une table. Un exercice n’est pas son modèle de
génération. Les données d’`eduschool` sont des représentations
structurées, nécessairement partielles, de réalités qui existent en
dehors du logiciel.

> **Toujours distinguer une chose, sa représentation dans eduschool et
> la fonction qui permet de l’interroger.**

### 2. D’où viennent les informations ?

Une information scolaire n’entre pas dans `eduschool` simplement parce
qu’elle semble plausible. Le projet conserve des informations de
provenance dans ses métadonnées et dans plusieurs tables métier.

Pour un programme scolaire, il faut ainsi distinguer au moins trois
objets :

- le programme scolaire, qui est la réalité décrite ;
- le texte officiel ou le document institutionnel, qui constitue une
  source ;
- les lignes structurées conservées par `eduschool`, qui représentent
  une partie des informations retenues à partir de cette source.

Par conséquent, écrire :

``` r

programme("6E", "MAT")
```

ne demande pas à `eduschool` de restituer « le programme officiel » au
sens strict. La fonction construit une **vue** à partir des informations
structurées qu’`eduschool` possède pour ce niveau et cette discipline.

La provenance améliore la traçabilité. Elle ne prouve cependant ni que
la source est exempte d’erreur, ni qu’elle a été interprétée ou
transcrite correctement, ni que la représentation d’`eduschool` est
exhaustive.

### 3. Pourquoi des CSV ?

Les ressources distribuées avec le package sont principalement
conservées sous `inst/`. Le choix du CSV est volontaire : un fichier
peut être lu avec un éditeur de texte, un tableur, R ou de nombreux
autres outils sans imposer un moteur de base de données particulier.

Un CSV contient des **lignes** et des **colonnes**. Dans le mini-SI,
certaines colonnes jouent un rôle particulier :

- une **clé primaire** identifie une ligne de manière unique dans une
  table ;
- une **clé étrangère** contient un identifiant qui fait référence à une
  ligne définie dans une autre table ;
- une **relation** décrit ce lien entre les deux représentations.

> **Une clé étrangère ne fusionne pas deux tables. Elle indique comment
> une information d’une table fait référence à une information définie
> dans une autre.**

Le contrat du mini-SI est lui-même décrit dans des CSV :
`inst/metadata/tables.csv`, `colonnes.csv` et `relations.csv` décrivent
les tables, leurs colonnes et leurs relations.

Cette organisation permet de relier des informations sans les recopier
partout. Elle ne transforme pas pour autant le CSV en réalité scolaire :
le fichier reste un **support de représentation**.

### 4. Cohérence n’est pas vérité

`eduschool` contrôle une partie de son mini-SI avec
[`controle_integrite_si()`](https://gilles13.github.io/eduschool/reference/controle_integrite_si.md).
Les métadonnées servent notamment à vérifier la présence des colonnes
attendues, l’unicité des clés primaires et l’absence de certaines clés
étrangères orphelines. Des contrôles supplémentaires vérifient aussi
certaines règles sémantiques ou métier explicitement programmées.

``` r

resume_controles_si()
```

Ces contrôles sont utiles, mais leur portée doit rester claire.

Si une clé étrangère référence bien un identifiant existant, `eduschool`
peut établir que **la relation satisfait ce contrôle structurel**. Il ne
peut pas en déduire que l’information représentée est vraie dans le
monde réel.

De même, un contrôle métier ne vérifie que la règle qui a été formulée
et implémentée. Une règle à laquelle personne n’a pensé n’est pas
contrôlée par magie.

> **Une donnée cohérente peut être fausse. Une donnée sourcée peut être
> mal transcrite. Un contrôle qui passe ne prouve que ce qu’il
> contrôle.**

### 5. Quel est le rôle de R ?

Les fonctions R lisent les représentations, appliquent les règles
nécessaires, relient les informations et construisent des objets
destinés à l’utilisateur.

`eduschool` travaille directement à partir des CSV. Les relations,
contrôles et fonctions métier sont construits au-dessus de ces
ressources persistantes.

La chaîne peut donc être détaillée ainsi :

``` text
sources identifiées
       ↓
représentations dans les CSV
       ↓
relations et contrôles
       ↓
fonctions R
       ↓
vues et objets eduschool
       ↓
fiches / exercices / quiz / examens / HTML / PDF
```

Une fonction publique est ainsi une **interface vers les informations et
les règles du système**, pas la réalité qu’elle décrit.

### 6. Comment un exercice est-il fabriqué ?

La génération d’exercices introduit une autre distinction essentielle :
**modèle, générateur et instance ne désignent pas la même chose**.

Un **modèle** décrit une famille d’exercices et peut être relié à une ou
plusieurs capacités. Un **générateur** est le code R capable de
fabriquer une variante de ce modèle. Une **instance** est l’exercice
effectivement produit avec des valeurs particulières.

``` text
capacité → modèle → générateur R → paramètres → instance
```

Par exemple, remplacer les nombres d’une addition de fractions par
d’autres nombres peut produire une nouvelle instance sans créer un
nouveau modèle pédagogique.

Cette distinction explique une limite importante : un générateur peut
produire beaucoup d’instances techniquement différentes tout en restant
pédagogiquement répétitif.

> **Correction technique et qualité pédagogique sont deux propriétés
> différentes.**

Pour les quiz, une étape supplémentaire peut intervenir : un ensemble
d’instances est d’abord généré, puis le quiz peut sélectionner les
questions à présenter. L’aléatoire n’intervient donc pas nécessairement
à un seul endroit.

### 7. À quoi sert le seed ?

Un `seed`, ou graine pseudo-aléatoire, fixe l’état initial utilisé par
le générateur pseudo-aléatoire de R. Dans un **même contexte de
génération**, il permet de retrouver les mêmes choix pseudo-aléatoires.

Cette précision est essentielle.

Le seed n’est pas, à lui seul, un identifiant universel et permanent
d’un exercice. Si le code, les données, les modèles, leur ordre, les
paramètres ou le mécanisme de sélection changent, le même seed peut
conduire à un autre résultat. Dans un quiz, une sélection effectuée
ensuite dans le navigateur peut en outre introduire une autre étape qui
n’est pas décrite par le seul seed R.

Il est donc plus prudent de considérer le seed comme **une information
de provenance de la génération**, à interpréter avec son contexte, et
non comme une garantie absolue de reproduction future.

La version d’`eduschool` fait notamment partie des informations
importantes pour situer ce contexte. D’autres paramètres peuvent
également être nécessaires selon la production concernée.

### 8. Comment eduschool essaie-t-il de ne pas produire quelque chose de faux ?

Il n’existe pas un contrôle unique capable de certifier `eduschool`.
Plusieurs couches réduisent des risques différents :

1.  **provenance** : conserver l’origine déclarée des informations ;
2.  **structure** : vérifier tables, colonnes, identifiants et domaines
    ;
3.  **intégrité relationnelle** : vérifier certaines références entre
    tables ;
4.  **contrôles métier** : vérifier certaines règles explicitement
    programmées ;
5.  **tests du code** : vérifier des propriétés attendues dans des cas
    définis ;
6.  **contrôle du package** : utiliser notamment `R CMD check` pour les
    problèmes qu’il est conçu pour détecter ;
7.  **inspection humaine** : regarder les contenus et les productions,
    notamment leur pertinence pédagogique.

Ces couches sont complémentaires. Aucune ne signifie « tout est vrai ».

Un test qui passe montre que la propriété explicitement testée est
satisfaite dans les conditions du test. Il ne démontre pas l’absence de
toutes les erreurs possibles.

De la même manière, un `R CMD check` sans erreur, warning ni note
signifie que cet outil n’a détecté aucun problème parmi ceux qu’il
recherche dans ces conditions. Le fameux **0 / 0 / 0** est une exigence
de qualité du projet, pas un certificat de vérité mathématique ou
pédagogique.

### 9. Ce qu’eduschool ne sait pas garantir

`eduschool` tente d’être transparent précisément parce qu’il doit aussi
exposer ses limites.

Il ne peut notamment pas garantir :

- que sa représentation d’un programme est exhaustive ;
- qu’une source ou sa transcription ne contient aucune erreur ;
- que toutes les règles pertinentes ont été transformées en contrôles ;
- que des relations techniquement cohérentes représentent nécessairement
  une réalité correcte ;
- que des tests réussis couvrent tous les cas possibles ;
- qu’un exercice mathématiquement correct est pédagogiquement
  intéressant ;
- qu’un seed, isolé de son contexte de génération, suffira toujours à
  reproduire exactement une production future.

Exposer ces limites n’affaiblit pas les contrôles. Cela indique **ce
qu’ils permettent réellement d’affirmer**.

> **Être transparent sur le fonctionnement d’eduschool, c’est aussi être
> transparent sur ce qu’eduschool ne peut pas garantir.**

### 10. Où regarder ensuite ?

Cette vignette est volontairement une porte d’entrée. Elle montre les
grandes pièces du moteur sans chercher à documenter chaque fonction
auxiliaire.

La vignette **Rentrer en profondeur dans eduschool** détaille le contrat
de données, les clés, les relations et les contrôles du mini-SI.
**Données réelles et provenance** approfondit la question des sources.
Les fonctions publiques et leurs références permettent ensuite
d’examiner précisément les traitements réalisés par le package.

Une bonne manière de continuer consiste à suivre une information de bout
en bout : partir de sa source, retrouver sa représentation, observer les
relations qui la relient aux autres tables, regarder la fonction R qui
l’interroge, puis examiner la restitution obtenue et les contrôles qui
s’appliquent à chaque étape.

Nous n’essayons pas de rendre `eduschool` simple en cachant sa
mécanique. Nous essayons de rendre sa mécanique compréhensible.
