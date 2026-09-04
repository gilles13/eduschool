# Ajouter ou corriger des données

1. Modifier le CSV canonique sous `inst/`.
2. Conserver les identifiants existants lorsqu'ils représentent la même entité.
3. Ajouter la source officielle lorsque la donnée dépend d'un texte réglementaire.
4. Lancer les tests avant commit.
5. Ne jamais modifier une base DuckDB générée comme source de vérité.

Les CSV utilisent `;` comme séparateur et UTF-8 comme encodage.
