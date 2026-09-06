# Données réelles et provenance

## Une statistique n’est pas un décor

La version 0.21.0 introduit un premier chemin pour utiliser des données
publiques réelles dans des exercices, graphiques ou fiches, sans les
transformer en nouvelle source de vérité interne.

**Les données sont réelles. L’exercice est fabriqué. Le graphique est
joli. La source est obligatoire.**

Le premier adaptateur concerne l’Insee et son API Melodi. Déclarer une
source ne déclenche aucun appel réseau :

``` r

src = source_insee_melodi(
  "DS_POPULATIONS_REFERENCE",
  filtres = list(GEO = "FRANCE-F"),
  titre = "Populations de référence"
)

decrire_source(src)
#>   producteur service                  dataset                    titre
#> 1      Insee  Melodi DS_POPULATIONS_REFERENCE Populations de référence
#>                                                                      url
#> 1 https://api.insee.fr/melodi/data/DS_POPULATIONS_REFERENCE?GEO=FRANCE-F
#>                          licence
#> 1 Licence Ouverte / Open Licence
verifier_source(src)
#> [1] TRUE
```

## Appeler seulement quand c’est utile

L’appel réel est volontairement explicite :

``` r

donnees = recuperer_donnees(src)
head(donnees)
citer_source(donnees)
```

[`recuperer_donnees()`](https://gilles13.github.io/eduschool/reference/recuperer_donnees.md)
utilise le package optionnel `melodi`. Si celui-ci manque, ou si le
réseau est indisponible, `eduschool` s’arrête avec un message clair. Il
ne remplace jamais silencieusement une donnée officielle par une valeur
fabriquée.

> **eduschool ne collectionne pas les API. Il les appelle quand il a
> quelque chose d’intelligent à leur demander.**

## La source suit les données

Les données récupérées portent leur provenance comme attribut. Le
graphique peut ainsi réutiliser exactement la même information :

``` r

p = ggplot2::ggplot(
  donnees,
  ggplot2::aes(x = TIME_PERIOD, y = OBS_VALUE, fill = POPREF_MEASURE)
) +
  ggplot2::geom_col(position = "dodge")

annoter_source(p, donnees)
```

Une donnée qui perd sa provenance n’est pas considérée comme prête à
entrer dans une fiche. Et **« Source : Internet » n’est pas une source.
C’est un appel à l’aide.**

## Et les autres API ?

Elles attendront d’avoir du travail. Éducation nationale, Météo-France,
IGN/API Géo ou d’autres producteurs officiels pourront être ajoutés
lorsqu’un cas pédagogique concret le justifiera.

**Une nouvelle abstraction n’entre dans eduschool que lorsqu’elle a
trouvé du travail.**
