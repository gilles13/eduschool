# eduschool — Guide minimal de développement

**À relire avant chaque intervention, notamment après une reprise de conversation ou une perte de contexte.** Ce document est la référence opérationnelle du projet ; ne jamais supposer que l'état mémorisé correspond au dépôt courant.

**Toute API externe est vérifiée avant usage.** Avant d'introduire ou de modifier un appel à un package ou outil externe (`testthat`, Ryacas/Yacas, `jsonlite`, `ggplot2`, `rmarkdown`, etc.), vérifier la signature et le comportement dans la documentation de la version actuelle concernée. Ne jamais écrire un appel à partir d'un souvenir de syntaxe ni contourner une erreur en déplaçant le même argument vers une autre fonction sans vérification.

## Règle absolue : les donnees pedagogiques ne sont jamais codees en dur

**Aucune liste de notions, familles, niveaux ou contenus pedagogiques dans les fonctions R.**
Les fonctions traitent les donnees declarees dans les CSV, JSON et Markdown.
Avant tout patch : relire ce guide, chercher d'abord la donnee existante et
n'ajouter que le comportement generique strictement necessaire. Pas de seconde
source de verite, pas de duplication editoriale, pas d'usine a gaz.

## Principe fondamental : les Bulletins officiels sont la seule source de verite des programmes

**La seule source de verite sur les programmes scolaires est constituee par les Bulletins officiels (BO) qui posent ces programmes.**

Les CSV de programmes d'eduschool sont une transcription structuree et sourcee des BO. Les identifiants internes (`programme_id`, `item_id`, `notion_id`, etc.), les familles, les regroupements et les relations techniques servent a stocker, relier et exploiter cette transcription ; ils ne creent jamais a eux seuls une connaissance, une progression ou une relation officielle.

Toute information qui ne provient pas explicitement du BO doit etre distinguee de la transcription officielle : organisation editoriale, rapprochement entre notions, niveau d'introduction pratique, progression proposee, deduction ou autre interpretation d'eduschool. Lorsqu'elle apparait dans un rendu, sa nature doit etre explicitement mentionnee. Une ambiguite ou une lacune du BO ou de sa transcription reste visible ; elle n'est jamais comblee silencieusement par une convention interne, un ancien programme ou une correspondance textuelle.

Avant toute evolution du SI qui touche aux programmes, notions ou progressions :

1. identifier le BO de reference et la source precise ;
2. auditer ce qui est effectivement transcrit, sans corriger pendant le diagnostic ;
3. separer la transcription du BO des constructions editoriales ou techniques d'eduschool ;
4. seulement ensuite modifier les CSV ou le code, en conservant cette distinction dans les controles et les rendus.

Une cle technique peut identifier une donnee officielle ; **elle ne constitue jamais la preuve que cette donnee ou cette relation est officielle**.

### Statut des rattachements de notions

`inst/editorial/mathematiques/editorial_notions.csv` et ses identifiants `MAT_*` constituent un referentiel interne eduschool. `inst/editorial/mathematiques/editorial_notions_items.csv` constitue egalement une **construction editoriale eduschool** : il rapproche des notions internes et des items officiels (DOMAINE ou THEME) pour faciliter l'exploration. Ce fichier ne transcrit pas une relation officielle du BO et ne doit jamais etre presente comme telle.

Un rattachement actif ne doit pas pointer vers un attendu Eduscol ni vers un ancien programme pour combler un trou du programme de reference courant. Lorsqu'un BO recent est transcrit mais que le rapprochement avec une notion interne n'a pas ete relu, **laisser le trou visible**. La reconstruction ulterieure d'une progression doit conserver la reference precise au BO qui l'etaye et annoncer explicitement la part d'organisation ou d'interpretation eduschool dans le rendu.

Les recherches textuelles (`grepl()`, mots-cles, similarite de libelles) ne prouvent jamais un rattachement. Elles ne sont admises qu'en dernier recours comme aide exploratoire ; tout rendu qui en depend doit emettre un `warning()` explicite et ne doit pas persister le resultat comme verite du programme.

## Temporalite des programmes

Eduschool ne modelise pas l application progressive des nouveaux programmes. Des qu un nouveau BO est retenu, le projet fait le choix editorial de le presenter comme pleinement applicable a tous les niveaux concernes. Ce choix doit etre explicitement annonce dans les rendus. Il ne modifie pas le contenu officiel : le BO reste la seule source de verite.

