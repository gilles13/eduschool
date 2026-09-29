# Transcription des mathématiques du cycle 4 (2026) — EN COURS

Source : annexe 2 du BO n° 10 du 5 mars 2026 : https://www.education.gouv.fr/bo/2026/Hebdo10/MENE2602912A

Ce lot ajoute des **intitulés synthétiques**, et non des citations littérales, des objectifs d’apprentissage du domaine « Nombres et calculs » pour les classes de quatrième et troisième. Les descriptions et les automatismes n’ont pas encore été transcrits. Les libellés synthétiques doivent être vérifiés lors de la revue éditoriale ; le texte officiel fait autorité.

**Périmètre couvert** : quatrième, cinq thèmes du domaine « Nombres et calculs » ; troisième, quatre thèmes de ce domaine. En troisième, la rubrique « Multiples et diviseurs » présente des automatismes mais pas de rubrique distincte « Objectifs d’apprentissage » : aucune capacité n’y a été inventée.

**Périmètre NON couvert** : les autres domaines du cycle 4 pour la quatrième et la troisième, les automatismes, les prolongements et les descriptions détaillées. Les programmes du lycée 2026 restent à transcrire. Les anciens programmes demeurent archivés, jamais utilisés pour compléter le programme 2026.

**Entrée en application** : 4e en 2027-2028 ; 3e en 2028-2029. Les diagrammes 2026 représentent les programmes publiés, pas nécessairement ceux actuellement appliqués.

La présence de capacités dans un diagramme ne constitue pas une certification d’exhaustivité. Ne pas retirer la mention « transcription partielle » avant vérification thème par thème de l’ensemble de l’annexe officielle.

## Deuxieme lot : objectifs des autres domaines en 4E et 3E

76 nouveaux intitules synthetiques ont ete ajoutes pour la geometrie, les statistiques, les probabilites, la proportionnalite, les fonctions et la pensee informatique. Source : annexe 2 du BO n°10, pages 13 a 20. Ce lot complete les objectifs identifies pour ces domaines en 4E et 3E ; il ne constitue pas une transcription integrale du document.

Certains themes ne possedent dans le texte officiel que des automatismes et aucun objectif d’apprentissage distinct : Transformations et Reperage en 4E, Reperage en 3E. Ils restent volontairement sans CAPACITE. La rubrique Automatismes, les descriptions, prolongements et le controle exhaustif des objectifs existants (y compris 5E et Nombres et calculs) restent a traiter.

## Annexe officielle reçue : inventaire des rubriques par thème

Le fichier `inst/programmes/programme_rubriques_c4_2026.csv` contient les passages extraits de l’annexe officielle (pages 7 à 20), reliés aux **45 thèmes existants** par `theme_item_id` : **41 rubriques OBJECTIFS, 36 rubriques AUTOMATISMES et 22 rubriques PROLONGEMENTS**. Une rubrique est stockée en un seul enregistrement multiligne, sans inventer des objectifs ou des automatismes absents du texte. Les quatre thèmes sans rubrique OBJECTIFS distincte sont : Multiples et diviseurs (3E), Transformations (4E), Repérage (4E et 3E). Les lignes existantes de `programme_items.csv` ne sont pas modifiées : les capacités synthétiques restent distinctes du texte source.

**Attention à la fidélité des formules :** l'extraction du PDF peut déplacer des fractions présentées verticalement, des exposants et certains symboles. Les rubriques contenant des chiffres, symboles ou espacements suspects sont signalées `A_VERIFIER` dans `controle_formules`. Le PDF officiel fait autorité ; ne pas publier ces passages comme des citations garanties sans relecture visuelle. Le nouveau CSV sert de base à la comparaison des capacités et à la transcription détaillée, pas de certification d'exhaustivité des capacités déjà présentes.

La présence de toutes les rubriques par thème ne signifie pas que tous les objectifs sont déjà représentés individuellement par des `CAPACITE` : une vérification éditoriale objectif par objectif est encore nécessaire. Les automatismes et prolongements ne sont pas encore affichés par `diagramme_programme()` ; leur intégration graphique constitue une étape distincte.

## Visualisation de controle des rubriques officielles

`tools/diagramme-c4-officiel.R` fournit `diagramme_c4_officiel("5E"/"4E"/"3E")` pour visualiser les 45 themes avec les capacites synthetiques et les rubriques extraites (automatismes, objectifs et prolongements). C'est un outil de relecture, independant de l'API publique et de la fonction experimentale `diagramme_programme()`. Les fractions et formules signalees restent a comparer visuellement au PDF avant publication. Ce rendu n'est pas une certification d'exhaustivite objectif par objectif.
