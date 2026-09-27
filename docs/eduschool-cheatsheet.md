# eduschool · Cheatsheet

![Logo eduschool math](identite/logo-chouette.png)

# eduschool · Cheatsheet

Quelques commandes pour explorer, comprendre et s'exercer

## Découvrir les questions

Consulter les questions d'une notion ou d'une famille.

    library(eduschool)
    questions("addition_fractions")
    questions("fractions")

## Créer un quiz HTML

Un questionnaire à choix multiples avec correction.

    produire("addition_fractions", "quiz",
            format = "html")

## Fiche découverte

Aborder une notion par plusieurs chemins.

    produire("addition_fractions",
            "decouverte", format = "html")

## Fiche de révision

Créer une fiche imprimable.

    produire("addition_fractions",
            "revision", format = "pdf",
            dossier = "sorties")

## Produire tous les supports

Créer les supports disponibles pour une famille.

    produire("fractions", "tous",
            dossier = "sorties")

## Toujours ouvrir des portes

Une notion peut mener vers une autre, sans obliger à franchir la porte.
Le savoir reste libre, gratuit et ouvert.

## Contribuer

Améliorer une explication, proposer un exercice, corriger une source :
le savoir se partage.

**eduschool** · libre · gratuit · ouvertToujours ouvrir des portes.
