# Découvrir la trigonométrie : mesurer sans grimper

## Mission impossible ?

Comment mesurer la hauteur d'un immeuble quand notre mètre ne dépasse pas trois mètres ? Monter sur le toit avec une règle géante serait une solution... assez peu pratique.

<!-- image: immeuble.png -->

Imaginons une autre méthode : nous nous plaçons à une distance connue du bâtiment et nous mesurons **l'angle** entre le sol et la direction de son sommet. Est-ce suffisant pour retrouver sa hauteur ?

## Une découverte : des triangles qui grandissent sans changer de forme

Observons deux triangles rectangles possédant le **même angle aigu**. Le second est plus grand, mais leurs côtés correspondants grandissent dans la même proportion.

<!-- graphique: trigonometrie_triangles_semblables -->

> **À observer**<br>
> Dans le petit triangle, les côtés mesurent 3 et 4. Dans le grand, ils mesurent 6 et 8. Compare les rapports $3/4$ et $6/8$.

> **À retenir**<br>
> Les rapports sont égaux ! Pour un même angle, les proportions entre les côtés restent identiques, quelle que soit la taille du triangle.

Voilà pourquoi la trigonométrie permet de calculer des longueurs sans tout mesurer.

## Trois façons de comparer les côtés

Dans le triangle $ABC$ rectangle en $A$, intéressons-nous à l'angle $\widehat{ABC}$, situé en $B$.

<!-- graphique: trigonometrie_triangle_rectangle -->

- **L'hypoténuse** est $BC$ : elle est en face de l'angle droit.
- **Le côté opposé** à l'angle en $B$ est $AC$.
- **Le côté adjacent** à l'angle en $B$ est $AB$ (autre que l'hypoténuse).

Le **sinus** compare le côté opposé à l'hypoténuse :

$$\sin(\widehat{ABC})=\frac{AC}{BC}$$

Le **cosinus** compare le côté adjacent à l'hypoténuse :

$$\cos(\widehat{ABC})=\frac{AB}{BC}$$

La **tangente** compare le côté opposé au côté adjacent :

$$\tan(\widehat{ABC})=\frac{AC}{AB}$$

Ces trois rapports ne sont pas trois formules à utiliser en même temps : **on choisit celui qui relie les longueurs connues à la longueur recherchée**.

## Une astuce pour retenir : SOHCAHTOA

**SOH** : **S**inus = **O**pposé / **H**ypoténuse.

**CAH** : **C**osinus = **A**djacent / **H**ypoténuse.

**TOA** : **T**angente = **O**pposé / **A**djacent.

> **À retenir**<br>
> SOHCAHTOA aide à retrouver les rapports, mais commence toujours par repérer l’angle étudié : opposé et adjacent dépendent de cet angle.

## Retour à notre immeuble

Nous nous plaçons à 12 m du pied d'un immeuble, sur un sol horizontal. L'angle entre le sol et notre regard vers son sommet mesure 30°. La tangente relie précisément la hauteur au recul :

$$\tan(30^\circ)=\frac{\text{hauteur au-dessus des yeux}}{12}$$

La hauteur au-dessus de nos yeux vaut donc $12\times\tan(30^\circ)$, soit environ **6,9 m**. Si nos yeux sont à 1,6 m du sol, l'immeuble mesure environ **8,5 m** dans ce modèle simplifié.

> **À explorer**<br>
> Si nous reculons alors que l’immeuble garde la même hauteur, l’angle augmente-t-il ou diminue-t-il ?

## Et si nous cherchions l’angle ?

Nous connaissons maintenant la distance et la différence de hauteur : nous sommes à **20 m** de l’immeuble et son sommet est à **15 m au-dessus de nos yeux**. Mais cette fois, nous ignorons l’angle de notre regard. Comment le retrouver ?

SOHCAHTOA nous indique d’utiliser la tangente :

$$\tan(\alpha)=\frac{15}{20}=0{,}75$$

La calculatrice permet de retrouver l’angle avec la touche **arctan** (parfois notée $\tan^{-1}$) :

$$\alpha=\arctan(0{,}75)\approx36{,}9^\circ$$

> **À explorer**<br>
> On peut également retrouver un angle avec **arcsin** ou **arccos** lorsqu’on connaît les côtés correspondants. Sur la calculatrice, vérifie que le mode **degrés** est activé.

Pour retrouver les trois formules d'un seul coup d'œil, consulte la **fiche synthèse**. Ici, l'essentiel est de comprendre pourquoi ces rapports existent.
