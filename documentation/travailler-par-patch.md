# Évoluer sans échanger le projet complet

Après l'initialisation du dépôt Git local, le dépôt de l'utilisateur devient la référence. Pour une évolution ciblée, un échange sous forme de patch texte est préférable à un nouveau ZIP complet.

## Appliquer un patch

Depuis la racine du dépôt :

```sh
git status
git apply --check evolution.patch
git apply evolution.patch
git diff
```

Après test :

```sh
git add .
git commit -m "Description de l'évolution"
```

`git apply --check` permet de vérifier que le patch correspond bien à l'état courant avant de modifier les fichiers.

## Pour les changements importants

Un patch peut créer, modifier ou supprimer des fichiers texte. Pour une refonte très importante ou des ressources binaires, un instantané complet peut encore être utilisé exceptionnellement, mais il ne doit plus constituer le mode normal de développement.

## Règle pratique

- dépôt Git local : source de vérité ;
- patch : échange normal des évolutions ;
- tag Git : jalon de version ;
- `R CMD build` : artefact de distribution du package ;
- ZIP : secours ou photographie ponctuelle seulement.
