# eduschool — Guide minimal de développement

**À relire avant chaque intervention, notamment après une reprise de conversation ou une perte de contexte.** Ce document est la référence opérationnelle du projet ; ne jamais supposer que l'état mémorisé correspond au dépôt courant.

## Règle absolue : les donnees pedagogiques ne sont jamais codees en dur

**Aucune liste de notions, familles, niveaux ou contenus pedagogiques dans les fonctions R.**
Les fonctions traitent les donnees declarees dans les CSV, JSON et Markdown.
Avant tout patch : relire ce guide, chercher d'abord la donnee existante et
n'ajouter que le comportement generique strictement necessaire. Pas de seconde
source de verite, pas de duplication editoriale, pas d'usine a gaz.

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
- Chaque QCM doit avoir **une seule réponse mathématiquement correcte**. Avant toute migration ou génération transversale, auditer les distracteurs : deux écritures différentes d’une même fraction (ex. `1/2` et `2/4`) ne peuvent pas être proposées comme deux réponses distinctes dans un QCM à réponse unique. Chaque distracteur doit être explicitement faux dans les conditions de l'énoncé, y compris après tirage des paramètres. Vérifier les équivalences mathématiques, pas seulement l'identité des chaînes de caractères.
- Favoriser la **diversité des raisonnements** plutôt que plusieurs formulations du même calcul.
- Une notion est un apprentissage, pas un format de question. Éviter les doublons artificiels ; ne supprimer aucune question historique lors d'un regroupement.
- Autoriser une correction libre et directe : les étapes « Je vois / Je sais » sont facultatives.
- Les questions portant sur une droite graduée doivent montrer une véritable droite dans les quiz HTML et PDF ; la figure ne révèle pas la réponse.
- Un quiz transversal `fractions` mélange les questions de toutes les notions de fractions sans dupliquer les banques.
- **Contrat impératif : questions de vocabulaire « mot à trou » et « mot masqué »**. Ce sont deux présentations de **QCM à propositions plausibles**, jamais des champs de saisie. L’élève sélectionne une proposition ; la correction est automatique par le moteur QCM existant. Ne jamais proposer de réponse libre, de reconnaissance textuelle ou un nouveau moteur de correction pour ces exercices.
  - **Mot à trou** : quelques lettres du terme recherché restent visibles et les emplacements cachés correspondent **exactement** aux lettres manquantes. Exemple pour « rayon » : `r _ _ _ n`.
  - **Mot masqué** : seules des lettres-indices éventuelles restent visibles ; le trait central a une **longueur graphique fixe, sans rapport avec le nombre de caractères**. Exemple pour « hypoténuse » : `H________E`. Afficher obligatoirement l’avertissement : « La longueur du trait ne correspond pas au nombre de caractères du mot recherché. »
  - Dans **les deux variantes**, fournir plusieurs **propositions de mots mathématiques plausibles**, en lien avec la question et les confusions pédagogiques possibles. La question est affichée **une seule fois**, puis chaque proposition est affichée sous sa propre forme masquée (ne pas montrer les mots en clair avant correction). Le mot réel est conservé comme valeur interne pour la correction automatique. Les représentations affichées doivent permettre de distinguer les propositions : ne jamais produire des choix visuellement identiques ou une question ambiguë. Une seule proposition doit répondre à la définition posée. La correction révèle le mot choisi, la bonne réponse et une explication utile.
  - Conserver ces deux types lors des migrations de questions et vérifier leur présence dans les banques historiques avant de conclure qu’ils n’existaient pas. **Ne pas confondre** avec un nombre manquant dans une équation ni avec des mots masqués dans une correction.
- Préserver les corrections pertinentes, notamment « Je vois / Je sais / J'en déduis » et « Je calcule » quand cela apporte réellement quelque chose. Ne pas imposer artificiellement ces étapes.
- **Trois actions HTML distinctes, dans cet ordre** : « Valider mes réponses » corrige le tirage affiché ; « Relancer ce quiz » efface réponses et corrections **sans changer les questions, valeurs ni propositions** ; « Générer un nouveau quiz » affiche le prochain tirage pré-calculé. Après le dernier tirage, revenir au premier (boucle). Ne jamais confondre relance et nouveau tirage.
- `produire(..., n = 10, tirages = 5)` signifie dix questions par quiz et cinq quiz pré-calculés ; `variantes` reste un ancien alias de `tirages`. Accepter les répétitions : aucune détection complexe de doublons. Les tirages sont calculés en R lors de la génération, jamais par JavaScript dans le navigateur.
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

Le travail en cours porte sur la diversité des questions, les quiz transversaux et les fractions, après migration des notions pilotes. Les données historiques migrées ne sont pas nécessairement exécutables : vérifier l'état réel des JSON et du moteur, sans se fier à cette indication qui peut devenir obsolète.

## 7. RETEX : identification et corrections (septembre 2026)

