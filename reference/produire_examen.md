# Produire un examen redige en PDF

Assemble l'en-tete, les questions et les ressources vectorielles d'un
objet produit par \[rediger_examen()\]. Le sujet et le corrige utilisent
le meme objet intermediaire afin de garantir leur coherence.

## Usage

``` r
produire_examen(examen, fichier = NULL, corrige = FALSE, ouvrir = FALSE)
```

## Arguments

- examen:

  Objet produit par \[rediger_examen()\].

- fichier:

  Chemin de sortie. Si \`NULL\`, un nom est construit automatiquement.

- corrige:

  Inclure les reponses et corrections.

- ouvrir:

  Ouvrir le PDF apres creation.

## Value

Invisiblement, le chemin absolu du PDF produit.
