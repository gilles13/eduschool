# Libelle d'une capacite de programme

Retourne le libelle associe a un identifiant de capacite ou d'item de
programme. Si le referentiel n'est pas disponible ou si l'identifiant
n'est pas trouve, l'identifiant fourni est retourne tel quel.

## Usage

``` r
libelle_capacite(capacite_id)
```

## Arguments

- capacite_id:

  Identifiant de la capacite ou de l'item de programme.

## Value

Une chaine de caracteres contenant le libelle de la capacite, ou
\`NULL\` si \`capacite_id\` est absent.
