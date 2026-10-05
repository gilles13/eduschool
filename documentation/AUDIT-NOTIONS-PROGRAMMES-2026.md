# Audit notions / programmes - 2026

## Principe

La seule source de verite sur le contenu des programmes est le Bulletin officiel (BO). Les identifiants, notions, familles, capacites synthetiques et rattachements crees par eduschool sont des constructions internes. Ils ne prouvent jamais qu une relation est officielle.

Eduschool fait par ailleurs le choix editorial de presenter le programme le plus recent retenu comme pleinement applicable a tous les niveaux concernes, sans modeliser son calendrier officiel d entree en vigueur progressive. Ce choix doit etre annonce dans les rendus.

## Separation des donnees

La migration distingue maintenant explicitement :

- `inst/programmes/officiel_programme_items.csv` : structure DOMAINE / THEME transcrite depuis les programmes retenus ;
- `inst/programmes/officiel_programme_rubriques_*.csv` : extraits officiels transcrits ;
- `inst/programmes/editorial_capacites.csv` : 753 capacites synthetiques eduschool, auparavant melangees aux items officiels ;
- `inst/editorial/mathematiques/editorial_notions.csv` : 137 notions internes eduschool ;
- `inst/editorial/mathematiques/editorial_notions_items.csv` : rapprochements editoriaux entre notions internes et items officiels ;
- `inst/referentiels/editorial_familles_notions.csv` : familles pedagogiques eduschool.

`programmes.csv` et `metadata/sources.csv` gardent un nom neutre : ce sont des registres techniques mixtes et les prefixer `officiel_` serait trompeur.

## Loupe sur les 56 notions auparavant sans rattachement

Apres retrait des anciens liens `ITM_MATOLD_*`, 56 notions internes etaient sans rattachement. L audit a montre que ce nombre melangeait plusieurs situations : themes ou domaines officiels deja transcrits, notions explicitement presentes dans les rubriques officielles, et objets editoriaux.

Les anciens liens ne sont pas reconstruits par recherche textuelle approximative. Les 284 rattachements conserves sont d abord ramenes au THEME officiel parent de leur ancienne capacite synthetique. Les notions restantes sont rattachees lorsqu un appui dans le BO retenu est identifiable ; le rattachement reste editorial et cible l item officiel qui porte le passage concerne.

Apres migration, 136 notions sur 137 possedent au moins un rattachement editorial vers un item officiel. `MAT_HOMOTHETIE` reste volontairement sans rattachement : aucun appui n a ete retenu dans le BO C4 2026 actif. Ce trou est conserve et doit rester visible dans les futurs rendus.

## Consequence pour les rendus

Un futur `diagramme_notions()` devra distinguer visuellement :

1. le contenu officiel transcrit du BO ;
2. le rattachement editorial propose par eduschool ;
3. les notions sans rattachement ;
4. le choix editorial d anticipation du dernier BO retenu.

Aucune recherche par mots-cles ou `grepl()` ne doit completer silencieusement un rattachement absent. Une heuristique textuelle eventuelle est une aide d audit, jamais une source de verite, et doit produire un avertissement si elle intervient dans un rendu.
