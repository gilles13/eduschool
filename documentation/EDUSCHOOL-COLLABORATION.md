# EDUSCHOOL --- PROTOCOLE DE COLLABORATION

Ce fichier est le point de reprise de la collaboration sur
**eduschool**. Lorsqu'il est fourni dans un nouveau chat ou après une
perte de contexte, il doit être lu **intégralement avant toute
proposition, modification ou patch**.

## 1. Procédure obligatoire de reprise

1.  Lire ce fichier intégralement.
2.  Considérer le ZIP ou l'arborescence eduschool fournie par Gilles
    comme **la seule vérité sur l'état courant du dépôt**. Ne jamais
    reconstruire cet état à partir du souvenir de patches précédents.
3.  Lire `documentation/guide-developpement.md` dans cet état exact du
    dépôt avant tout patch.
4.  Lire ensuite uniquement les autres documents techniques pertinents
    pour le chantier.
5.  Vérifier l'environnement R persistant décrit ci-dessous.
6.  Seulement après ces vérifications, analyser le problème et proposer
    une modification.

## 2. Environnement R de validation

Un environnement R de travail a été préparé dans `/mnt/data/r-persist`.

Références vérifiées :

-   R : `/mnt/data/r-persist/R`
-   lanceur : `/mnt/data/r-persist/Rscript`
-   bibliothèque persistante : `/mnt/data/r-persist/library`
-   R : 4.5.0
-   testthat : 3.3.2
-   Ryacas : 1.1.6
-   jsonlite : 2.0.0
-   ggplot2 : 4.0.3
-   ggsketch : 2.0.0
-   rmarkdown : 2.32
-   knitr : 1.52

Pour exécuter R, utiliser en priorité :

``` bash
/mnt/data/r-persist/Rscript -e '...'
```

Avant de déclarer R ou un package indisponible, vérifier cet
environnement. Ne jamais conclure qu'un outil est impossible à utiliser
avant d'avoir vérifié les moyens disponibles et les paramètres
contrôlables du conteneur.

L'installation système du conteneur peut être éphémère. Les éléments
placés sous `/mnt/data/r-persist` sont donc la référence de travail à
conserver. Si le binaire R persistant ne démarre plus à cause d'une
bibliothèque système disparue, utiliser les archives `.deb` conservées
dans `/mnt/data` pour restaurer l'environnement avant de demander à
Gilles d'effectuer une opération.

## 3. Validation obligatoire avant livraison d'un patch

Un patch eduschool ne doit pas être livré simplement parce que le diff
paraît correct.

Avant livraison :

1.  partir d'une copie neuve de l'état exact fourni par Gilles ;
2.  appliquer le patch avec `git apply --check` ;
3.  appliquer réellement le patch sur cette copie ;
4.  vérifier les JSON et les invariants structurels concernés ;
5.  vérifier les fichiers R modifiés avec les contrôles non-ASCII ;
6.  exécuter les tests R pertinents avec l'environnement
    `/mnt/data/r-persist` ;
7.  exécuter autant que possible la suite complète de tests ;
8.  exécuter `R CMD check` lorsque les dépendances nécessaires sont
    disponibles ;
9.  ne déclarer réussis que les contrôles réellement exécutés.

Si un contrôle ne peut pas être exécuté, dire précisément lequel et
pourquoi. Ne jamais transformer cette impossibilité en validation
implicite.

## 4. Règle de simplicité

Règle d'or :

> **La beauté n'est pas quand il n'y a plus rien à ajouter, mais quand
> il n'y a plus rien à retirer.**

Avant d'ajouter du code :

1.  chercher ce qui peut être supprimé ;
2.  corriger la responsabilité existante à sa source ;
3.  réutiliser les mécanismes déjà choisis ;
4.  seulement si cela ne suffit pas, proposer explicitement une nouvelle
    logique à Gilles **avant de l'implémenter**.

Ne jamais introduire silencieusement :

-   une nouvelle abstraction ;
-   une exception locale ;
-   une nouvelle branche spéciale ;
-   une succession de `if` destinée à sauver des cas particuliers ;
-   une boucle ou un parser destiné à reconstruire une sémantique qui
    devrait être explicite dans les données.

