# Ressources complementaires aux mathematiques

Ces fonctions sont independantes du moteur de fiches et de quiz.

- `voies()` et `series()` consultent les referentiels de la sauvegarde v1.
- `maths_programmes(niveau)` consulte les programmes de mathematiques archives et leurs niveaux d application connus. La date de publication et la source sont conservees. Les dates historiques ne garantissent pas la validite actuelle des textes.
- `maths_parcours()` retourne les noeuds et liens ; `maths_parcours("parcours.svg")` ecrit dans `tempdir()` ; un chemin avec dossier explicite est respecte. Il reproduit un diagramme simplifie cycle 3 -> cycle 4 -> lycee. Ce diagramme represente les voies, et non le detail des options mathematiques.

Les donnees proviennent de la sauvegarde master ; celle-ci reste l archive de reference. Aucune dependance avec `produire()` ou les banques de questions.

Le SVG de `maths_parcours()` est vertical pour une insertion dans pkgdown ; il affiche les series technologiques repertoriees dans `inst/ressources/series.csv`. Le chemin complet du SVG est annonce dans la console.
