# Migration depuis V0.9.8

V0.10.0 est la première version structurée comme package.

Principaux changements : les CSV/Markdown passent sous `inst/`; les fichiers R sont directement sous `R/`; les consultations ne nécessitent plus `tables` ou `con`; les chemins sont résolus par `eduschool_path()`; `devtools::load_all()` devient le mode de développement normal.

Le fichier racine `launcher.R` reste comme compatibilité temporaire pour charger l'arbre source sans changer immédiatement les habitudes. Il est exclu du package construit.