## Frontiere officiel / editorial

Les noms de fichiers rendent cette frontiere visible lorsque leur statut est univoque : `officiel_*` pour une transcription du BO, `editorial_*` pour une construction eduschool. Les registres techniques mixtes conservent un nom neutre. Une notion eduschool peut etre rapprochee d un DOMAINE ou d un THEME officiel par `editorial_notions_items.csv` ; cette relation est toujours editoriale, meme si sa cible est officielle.

## 1. Finalité

eduschool est un projet R libre, gratuit et ouvert, destiné à aider les élèves et leurs proches à comprendre les mathématiques. Il propose plusieurs chemins pour apprendre, relie les notions et valorise les raisonnements. **Toujours ouvrir des portes.** L'erreur est une occasion de progresser, pas un échec.

**Priorité : produire et utiliser des contenus mathématiques**, pas perfectionner un système d'information.

### Principe pédagogique : commencer par « de quoi parle-t-on ? »

Avant d'apprendre à utiliser une notion, une fiche doit permettre de comprendre **ce qu'elle désigne**. Toute fiche notion commence donc, autant que possible, par une définition simple, concrète et suffisamment juste de l'objet étudié. Elle explicite le vocabulaire et les distinctions élémentaires nécessaires avant d'introduire ses propriétés, ses opérations ou ses techniques de calcul.

La première définition n'a pas besoin d'épuiser immédiatement toute la subtilité mathématique de la notion. Elle doit fournir un socle solide, qui pourra être précisé ensuite. **Ne jamais considérer comme inutile une définition sous prétexte qu'elle paraît évidente à celui qui connaît déjà la notion.**

Dans une fiche **Découverte**, construire ce sens avec des exemples et, lorsque cela aide, des contre-exemples. Dans une fiche **Synthèse**, conserver une définition courte permettant de retrouver immédiatement de quoi on parle.

Quand une confusion révèle une marche implicite, expliciter d’abord **la nature des objets et la question posée par chaque notation** avant d’ajouter une règle de manipulation. Ne pas confondre la nature d’un objet avec la notation utilisée pour le représenter.

Question de contrôle avant de considérer une fiche terminée : **« Avant de lui apprendre quoi en faire, avons-nous expliqué à l'élève de quoi nous parlons ? »**

La définition fondamentale dispose d’un repère visuel commun aux fiches : une petite boîte sobre, à fond pastel très clair et bordure fine foncée, intitulée **« De quoi parle-t-on ? »**. Le Markdown la déclare avec un bloc `::: {.edu-definition}` ; le modèle assure le rendu HTML/PDF. Ne pas généraliser ce mécanisme à d’autres catégories tant qu’un besoin concret et répété ne l’exige pas.

### Modèles éditoriaux des fiches

Les fichiers `documentation/modeles/decouverte.md` et `documentation/modeles/synthese.md` sont les **points de départ obligatoires** de toute nouvelle fiche. Toujours repartir d’une copie du modèle correspondant, puis remplacer et adapter son contenu. **Ne jamais reconstruire de mémoire la structure Markdown d’une fiche.**

Ces modèles fixent la hiérarchie de présentation commune : titre principal, bloc `edu-definition`, niveaux de sections et absence de numérotation manuelle des titres. Une section inutile pour une notion peut être supprimée et une section pédagogiquement utile peut être ajoutée, mais la hiérarchie Markdown et la forme du bloc de définition restent celles du modèle. La présentation visuelle appartient au modèle commun `fiche.Rmd`, pas aux fichiers de contenu.

## 2. Architecture volontairement minimale

- **CSV** : catalogue léger des notions et rattachements souples aux niveaux et thèmes. Une notion n'est pas prisonnière d'un programme scolaire.
- **JSON** : questions, variantes finies, réponses, propositions et corrections. Le JSON contient le produit fini de l’atelier, jamais le calcul ou la validation qui a permis de le fabriquer.
- **Markdown** : contenu pédagogique.
- **R Markdown** : production de fiches et de quiz en HTML et PDF.

Pas de réimportation de l'ancien moteur ni de l'ancien SI. Une abstraction nouvelle n'entre que si un besoin concret et répété la justifie. Privilégier des modifications localisées, compréhensibles et réversibles. En R, utiliser `=` pour les affectations ; ne pas introduire Quarto.

