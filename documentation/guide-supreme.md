# Guide supreme eduschool

Ce document conserve la memoire de conception d'eduschool : les regles qui ont
deja servi, les arbitrages, les fragilites connues et les questions que nous
avons choisi de ne pas trancher trop tot.

Il n'est ni une documentation utilisateur, ni une seconde architecture, ni un
cimetiere de TODO. Il doit nous eviter de redécouvrir les memes raisons six
mois plus tard.

Le Guide est versionne avec le code. Une modification importante de notre
maniere de construire eduschool doit pouvoir laisser ici une trace courte,
comprehensible et utile.

## Etats d'une note

Pour l'instant, trois etats suffisent :

- **Decision** : une regle a deja trouve du travail et guide nos choix ;
- **Reflexion ouverte** : le probleme est reel, mais nous n'avons pas encore
  assez d'usages pour choisir proprement ;
- **Fragilite connue** : nous savons qu'un point peut casser ou devenir couteux,
  nous savons pourquoi nous l'acceptons aujourd'hui et ce qui nous conduirait a
  le revoir.

Une non-decision peut donc etre versionnee. Elle n'est pas un oubli.

# Construire sans perdre le chemin

## Decision - partir de l'etat reel

Le depot Git local est la reference de travail. Avant de modifier une fonction
existante, identifier son contrat, ses appelants et le test le plus proche.

Un patch doit etre construit contre l'etat reel du depot et verifie avant
application :

```sh
git apply --check evolution.patch
git apply evolution.patch
```

Un patch qui suppose l'etat du projet est plus dangereux qu'un patch plus petit
construit a partir de ce qui existe vraiment.

## Decision - tester du plus petit au plus grand

Lorsqu'un test cible existe, il passe avant la suite complete. La suite complete
passe avant le check.

> **Pas de check si les tests echouent.**

Le check local courant peut rester leger. Le check CRAN complet est reserve aux
jalons ou aux situations dans lesquelles sa rigueur supplementaire a un travail
reel a accomplir.

Une correction purement editoriale n'a pas besoin de convoquer toute la chaine
de validation si un controle plus proche suffit.

## Decision - une abstraction doit avoir du travail

> **Une nouvelle abstraction n'entre dans eduschool que lorsqu'elle a trouve du travail.**

Une architecture elegante n'est pas un benefice si elle rend le projet plus
difficile a comprendre, tester ou modifier. On prefere la plus petite solution
qui repond au besoin observe, puis on regarde ce que les usages suivants nous
apprennent.

> **Un PNG a trouve du travail ; un "asset manager" non.**

Le fait qu'un objet local puisse un jour appartenir a un systeme plus general
ne justifie pas la construction immediate de ce systeme. Plusieurs usages reels
nous diront, le moment venu, ce qu'ils ont effectivement en commun.

## Decision - accepter une solution locale consciente

Une solution locale peut etre imparfaite sans que le projet soit mal concu. Une
rustine connue, limitee et documentee peut etre preferable a une architecture
generale inventee avant de connaitre les besoins reels.

Le point important est de savoir qu'elle existe, pourquoi elle existe et quel
signal justifierait son remplacement.

# Donnees, contenus et rendus

## Decision - les CSV internes privilegient la robustesse

Les CSV eduschool sont des donnees internes, pas une interface humaine. Leur
robustesse structurelle prime sur leur lisibilite brute. Lorsqu'un CSV est
modifie, sa structure doit etre controlee : separateur, nombre de champs et
identifiants notamment.

## Fragilite connue - notation mathematique et moteurs de rendu

La fiche de revision sur les ensembles a montre qu'un symbole mathematique
Unicode parfaitement lisible dans un contenu peut faire echouer un rendu PDF
avec `pdflatex`.

La correction actuelle utilise ponctuellement du LaTeX dans certains textes de
la fiche. Elle permet le rendu, mais elle fait connaitre au contenu une
contrainte du moteur de sortie. Ce couplage n'est pas considere comme une
solution generale satisfaisante.

Une petite table R de correspondance et une fonction de traduction pourraient
centraliser certains passages Unicode vers LaTeX. Cette solution introduirait
toutefois sa propre logique : racines, expressions composees, contexte HTML,
limites de la substitution et distinction entre texte naturel et vraie formule.

**Decision actuelle : ne pas arbitrer trop tot.** Nous gardons la solution
locale, nous versionnons la fragilite et nous observons les prochains cas reels.
Si le meme besoin se repete dans plusieurs contenus ou plusieurs moteurs, la
couche de traduction aura alors trouve du travail et son contrat pourra etre
defini a partir d'exemples reels.

### Regle de prudence actuelle

