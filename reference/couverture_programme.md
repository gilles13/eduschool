# Observer la couverture pedagogique d'un programme

\`couverture_programme()\` part des capacites du programme et indique ce
qu'eduschool sait actuellement leur rattacher : notions documentees,
modeles d'exercices et plage de difficulte declaree par ces modeles.

## Usage

``` r
couverture_programme(niveau, discipline = "MAT", version = "2026_2027")
```

## Arguments

- niveau:

  Niveau scolaire, par exemple \`"5E"\` ou \`"2GT"\`.

- discipline:

  Discipline, \`"MAT"\` par defaut.

- version:

  Version scolaire, \`"2026_2027"\` par defaut.

## Value

Un data.frame avec une ligne par capacite et son etat observable.

## Details

La fonction ne pretend pas mesurer la qualite pedagogique des
generateurs. Une capacite avec un modele est donc marquee
\`modele_disponible\`, et non \`couverte\`. L'audit de la difficulte et
de la portee reelle des generateurs est un chantier distinct.