- L’en-tête doit présenter des **libellés humains** de thème et de notion. Ne jamais afficher `NA` ni « Niveau : Non renseigné » ; omettre le niveau absent.
- Pour les identités remarquables, permettre un quiz général et des quiz ciblés sur le **développement** et la **factorisation** sans créer un nouveau moteur ni supprimer les questions existantes.
- Les corrections HTML utilisent un **encadré coloré**, une police lisible et un paragraphe par étape ou phrase.
- Le champ `correction` des JSON peut contenir du Markdown éditorial simple : `**terme important**`, retours à la ligne et `[fiche](chemin-local.html)`. Les liens doivent pointer vers des documents réellement produits et accessibles ; en PDF, garder une correction compréhensible même sans lien cliquable. Ne pas injecter le JSON comme HTML brut.
- Préserver les définitions et propriétés utiles de la v1 ; les corrections ne se réduisent pas à annoncer la bonne réponse.

## 8. Graphiques et fichiers de sortie

- Un graphique = un identifiant unique. Le code des figures réside dans `inst/graphiques/` ; les paramètres règlent ses variantes. Les JSON utilisent `triangle_rectangle_A` (pas d’alias `triangle_angle_droit_A`).
- `illustrer_question()` délègue aux fonctions graphiques ; `graphique(id, ...)` permet leur réutilisation dans les fiches. Ne pas dupliquer le code des figures dans les modèles Rmd.
- Les fiches declarent les figures a leur emplacement avec `<!-- graphique: id parametre=nombre -->`. Seuls les scalaires numeriques sont admis. Le meme rendu s applique aux fiches simples et familiales, HTML et PDF. Aucune condition par notion dans les modeles.
- Les figures de fiche ont une largeur documentaire commune de 65 %. Le script de chaque figure peut definir `attr(figure, "eduschool_dimensions") = c(largeur, hauteur)` pour ses proportions ; le rendu ne connait aucune notion. Les dimensions sont de presentation, jamais des donnees pedagogiques.
- `produire()` génère un fichier au nom unique dans `tempdir()` sans `dossier` explicite. Avec `dossier`, le fichier est enregistré à l’emplacement demandé. Le chemin complet est affiché par `message()` et retourné invisiblement pour les scripts. Un fichier temporaire n’est pas une archive.

## 9. Verification ASCII et dependances graphiques (imperatif)

- **Avant chaque patch touchant `R/`**, verifier les caracteres non ASCII dans **tous les fichiers R modifies** avec `tools::showNonASCIIfile()` (et non seulement attendre `R CMD check`). Conserver les accents visibles dans les documents pedagogiques UTF-8 ; dans les chaines R, ecrire les accents sous forme `\uXXXX`. Preferer les commentaires ASCII dans `R/` pour eviter toute ambiguite.
- `ggplot2` et `ggsketch` restent dans `Imports` de `DESCRIPTION` : ils sont necessaires aux graphiques places dans `inst/graphiques/`. Leurs appels y restent explicites (`ggplot2::` et `ggsketch::`). Le `NAMESPACE` importe explicitement une fonction de chaque dependance afin que `R CMD check` reconnaisse leur utilisation, sans importer toutes leurs fonctions. Maintenir les directives roxygen correspondantes et regenerer `NAMESPACE` avec `devtools::document()`.
- Les productions HTML/PDF et `sorties/` ne sont pas des sources du package : les exclure du paquet construit avec `.Rbuildignore`. Cela ne supprime pas les fichiers existants du repertoire de travail ni du suivi Git.

## 10. Humour : retour archeologique de la v1

- L'humour est une option pedagogique, jamais une condition de validite d'une question.
- `produire(..., humour_ratio = 0.2)` fixe la proportion cible de questions humoristiques (0 a 1). `0` reste autorise, avec un message bienveillant. `seed` permet des tirages reproductibles.
- Les variantes `humour` sont des tableaux de textes facultatifs dans les JSON. Elles sont affichees **apres** la correction, sans jamais remplacer le raisonnement.
- Le ratio s'applique aux questions du quiz, dans la limite des questions disposant d'un aparté. Aucune blague artificielle pour remplir le quota.
- Origine : `legacy/R/humour.R` de la v1 (catalogue `cle`, `niveau`, `texte` et mecanisme `apart_humour`). Reprise selective des textes des fractions, sans reimporter l'ancien moteur.
- Ne jamais rire de l'eleve ni masquer une erreur mathematique. La forme et la quantite d'humour restent au choix de chacun.

## 11. Familles de notions (regroupement minimal)

- `inst/referentiels/familles_notions.csv` associe explicitement `famille;notion`.
  Pas de deduction fragile depuis les noms des dossiers ni de copie des JSON.
- `questions("fractions")` melange les banques des membres declares dans le CSV.
- `produire("fractions", "quiz")` genere uniquement le quiz transversal.
- `produire("fractions", "tous")` genere **au maximum quatre fichiers** :
  decouverte, synthese, revision et quiz transversal. Chaque fiche assemble
  les Markdown des membres declares dans le CSV, dans leur ordre, avec titres
  de section ; les ressources absentes sont ignorees et signalees si un support
  entier manque. Aucun nouveau Markdown au niveau de la famille.
