# API publique

L'API volontairement courte de V0.10.0 est organisée autour de :

- référentiels : `niveaux()`, `voies()`, `series()`, `disciplines()`, `enseignements()` ;
- programmes : `programmes()`, `capacites()` ;
- documentation : `notions()`, `chercher_notions()`, `notions_capacite()`, `prerequis_capacite()`, `obtenir_rappel()` ;
- exercices : `generer_exercice()`, `generer_fiche()`, `produire_rapport_exercices()` ;
- données avancées : `ouvrir_base()` ;
- ressources : `eduschool_path()`.

Une fonction non exportée peut évoluer sans garantie de compatibilité.
