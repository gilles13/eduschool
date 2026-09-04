# Diagrammes et documentation visuelle

Les diagrammes de `eduschool` sont décrits par des graphes internes en R. Le même modèle alimente deux formats de sortie :

- les pages HTML autonomes, destinées à la consultation utilisateur, sous `rapports/sorties/diagrammes/` ;
- les SVG statiques, versionnés sous `man/figures/`, utilisés par les vignettes et le site pkgdown.

La génération SVG est native : elle ne requiert ni Mermaid, ni Node.js, ni npm, ni navigateur, ni accès réseau. Les SVG peuvent donc être régénérés sur une installation R classique.

Depuis l'arbre source du package :

```r
devtools::load_all()
generer_documentation_visuelle()
```

Cette commande régénère les SVG documentaires et les pages HTML correspondantes.

Pour ne reconstruire que les SVG utilisés par les vignettes :

```r
generer_diagrammes_documentation()
```

Puis contrôler les vignettes et le site :

```r
devtools::build_vignettes()
pkgdown::build_site()
```

Les SVG de `man/figures/` sont volontairement versionnés afin que la construction de la documentation reste reproductible et indépendante du moteur de dessin.
