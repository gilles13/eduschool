# Architecture des données

Les données distribuées sont conservées sous `inst/` et retrouvées avec
[`eduschool_path()`](https://gilles13.github.io/eduschool/reference/eduschool_path.md).
Les consultations simples utilisent directement les CSV; DuckDB reste
disponible pour les jointures et analyses relationnelles.

Le flux logique est : programme officiel → capacité → notion → prérequis
→ rappel → modèle d’exercice → exercice → rapport.
