# Guide de développement eduschool

Ce document conserve les **conclusions techniques réutilisables** du
projet. Il ne remplace ni Git, qui garde l'histoire, ni les tests, qui
vérifient des contrats précis.

Son objectif est plus simple : éviter de résoudre demain un problème
déjà compris hier.

> **RTM / RTFM avant tout patch.**
>
> Avant toute modification, relire d'abord les règles techniques
> pertinentes de ce document. Observer et comprendre avant de corriger.

## Routine avant modification

1.  Lire la documentation développeur pertinente.
2.  Observer l'état réel du code et du dépôt.
3.  Reproduire et localiser le problème au niveau le plus proche de sa
    source.
4.  Distinguer le défaut observé de ses effets dans les rendus.
5.  Vérifier les invariants et tests déjà existants avant d'en ajouter.
6.  Modifier le minimum nécessaire.
7.  Exécuter d'abord les tests ciblés.
8.  Exécuter la suite complète et `R CMD check` au jalon approprié.
9.  Regarder le résultat produit : le triple zéro ne remplace pas le
    quatrième œil.
10. Documenter une nouvelle leçon seulement si elle est réutilisable.

La routine est donc :

`doc → observer → comprendre → corriger → tester → regarder → avancer`

## Texte, encodage et Unicode

`eduschool` déclare `Encoding: UTF-8`.

### Texte destiné aux humains

Le français destiné à être lu par un humain reste correctement accentué.
Dans les fichiers de données, la documentation et les autres sources UTF-8,
il est écrit directement et lisiblement en UTF-8.

Les fichiers `R/*.R` constituent un cas particulier : `R CMD check` exige
des fichiers de code portables en ASCII. Les caractères non-ASCII présents
dans les chaînes destinées aux humains y sont donc écrits avec des
échappements Unicode, sans modifier le texte produit :

``` r
"V\u00e9rifier beaucoup de cas peut faire na\u00eetre une conjecture."
"La propri\u00e9t\u00e9 est v\u00e9rifi\u00e9e de 0 \u00e0 39."
"1681 = 41 \u00d7 41"
```

À l'exécution, ces chaînes produisent bien du français accentué. La
portabilité du code ne doit jamais être obtenue en désaccentuant le texte
affiché à l'utilisateur.

### Séparer le code et le contenu éditorial

Les fichiers `R/*.R` portent la logique. Les contenus éditoriaux ou
pédagogiques destinés à l'utilisateur vivent, autant que possible, dans
les ressources UTF-8 appropriées de `inst/`.

Cela concerne en particulier les énoncés, réponses, corrections,
feedbacks, rappels et libellés des exercices. Lorsqu'une famille
d'exercices possède déjà le mécanisme `textes_*.csv`, l'utiliser plutôt
que coder ces textes dans le fichier R.

Avant d'écrire une chaîne française dans `R/`, demander :

> **Est-ce du code ou du contenu ?**
>
> Si c'est du contenu, le ranger dans la ressource UTF-8 appropriée.

Les échappements `\uXXXX` ne sont donc pas un moyen de contourner cette
séparation. Ils ne doivent pas servir à enfouir du français pédagogique
dans le code R.

Cette règle n'interdit pas les chaînes techniques nécessaires au code,
les messages d'erreur courts, ni la documentation du code lorsqu'ils
appartiennent réellement au source R. Elle évite de transformer le code
en dépôt de contenu éditorial.

### Identifiants et syntaxes techniques

Les identifiants internes peuvent rester ASCII :

``` r
"distinguer-verification-preuve"
"trouver-le-contre-exemple"
```

Une syntaxe imposée par un outil peut également rester ASCII lorsqu'elle
l'exige, par exemple une expression destinée à un CAS.

### Échappements Unicode

Dans `R/*.R`, les formes telles que `\u00e9` sont utilisées lorsque
nécessaire pour satisfaire la contrainte de portabilité de `R CMD check`
tout en produisant du français correctement accentué.

Dans les autres sources UTF-8, elles restent réservées aux cas où la
représentation Unicode elle-même fait partie du problème ou du test.

Exemple : vérifier explicitement la différence entre un `é` précomposé et
un `e` suivi d'un accent combinant.

### `showNonASCIIfile()`