- Les fiches individuelles restent les sources editoriales uniques. Pour
  ameliorer les documents transversaux, ameliorer ces sources a la marge.
- Une famille peut demander chaque support separement. Le quiz reutilise
  toutes les banques des membres, sans copie ni liste de notions en R.

## Quiz : illustrations compactes (septembre 2026)

- Les graphiques des questions utilisent `illustrer_question()` et les scripts existants dans `inst/graphiques/`. `triangle_rectangle_normal` accepte `angle_droit` (A, B ou C) ; ne pas remplacer le triangle dessine a main levee, qui a un autre objectif.
- Une valeur d'illustration JSON `{sommet}` est resolue a partir des parametres tires de la question, sans condition liee a la notion.
- `inst/styles/eduschool.css` porte les styles HTML du quiz, charges par `quiz.Rmd`. La grille place les petites figures a droite des propositions sur grand ecran et les empile sur petit ecran. Le PDF conserve sa disposition verticale.
- Pas de nouvelle infrastructure de mise en page ; les figures definissent leurs dimensions via `eduschool_dimensions`.

## P0 — calculs fixes (27 septembre 2026)

Pour les calculs numeriques migres, `reponse.mode = calcul_fixe` contient
uniquement deux litteraux rationnels fixes, une operation autorisee et le
format d'affichage. Le moteur construit l'enonce a partir de ces valeurs et
calcule la reponse avec Ryacas. Aucun resultat calcule n'est stocke dans le
JSON ; aucune generation aleatoire de valeurs n'est autorisee. Le melange
avec des `parametres` ou des `distracteurs.expressions` est interdit.

Les conversions conservent leurs unites fixes et produisent la quantite
source depuis le premier litteral. Les questions de connaissances et les
questions symboliques non migrees restent editoriales : ne pas leur attribuer
une garantie Ryacas. Les corrections en francais restent editoriales et
ne doivent pas introduire de valeurs variables.

## Cercle trigonometrique et niveaux (septembre 2026)

- Le CSV conserve `famille;notion;libelle_notion;niveau;etape_scolaire`.
- Pour un quiz de famille, `niveau` filtre les notions dont le niveau
  d'introduction est connu et inferieur ou egal au niveau demande.
- Un niveau absent n'est pas interprete comme accessible a tous.
- Le triangle rectangle (3E) et le cercle trigonometrique (2DE) sont
  deux notions distinctes, sans duplication de banque.
- Les etiquettes des figures de trigonometrie utilisees en quiz sont
  agrandies sans changer les dimensions documentaires des figures.

## RETEX — Cercle trigonométrique : lisibilité des figures

Une figure présentant un angle orienté doit montrer les deux rayons, un arc fléché et le nom de l’angle. Les fiches peuvent afficher sa mesure ; les quiz ne doivent pas révéler une réponse dans l’illustration. `eduschool_display_width` permet à une figure compacte de demander une largeur inférieure au plafond documentaire commun de 65 %, sans traitement par notion dans le moteur.

## Fiches découvertes : activités et réponses (septembre 2026)

- Toute invitation à effectuer un exercice vérifiable utilise la forme **À essayer N — titre :** (en gras), avec numérotation continue dans chaque fiche. Ne pas glisser un « essaie » non identifié dans le texte courant.
- Chaque **À essayer N** possède une correction **N. titre** dans la dernière section **Pour vérifier tes découvertes**, dans le même ordre. Expliquer le raisonnement, pas seulement donner le résultat.
- Une exploration libre sans réponse unique peut rester une ouverture éditoriale clairement distincte ; ne pas la présenter comme un exercice dont la correction manquerait.
- Pour les fiches de familles, les corrections restent dans le Markdown de chaque notion, source éditoriale unique. Pas de nouvelle logique dans le moteur de rendu.

- Lorsqu'un « À essayer » demande de construire ou de lire une figure, sa correction doit montrer le résultat en réutilisant, si possible, le graphique existant avec des paramètres explicites. Le texte doit expliquer le raisonnement et identifier sur la figure tous les points nommés dans la correction. Vérifier la lisibilité des noms lorsque des points coïncident.

- Les images des fiches sont centrees dans les PDF par le modele commun `fiche.Rmd` ; conserver leur largeur editoriale et le rendu HTML existant. `fig.align` de knitr ne centre pas les images Markdown externes.

## UX — reperer les notions et les fonctions utiles

- `notions()` liste les identifiants de notions et de familles utilisables par `produire()`, a partir des dossiers et du referentiel existants. Aucun catalogue parallele en R.
- La cheatsheet source est `inst/templates/eduschool-cheatsheet.html` ; conserver sa copie publiee dans `pkgdown/assets/` synchronisee.
