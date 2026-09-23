# Exercices de mathématiques

Les banques d’exercices eduschool sont décrites avec des fichiers Markdown
simples. Le Markdown formule ; R calcule et vérifie.

Contrat minimal :

```markdown
# NOTION : multiplication

## TYPE : libre

### QUESTION 1

Combien font %s multiplié par %s ?
```

Le `TYPE` décrit la mécanique de réponse du futur parser, pas le thème
pédagogique de la question :

- `booleen` : exactement deux propositions ;
- `3_reponses` : exactement trois propositions ;
- `libre` : un nombre variable de propositions ; la règle précise du parser sera définie plus tard ;
- `mot_a_trou` : jeu de vocabulaire. La première et la dernière lettre restent visibles et chaque caractère caché est représenté par un `_` lisible et espacé. La longueur est donc un indice ;
- `mot_masque` : jeu de vocabulaire. La première et la dernière lettre restent visibles, mais le milieu est remplacé par une seule barre de longueur visuelle fixe. La barre n’est pas proportionnelle au nombre de caractères cachés et le joueur doit en être averti.

`mot_a_trou` et `mot_masque` servent à retrouver des mots mathématiques
(`rayon`, `périmètre`, `distributivité`, etc.). Un nombre manquant, une fraction
à compléter ou une suite à poursuivre n’est donc pas un `mot_a_trou`.

Une banque n’invente pas un autre type. Lorsqu’une formulation historique ne
peut pas être classée proprement, elle reste dans le carton de migration pour
le polissage final au lieu de compliquer le contrat.

Le Markdown ne contient ni réponse ni vérité calculée. R produit les valeurs,
calcule la réponse et la vérifie. Pour les jeux de vocabulaire, R fournit le mot
et appliquera la règle de masquage ; le Markdown ne stocke pas le mot masqué.

Les fichiers `inst/exercices/textes_*.md` restent provisoirement la source du
moteur historique pendant la transition. Ils sont un carton de déménagement,
pas le format cible. Ils pourront disparaître lorsque les générateurs R liront
directement ces banques.

## Questions calculables

Lorsqu'une formulation peut etre instanciee et verifiee par R, elle porte trois blocs locaux :

```markdown
#### PARAMETRES

a = sample(2:12, 1)
b = sample(2:12, 1)

#### CALCUL

a * b

#### MOTEUR

R
```

`PARAMETRES` produit les valeurs utilisees par les marqueurs de la formulation, dans leur ordre. `CALCUL` exprime la verite attendue a partir de ces memes valeurs. `MOTEUR` vaut `R` pour un calcul numerique direct ou `Ryacas` lorsqu'une verification symbolique est pertinente.

Une question purement editoriale n'invente pas de calcul pour satisfaire ce format : elle peut rester sans ces blocs tant qu'une verite executable n'a pas ete definie.
