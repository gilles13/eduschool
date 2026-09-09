<div class="eduschool-hero">
  <img src="identite/hero-eduschool-math.png"
       alt="edusch∞l Math — plusieurs chemins, différents points de vue, mêmes découvertes">
</div>

# Comprendre sa scolarité. Travailler les mathématiques.

> **Apprendre → structurer → transmettre.**

**eduschool** aide à comprendre la scolarité du collège au lycée et propose des
outils pour travailler les mathématiques.

Pas besoin de connaître l'architecture du package pour commencer. Choisissez
simplement la porte qui vous ressemble le plus. Le but est de disposer vite
d'un support qui puisse être imprimé, lu sur tablette, envoyé et surtout
discuté ensemble.

---

## Je suis parent

Vous voulez comprendre ce que votre enfant est censé apprendre, ce qui compte
vraiment d'une classe à l'autre et comment l'aider sans refaire le cours à sa
place.

**[Prendre un parent par la main →](articles/prendre-un-parent-par-la-main.html)**

Cycles, notions essentielles, difficultés classiques, DNB, lycée et spécialité
mathématiques : le guide long, progressif et volontairement humain.

---

## Je suis élève

Allez directement à votre classe.

**Collège :** [6e](articles/mathematiques-6e.html) ·
[5e](articles/mathematiques-5e.html) ·
[4e](articles/mathematiques-4e.html) ·
[3e](articles/mathematiques-3e.html)

**Lycée :** [2de](articles/mathematiques-2de.html) ·
[1re spécialité](articles/mathematiques-1re-specialite.html) ·
[Terminale spécialité](articles/mathematiques-terminale-specialite.html)

**[Voir toutes les ressources de mathématiques →](articles/mathematiques-par-niveau.html)**

---

## Je veux comprendre le parcours scolaire

Niveaux, cycles, voies, séries, options, spécialités et orientation : commencez
par une vue d'ensemble avant de descendre dans les détails.

**[Explorer les parcours scolaires →](articles/parcours-scolaires.html)** ·
**[Comprendre l'orientation →](articles/orientation-au-lycee-et-apres-le-bac.html)**

---

## Je veux utiliser les données et R

`eduschool` repose sur un mini-système relationnel volontairement frugal. Les
consultations usuelles restent simples ; les couches plus techniques sont là
pour ceux qui souhaitent regarder sous le capot.

```r
library(eduschool)

parcours("3E")
programme("6E")
revision("6E")
exercices("6E", n = 5)
```

**[Prise en main rapide →](articles/prise-en-main.html)** ·
**[Architecture des données →](articles/architecture-des-donnees.html)** ·
**[Référence R →](reference/index.html)**

---

## Un projet sérieux qui ne se prend pas trop au sérieux

Les données, les relations et les mathématiques doivent être exactes. La
documentation, elle, a le droit de respirer.

`eduschool` est donc un projet à la fois très simple et assez complexe. Il vous
faudra un certain temps pour bien le comprendre et l'utiliser. Mais
rassurez-vous : une fois le système parfaitement maîtrisé, vous serez
probablement proche de la retraite et pourrez **enfin** vous reposer.

En attendant, les contrôles automatiques travaillent pour vous :

```r
controle_integrite(strict = TRUE)
```

Le silence est ici une bonne nouvelle.

---

## Un projet volontairement centré sur les math

L'architecture peut accueillir d'autres disciplines, mais les fiches de
révision, exercices et générateurs restent volontairement consacrés aux
mathématiques. Cette limite permet de conserver un outil cohérent, maintenable
et utile.

**Utiliser → comprendre → adapter → partager**


---

## Le projet a aussi une histoire

`eduschool` garde une trace de ce qui l'a fait évoluer, sans transformer la page
d'accueil en autobiographie.

**[Journal du projet →](articles/journal-du-projet.html)** ·
**[Livre d'or →](articles/livre-d-or.html)** ·
**[Guide d'or →](articles/guide-d-or.html)**