### Convention de nommage des notions

- Un identifiant editorial de notion suit autant que possible la forme `<objet>_<specialisation>`. Lorsqu'un meme objet porte plusieurs notions, utiliser un prefixe commun et stable afin que les notions apparentees soient naturellement regroupees par tri alphabetique : `fractions_addition`, `fractions_comparaison`, `fractions_problemes`.
- Le prefixe peut etre collectif ou pluriel lorsqu'il designe naturellement l'objet commun, par exemple `fractions_*`. Il facilite la lecture, la recherche et le classement ; **il ne definit jamais l'appartenance a une famille**. Les appartenances restent portees explicitement par `editorial_familles_notions.csv`, et une notion peut appartenir a plusieurs familles.
- Ne pas ajouter un prefixe uniquement pour reproduire le nom d'une famille. Une notion dont l'identifiant est deja autonome, clair et non ambigu peut le conserver (`pythagore`, `ratio`, `intervalles_reels`, `racine_carree`). Le nommage aide les humains ; les relations du SI portent les rattachements et permettent aux familles d'agreger des notions aux noms differents.
- Choisir un nouvel identifiant comme s'il devait rester longtemps : avant de creer une notion, examiner les identifiants voisins et reutiliser leur convention. Appliquer ensuite exactement le meme identifiant dans le dossier `inst/notions/`, le `notion_id` du JSON et les referentiels pratiques qui decrivent cette notion. Les identifiants `MAT_*` du referentiel editorial des programmes constituent une autre couche et ne doivent pas etre confondus avec cet identifiant pratique.
- Le libelle humain reste libre de suivre la grammaire naturelle du francais ; la convention technique de l'identifiant ne doit pas deformer le libelle.

## 3. Contrat pédagogique des quiz

- Les quiz contiennent **uniquement des questions corrigibles automatiquement et sans ambiguïté**. Reformuler ou écarter une question libre qui ne satisfait pas ce critère ; ne pas ajouter de correction automatique de texte libre.
- Chaque QCM doit avoir **une seule réponse mathématiquement correcte**. Un **distracteur est un raisonnement faux plausible que l’on veut tester**, pas la proposition fausse affichée à l’élève. L’atelier applique ce raisonnement à une combinaison et obtient une proposition fausse. Deux raisonnements faux peuvent produire accidentellement la même proposition ou une proposition équivalente à la bonne réponse : la combinaison doit alors être rejetée ou retravaillée **avant** l’écriture du JSON. Le JSON final conserve les propositions affichées, pas la mécanique des distracteurs. Vérifier les équivalences mathématiques, pas seulement l’identité des chaînes de caractères.
- Favoriser la **diversité des raisonnements** plutôt que plusieurs formulations du même calcul.
- **Une question numérique possède des variantes, dans toutes les notions et toutes les familles.** Dès que des valeurs numériques apparaissent dans une question active, l’atelier prépare plusieurs variantes finies. Les données d’exercice varient réellement ; réponses, propositions, corrections et illustrations restent cohérentes. Une constante mathématique (par exemple 0 pour un événement impossible, le rayon 1 du cercle trigonométrique ou l’exposant 0 dans `a^0 = 1`) reste vraie : la diversité porte alors sur le contexte ou la formulation, jamais sur une fausse variation de la constante. Ryacas/Yacas contrôle en amont les calculs et équivalences lorsqu’il peut faire le travail. Le runtime ne calcule rien : il choisit une variante déjà terminée. Une question numérique sans plusieurs variantes distinctes est une anomalie de contenu. Les questions de vocabulaire ou de définition sans valeur numérique ne sont pas concernées.
- Une notion est un apprentissage, pas un format de question. Éviter les doublons artificiels. Les vestiges de migration et les données mortes ne restent pas dans les banques actives.
- Autoriser une correction libre et directe : les étapes « Je vois / Je sais » sont facultatives.
- Les questions portant sur une droite graduée doivent montrer une véritable droite dans les quiz HTML et PDF ; la figure ne révèle pas la réponse.
- Un quiz transversal `fractions` mélange les questions de toutes les notions de fractions sans dupliquer les banques.
- **Contrat impératif : questions de vocabulaire « mot à trou » et « mot masqué »**. Toute nouvelle banque de notion contient **au moins un `mot_a_trou` et au moins un `mot_masque`** ; les deux peuvent porter sur le même terme. Les banques historiques encore incomplètes sont explicitement recensées comme dette de migration par le test correspondant : toute nouvelle banque non recensée échoue immédiatement si une des deux formes manque, et une banque historique sortie de dette doit être retirée de cette liste. Ce sont deux présentations de **QCM à propositions plausibles**, jamais des champs de saisie. L’élève sélectionne une proposition ; la correction est automatique par le moteur QCM existant. Ne jamais proposer de réponse libre, de reconnaissance textuelle ou un nouveau moteur de correction pour ces exercices.
  - **Mot à trou** : quelques lettres du terme recherché restent visibles et les emplacements cachés correspondent **exactement** aux lettres manquantes. Exemple pour « rayon » : `r _ _ _ n`. Le contrôle automatisé vérifie le nombre total de positions et la position de chaque lettre visible pour toutes les propositions.
  - **Mot masqué** : seules des lettres-indices éventuelles restent visibles ; le trait central a une **longueur graphique fixe, sans rapport avec le nombre de caractères**. Exemple pour « hypoténuse » : `H________E`. Afficher obligatoirement l’avertissement : « La longueur du trait ne correspond pas au nombre de caractères du mot recherché. » Utiliser un terme mathématique unique, pas une expression de plusieurs mots.
  - Dans **les deux variantes**, fournir plusieurs **propositions de mots mathématiques plausibles**, en lien avec la question et les confusions pédagogiques possibles. La question est affichée **une seule fois**, puis chaque proposition est affichée sous sa propre forme masquée (ne pas montrer les mots en clair avant correction). Le mot réel est conservé comme valeur interne pour la correction automatique. Les représentations affichées doivent permettre de distinguer les propositions : ne jamais produire des choix visuellement identiques ou une question ambiguë. Une seule proposition doit répondre à la définition posée. La correction révèle le mot choisi, la bonne réponse et une explication utile.
  - Conserver ces deux types lors des migrations de questions et vérifier leur présence dans les banques historiques avant de conclure qu’ils n’existaient pas. **Ne pas confondre** avec un nombre manquant dans une équation ni avec des mots masqués dans une correction.