`tools::showNonASCIIfile()` signale la présence de caractères non-ASCII.
Il ne démontre pas qu'un fichier est mal encodé.

Par exemple, en UTF-8, `é` est encodé par les octets `c3 a9`. Voir ces
octets signalés par l'outil est compatible avec un fichier UTF-8
parfaitement valide.

À retenir :

`ASCII ≠ UTF-8 valide ≠ non-ASCII problématique`

### Canari Unicode

Le canari Unicode vérifie le **transport** de caractères correctement
fournis au pipeline de rendu.

Son contrat est de la forme :

`Unicode correct à l'entrée → Unicode correct à la sortie`

Il ne vérifie pas qu'un auteur a correctement accentué le français à la
source.

Ainsi, `Verifier` transmis sans modification jusqu'au HTML n'est pas une
défaillance du transport Unicode : le `é` n'a jamais été fourni.

## Tests : savoir ce que l'on prouve

> **Un test ne prouve que ce qu'il teste.**

Avant de modifier un test rouge, déterminer quel côté du contrat est
faux : la production, l'attendu, ou le contrat lui-même.

### Séparer les responsabilités

Distinguer autant que possible :

-   la vérité ou l'invariant mathématique ;
-   la structure de l'exercice ;
-   la représentation pédagogique lorsqu'elle constitue un invariant ;
-   le transport et le rendu Unicode ;
-   l'intégration jusqu'au HTML ou au PDF.

Tester la représentation du source et tester la valeur produite sont
deux opérations différentes.

### Ne pas transformer une erreur en contrat

Éviter de comparer des phrases complètes avec `expect_identical()`
lorsque l'intention réelle du test est seulement de protéger une
progression ou une propriété mathématique.

Une chaîne incorrecte copiée à la fois dans la production et dans le
résultat attendu produit un test vert qui consacre l'erreur.

Un test doit être aussi local que possible :

`petit prédicat → échec local → diagnostic lisible → correction ciblée`

Lorsqu'il échoue, son diagnostic doit être plus petit et plus précis que
l'objet testé.

## Mathématiques et représentation

> **Le rendu typographique d'une expression mathématique ne doit jamais
> modifier sa sémantique.**

Le moteur de rendu ne doit pas avoir à deviner ce que le source voulait
dire.

Exemple :

`2 × x × 7 = 14x`

est préférable à une notation où `x` pourrait être confondu avec le
signe de multiplication.

La représentation fait partie de la question lorsqu'elle porte une
information mathématique.

Séparer lorsque nécessaire :

-   l'expression destinée au calcul ou au CAS ;
-   l'expression destinée à l'apprenant.

Le CAS valide le calcul ; eduschool reste responsable du sens.

## Corrections pédagogiques

Une correction doit apporter l'information qui manquait, pas dresser le
procès-verbal de l'erreur.

Dans une correction, séparer régulièrement le discours et le calcul
plutôt que laisser le navigateur décider où couper le raisonnement.

Le gras sert aux concepts mathématiques importants, pas à la décoration,
aux résultats ou aux félicitations.

## Rendus HTML et PDF

Lorsqu'un défaut apparaît dans un rendu, remonter vers la source avant
de modifier le renderer.

Ordre de diagnostic recommandé :

`générateur → objet R produit → habillage → renderer → fichier final`

Si l'objet R contient déjà l'erreur, le HTML ou le PDF n'est pas le
premier suspect.

Inversement, un objet R correct qui devient incorrect au rendu justifie
alors une enquête sur la chaîne de rendu.

### JavaScript dans les quiz

> **JavaScript dans un quiz : exception négociée, jamais solution par défaut.**

Ne pas introduire ni étendre du JavaScript dans le HTML d'un quiz sans
discussion préalable. Avant tout patch qui en aurait besoin, comparer
explicitement :

-   le bénéfice pédagogique ou fonctionnel attendu ;
-   la possibilité d'obtenir le même résultat en HTML/CSS ou avec
    l'architecture existante ;
-   les risques pour l'autonomie du fichier, l'accessibilité, la robustesse,
    la sécurité et la maintenance.

Un rapport bénéfice/risque favorable doit être établi et la décision
doit être prise explicitement **avant** l'écriture du patch.

