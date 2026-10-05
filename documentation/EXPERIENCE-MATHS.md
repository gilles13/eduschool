# Première expérience mathématique : fractions et Pythagore

Cette branche reconstruit eduschool sans reprendre son ancien moteur.
Les six CSV du socle sont conservés comme références, sans reconstruire
pour l'instant une API de jointures niveau/thème/notion.

- `inst/notions/<notion>/` : questions JSON et trois contenus Markdown.
- `inst/modeles/` : deux modèles R Markdown de publication.
- `R/mathematiques.R` : lecture, instanciation et production.

Après installation du package, dans R :

```r
eduschool::produire("fractions_addition", "decouverte", "sorties")
eduschool::produire("fractions_addition", "synthese", "sorties")
eduschool::produire("fractions_addition", "revision", "sorties")
eduschool::produire("fractions_addition", "quiz", "sorties")
eduschool::produire("pythagore", "decouverte", "sorties")
eduschool::produire("pythagore", "synthese", "sorties")
eduschool::produire("pythagore", "revision", "sorties")
eduschool::produire("pythagore", "quiz", "sorties")
```

Les questions ouvertes n'ont pas de propositions ; les distracteurs calculés
sont évalués avec la même instance de paramètres que la bonne réponse.
Les quiz sont pour l'instant des documents corrigés, non des formulaires
interactifs. Les expressions JSON sont du code R/Ryacas **local de confiance**,
jamais des contributions tierces non contrôlées.

Aucun test automatisé nouveau : validation visuelle et mathématique d'abord.
