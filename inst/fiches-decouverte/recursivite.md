---
title: "Recursivite : quand une chose se contient elle-meme"
niveau: "decouverte"
notions: "recursivite, fonction, condition d'arret, pile d'appels"
---

# Recursivite : quand une chose se contient elle-meme

## QUESTION

Une fonction peut-elle s'appeler elle-meme ?

A premiere vue, l'idee semble absurde.

Si une fonction s'appelle elle-meme, puis que cette nouvelle execution appelle encore la meme fonction, qui l'appelle encore...

Quand est-ce que cela s'arrete ?

Et surtout :

**est-ce que cela s'arrete ?**

---

## JE CROIS SAVOIR

Prenons une fonction tres simple.

```r
bonjour = function() {
  print("Bonjour")
}
```

Quand on ecrit :

```r
bonjour()
```

R execute la fonction une fois.

Rien de tres mysterieux.

Mais rien n'interdit a une fonction d'appeler une autre fonction.

```r
a = function() {
  b()
}

b = function() {
  print("Bonjour depuis b")
}
```

Alors pourquoi une fonction ne pourrait-elle pas...

s'appeler elle-meme ?

---

## MAIS...

Essayons.

```r
encore = function() {
  print("Encore...")
  encore()
}
```

Puis :

```r
encore()
```

Que se passe-t-il ?

La fonction `encore()` :

1. affiche `"Encore..."` ;
2. appelle `encore()` ;
3. cette nouvelle execution affiche `"Encore..."` ;
4. puis appelle `encore()` ;
5. qui appelle `encore()` ;
6. qui appelle...

Il n'existe ici **aucune raison de s'arreter**.

Mathematiquement, on pourrait imaginer continuer indefiniment.

Mais un ordinateur n'a ni memoire infinie, ni patience infinie.

R finira donc par refuser de continuer.

La machine vient de nous apprendre quelque chose d'important :

> Une definition recursive ne suffit pas.  
> Il faut aussi savoir quand la recursion doit s'arreter.

---

# JE DECOUVRE

Une fonction recursive est une fonction qui utilise une version plus simple du meme probleme pour calculer sa reponse.

Prenons un compte a rebours.

```r
compte_a_rebours = function(n) {

  print(n)

  if (n > 0) {
    compte_a_rebours(n - 1)
  }
}
```

Essayons :

```r
compte_a_rebours(5)
```

On obtient :

```text
5
4
3
2
1
0
```

Que s'est-il passe ?

Au depart :

```text
compte_a_rebours(5)
```

appelle :

```text
compte_a_rebours(4)
```

qui appelle :

```text
compte_a_rebours(3)
```

qui appelle :

```text
compte_a_rebours(2)
```

puis :

```text
compte_a_rebours(1)
```

et enfin :

```text
compte_a_rebours(0)
```

Mais cette fois :

```r
n > 0
```

est faux.

La fonction n'en appelle donc pas une nouvelle.

La recursion s'arrete.

---

## DEUX INGREDIENTS

Notre fonction contient en realite deux idees tres differentes.

### 1. Le pas recursif

```r
compte_a_rebours(n - 1)
```

C'est ce qui permet au probleme de se ramener a une version plus petite de lui-meme.

### 2. Le cas d'arret

Ici :

```r
if (n > 0)
```

Lorsque `n` atteint zero, on ne recommence plus.

Ce cas est souvent appele **cas de base**.

On pourrait presque resumer la recursion ainsi :

```text
Si je connais le cas le plus simple,
et si je sais transformer un cas complique
en un cas un peu plus simple,
alors je peux peut-etre resoudre le probleme entier.
```

---

# UN EXEMPLE MATHEMATIQUE

Considerons la factorielle.

On note :

```text
5! = 5 x 4 x 3 x 2 x 1
```

Donc :

```text
5! = 120
```

Mais on peut aussi remarquer :

```text
5! = 5 x 4!
```

et :

```text
4! = 4 x 3!
```

et :

```text
3! = 3 x 2!
```

Le meme motif reapparait.

On peut donc definir :

```text
n! = n x (n - 1)!
```

Mais cette definition pose exactement notre probleme precedent.

Si nous continuons sans jamais nous arreter :

```text
5!
4!
3!
2!
1!
0!
(-1)!
(-2)!
...
```

nous n'avons rien gagne.

Il nous faut un cas de base.

Par convention :

```text
0! = 1
```

Nous pouvons maintenant ecrire une fonction recursive.

```r
factorielle = function(n) {

  if (n == 0) {
    return(1)
  }

  n * factorielle(n - 1)
}
```

Essay