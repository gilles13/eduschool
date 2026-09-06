# Générer une épreuve de mathématiques du DNB

`eduschool` peut produire des variantes reproductibles d’une épreuve de
mathématiques du DNB à partir d’une banque de gabarits. Le principe
n’est pas de stocker des sujets complets, mais de séparer les **règles
de l’épreuve**, les **familles d’exercices**, les **paramètres tirés**,
la **rédaction** et le **rendu**.

Cette organisation permet d’enrichir progressivement la banque au fil
des annales et des révisions, sans transformer chaque nouveau sujet en
nouveau code spécifique.

## Vue d’ensemble

Le générateur suit cinq étapes principales :

``` text
structure du DNB
      |
      v
banque de gabarits
      |
      v
composition du sujet
      |
      v
rédaction des questions
      |
      v
sujet / corrigé / corrigé détaillé
```

Dans R, ce flux correspond principalement à :

``` r

sujet = composer_examen("DNB", 2026, seed = 123)
partie1 = rediger_examen(sujet, partie = 1)
partie2 = rediger_examen(sujet, partie = 2)
```

La fonction
[`composer_examen()`](https://gilles13.github.io/eduschool/reference/composer_examen.md)
ne rédige pas encore le sujet. Elle choisit une composition compatible
avec le profil de l’épreuve.
[`rediger_examen()`](https://gilles13.github.io/eduschool/reference/rediger_examen.md)
transforme ensuite cette composition en questions effectivement posées,
avec leurs réponses, leurs corrections et, lorsqu’elles existent, leurs
ressources graphiques.

## Deux parties, deux logiques de génération

Pour le DNB 2026, `eduschool` distingue deux mécanismes.

### Partie 1 : automatismes

Les automatismes sont produits à partir de gabarits courts et
paramétrés. Une famille décrit par exemple une addition de fractions, un
pourcentage, une équation, un calcul de médiane ou une question
géométrique.

Chaque gabarit est associé à :

- un domaine mathématique ;
- un ou plusieurs concepts du référentiel ;
- des paramètres de tirage ;
- un générateur R ;
- éventuellement une ressource graphique.

Le même gabarit peut donc produire de nombreuses variantes numériques
sans changer la nature de la question.

``` r

gabarits_examen()
generer_gabarit_examen("GAB_DNB_AUT_POURCENTAGE", seed = 123)
```

### Partie 2 : exercices composés

La seconde partie est organisée par **exercices complets**, et non par
questions indépendantes. Un gabarit composé contient un contexte
partagé, plusieurs questions ordonnées et, si nécessaire, une ressource
commune.

Les questions d’un même exercice peuvent relier plusieurs notions :
géométrie et grandeurs, fonctions et équations, statistiques et
probabilités, calcul littéral et algorithmique, par exemple.

``` r

gabarits_exercices_composes("DNB", "PROBLEMES")

generer_exercice_compose(
    "GABC_DNB_GEOM_AMENAGEMENT",
    seed = 123
)
```

Cette couche est volontairement distincte des automatismes : elle permet
de conserver un enchaînement logique entre les sous-questions d’un même
problème.

## Quelles familles de questions sont disponibles ?

Une **famille** décrit une forme de question ou de problème, et non un
énoncé figé. Les valeurs numériques sont tirées au moment de la
génération ; plusieurs énoncés peuvent donc partager le même
raisonnement mathématique tout en utilisant des données différentes.

### Familles d’automatismes

La partie 1 couvre actuellement treize familles courtes. Elles peuvent
être regroupées ainsi :

- **nombres et calcul** : addition de fractions, fraction d’une
  quantité, pourcentage, priorités opératoires et puissances de 10 ;
- **algèbre et fonctions** : équation du premier degré et
  proportionnalité ;
- **arithmétique** : divisibilité ;
- **statistiques et probabilités** : médiane et probabilité simple ;
- **géométrie et grandeurs** : angle d’un triangle et aire d’un
  rectangle ;
- **algorithmique** : lecture ou exécution d’une boucle Scratch.

Quelques formulations représentatives sont par exemple :

> Calculer 15 % de 240.
>
> Résoudre l’équation 3x + 5 = 20.
>
> Un rectangle mesure 8 cm de longueur et 5 cm de largeur. Calculer son
> aire.
>
> Dans une urne, 3 boules sont rouges et 5 sont bleues. On tire une
> boule au hasard. Quelle est la probabilité d’obtenir une boule rouge ?

Ces phrases ne constituent pas des questions stockées telles quelles :
le gabarit fournit la structure et le générateur choisit les valeurs
compatibles.

### Familles d’exercices composés

La partie 2 contient actuellement huit familles. Chacune relie plusieurs
notions et organise les questions dans un ordre cohérent.

| Famille | Notions principalement mobilisées | Exemple de situation |
|----|----|----|
| Aménagement géométrique | Pythagore, aire, proportionnalité | Une parcelle triangulaire doit être engazonnée ; vérifier sa géométrie, calculer son aire puis le coût. |
| Comparaison de tarifs | Fonctions affines, graphique, équation | Deux formules de location ont des coûts différents ; déterminer à partir de combien d’utilisations elles deviennent équivalentes. |
| Enquête et données | Médiane, pourcentage, probabilité | Un diagramme donne le nombre de trajets observés pendant plusieurs jours ; calculer une médiane puis une fréquence et une probabilité. |
| Programme de calcul et Scratch | Calcul littéral, équation, algorithmique | Exécuter un programme de calcul, le traduire par une expression puis retrouver une valeur de départ. |
| Mesure indirecte | Triangles semblables, Thalès, proportionnalité | Un piquet et un arbre projettent des ombres ; utiliser les longueurs mesurées pour déterminer la hauteur de l’arbre. |
| Cuve, volume et débit | Volume, conversions, pourcentage, proportionnalité | Une cuve partiellement remplie est vidée par une pompe ; calculer son contenu puis la durée de vidange. |
| Répartition de lots | Divisibilité, facteurs premiers, probabilité | Des jetons sont répartis en sachets identiques ; vérifier la répartition puis étudier les numéros gagnants. |
| Évolutions d’un prix | Pourcentages, coefficients multiplicateurs | Le prix d’un article augmente puis bénéficie d’une remise ; calculer le prix final et l’évolution globale. |

Par exemple, la famille **Cuve, volume et débit** peut conduire à un
enchaînement du type :

> Une cuve en forme de pavé droit mesure 2,5 m de longueur, 1,5 m de
> largeur et 1,2 m de hauteur. Elle est remplie à 75 %. Une pompe évacue
> 30 litres par minute.
>
> 1.  Calculer le volume total de la cuve en mètres cubes puis en
>     litres.
> 2.  Calculer le volume d’eau effectivement contenu dans la cuve.
> 3.  Déterminer la durée nécessaire pour la vider.

Le même mécanisme mathématique pourrait être décliné dans un autre
contexte, par exemple :

> Une piscine contient 18 000 litres d’eau. Une pompe évacue 120 litres
> par minute. Quelle quantité d’eau reste-t-il après 35 minutes ?
> Combien de temps faut-il pour vider complètement la piscine ?

De même, une famille reliant **aire et coût** peut être contextualisée
par une surface à aménager, à carreler ou à peindre :

> Un mur mesure 6 m de longueur et 2,5 m de hauteur. Un pot de peinture
> couvre 10 m² et coûte 24 euros. Calculer l’aire à peindre, déterminer
> le nombre de pots nécessaires puis le coût total.

Ces variantes de contexte sont intéressantes parce qu’elles permettent
d’augmenter la diversité des sujets sans multiplier artificiellement les
moteurs de calcul. Une nouvelle famille n’est utile que lorsque le
**raisonnement** ou l’enchaînement des questions devient réellement
différent.

## Les données mobilisées

Les données propres aux examens sont regroupées sous `inst/examens/`.
Elles réutilisent le référentiel mathématique existant au lieu de le
dupliquer.

On peut résumer les principales relations ainsi :

``` text
examens.csv
    |
    +-- parties_examen.csv
    |       |
    |       +-- profils_examen.csv
    |               |
    |               +-- profils_examen_concepts.csv
    |
    +-- gabarits_exercices.csv
    |       |
    |       +-- gabarits_exercices_concepts.csv
    |       +-- gabarits_parametres.csv
    |
    +-- gabarits_exercices_composes.csv
            |
            +-- gabarits_exercices_questions.csv
            +-- gabarits_exercices_ressources.csv
```

Les tables n’ont pas toutes le même rôle :

- `examens.csv` et `parties_examen.csv` décrivent la structure de
  l’épreuve ;
- `profils_examen.csv` décrit les choix de composition retenus par
  `eduschool` ;
- `gabarits_exercices.csv` et ses tables associées décrivent les
  automatismes ;
- `gabarits_exercices_composes.csv` et ses tables associées décrivent
  les exercices de la partie 2 ;
- les identifiants de concepts renvoient aux tables de
  `inst/mathematiques/`.

Quelques aperçus suffisent généralement pour comprendre la banque :

``` r

head(examens())
head(gabarits_examen())
head(gabarits_exercices_composes())
```

## Des ressources graphiques générées par R

Les figures ne sont pas stockées comme des images fixes. Les gabarits
décrivent les données nécessaires au dessin, puis R produit la ressource
au moment du rendu.

Cette approche permet notamment de faire varier les dimensions, les
valeurs ou les positions en même temps que l’énoncé, tout en conservant
un sujet et un corrigé cohérents.

``` r

x = generer_exercice_compose(
    "GABC_DNB_GEOM_AMENAGEMENT",
    seed = 123
)

if (!is.null(x$ressource)) {
    produire_ressource_examen(
        x$ressource,
        fichier = "ressource.pdf"
    )
}
```

Les graphiques cartésiens et géométriques utilisent `ggplot2` lorsque
cela apporte de la lisibilité ; les ressources qui s’y prêtent moins,
comme certains blocs Scratch, peuvent conserver un moteur plus simple
basé sur `grid`.

## Produire un sujet et son corrigé

Une fois la composition rédigée, chaque partie peut être produite
séparément :

``` r

sujet = composer_examen("DNB", 2026, seed = 123)

partie2 = rediger_examen(sujet, partie = 2)

produire_examen(
    partie2,
    fichier = "dnb-2026-partie2.pdf"
)

produire_corrige_examen(
    partie2,
    fichier = "dnb-2026-partie2-corrige.pdf"
)
```

Le corrigé est construit à partir de la même variante que le sujet : les
valeurs, les figures et les réponses restent donc synchronisées.

Pour les questions qui demandent plusieurs étapes de raisonnement, un
corrigé plus explicite peut être demandé :

``` r

produire_corrige_examen(
    partie2,
    fichier = "dnb-2026-partie2-corrige-detaille.pdf",
    detaille = TRUE
)
```

Le mode détaillé n’ajoute pas une nouvelle banque de réponses. Il
utilise la même question et développe seulement davantage les étapes
intermédiaires lorsque le gabarit les prévoit.

## Produire directement une variante complète

Pour l’usage courant,
[`produire_dnb()`](https://gilles13.github.io/eduschool/reference/produire_dnb.md)
orchestre l’ensemble du processus :

``` r

produire_dnb(
    seed = 123,
    repertoire = "dnb-123"
)
```

Pour générer en même temps les corrigés détaillés :

``` r

produire_dnb(
    seed = 123,
    repertoire = "dnb-123",
    detaille = TRUE
)
```

Le `seed` est l’identifiant pratique d’une variante. En le conservant,
on peut reconstruire la même composition et les mêmes paramètres de
génération.

## Enrichir progressivement la banque

La banque est destinée à évoluer au fil des annales et de l’utilisation
réelle des exercices. Lorsqu’une nouvelle forme intéressante apparaît,
la démarche préférée est :

1.  vérifier si une famille existante peut déjà la représenter ;
2.  enrichir les paramètres ou la traçabilité si le mécanisme existe ;
3.  ajouter un gabarit lorsque la forme pédagogique est réellement
    différente ;
4.  ajouter du code seulement lorsqu’un nouveau calcul ou un nouveau
    type de ressource est nécessaire.

Cette distinction entre **données de gabarit** et **moteurs R** évite de
faire grossir inutilement le code. Elle permet aussi de contrôler
progressivement la cohérence pédagogique des exercices pendant leur
utilisation réelle.

## Diversifier les contextes sans stocker les enonces

A partir de la version 0.18.0, `eduschool` separe explicitement la
**structure mathematique** de l’exercice et son **contexte semantique**.
Le gabarit indique ce qu’il faut raisonner ; le contexte indique dans
quelle situation ce raisonnement est presente.

``` text
GABARIT MATHEMATIQUE
        |
        +---- contexte : piscine / pompe
        +---- contexte : cuve / pompe
        +---- contexte : citerne / pompe
        +---- contexte : bassin / pompe
        |
        +---- parametres numeriques
                    |
                    v
             EXERCICE GENERE
```

Les contextes sont decrits dans `contextes_exercices.csv` par quelques
attributs semantiques. Pour une famille comme `STOCK_FLUX`, il ne suffit
pas de remplacer le mot *cuve* par *citerne* : le contexte fournit aussi
le genre de l’objet, son contenu et les verbes naturels. Une piscine
peut ainsi contenir de l’eau que la pompe *evacue*, alors qu’une citerne
peut contenir du gazole que la pompe *pompe*. Ces elements restent des
briques lexicales courtes, pas des phrases.

La table `gabarits_exercices_contextes.csv` indique simplement quels
contextes sont compatibles avec chaque gabarit. Aucun de ces deux
fichiers ne contient une banque d’enonces ou de questions completes. Le
moteur R assemble les briques semantiques avec les parametres
mathematiques du gabarit.

``` text
contexte semantique        parametres mathematiques
piscine / eau              volume / taux / debit
citerne / gazole      +     dimensions / valeurs
reservoir / fioul
          \                    /
           \                  /
            ----> redaction <----
                    |
                    v
          contexte + questions + correction
```

``` r

contextes_exercices("STOCK_FLUX")
gabarits_exercices_contextes("GABC_DNB_GRAND_CUVE")
```

Un contexte peut etre impose pour produire une variante precise :

``` r

generer_exercice_compose(
    "GABC_DNB_GRAND_CUVE",
    seed = 123,
    contexte_id = "CTX_PISCINE_VIDANGE"
)
```

Sans `contexte_id`, le moteur tire un contexte compatible. Le `seed`
fixe a la fois ce choix et les parametres numeriques : le sujet reste
donc reproductible. Cette separation permet d’augmenter progressivement
le nombre de situations rencontrees par l’eleve sans multiplier les
moteurs R ni recopier des exercices entiers. Le meme principe s’applique
aux huit familles : une famille de tarifs porte par exemple une unite
d’usage (*heure*, *seance*, *livraison*), une famille de lots distingue
l’objet (*jeton*, *ticket*, *badge*) du contenant (*sachet*, *carnet*,
*lot*), et une famille d’evolution de prix porte simplement le bien ou
service concerne.

Ainsi, la diversification reste fondee sur des donnees tres courtes :

``` text
GABARIT MATHEMATIQUE
        |
        +-- briques de contexte
        |      objet / produit / unite / contenant / acteur / verbe
        |
        +-- parametres numeriques
        |
        +-- moteur de redaction
                |
                v
        variante complete
```

Les phrases completes restent donc dans le moteur de redaction, ou elles
sont construites, et non dans les tables de donnees.
