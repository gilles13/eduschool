# Combinatoire et dénombrement

## Idée centrale

Dénombrer consiste à compter sans énumérer un à un. On traduit une situation en choix successifs, arrangements ou sous-ensembles, puis on utilise les principes additif et multiplicatif et les coefficients binomiaux.

## À connaître

- principe additif : des cas incompatibles se comptent en additionnant leurs effectifs ;
- principe multiplicatif : des choix successifs se comptent en multipliant le nombre de possibilités à chaque étape ;
- nombre de permutations de $n$ objets distincts : $n!$ ;
- nombre de parties à $k$ éléments d'un ensemble à $n$ éléments : $\binom{n}{k}$ ;
- $\binom{n}{k}=\binom{n}{n-k}$ et $\binom{n}{k}=\binom{n-1}{k-1}+\binom{n-1}{k}$.

## Méthode

1. préciser ce qui constitue une issue ;
2. décider si l'ordre intervient et si les choix peuvent se répéter ;
3. décomposer en cas incompatibles ou en choix successifs ;
4. appliquer la règle de dénombrement adaptée ;
5. vérifier que chaque issue est comptée une seule fois.

## Exemple

Dans une classe de 12 élèves, le nombre de groupes de 3 élèves est $\binom{12}{3}=220$. L'ordre des trois élèves ne compte pas : un groupe n'est donc pas une suite ordonnée.

## Vérification

Pour de petites valeurs, dresser la liste ou un arbre permet de contrôler la formule. Une symétrie comme $\binom{12}{3}=\binom{12}{9}$ fournit aussi un contrôle utile.

## Automatismes à maîtriser

- calculer de petites factorielles et des coefficients binomiaux ;
- reconnaître si l'ordre est pertinent ;
- utiliser un arbre ou un tableau pour organiser les choix ;
- passer d'un dénombrement à une probabilité équiprobable.

## Erreurs fréquentes

- utiliser $n!$ alors que l'ordre n'a pas d'importance ;
- compter plusieurs fois la même configuration ;
- additionner des cas qui ne sont pas incompatibles ;
- oublier qu'un coefficient binomial compte des sous-ensembles, pas des listes ordonnées.