- Préserver les corrections pertinentes, notamment « Je vois / Je sais / J'en déduis » et « Je calcule » quand cela apporte réellement quelque chose. Ne pas imposer artificiellement ces étapes.
- **Trois actions HTML distinctes, dans cet ordre** : « Valider mes réponses » corrige le tirage affiché ; « Relancer ce quiz » efface réponses et corrections **sans changer les questions, valeurs ni propositions** ; « Générer un nouveau quiz » affiche le prochain tirage pré-calculé. Après le dernier tirage, revenir au premier (boucle). Ne jamais confondre relance et nouveau tirage.
- `produire(..., n = 10, tirages = 20)` signifie dix questions par quiz et vingt quiz pré-calculés ; `variantes` reste un ancien alias de `tirages`. Lorsqu'une même définition variable est utilisée plusieurs fois dans ces tirages, consommer ses variantes sans remise tant qu'il en reste ; une répétition n'est acceptable qu'après épuisement des variantes disponibles. Ne pas construire de détection générique de doublons sur les énoncés.
- Les modèles R Markdown restent des modèles de rendu : la sélection et l'instanciation cohérente des questions sont réalisées par une petite fonction R dédiée et testable. Ne pas déplacer cette logique métier dans `quiz.Rmd`. Les tirages sont calculés en R lors de la génération, jamais par JavaScript dans le navigateur.
- HTML : réponses sélectionnables, vérification/correction et relance. PDF : version imprimable avec corrigé. `produire()` doit ouvrir le document par défaut et permettre de désactiver l'ouverture lors des générations en série.
- **Lisibilite des enonces** : lorsqu'un enonce contient plusieurs phrases, chaque nouvelle phrase commence sur une nouvelle ligne dans le rendu HTML et PDF. Cette regle est appliquee par le modele de quiz ; ne pas ajouter manuellement des retours a la ligne dans les JSON pour obtenir cet effet.
- Le vocabulaire mathematique interessant a questionner est conserve dans `inst/referentiels/vocabulaire_notions.csv`. Ce fichier est un pense-bete editorial minimal `notion;mot`, enrichi au fil du travail. Il ne pilote ni le moteur ni la selection des questions et n'impose pas que chaque mot devienne une question.

