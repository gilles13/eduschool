# Reconstruction des controles des ateliers (phase independante)

Ce chantier est volontairement **debranche** de `audit_banques.R` et du runtime.
Les ateliers historiques restent inchanges. Le script de verification lit leurs
objets `valides`, puis evalue independamment la bonne reponse et chacun des
3 distracteurs a partir des parametres du candidat.

Depuis la racine du depot, dans R :

```r
source("tools/verifier_ateliers_fractions.R")
r = verifier_ateliers_fractions()
subset(r, statut != "VALIDE")
table(r$atelier, r$statut)
```

Le controle couvre les 11 ateliers `atelier_fractions_{addition,soustraction,
multiplication,division,fois_entier,equivalentes,comparaison,quotient,quantite,
irreductibles,encadrement}.R` et seulement leurs candidats `valides`.
Il utilise des produits croises entiers pour les fractions, sans tolerance
flottante, et distingue `ERREUR`, `VALIDE`, `INDETERMINE`.

**Important :** la verification porte sur les candidats conserves dans les
ateliers, **pas encore sur les variantes des `questions.json`**. Il faudra
ensuite etablir leur correspondance ou adapter ces regles aux modeles JSON.
Le script ne certifie ni les corrections redigees, ni les figures, ni la
qualite pedagogique des distracteurs. Les autres ateliers, notamment ceux
utilisant Ryacas, restent a reconstruire. Le script n'a pas pu etre execute
sous R dans l'environnement de preparation : premiere execution a confirmer.

Constat de lecture : `atelier_fractions_addition.R` ne recalculait pas la
somme ; son helper `ajouter()` verifiait seulement la presence des quatre
candidats, leur distinction textuelle et, dans certains cas, leur collision
numerique par arrondi. Le controle mathematique reconstruit ici est donc
plus exigeant que le controle historique conserve.
