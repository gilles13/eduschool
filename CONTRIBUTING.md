# Contribuer à eduschool

Merci de vous intéresser à eduschool.

Si vous êtes ici parce que vous avez trouvé une erreur, que vous avez une
meilleure explication, que vous connaissez les mathématiques ou, au contraire,
que vous n'avez absolument rien compris :

vous êtes au bon endroit.

## La règle la plus importante

**Ne pas comprendre est un cas d'utilisation, pas une erreur utilisateur.**

eduschool est notamment développé par un parent qui essaie de comprendre ce
que ses enfants apprennent, puis de l'expliquer sans provoquer de catastrophe
pédagogique.

HELP PLIZ.

## Comment contribuer ?

Il n'est pas nécessaire de savoir programmer en R.

Vous pouvez contribuer si :

- vous connaissez les mathématiques ;
- vous enseignez les mathématiques ;
- vous êtes parent ;
- vous êtes élève ;
- vous savez expliquer quelque chose simplement ;
- vous avez repéré une erreur ;
- vous n'avez rien compris à une explication ;
- vous connaissez R et souhaitez améliorer le code ;
- vous avez une idée d'exercice, de fiche ou de visualisation.

## « Je n'ai rien compris »

C'est une contribution parfaitement valable.

Ouvrez une issue et expliquez ce qui vous pose problème.

**Qu'est-ce que vous n'avez pas compris ?**

N'ayez aucune honte. L'auteur du package n'a probablement pas compris non plus.

## Proposer un exercice

Une proposition devrait idéalement préciser :

- le niveau ou la classe ;
- la notion travaillée ;
- l'objectif pédagogique ;
- l'énoncé ;
- la correction ;
- les éventuelles sources utilisées.

Les données réelles utilisées dans un exercice doivent être accompagnées de
leur provenance.

**« Source : Internet » n'est pas une source. C'est un appel à l'aide.**

## Proposer une modification du code

Les contributions R sont les bienvenues.

Quelques principes :

1. rester simple ;
2. tester le comportement ajouté ;
3. documenter les fonctions publiques ;
4. ne pas introduire une dépendance sans raison ;
5. conserver `R CMD check` parfaitement propre.

La règle qualité du projet est :

**0 error, 0 warning, 0 note.**

Dans eduschool, une NOTE n'est pas une information.
C'est un problème qui n'a pas encore suffisamment insisté.

## À propos des abstractions

**Une nouvelle abstraction n'entre dans eduschool que lorsqu'elle a trouvé
du travail.**

Avant d'ajouter une couche architecturale, demandez-vous si une fonction de
quinze lignes ne ferait pas parfaitement l'affaire.

La création d'un `ContributionProposalFactoryManager` pour gérer quatre types
de contributions sera considérée comme une démonstration particulièrement
convaincante du problème.

## Données et provenance

**Les données sont réelles. L'exercice est fabriqué. Le graphique est joli.
La source est obligatoire.**

Dans eduschool, une donnée dont on ne sait pas d'où elle vient est une donnée
qui n'est pas encore prête à être utilisée.

Les données sensibles ne sont jamais utilisées comme prétexte ludique.
L'humour peut viser eduschool, les maths et nos habitudes de développeurs,
jamais les personnes concernées par les données.

## Avant une pull request

Merci de lancer au minimum :

    devtools::document()
    devtools::test()
    devtools::check()

Le résultat attendu est sans ambiguïté :

    0 errors
    0 warnings
    0 notes

Les décorations de Noël sont très jolies.

Les WARNING rouges dans `R CMD check`, beaucoup moins.

## Enfin

Vous n'avez pas besoin d'être expert pour contribuer.

Si vous savez quelque chose qu'eduschool explique mal, dites-le.

Si vous ne comprenez pas quelque chose qu'eduschool prétend expliquer,
dites-le encore plus fort.

Et si vous comprenez enfin quelque chose grâce à eduschool :

**prévenez-nous. Cela voudra dire que le système fonctionne.**

Le but n'est finalement pas très compliqué :

> **expliquer un truc de maths à quelqu'un qui ne l'avait pas compris.**

Si vous pouvez nous aider à y parvenir, bienvenue.

Si vous êtes justement la personne qui n'a pas compris, bienvenue aussi.

Nous avons besoin des deux.