### Procédure fonctionnelle obligatoire avant de créer une banque de questions

**Cette section est un invariant d’architecture. La relire avant toute modification des questions ou du moteur.** Si une nouvelle notion semble exiger une exception dans le runtime, ne pas ajouter l’exception : revenir à cette procédure et revoir le fonctionnement général. Une difficulté rencontrée par une notion ou une famille est un signal pour réexaminer l’ensemble, jamais une raison d’empiler une branche spéciale.

Pour toute nouvelle notion ou famille, **ne jamais commencer par remplir le JSON**. Partir d’une copie de `documentation/modeles/atelier_questions.R`, dans un espace de travail local. L’atelier est spécifique à la notion, jetable et n’est jamais appelé par eduschool.

1. **Choisir d’abord ce que l’on veut faire raisonner.** Inventorier les formes déjà supportées par eduschool et retenir celles qui servent réellement la notion. Pour un QCM, définir la bonne méthode et quelques **raisonnements faux plausibles**. Un distracteur désigne ce raisonnement faux ; la valeur ou le texte qu’il produit est une **proposition fausse**.
2. **Explorer un domaine large hors du runtime.** Le helper local génère des combinaisons candidates. Il peut être aussi spécifique que nécessaire à la notion ; cette complexité disparaît avec l’atelier et ne devient pas une API générique du package.
3. **Faire les mathématiques avec Ryacas/Yacas en amont.** Avant d’implémenter un calcul, une transformation, une simplification, une équivalence ou un contrôle mathématique, vérifier sérieusement si Ryacas/Yacas sait le faire. L’atelier lui délègue le plus gros du travail.
4. **Appliquer les raisonnements faux aux combinaisons.** L’atelier produit la bonne réponse et les propositions fausses correspondant aux erreurs pédagogiques choisies. Il ne fabrique pas trois valeurs fausses arbitraires uniquement pour remplir un QCM.
5. **Valider avant toute écriture JSON.** Ryacas/Yacas contrôle les résultats, les équivalences et, lorsque c’est pertinent, les transformations symboliques. Rejeter toute combinaison avec zéro ou plusieurs bonnes réponses, collision entre propositions, proposition fausse équivalente à la bonne, résultat non admissible ou distracteur pédagogiquement inutilisable. Pour une notion paramétrée destinée à l’entraînement, vérifier qu’un domaine suffisamment riche peut fournir au moins 50 combinaisons valides et distinctes ; ce seuil ne justifie jamais une abstraction dans le moteur.
6. **Sélectionner pédagogiquement.** Parmi les combinaisons valides, retenir un ensemble fini varié et utile, réparti si nécessaire par `progression`. La sélection humaine intervient après la validation mathématique, pas avant.
7. **Préparer le contenu final.** Réponse, propositions, correction, affichage mathématique et paramètres nécessaires aux illustrations sont finalisés dans l’atelier. Le JSON ne contient ni expression à exécuter, ni candidat à tester, ni calcul dérivé à refaire.
8. **Écrire seulement alors le JSON.** Une question fixe contient directement sa réponse finale. Une question variable contient une liste finie de variantes dont les paramètres sont déjà calculés, validés et relus. Le runtime ne découvre jamais la vérité mathématique.
9. **Jeter l’atelier lorsqu’il n’a plus de travail.** Le modèle reste ; les helpers spécifiques n’entrent pas dans le moteur. Conserver ponctuellement un atelier dans `tools/` n’est justifié que s’il sert encore concrètement à fabriquer ou réviser la banque.

La frontière est stricte :

```text
ATELIER : générer → Ryacas/Yacas → valider → sélectionner → préparer l’affichage → JSON
RUNTIME : lire → choisir → substituer → mélanger → afficher
```

Le runtime ne calcule pas une réponse, ne recherche pas la bonne proposition, ne teste pas une équivalence mathématique, ne calcule pas un paramètre dérivé et ne reconstruit pas une écriture mathématique. Les contrôles permanents du package sont **structurels** : JSON lisible, réponse présente une fois dans les propositions, propositions textuellement distinctes, correction présente, variantes bien formées, placeholders résolus et illustrations référencées correctement.

**Contrôle avant tout patch :** « Ce code aide-t-il à utiliser un contenu fini, ou essaie-t-il de fabriquer/valider les mathématiques pendant l’utilisation ? » Dans le second cas, il est au mauvais endroit.

