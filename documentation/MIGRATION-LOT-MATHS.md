# Migration de contenus — premier lot mathématique

Ce lot reprend et adapte des contenus de la v1 **sans reprendre son moteur** :

- `inst/revision/2gt-identites-remarquables.Rmd` et `inst/exercices/textes_identites.md` : trois identités, développement, factorisation, rôle du double produit et identité valable pour toute valeur admise.
- `inst/fiches-essentielles/raisonnement-math-ensemble.md` et `inst/revision/2gt-ensembles.Rmd` : appartenance, inclusion, ensemble des parties, intersection et réunion.
- `inst/exercices/textes_geometrie_6e.md` et `inst/revision/2gt-geometrie.Rmd` : angles, médiatrice, propriétés et déductions.

Trois notions directement utilisables sont créées : `identites_remarquables`, `ensembles` et `geometrie_deductive`. Chacune contient sept QCM et les fiches découverte, synthèse et révision. La géométrie réutilise pour deux questions **la figure à main levée du pilote Pythagore**, avec codage explicite. Les figures propres aux quadrilatères ne sont pas encore créées : les questions correspondantes s'appuient pour l'instant sur des hypothèses écrites, et non sur un dessin supposé exact.

**Périmètre :** premier lot de migration exploitable, non migration exhaustive des sources historiques. Les questions ont été reformulées pour obtenir une réponse unique et une correction automatique ; elles ne sont pas présentées comme des transcriptions littérales. Aucune abstraction ni dépendance nouvelle.

**Validation locale :** JSON et unicité textuelle des propositions ; R et rendu HTML/PDF à vérifier dans le dépôt de l'utilisateur.
