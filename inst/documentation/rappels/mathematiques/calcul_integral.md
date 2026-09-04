# Calcul intégral

## Idée centrale

L'intégrale $\int_a^b f(x)\,dx$ mesure une accumulation orientée. Pour une fonction continue, elle se calcule à l'aide d'une primitive et permet notamment de déterminer des aires et des valeurs moyennes.

## À connaître

Si $F'=f$, alors $\int_a^b f(x)\,dx=F(b)-F(a)$. L'intégrale est linéaire et additive sur les intervalles. Si $f\geq0$, l'intégrale représente l'aire sous la courbe. La valeur moyenne de $f$ sur $[a,b]$ est $\frac1{b-a}\int_a^b f(x)\,dx$.

## Méthode

1. identifier une primitive ;
2. calculer $F(b)-F(a)$ ;
3. pour une aire entre deux courbes, déterminer d'abord laquelle est au-dessus ;
4. séparer l'intervalle si le signe change.

## Exemple

$\int_0^2 (3x^2+1)\,dx=[x^3+x]_0^2=10$.

## Vérification

Pour une fonction positive, l'intégrale doit être positive. Un encadrement simple de la fonction donne souvent un ordre de grandeur de l'intégrale.

## Automatismes à maîtriser

- trouver les primitives usuelles ;
- appliquer correctement les bornes ;
- utiliser linéarité et relation de Chasles ;
- distinguer intégrale orientée et aire géométrique.

## Erreurs fréquentes

- oublier d'évaluer la primitive aux deux bornes ;
- confondre $F(b)-F(a)$ avec $f(b)-f(a)$ ;
- considérer directement une intégrale négative comme une aire.