**Règle de complexité :** ne jamais ajouter une exception, un mode de réponse, une branche par notion ou un parseur de représentation pour sauver un cas particulier. Si le modèle général ne suffit plus, arrêter le patch et revoir le modèle général avant d’ajouter du code.

### Fractions : choix du dénominateur commun (octobre 2026)

Pour une addition ou une soustraction de fractions, eduschool privilégie une méthode élémentaire et reproductible plutôt que la recherche systématique du PPCM. Si les dénominateurs sont identiques, aucun changement n’est nécessaire. Si l’un est un multiple de l’autre, utiliser le plus grand. Sinon, utiliser simplement le produit des deux dénominateurs. Le résultat final est ensuite simplifié si nécessaire.

Cette règle est éditoriale. Dans l’atelier de fabrication, les dénominateurs, facteurs, fractions équivalentes et résultats dérivables sont calculés autant que possible par Ryacas/Yacas, puis figés dans le JSON ; ne pas réimplémenter un algorithme de fractions dans le runtime R.

## Niveau affiché dans les quiz

L'en-tête d'un quiz affiche son niveau à partir de `inst/referentiels/editorial_familles_notions.csv`, sans liste parallèle dans le code. Pour une notion, afficher son niveau d'introduction. Pour une famille transversale couvrant plusieurs niveaux, afficher la plage du premier au dernier niveau, par exemple `6E à 3E`. Si `produire(..., niveau = ...)` demande explicitement un niveau, afficher ce niveau demandé. Ne jamais afficher un niveau absent ou `NA`.

## 4. Contrat impératif de livraison des patchs

**RTM / RTFM avant tout patch.**

1. Lire **ce guide**, puis les documents techniques pertinents présents dans `documentation/`, en particulier `EXPERIENCE-MATHS.md`.
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

- `inst/referentiels/editorial_familles_notions.csv` associe explicitement `famille;notion`.
  Pas de deduction fragile depuis les noms des dossiers ni de copie des JSON.
- `questions("fractions")` melange les banques des membres declares dans le CSV.
- `produire("fractions", "quiz")` genere uniquement le quiz transversal.
- `produire("fractions", "tous")` genere **au maximum quatre fichiers** :
  decouverte, synthese et quiz transversal. Les anciens fichiers revision.md
  peuvent rester archives, mais produire() ne les expose plus. Chaque fiche assemble
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

## Cercle trigonometrique et niveaux (septembre 2026)

- Le CSV conserve `famille;notion;libelle_notion;niveau;etape_scolaire`.
- Pour un quiz de famille, `niveau` filtre les notions dont le niveau
  d'introduction est connu et inferieur ou egal au niveau demande.
- Un niveau absent n'est pas interprete comme accessible a tous.
- Dans le catalogue pratique eduschool, `niveau` est un niveau d'introduction editorial et revisable : il indique a partir de quand eduschool accepte de proposer la notion. Il n'a pas vocation a certifier a lui seul le programme officiel.
- Une notion peut appartenir a plusieurs familles : repeter la notion sur plusieurs lignes du CSV plutot que creer une famille secondaire ou une nouvelle mecanique.
- Le triangle rectangle (3E) et le cercle trigonometrique (2GT) sont
  deux notions distinctes, sans duplication de banque.
- Les etiquettes des figures de trigonometrie utilisees en quiz sont
  agrandies sans changer les dimensions documentaires des figures.

## RETEX — Cercle trigonométrique : lisibilité des figures

Une figure présentant un angle orienté doit montrer les deux rayons, un arc fléché et le nom de l’angle. Les fiches peuvent afficher sa mesure ; les quiz ne doivent pas révéler une réponse dans l’illustration. `eduschool_display_width` permet à une figure compacte de demander une largeur inférieure au plafond documentaire commun de 65 %, sans traitement par notion dans le moteur.

## Fiches découvertes : activités et réponses (septembre 2026)

- Toute nouvelle fiche `decouverte.md` ou `synthese.md` part d'une copie du modèle canonique correspondant dans `documentation/modeles/` ; ne pas reconstruire sa structure de mémoire.
- Toute invitation à effectuer un exercice vérifiable utilise la forme **À essayer N — titre :** (en gras), avec numérotation continue dans chaque fiche. Ne pas glisser un « essaie » non identifié dans le texte courant.
- Chaque **À essayer N** possède une correction **N. titre** dans la dernière section **Pour vérifier tes découvertes**, dans le même ordre. Expliquer le raisonnement, pas seulement donner le résultat.
- Une exploration libre sans réponse unique peut rester une ouverture éditoriale clairement distincte ; ne pas la présenter comme un exercice dont la correction manquerait.
- Pour les fiches de familles, les corrections restent dans le Markdown de chaque notion, source éditoriale unique. Pas de nouvelle logique dans le moteur de rendu.

