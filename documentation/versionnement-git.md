# Versionnement avec Git

À partir de V0.10.0, le dépôt source doit devenir la référence du projet. Un ZIP n'est qu'un instantané de livraison.

## Démarrage recommandé

Depuis la racine du projet, l'utilisateur peut lui-même initialiser son dépôt :

```sh
git init
git add .
git commit -m "Initial import: eduschool 0.10.0"
```

Le choix de GitHub, GitLab ou d'un dépôt local reste entièrement indépendant du package. Aucun dépôt Git n'est inclus dans la distribution.

## Cycle de travail

Pour les prochaines évolutions, travailler directement sur le dépôt et échanger des modifications sous forme de fichiers ciblés ou de patchs (`git diff`) plutôt que de reconstruire systématiquement l'ensemble du projet. Les versions publiées peuvent ensuite être matérialisées par des tags et, si nécessaire, par `R CMD build`.

## Fichiers à ne pas versionner

Les bases `*.duckdb`, sorties de rapports, fichiers temporaires R, résultats de check et archives construites sont exclus via `.gitignore`.