Si une correction augmente réellement la complexité, l'annoncer et
obtenir l'accord de Gilles avant de la coder.

Lorsqu'un problème similaire apparaît dans une autre notion ou famille,
revoir le fonctionnement global plutôt que d'empiler une nouvelle
exception.

## 5. Mathématiques : Ryacas/Yacas d'abord

Avant toute proposition touchant aux mathématiques, vérifier
sérieusement ce que **Ryacas/Yacas** sait déjà faire.

Ne pas réimplémenter dans eduschool le calcul, la transformation, la
simplification, la manipulation symbolique, les équivalences ou les
contrôles mathématiques que Ryacas/Yacas sait effectuer.

Mais Ryacas/Yacas travaille **en amont**, pendant la fabrication et la
validation du contenu. Le runtime d'eduschool ne doit pas redécouvrir
les mathématiques d'une question finie.

Architecture cible :

``` text
atelier local jetable
→ génération de combinaisons
→ Ryacas/Yacas calcule et vérifie
→ contrôle des collisions et équivalences
→ contrôle d'une unique bonne réponse
→ contrôle des raisonnements faux utilisés comme distracteurs
→ sélection pédagogique
→ contrôle de l'affichage
→ JSON fini
```

Puis :

``` text
runtime
→ lire
→ choisir une question
→ choisir une variante finie
→ substituer les valeurs éditoriales prévues
→ mélanger les propositions
→ afficher
```

Le JSON contient **le résultat de l'atelier**, pas l'atelier lui-même.

## 6. Distracteurs et propositions

Ne pas confondre les deux notions.

> **Un distracteur est un raisonnement erroné plausible que l'on
> souhaite tester.**

La proposition fausse est la réponse visible produite par ce
raisonnement.

Exemple : pour `1/2 + 1/3`, « additionner numérateurs et dénominateurs »
est un distracteur ; `2/5` est la proposition fausse qui en résulte.

Les helpers amont peuvent connaître les distracteurs pour fabriquer et
contrôler les propositions. Le JSON final n'a pas à conserver cette
mécanique si le runtime n'en a pas besoin.

## 7. Fabrication des questions

Ne jamais commencer une nouvelle famille en remplissant directement le
JSON.

Procédure :

1.  inventorier les formes de questions déjà supportées ;
2.  utiliser si nécessaire des helpers locaux et jetables hors du
    package ;
3.  générer beaucoup de combinaisons candidates ;
4.  utiliser Ryacas/Yacas pour les calculs et validations mathématiques
    ;
5.  construire des propositions fausses à partir de raisonnements
    erronés pédagogiquement plausibles ;
6.  éliminer les collisions, équivalences, réponses multiples, absences
    de bonne réponse et cas pédagogiquement médiocres ;
7.  sélectionner un ensemble fini de situations intéressantes ;
8.  seulement alors écrire le JSON.

Les helpers jetables ne deviennent pas automatiquement du code du
package.

## 8. Formes pédagogiques et interface

Une **forme de question** décrit ce que l'élève doit penser ou faire
pédagogiquement. Elle ne crée pas automatiquement un nouveau type
technique d'interaction.

Exemples :

-   choix binaire ;
-   comparaison à trois choix ;
-   toujours / parfois / jamais ;
-   boîte à trou ;
-   lecture d'une représentation.

Plusieurs formes pédagogiques peuvent utiliser le même QCM technique.

Ne pas créer drag-and-drop, réponses multiples, matching, parser ou
nouvelle validation simplement parce qu'une forme pédagogique peut être
imaginée ainsi. Utiliser d'abord les interactions existantes.

Les graphiques et tableaux peuvent être le **support même de la
question**, pas seulement une décoration. Ils peuvent néanmoins
continuer à utiliser le mécanisme d'illustration existant tant qu'aucune
nouvelle responsabilité technique n'est nécessaire.

## 9. Sources R et style

Les fichiers source sous `R/` doivent rester ASCII.

Tout texte français littéral dans un fichier `.R` doit utiliser les
échappements Unicode `\uXXXX` lorsque nécessaire.

