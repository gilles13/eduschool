# API publique

L'API active d'eduschool est volontairement petite. Le mini-SI, les banques de
questions et les anciens moteurs restent des ressources internes tant qu'une
fonction publique simple n'en a pas besoin.

## J'arrive

```r
eduschool()
choix()
```

`eduschool()` montre les portes d'entree. `choix()` donne les libelles exacts
utilisables et progresse par `niveau -> theme -> notion`.

## Je decouvre

```r
parcours("6E")
notions(niveau = "6E")
```

`parcours()` et `notions()` lisent le meme coeur relationnel actif. Les anciens
identifiants DOMAINE/THEME/CAPACITE restent de la plomberie interne.

## Je revise

```r
fiches("6E")
```

`fiches()` inventorie les fiches de revision qui existent reellement dans
`inst/revision/`. Elle ne promet pas une fiche absente.

## Je m'exerce

```r
questions(banque = "fractions")
question(banque = "fractions")
quiz(5, banque = "fractions")
```

Les banques Markdown formulent ; R doit calculer et verifier. Tant qu'un
modele contient encore `%d` ou `%s` sans generateur R associe, `question()` et
`quiz()` exposent ce modele tel quel. Ils ne fabriquent ni valeur ni reponse.
C'est une limite visible, pas une fausse fonctionnalite.

## Regle d'evolution

Une nouvelle fonction publique doit rendre un service immediat. Une piece de
`legacy/` ne revient dans le code actif que lorsqu'une fonction actuelle en a
besoin. Git garde l'histoire ; l'API active garde le service.
