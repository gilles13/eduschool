# eduschool — Guide minimal de développement

**À relire avant chaque intervention, notamment après une reprise de conversation ou une perte de contexte.** Ce document est la référence opérationnelle du projet ; ne jamais supposer que l'état mémorisé correspond au dépôt courant.

## 1. Finalité

eduschool est un projet R libre, gratuit et ouvert, destiné à aider les élèves et leurs proches à comprendre les mathématiques. Il propose plusieurs chemins pour apprendre, relie les notions et valorise les raisonnements. **Toujours ouvrir des portes.** L'erreur est une occasion de progresser, pas un échec.

**Priorité : produire et utiliser des contenus mathématiques**, pas perfectionner un système d'information.

## 2. Architecture volontairement minimale

- **CSV** : catalogue léger des notions et rattachements souples aux niveaux et thèmes. Une notion n'est pas prisonnière d'un programme scolaire.
- **JSON** : questions, paramètres, réponses, distracteurs et corrections.
- **Markdown** : contenu pédagogique.
- **R Markdown** : production de fiches et de quiz en HTML et PDF.

Pas de réimportation de l'ancien moteur ni de l'ancien SI. Une abstraction nouvelle n'entre que si un besoin concret et répété la justifie. Privilégier des modifications localisées, compréhensibles et réversibles. En R, utiliser `=` pour les affectations ; ne pas introduire Quarto.

## 3. Contrat pédagogique des quiz

- Les quiz contiennent **uniquement des questions corrigibles automatiquement et sans ambiguïté**. Reformuler ou écarter une question libre qui ne satisfait pas ce critère ; ne pas ajouter de correction automatique de texte libre.
- Chaque QCM doit avoir **une seule réponse mathématiquement correcte**. Chaque distracteur doit être explicitement faux dans les conditions de l'énoncé, y compris après tirage des paramètres. Vérifier les équivalences mathématiques, pas seulement l'identité des chaînes de caractères.
- Favoriser la **diversité des raisonnements** plutôt que plusieurs formulations du même calcul.
- Préserver les corrections pertinentes, notamment « Je vois / Je sais / J'en déduis » et « Je calcule » quand cela apporte réellement quelque chose. Ne pas imposer artificiellement ces étapes.
- HTML : réponses sélectionnables, vérification/correction et relance. PDF : version imprimable avec corrigé. `produire()` doit ouvrir le document par défaut et permettre de désactiver l'ouverture lors des générations en série.

## 4. Contrat impératif de livraison des patchs

**RTM / RTFM avant tout patch.**

1. Lire **ce guide**, puis les documents techniques pertinents présents dans `documentation/`, en particulier `EXPERIENCE-MATHS.md` et `MIGRATION-PILOTES.md` tant qu'ils existent.
2. Obtenir les **versions actuelles exactes** de tous les fichiers à modifier, ainsi que les informations nécessaires sur leur emplacement. Les anciennes archives, précédents patchs et souvenirs ne prouvent pas l'état du dépôt.
3. Vérifier les chemins, produire un **patch Git minimal**, puis effectuer `git apply --check` et `git apply` sur une copie conforme des fichiers reçus. Contrôler les modifications et exécuter les validations possibles (JSON, tests R, rendus) ; ne pas annoncer de tests non réalisés.
4. Distinguer clairement **« vérifié sur les fichiers transmis »** et **« vérifié sur le dépôt courant complet »**. Si la copie est incomplète, l'indiquer et demander les fichiers manquants **avant** de produire le patch.
5. Si un patch échoue, **diagnostiquer à partir de l'erreur et des fichiers actuels** avant de générer un correctif. Ne jamais corriger à l'aveugle.
6. Ne pas ajouter de complexité, de tests artificiels, de dépendances ou de changements documentaires hors périmètre sans justification explicite.
7. Fournir un lien vers un **fichier de patch réellement créé**, les commandes de vérification/application et un test fonctionnel court.

## 5. Reprise après perte de contexte

Avant de proposer du code ou un patch : demander ou consulter ce guide **dans sa version courante**, lire la documentation pertinente et vérifier les fichiers réels. Si le dépôt n'est pas accessible, demander seulement les fichiers nécessaires. **Ne jamais prétendre avoir relu un document absent ni avoir validé un patch sur un dépôt non fourni.**

## 6. État à confirmer à chaque reprise

Le travail en cours porte sur la diversité et la qualité des questions pour `addition_fractions` et `pythagore`, avant généralisation. Les données historiques migrées ne sont pas nécessairement exécutables : vérifier l'état réel des JSON et du moteur, sans se fier à cette indication qui peut devenir obsolète.
