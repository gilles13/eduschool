# Composer un squelette d'examen

Construit une composition parametree a partir du profil de l'examen. Le
resultat ne contient pas encore les enonces : il decrit les questions ou
exercices a rediger, leurs concepts, supports et points cibles.

## Usage

``` r
composer_examen(code, session, seed = NULL)
```

## Arguments

- code:

  Code de l'examen.

- session:

  Session de l'examen.

- seed:

  Graine pseudo-aleatoire utilisee pour controler les tirages de
  composition.

## Value

Un data.frame de composition.
