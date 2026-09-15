# Auditer les modeles d'exercices

\`auditer_modeles()\` compare empiriquement les exercices produits aux
differents niveaux de difficulte declares. Pour une meme graine, les
champs purement techniques (\`exercice_id\`, \`seed\`, \`difficulte\`)
sont ignores. Si plusieurs difficultes produisent toujours le meme
contenu sur les graines testees, elles appartiennent au meme profil
empirique.

## Usage

``` r
auditer_modeles(niveau = NULL, graines = 1:5)
```

## Arguments

- niveau:

  Niveau scolaire facultatif. Si \`NULL\`, tous les modeles sont audites
  sur leur premier niveau declare.

- graines:

  Graines reproductibles utilisees pour comparer les sorties.

## Value

Un data.frame avec une ligne par modele et son audit empirique.

## Details

Cet audit ne pretend pas mesurer toute la qualite pedagogique d'un
modele. Il detecte en revanche un cas important pour le pilotage : une
difficulte declaree dans le catalogue qui ne modifie pas le generateur.
