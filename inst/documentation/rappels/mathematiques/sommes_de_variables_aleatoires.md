# Sommes de variables aléatoires

## Idée centrale

Une somme de variables aléatoires modélise un total : gain cumulé, nombre total d'événements ou mesure agrégée. L'espérance est additive, sans condition d'indépendance ; les variances s'additionnent pour des variables indépendantes.

## À connaître

$E(X+Y)=E(X)+E(Y)$ et plus généralement $E(aX+b)=aE(X)+b$. Si $X$ et $Y$ sont indépendantes, $V(X+Y)=V(X)+V(Y)$. Ces propriétés évitent souvent de construire toute la loi de la somme.

## Méthode

Décomposer la quantité étudiée en variables simples, identifier les indépendances réellement disponibles, puis utiliser linéarité de l'espérance et, si possible, additivité des variances.

## Exemple

Pour 20 variables de Bernoulli indépendantes de paramètre $p$, leur somme $S$ vérifie $E(S)=20p$ et $V(S)=20p(1-p)$.

## Vérification

L'additivité de l'espérance ne nécessite pas l'indépendance ; celle des variances, dans le cadre étudié ici, oui.

## Automatismes à maîtriser

- calculer $E(aX+b)$ ;
- reconnaître une somme de variables indicatrices ;
- utiliser l'indépendance uniquement lorsqu'elle est justifiée.

## Erreurs fréquentes

- croire que les espérances ne s'additionnent que sous indépendance ;
- additionner les écarts-types au lieu des variances ;
- supposer une indépendance non donnée.
