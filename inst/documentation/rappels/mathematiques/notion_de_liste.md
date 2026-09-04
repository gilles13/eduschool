# Notion de liste en algorithmique

## Idée centrale

Une liste permet de regrouper une suite ordonnée de valeurs et de les traiter par indice ou par parcours. Elle facilite les simulations, le stockage de résultats intermédiaires et le traitement de données.

## À connaître

En Python, une liste peut être créée avec des crochets, par exemple `L = [2, 5, 7]`. Les indices commencent à 0. `len(L)` donne la longueur ; `L.append(x)` ajoute une valeur à la fin. Une boucle `for` permet de parcourir les valeurs ou les indices.

## Méthode

Avant de coder, préciser ce que représente chaque élément de la liste, l'ordre attendu et l'opération à effectuer. Choisir ensuite entre parcours des valeurs et parcours des indices.

## Exemple

```python
L = [3, 1, 4, 1, 5]
s = 0
for x in L:
    s = s + x
```

À la fin, `s` contient la somme des éléments de `L`.

## Vérification

Tester l'algorithme sur une liste très courte dont le résultat peut être calculé à la main. Contrôler aussi le cas de la liste vide lorsqu'il est pertinent.

## Automatismes à maîtriser

- créer et lire une liste ;
- accéder à un élément par son indice ;
- ajouter un élément ;
- parcourir une liste ;
- calculer somme, minimum, maximum ou fréquence par une boucle simple.

## Erreurs fréquentes

- commencer les indices à 1 au lieu de 0 en Python ;
- dépasser le dernier indice ;
- modifier une liste pendant son parcours sans anticiper les conséquences ;
- confondre indice et valeur.