Le JavaScript déjà présent dans un quiz n'autorise pas son extension par
défaut. Une modification sans rapport avec le comportement interactif
doit laisser ce JavaScript inchangé.

## Triple zéro et quatrième œil

`0 errors | 0 warnings | 0 notes` est une condition importante de
stabilité, pas une preuve de perfection.

> **L'intégrité n'implique pas la complétude.**
>
> **Un test ne prouve que ce qu'il teste. Le triple zéro ne dispense
> jamais de regarder ce qu'on n'a pas pensé à tester.**

Après les tests, regarder les sorties réellement destinées à
l'utilisateur.

## Fiches : comprendre, chercher, s’entraîner

Une fiche n’est pas faite pour être cachée pendant qu’on apprend. Elle
est faite pour être utilisée.

Le chemin recherché est :

`comprendre → règles sous les yeux → chercher → s’entraîner ensemble`

Une représentation graphique entre dans une fiche lorsqu’elle aide
réellement à comprendre ou à raisonner. Elle n’est ni obligatoire ni
décorative : la représentation fait partie du savoir lorsqu’elle permet
de mieux le voir.

Le code R reste autant que possible derrière le rideau. L’objectif n’est
pas de fabriquer des fiches avec R ; l’objectif est de faire des
mathématiques avec les fiches produites.

Ne pas figer prématurément le nombre ou la nature des types de fiches.
Partir des usages réels, puis structurer seulement ce qui a trouvé du
travail.

## Humour : toujours ouvrir des portes

> **Quand l'humour peut ouvrir une porte sans brouiller le savoir, eduschool essaie de l'ouvrir.**

L'humour peut attirer l'attention, aider à mémoriser, dédramatiser une
erreur, provoquer une question ou laisser entrevoir quelque chose qui
dépasse la notion étudiée. Il n'est jamais nécessaire pour comprendre
l'énoncé ni pour trouver la réponse.

Lorsqu'un aparté humoristique porte une intention pédagogique réelle,
les tests peuvent protéger cette intention comme n'importe quel autre
contrat d'eduschool. Ils ne doivent pas imposer un quota artificiel de
blagues : on protège une porte utile, pas un indicateur de production.

Le public compte également. Une blague adaptée à un parent ne l'est pas
nécessairement à un élève. Utiliser les mécanismes de catégorisation
existants lorsque le destinataire est spécifique, plutôt que de diffuser
le même humour à tout le monde.

L'humour ne vise jamais les personnes concernées par des données
sensibles. Et, comme ailleurs dans eduschool : **toujours ouvrir des
portes, même avec une blague.**

## Simplicité

Une nouvelle abstraction n'entre dans eduschool que lorsqu'elle a trouvé
du travail.

Si une idée pédagogique simple exige une machinerie énorme, chercher
d'abord plus simple.

L'objectif technique reste :

`minimum de machinerie visible → maximum de mathématiques accessibles`

La documentation elle-même suit cette règle : conserver les conclusions
réutilisables, pas la chronologie détaillée de toutes les rustines.

## Pièges connus

### Confondre source ASCII et texte portable

**Mauvaise conclusion :** les sources R doivent être ASCII, donc le
français doit être désaccentué ou écrit systématiquement avec des
échappements Unicode.

**Règle :** le package est UTF-8 ; écrire naturellement le texte humain
en UTF-8. Réserver l'ASCII aux identifiants et aux syntaxes qui en ont
besoin.

### Confondre transport Unicode et qualité du texte

Un test de transport Unicode peut être parfaitement vert alors qu'un
texte a été écrit sans accents dès l'origine.

Toujours distinguer :

`caractère perdu pendant le transport`

de :

`caractère correct jamais fourni`

### Copier une sortie fautive dans un test

Un attendu fautif peut transformer une régression en contrat.

Avant de mettre à jour un attendu après un échec, demander :

**« Quel invariant ce test est-il réellement censé protéger ? »**

## Principe de maintenance de ce guide

Ajouter une règle lorsqu'une difficulté a produit une conclusion
technique réutilisable.

Ne pas documenter chaque incident pour lui-même. Git conserve l'histoire
; ce guide conserve ce qu'elle nous a appris.

Et avant le prochain patch :

> **RTFM. Puis seulement le bistouri.**