- Lorsqu'un « À essayer » demande de construire ou de lire une figure, sa correction doit montrer le résultat en réutilisant, si possible, le graphique existant avec des paramètres explicites. Le texte doit expliquer le raisonnement et identifier sur la figure tous les points nommés dans la correction. Vérifier la lisibilité des noms lorsque des points coïncident.

- Les images des fiches sont centrees dans les PDF par le modele commun `fiche.Rmd` ; conserver leur largeur editoriale et le rendu HTML existant. `fig.align` de knitr ne centre pas les images Markdown externes.

## UX — reperer les notions et les fonctions utiles

- `notions()` liste les identifiants de notions et de familles utilisables par `produire()`, a partir des dossiers et du referentiel existants. Aucun catalogue parallele en R.
- La cheatsheet source est `inst/templates/eduschool-cheatsheet.html` ; conserver sa copie publiee dans `pkgdown/assets/` synchronisee.

## Cheatsheet : parcours de decouverte

La cheatsheet commence par `eduschool()` puis regroupe les fonctions par usage :
decouvrir, explorer le systeme scolaire, trouver ses mathematiques, produire
des supports et utiliser les outils graphiques. Les deux bulles de contribution
et de manifeste figurent en bas, en deux colonnes. Les exemples `produire()`
montrent explicitement `notion =` et `format =`, chacun sur sa ligne.

## Variantes finies de questions (octobre 2026)

Une question variable contient une liste finie de `variantes`. Chaque variante
ne contient que des valeurs de `parametres` relues ; aucun code R, tirage ou
expression generatrice n'est execute depuis le JSON. Une variante est choisie
une seule fois, puis ses marqueurs `[[nom]]` sont remplaces litteralement dans
la definition avant le calcul ou la validation mathematique existante.

La definition concrete ainsi obtenue suit exactement le meme chemin que les
questions fixes. Les anciens `parametres` executables restent interdits. Les
variantes servent a varier le contenu ; elles ne constituent pas un nouveau
moteur de reponse.

La cle facultative `progression` appartient a une variante et decrit un palier
editorial local a la famille de questions, pas une mesure universelle de
difficulte. Elle peut etre modifiee simplement apres retour d'usage. Les
scripts de fabrication qui explorent ou caracterisent les combinaisons restent
hors du package ; le JSON ne conserve que les variantes relues et retenues.

## RETEX — typographie de l'inconnue dans les quiz (octobre 2026)

- Dans tout texte destine a l'eleve, la variable mathematique `x` s'affiche avec le caractere italique mathematique `\u1D465` (`𝑥`). Le `x` ASCII est reserve aux champs de calcul du moteur (`expression`, `source`, `*_expression`, etc.).
- Le signe de multiplication s'affiche `×`, jamais avec la lettre `x`.

## Règle d’or Ryacas et frontière de runtime (octobre 2026)

Ryacas/Yacas reste l’outil mathématique de référence d’eduschool, mais **dans l’atelier de fabrication**. Avant tout travail mathématique, vérifier systématiquement et sérieusement si Ryacas/Yacas peut effectuer le calcul, la transformation, la simplification, la représentation ou le contrôle attendu. Ne pas réimplémenter spontanément ces opérations en R.

Le résultat de ce travail est ensuite **figé dans le JSON**. Le runtime d’eduschool n’appelle pas Ryacas/Yacas et ne possède aucun mode `calcul_fixe`, `symbolique_fixe`, `relation_fixe`, aucun `calculs` dérivé et aucune reconstruction mathématique `presentation.math`. Une réponse finale est une donnée ; une variante finale ne contient que des données.

Pour une représentation mathématique destinée à l’élève, l’atelier peut demander à Yacas une forme TeX (`TeXForm`, `Hold`, etc.) lorsqu’elle est adaptée, puis stocker la représentation finale nécessaire au contenu. **Ryacas fait les maths en amont ; eduschool utilise le contenu validé.**