Dans une source destinee directement a un rendu R Markdown, LaTeX ou PDF, une
vraie expression mathematique est ecrite en LaTeX plutot qu'avec des symboles
mathematiques Unicode bruts susceptibles de casser `pdflatex`.

Dans le code R, lorsqu'un caractere Unicode est reellement necessaire a une
interface ou a un graphique, utiliser une sequence d'echappement plutot que de
semer des symboles mathematiques bruts dans le source.

Cette regle protege l'etat actuel ; elle ne prejuge pas de l'architecture future.

## Fragilite connue - asset graphique et source du graphique

Le schema des ensembles dispose maintenant d'un petit PNG adapte a son usage
dans la fiche PDF. La fonction R qui sait dessiner le schema reste utile par
ailleurs.

Le PNG est donc volontairement un instantane. Il peut diverger de la fonction
qui a servi de reference si l'un evolue sans l'autre. Nous acceptons cette
fragilite tant qu'un mecanisme de generation ou de gestion des assets n'a pas
plusieurs usages reels a servir.

# Interface humaine

## Decision - une intention, une porte

> **Une intention = une porte.**

Les moteurs internes peuvent etre plusieurs ; l'utilisateur ne devrait pas
avoir a les connaitre pour accomplir une intention simple. La complexite du SI
reste derriere l'interface humaine.

Une API destinee a apprendre doit eviter le bruit inutile. Dans les exemples
humains, les operations naturellement enchainees utilisent de preference le
pipe natif `|>`. Une affectation est reservee aux objets qu'il est reellement
utile de conserver.

## Decision - un outil range ce qu'il produit

Un outil qui produit des fichiers doit savoir ou les ranger. Il ne doit pas
compter sur l'utilisateur pour faire le menage. Les choix de rangement font
partie du contrat des fonctions de production et doivent etre testes comme tels.

# Pedagogie et conception

## Decision - comprendre l'intention avant la reponse

> **Comprendre l'intention avant de chercher la reponse.**

Cette regle vaut pour l'eleve comme pour le developpement. Une correction
techniquement exacte peut etre mauvaise si elle repond a la formulation
litterale tout en manquant l'intention pedagogique.

## Decision - la hierarchie visuelle a un sens pedagogique

Un logo signe un support ; il n'en est pas le sujet. Un graphique important ne
doit pas etre rendu secondaire par l'identite visuelle. Les notions essentielles
doivent pouvoir etre reperees rapidement.

> **Un bon graphique ne decore pas la notion. Il doit permettre de la comprendre.**

Une image absurde peut aider a memoriser ; elle ne remplace pas le graphique
qui explique.

## Decision - l'ordre peut enseigner

Lorsqu'un ordre semantique existe, il peut faire partie de l'apprentissage. Pour
les ensembles usuels de nombres, conserver l'ordre N, Z, D, Q, R dans les
questions de classement renforce la chaine d'inclusion et evite une charge
visuelle inutile. Le melange reste utile lorsqu'aucun ordre naturel n'a de
valeur pedagogique.

## Decision - distinguer refaire et transferer

Dans un quiz, "Reessayer" et "Nouveau defi" ne poursuivent pas la meme
intention. Reessayer permet de verifier si l'erreur a ete comprise sur la meme
situation. Un nouveau defi verifie si cette comprehension se transfere a une
autre situation.

La mise en oeuvre technique de cette distinction doit respecter l'autonomie des
supports HTML ; elle ne doit pas etre simulee par une interface qui promettrait
plus que le moteur ne peut faire.

# Fragilites et arbitrages

## Decision - nommer ce que nous savons fragile

Une fragilite connue et versionnee reste une fragilite, mais elle n'est plus un
angle mort. Le Guide doit conserver :

1. ce qui est fragile ;
2. pourquoi nous l'acceptons aujourd'hui ;
3. le signal qui justifierait de rouvrir la decision.

## Reflexion ouverte - ne pas confondre proprete et solidite

Un refactoring peut rendre le code plus joli tout en augmentant le nombre de
contrats implicites. Avant de generaliser, demander quel risque concret est
retire et quel nouveau risque est introduit.

> **Ne pas decider trop tot est parfois une (bonne) decision.**

Les parentheses sont volontaires. Elles laissent une petite embuscade logique.
Le Guide conserve ici la regle de conception ; le Livre d'or peut, lui, en faire
une porte pedagogique.

# Guide et Livre d'or

Le Guide et le Livre d'or ne sont pas deux copies du meme texte.

**Le Guide conserve ce que nous apprenons en construisant eduschool et pourquoi
nous prenons, differons ou revisons certaines decisions.**

**Le Livre d'or utilise aussi ce que nous apprenons pour faire apprendre.** Une
phrase peut y etre utile, ambigue, surprenante ou legerement contradictoire si
elle ouvre une question. Le Livre d'or est une methode pedagogique a part
entiere, pas seulement un recueil de principes.

