# Inventaire contrôlable — fractions et Pythagore

Ce lot est une **transcription structurée complète des sources disponibles**, et non une certification de leur exactitude mathématique ou de leur exécution par le nouveau moteur.

- Pythagore : 5 définitions historiques dans `inst/notions/pythagore/questions.json` → `migration_historique.questions` ; 5 blocs éditoriaux regroupés par identifiant. Les étapes « Je vois / Je sais / J'en déduis » sont séparées lorsqu'elles figurent dans la source.
- Addition de fractions : 3 définitions historiques dans `inst/notions/addition_fractions/questions.json` → `migration_historique.questions`. Les textes éditoriaux existants concernent principalement `FRAC_ADD_001` ; aucune correction manquante n'est inventée.
- Autres fractions : 20 définitions historiques, conservées **séparément** dans `inst/notions/famille_fractions/questions_historiques.json` (11 familles), sans les présenter à tort comme des additions.

Les questions pilotes déjà présentes restent dans le tableau `questions`, donc le moteur actuel n'est pas cassé. Les transcriptions figurent dans `migration_historique` et ne sont **pas encore utilisées par `produire()`**.

**Prochain contrôle concret** : vérifier mathématiquement les définitions historiques (notamment les paramètres aléatoires et les arrondis de Pythagore), sélectionner les variantes valides, brancher les questions validées sur le moteur, puis produire HTML **et** PDF et inspecter les documents.
