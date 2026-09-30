# Audit du programme de mathématiques du cycle 4 (2026)

Source de référence : annexe 2 du programme officiel publié au BO du 5 mars 2026.

## Résultat structurel

- 45 thèmes contrôlés : 16 en 5e, 15 en 4e, 14 en 3e.
- 99 rubriques officielles présentes dans `programme_rubriques_c4_2026.csv`.
- Les 45 thèmes du sommaire officiel ont un correspondant dans `programme_items.csv`.
- Les rubriques présentes ou absentes par thème concordent avec le PDF officiel.
- Quatre thèmes ne comportent pas de rubrique `OBJECTIFS` distincte dans le PDF : Transformations (4e), Repérage sur une droite et dans le plan (4e), Multiples et diviseurs (3e), Repérage sur une droite et dans le plan (3e). Ils ne doivent pas être complétés artificiellement.

## Statut des transcriptions

Le contrôle structurel ne transforme pas automatiquement les statuts éditoriaux de transcription. Le CSV conserve donc les indicateurs existants : `{'A_VERIFIER': 20, 'RELECTURE': 68, 'RELU_PDF': 11}`. Les passages marqués `A_VERIFIER` restent explicitement signalés jusqu'à validation éditoriale de leur typographie mathématique.

## Capacités eduschool

Les capacités de `programme_items.csv` restent des synthèses eduschool. Elles ne sont ni utilisées comme substitut au texte officiel ni déclarées exhaustives. Le diagramme distingue explicitement ces synthèses des rubriques officielles.

## Contrôle de segmentation des phrases

Les 99 rubriques ont également été relues pour distinguer les retours à la ligne sémantiques des retours imposés par la mise en page du PDF. Les retours physiques situés au milieu d'une même phrase ont été supprimés dans `texte_officiel_extrait`, tandis que les changements de puce, sous-puce, objectif et formule affichée ont été conservés. Ce nettoyage concerne 51 rubriques et ne change ni leur rattachement aux 45 thèmes ni leur contenu pédagogique. Il évite notamment de couper une phrase telle que « Utiliser les tables de multiplication pour factoriser des nombres entiers décomposables en produit de deux nombres différents de 1, par exemple, 21 = 3 × 7. ».
