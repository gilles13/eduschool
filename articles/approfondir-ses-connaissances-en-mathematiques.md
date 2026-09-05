# Approfondir ses connaissances en mathématiques

``` r

library(eduschool)
```

`eduschool` structure les programmes et produit des outils de révision,
mais n’a pas vocation à remplacer les cours, exercices interactifs,
vidéos ou logiciels pédagogiques disponibles sur le Web. Cette vignette
recense une **sélection courte de ressources externes** utiles pour
comprendre, s’entraîner, visualiser ou approfondir les mathématiques.

Ces ressources pédagogiques sont volontairement séparées des **sources
de référence** utilisées pour documenter le système scolaire français.
Leur présence ici constitue une orientation pratique, pas une validation
institutionnelle de tous leurs contenus.

## Choisir une ressource selon son besoin

``` r

usages_ressources()[, c("libelle", "description")] |>
  knitr::kable(row.names = FALSE)
```

| libelle | description |
|:---|:---|
| Comprendre le cours | Cours explications vidéos et démonstrations |
| S’entraîner | Exercices quiz et entraînement avec correction ou retour |
| Réviser | Synthèses automatismes et préparation d’examens |
| Visualiser | Graphiques géométrie dynamique et exploration interactive |
| Travailler sur des annales | Sujets d’examens concours et corrigés |
| Programmer | Algorithmique programmation et expérimentation numérique |
| Approfondir | Problèmes raisonnements curiosités et prolongements |

## Ressources sélectionnées

La liste ci-dessous est produite depuis les tables relationnelles du
package. Elle n’est donc pas recopiée manuellement dans la vignette.

``` r

x = ressources_pedagogiques()
x$lien = paste0("[", x$nom, "](", x$url, ")")
x$acces = ifelse(
  x$compte_requis == "OUI",
  "gratuit, compte requis pour certaines fonctions",
  "gratuit, sans compte pour l'usage principal"
)
knitr::kable(
  x[, c("lien", "organisme", "description", "usages", "acces")],
  col.names = c("Ressource", "Responsable", "Pour quoi faire ?", "Usages", "Accès"),
  row.names = FALSE
)
```

| Ressource | Responsable | Pour quoi faire ? | Usages | Accès |
|:---|:---|:---|:---|:---|
| [APMEP](https://www.apmep.fr/) | APMEP | Annales du brevet du bac et de concours ainsi que ressources mathématiques | Travailler sur des annales, Approfondir | gratuit, sans compte pour l’usage principal |
| [France-IOI](https://www.france-ioi.org/algo/) | France-IOI | Cours exercices corrigés et entraînement progressif en algorithmique et programmation | Programmer, S’entraîner, Approfondir | gratuit, compte requis pour certaines fonctions |
| [GeoGebra](https://www.geogebra.org/?lang=fr) | GeoGebra | Outils interactifs pour fonctions géométrie algèbre statistiques et géométrie 3D | Visualiser, Approfondir | gratuit, sans compte pour l’usage principal |
| [Khan Academy](https://www.khanacademy.org/?lang=fr_fr) | Khan Academy | Cours et exercices gratuits pour consolider les fondamentaux et progresser à son rythme | Comprendre le cours, S’entraîner, Approfondir | gratuit, sans compte pour l’usage principal |
| [Lumni](https://www.lumni.fr/) | Audiovisuel public | Vidéos quiz dossiers et fiches de révision du collège au lycée | Comprendre le cours, S’entraîner, Réviser | gratuit, sans compte pour l’usage principal |
| [Math et Tiques](https://maths-et-tiques.fr/) | Yvan Monka | Cours exercices vidéos problèmes et ressources classés par niveau et par thème | Comprendre le cours, S’entraîner, Réviser, Programmer, Approfondir | gratuit, sans compte pour l’usage principal |
| [MathALÉA](https://coopmaths.fr/alea/) | CoopMaths | Exercices aléatoirisés corrections automatismes et révisions par niveau | S’entraîner, Réviser, Travailler sur des annales | gratuit, sans compte pour l’usage principal |
| [Sésamath](https://www.sesamath.net/) | Association Sésamath | Manuels cahiers ressources numériques et exercices de mathématiques | Comprendre le cours, S’entraîner, Réviser | gratuit, sans compte pour l’usage principal |

## Quelques repères

**Math et Tiques** est particulièrement utile lorsqu’on souhaite
retrouver un cours ou des exercices organisés selon les niveaux du
collège et du lycée. **Sésamath** apporte des manuels, cahiers et
ressources numériques. **GeoGebra** est complémentaire : il permet
surtout de manipuler et visualiser fonctions, figures géométriques et
objets en 3D.

Pour l’entraînement intensif, **MathALÉA** permet de régénérer des
exercices avec de nouvelles données. Pour préparer un examen à partir de
sujets réels, **l’APMEP** constitue une ressource majeure grâce à ses
annales. **Lumni** et **Khan Academy** sont utiles pour varier les
explications et les formats de révision. Enfin, **France-IOI** fournit
un parcours progressif en algorithmique et programmation.

## Filtrer depuis R

Le catalogue peut être interrogé exactement comme les autres données du
package. Par exemple, pour chercher des ressources d’exercices adaptées
à la 6e :

``` r

ressources_pedagogiques("6E", "EXERCICES")[, c("nom", "url", "usages")] |>
  knitr::kable(row.names = FALSE)
```

| nom | url | usages |
|:---|:---|:---|
| France-IOI | <https://www.france-ioi.org/algo/> | Programmer, S’entraîner, Approfondir |
| Khan Academy | <https://www.khanacademy.org/?lang=fr_fr> | Comprendre le cours, S’entraîner, Approfondir |
| Lumni | <https://www.lumni.fr/> | Comprendre le cours, S’entraîner, Réviser |
| Math et Tiques | <https://maths-et-tiques.fr/> | Comprendre le cours, S’entraîner, Réviser, Programmer, Approfondir |
| MathALÉA | <https://coopmaths.fr/alea/> | S’entraîner, Réviser, Travailler sur des annales |
| Sésamath | <https://www.sesamath.net/> | Comprendre le cours, S’entraîner, Réviser |

Pour préparer des annales de 3e :

``` r

ressources_pedagogiques("3E", "ANNALES")[, c("nom", "url")] |>
  knitr::kable(row.names = FALSE)
```

| nom      | url                          |
|:---------|:-----------------------------|
| APMEP    | <https://www.apmep.fr/>      |
| MathALÉA | <https://coopmaths.fr/alea/> |

## Un catalogue maintenable

Le modèle est normalisé en quatre tables :

- `ressources.csv` décrit chaque site une seule fois ;
- `usages_ressources.csv` définit les usages pédagogiques ;
- `ressources_usages.csv` relie une ressource à plusieurs usages ;
- `ressources_niveaux.csv` relie une ressource aux niveaux concernés.

Cette structure évite les listes séparées par des virgules dans les
données et permettra plus tard, si cela devient utile, d’ajouter des
liens vers des notions ou des familles de connaissances sans modifier le
catalogue principal.

Les sites externes évoluent. La colonne `date_verification` indique donc
quand chaque entrée a été contrôlée pour la dernière fois ; elle doit
être mise à jour lorsqu’un lien, une offre ou le périmètre d’une
ressource change.