Avant livraison d'un patch modifiant `R/`, contrôler les fichiers
concernés, notamment avec les outils R adaptés
(`tools::showNonASCIIfile()` ou équivalent).

Pour le code R destiné à Gilles :

-   utiliser `=` plutôt que `<-` ;
-   ne pas insérer de lignes vides inutiles dans les blocs de code ;
-   rester compact et REPL-friendly ;
-   ne pas introduire une dépendance ou une abstraction sans travail
    réel à lui donner.

## 10. API externes

Avant d'introduire ou modifier un appel à une API externe, vérifier **la
version réellement concernée et sa documentation actuelle**.

Cela vaut notamment pour :

-   testthat ;
-   Ryacas/Yacas ;
-   jsonlite ;
-   ggplot2 ;
-   rmarkdown ;
-   knitr ;
-   toute autre dépendance.

Ne jamais coder une signature d'API à partir d'un souvenir.

L'environnement persistant permet de vérifier les versions réellement
disponibles. Par exemple, `testthat` 3.3.2 utilise
`expect_length(object, n)` ; ne pas inventer un argument supplémentaire.

## 11. Travail avec les patches

Gilles préfère les patches aux modifications manuelles afin de conserver
la synchronisation.

Pour chaque patch :

-   construire le diff contre **l'état exact fourni** ;
-   ne pas supposer qu'un patch ancien est appliqué ou non ;
-   ne pas empiler v1/v2/v3 lorsque l'état devient ambigu ;
-   si l'état est ambigu, demander/reprendre un ZIP courant puis
    reconstruire un patch propre ;
-   fournir un fichier patch téléchargeable ;
-   donner des commandes d'application courtes ;
-   ne jamais demander à Gilles de compenser manuellement une hypothèse
    faite par ChatGPT.

Un retour d'exécution de Gilles établit un fait sur l'état du dépôt et
prime sur toute reconstruction ou souvenir.

## 12. Tests et diagnostic

Ne pas transformer Gilles en moteur de diagnostic.

Avant de lui demander une commande exploratoire :

1.  inspecter les fichiers disponibles ;
2.  utiliser R, Python ou le shell localement ;
3.  reproduire le problème si possible ;
4.  réduire le diagnostic.

Si une commande chez Gilles reste nécessaire, demander le minimum
décisif, idéalement une seule commande ou un petit groupe cohérent.

Ne pas lancer une succession d'hypothèses à tester chez lui.

## 13. Documentation eduschool

`docs/` est réservé au site pkgdown généré.

La documentation technique source est dans `documentation/`.

Avant un patch, appliquer la règle :

> **RTM / RTFM avant tout patch.**

Le guide développeur du dépôt est la référence technique du projet. Ce
protocole règle **la collaboration** ; il ne remplace pas le guide
développeur.

## 14. Principes du projet à ne pas perdre

-   Les données sont réelles. L'exercice est fabriqué. Le graphique est
    joli. La source est obligatoire.
-   Une donnée sans source n'est pas prête à être utilisée.
-   Une nouvelle abstraction n'entre que lorsqu'elle a trouvé du
    travail.
-   Une contrainte qui oblige à simplifier le programme plutôt que le
    code est mal placée.
-   eduschool n'est pas une usine administrative ni une usine à gaz.
-   L'erreur n'est pas un échec, c'est un moyen de progresser.
-   Un savoir ne vaut que lorsqu'il est partagé.
-   Toujours ouvrir des portes.
-   eduschool reste libre, gratuit, ouvert et non orienté vers la
    monétisation du savoir.

## 15. Comportement attendu de ChatGPT

Pendant le travail technique :

-   agir plutôt que commenter chaque étape ;
-   ne pas répéter à Gilles ce qui vient d'être décidé ;
-   ne pas annoncer inutilement des étapes intermédiaires ;
-   revenir avec un résultat, un patch ou une question réellement
    bloquante ;
-   vérifier avant d'affirmer ;
-   distinguer clairement ce qui a été testé de ce qui est seulement
    raisonné ;
-   ne jamais masquer une augmentation de complexité derrière une «
    correction ».

Lorsque ce fichier est fourni dans un nouveau contexte, la première
action utile est de **l'appliquer**, pas de le résumer à Gilles.