Une idee peut donc naitre dans un bug, devenir une regle du Guide, puis ouvrir
une porte mathematique ou philosophique dans le Livre d'or. La digression n'est
pas necessairement une sortie du chemin ; elle peut faire partie du chemin.

# Garder le cap

Quand une evolution devient difficile a justifier, revenir a la question :

> **Qu'est-ce qu'on est en train d'apprendre ?**

Le projet n'a pas pour finalite de produire la plus belle architecture possible.
Il doit aider a comprendre, essayer, verifier, corriger, partager et ouvrir de
nouvelles portes.

Le Guide lui-meme doit respecter cette regle : il grandit lorsqu'une experience
lui donne quelque chose d'utile a conserver. Il ne doit pas devenir une usine a
gouvernance.

## Decision - une specialisation conserve un chemin de repli

Lorsqu'un cas particulier est ajoute devant un mecanisme general existant,
l'absence de specialisation doit explicitement retomber sur le comportement
general. L'ajout du PNG des ensembles l'a rappele : une illustration sans asset
dedie doit continuer a etre dessinee par le moteur historique.

Une exception utile ne doit pas casser le cas general.

## Fragilite connue - transport des assets jusqu'au document final

Un asset peut exister, etre trouve par R et pourtant etre mal transporte par la
chaine R Markdown, knitr, Pandoc et LaTeX. Le premier essai du PNG des ensembles
a produit dans le PDF un chemin de fichier au lieu de l'image attendue.

La correction locale laisse LaTeX inclure explicitement l'image lors du rendu
PDF. Cette solution est volontairement limitee a l'usage observe. Si plusieurs
supports rencontrent le meme probleme, il faudra reexaminer le contrat de
transport des ressources avant de generaliser.

## Reflexion ouverte - pagination et intention pedagogique

Un saut de page peut materialiser un changement d'intention, mais il ne doit pas
etre impose avant d'avoir observe le document reel.

Un premier essai sur la fiche des ensembles forcait une nouvelle page avant les
pieges afin de separer revision et ouverture. Le rendu a montre que cette
coupure etait trop mecanique. Le saut force a donc ete retire et la pagination
redevient naturelle.

L'idee reste ouverte : si plusieurs fiches montrent qu'une seconde page porte
une intention pedagogique stable, nous pourrons alors definir une regle. Pas
avant.

## Decision - le vocabulaire du SI reste derriere l'interface humaine

Une expression comme "Notions eduschool reliees" expose la plomberie du projet
sans aider l'eleve. Dans une production destinee a apprendre, on nomme
l'intention humaine plutot que l'objet interne.

Ici, "Pour aller plus loin" suffit. Le fait qu'eduschool connaisse les relations
entre notions appartient au moteur, pas au vocabulaire que l'eleve doit
apprendre pour utiliser la fiche.

## Reflexion ouverte - deux zeros, une boucle et l'infini

Transmettre un savoir n'est peut-etre pas faire passer quelque chose de celui
qui sait vers celui qui ne sait pas. Celui qui explique apprend en expliquant ;
celui qui questionne transforme la question. Ce qui est transmis peut revenir
different, puis repartir enrichi.

Le modele simple du maitre qui possederait le savoir et de l'eleve qui le
recevrait ne suffit donc pas. Dans le partage, chacun peut simultanement
transmettre et apprendre. Il n'y a pas necessairement un 1 qui remplit un 0.
Il peut y avoir deux savoirs incomplets qui acceptent de se rencontrer.

Deux zeros separes evoquent alors deux boucles encore independantes. Relies,
ils font penser a la forme de l'infini : deux boucles distinctes appartenant au
meme trace. La relation n'est plus seulement une fleche entre deux personnes ;
elle fait partie de la forme.

Cette image donne un sens supplementaire a une idee deja presente dans
eduschool : partager un savoir, c'est aussi accepter qu'il nous revienne
enrichi. Ce qui revient peut repartir, etre transforme a nouveau, puis revenir
encore. Le partage n'epuise pas le savoir : il peut l'ouvrir.

Le premier zero n'est d'ailleurs pas vide. Il peut simplement representer celui
qui sait qu'il ne sait pas tout et qui reste disponible pour apprendre. Le lead
dev valide personnellement cette hypothese : il se declare lui-meme "null en
maths". Longtemps soupconnee d'etre un bug, cette propriete pourrait finalement
etre une feature.

Ne pas transformer pour l'instant cette image en modele, en abstraction ou en
fonctionnalite. Une pensee a le droit d'exister avant d'avoir trouve du travail ;
c'est l'abstraction technique qui doit presenter son contrat d'embauche.

Le zero n'etait peut-etre pas vide. Il etait disponible.

L'infini, ca va loin.
