# Découvrir le cercle trigonométrique

## 1. Un cercle et trois points

Dessine un cercle de centre **O** et de rayon **1**. Sur l'axe horizontal, à droite de O, place **I** : c'est notre point de départ. Choisis un point **M** sur le cercle. Les deux segments **OI** et **OM** partent du même point O.

<!-- graphique: cercle_trigonometrique angle=45 -->

Sur la figure, **O** est le sommet de l'angle, **OI** est son côté de départ et **OM** son côté d'arrivée. Le rayon vaut 1 : OI = OM = 1.

## 2. Voir l'angle, puis le mesurer

Pour aller de I à M, on fait tourner le rayon OI autour de O. Le petit arc fléché **à l'intérieur du cercle** montre cette rotation. Nous appelons cet angle **alpha**, noté $\alpha$ : c'est l'angle orienté **de OI vers OM**.

<!-- graphique: cercle_trigonometrique angle=135 -->

Ici, $\alpha = 135°$. Le sens inverse des aiguilles d'une montre est le sens positif. Dans l'autre sens, l'angle serait négatif. Un tour entier correspond à 360°.

**À essayer 1 — Un quart de tour :** pars de I, tourne d'un quart de tour dans le sens positif et place M. Où se trouve-t-il ?

## 3. Pourquoi le rayon vaut-il 1 ?

Le choix du rayon 1 simplifie la lecture : sur ce cercle, l'abscisse (position horizontale) de M est le **cosinus** de l'angle, et son ordonnée (position verticale) est son **sinus**. On écrit $M=(\cos\alpha,\sin\alpha)$.

Pour commencer, retiens seulement ceci : **cosinus = horizontal ; sinus = vertical**. Nous pourrons ensuite comprendre pourquoi, en reliant le cercle au triangle rectangle.

## 4. Et les radians ?

On peut mesurer la même rotation dans deux unités. Un tour complet vaut **360°**, ou **$2\pi$ radians**. Un demi-tour vaut **180°**, ou **$\pi$ radians**. Un quart de tour vaut **90°**, ou **$\pi/2$ radians**. La figure ne change pas : seule l'unité utilisée pour mesurer l'angle change.

## 5. À toi de lire la figure

<!-- graphique: cercle_trigonometrique angle=135 -->

À 135°, M est à gauche de l'axe vertical et au-dessus de l'axe horizontal. Son abscisse, donc son cosinus, est négative ; son ordonnée, donc son sinus, est positive. **À essayer 2 — Une rotation de 45° :** dessine M après une rotation positive de 45° à partir de I. Dans quelle partie du cercle se trouve-t-il ? Quels sont les signes de ses coordonnées ?

## Pour vérifier tes découvertes

**1. Un quart de tour.** Un tour entier vaut 360°, donc un quart de tour vaut $360°/4=90°$. En partant de I et en tournant dans le sens positif (inverse des aiguilles d'une montre), M arrive au sommet du cercle, sur l'axe vertical. Ce point est J : $M=J=(0;1)$.

<!-- graphique: cercle_trigonometrique angle=90 -->

**2. Une rotation de 45°.** M se trouve en haut à droite du cercle : ses deux coordonnées sont positives. Comme l'angle est de 45°, elles sont aussi égales. L'activité demandait seulement de placer M et de déterminer les signes ; voici comment aller plus loin et retrouver leurs valeurs exactes.

<!-- graphique: cercle_trigonometrique angle=45 triangle=1 -->

Sur le dessin, **H** est le pied de la verticale issue de M. Le triangle **OHM** est rectangle en H. Ses deux angles aigus valent 45° : il est donc isocèle, et **OH = HM = a**. Comme OM est un rayon du cercle, **OM = 1**.

Avec le théorème de Pythagore : $a^2+a^2=1^2$, donc $2a^2=1$, puis $a^2=1/2$. Les deux coordonnées étant positives, $a=\sqrt{1/2}=\sqrt2/2$. On comprend ainsi pourquoi $M=(\sqrt2/2;\sqrt2/2)$, sans apprendre cette valeur par cœur.
