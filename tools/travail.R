# eduschool

library("eduschool")

eduschool()

# CHEATSHEET 
produire_cheatsheet()

# NOTIONS / MISC
notions() |> 
    tibble::as_tibble() |> 
    print(n = 150)

table_multiplication()
table_multiplication(max = 12, format = "pdf")
series()
voies()
maths_programmes()
maths_programmes("3E")
maths_parcours()
maths_parcours("parcours.png", ouvrir = TRUE)
maths_parcours("parcours.pdf", ouvrir = TRUE)

# taf = suivi_du_taf_restant()

# # FORMES DES QUESTIONS & VOCABULAIRE
# formes_questions()  |> 
#     tibble::as_tibble() |> 
#     print(n = 50)

# vocabulaire()

# GRAPHIQUES
graphique("sphere", pas = 24, azimut = 15, centre = TRUE, segment = "rayon")
graphique("sphere", pas = 24, azimut = 15, inclinaison = -65, centre = TRUE, segment = "rayon")
graphique("demi_sphere", segment = "rayon")
graphique("ensembles_nombres")
graphique("identites_remarquables", a = 3, b = 2)
graphique("tableau_conversion", type = 6)
graphique("droite_fractions", denominateur = 7,
          points = "1,3,5,6", etiquettes = "A,B,C,D")

# LOGIGRAMME PRODUIRE
source("~/repogit/eduschool/tools/logigramme_produire.R")

logigramme_produire(
  noeuds = "tools/workflow-produire-noeuds.csv",
  liens = "tools/workflow-produire-liens.csv"
)

# DIAGRAMMES PROGRAMMES
# diagramme_programme("CM1")
# diagramme_programme("CM2")
diagramme_programme("6E")
diagramme_programme("5E")
diagramme_programme("4E")
diagramme_programme("3E")

diagramme_programme("CM1", detail = "complet")
diagramme_programme("CM2", detail = "complet")

diagramme_programme("6E", detail = "complet")
diagramme_programme("5E", detail = "complet")
diagramme_programme("4E", detail = "complet")
diagramme_programme("3E", detail = "complet")

diagramme_programme("2GT", detail = "complet")
diagramme_programme("1G", detail = "complet")
diagramme_programme("TG", detail = "complet")

##################################################
#                                                #
#                                                #
#                  ENTRAINEMENT                  #
#                                                #
#                                                #
##################################################

# FAMILLE NOMBRES ENTIERS ET DECIMAUX
produire("nombres_entiers_et_decimaux", "quiz", n = 15)
produire("nombres_entiers_et_decimaux", "synthese", format = "pdf")

produire("decimaux_arrondis", "tous")
produire("decimaux_comparaison", "tous")
produire("decimaux_decomposition", "tous")
produire("decimaux_droite_graduee", "tous")
produire("decimaux_encadrement", "tous")
produire("decimaux_fractions", "tous")

# GEOMETRIE DEDUCTIVE
produire("geometrie_deductive", "tous", n = 7)

# FAMILLE GRANDEURS ET MESURES
produire("grandeurs_mesures_conversions", "tous", n = 15)
produire("grandeurs_mesures_conversions", "synthese", format = "pdf")

# NOMBRES RELATIFS
produire(notion = "nombres_relatifs", support = "tous", format = "html")
produire(notion = "nombres_relatifs", support = "synthese", format = "pdf")

# FAMILLE PUISSANCES
produire("calcul_avec_puissances")
produire("calcul_avec_puissances", support = "synthese")
produire("calcul_avec_puissances", niveau = "5E")
produire("calcul_avec_puissances")

# FAMILLE ENSEMBLES ET INTERVALLES
produire("ensembles_et_intervalles")

produire("ensembles_nombres", support = "decouverte")
produire("ensembles_nombres", support = "synthese", format = "pdf")
produire("ensembles_nombres", support = "quiz")
produire("ensembles_nombres", support = "quiz", format = "pdf")

produire("operations_ensembles", "decouverte")
produire("operations_ensembles", "synthese")
produire("operations_ensembles", "quiz")

produire("intervalles_reels", "decouverte")
produire("intervalles_reels", "synthese")
produire("intervalles_reels", "quiz")

# FAMILLE EQUATIONS

produire("equation_produit_nul", "decouverte")
produire("equation_produit_nul", "synthese")
produire("equation_produit_nul", "quiz", n = 10)

produire("equation_inconnue_deux_membres", "decouverte")
produire("equation_inconnue_deux_membres", "synthese")
produire("equation_inconnue_deux_membres", "quiz", n = 10)

produire("equations", "decouverte", format = "pdf")
produire("equations", "synthese", format = "pdf")
produire("equations", "quiz", n = 10)

# FAMILLE CALCUL LITTERAL 
# (COMPREND LES FAMILLE EQUATION, IDENTITES REMARQUABLES)

produire("factorisation_facteur_commun", "decouverte")
produire("factorisation_facteur_commun", "synthese")
produire("factorisation_facteur_commun", "synthese", format = "pdf")
produire("factorisation_facteur_commun", "quiz", n = 10)

produire("developpement_double_distributivite", "decouverte")
produire("developpement_double_distributivite", "synthese")
produire("developpement_double_distributivite", "synthese", format = "pdf")
produire("developpement_double_distributivite", "quiz", n = 10)

produire("inequation_premier_degre", "decouverte", format = "pdf")
produire("inequation_premier_degre", "synthese", format = "pdf")

produire("inequation_premier_degre", "decouverte", format = "html")
produire("inequation_premier_degre", "synthese", format = "html")
produire("inequation_premier_degre", "quiz", n = 10)

produire("identites_remarquables", "decouverte")
produire("identites_remarquables", "synthese")
produire("identites_remarquables", "synthese", format = "pdf")
produire("identites_remarquables", "quiz", n = 10)

produire("raisonnement_analyse_synthese", "decouverte")
produire("raisonnement_analyse_synthese", "synthese")
produire("raisonnement_analyse_synthese", "synthese", format = "pdf")
produire("raisonnement_analyse_synthese", "quiz", n = 10)

# FAMILLE PROBA
produire("probabilites", "decouverte")
produire("probabilites", "synthese")
produire("probabilites", "synthese", format = "pdf")
produire("probabilites", "quiz", n = 10)

# FAMILLE STATISTIQUES
produire("statistiques", "decouverte")
produire("probabilites", "synthese")
produire("probabilites", "synthese", format = "pdf")
produire("probabilites", "quiz", n = 10)

# FAMILLE PROPORTIONNALITE ET FONCTIONS
produire("proportionnalite_et_fonctions", "decouverte")
produire("proportionnalite_et_fonctions", "synthese")
produire("proportionnalite_et_fonctions", "synthese", format = "pdf")
produire("proportionnalite_et_fonctions", "quiz", n = 10)

# FAMILLE FRACTIONS
produire("fractions", "decouverte")
produire("fractions", "synthese")
produire("fractions", "synthese", format = "pdf")
produire("fractions_addition", "quiz", n = 20)
produire("fractions_droite", "quiz", n = 20)
produire("fractions", "quiz", n = 20)

# FAMILLE GEOMETRIE
produire("triangles", "decouverte")
produire("triangles", "synthese")
produire("triangles", "synthese", format = "pdf")
produire("triangles", "quiz", n = 5)
produire("geometrie", "decouverte")

# FAMILLE PYTHAGORE
produire("pythagore", "decouverte")
produire("pythagore", "synthese")
produire("pythagore", "synthese", format = "pdf")
produire("pythagore", "quiz", n = 5)

# MODELES
produire("cercle", "decouverte", format = "html")
produire("cercle", "synthese", format = "html")
produire("droites", "decouverte", format = "html")
produire("parallelogrammes", "synthese", format = "html")

# FAMILLE GRANDEURS MESURES & CONVERSION
produire("perimetres", "decouverte")
produire("perimetres", "synthese")
produire("perimetres", "synthese", format = "pdf")
produire("perimetres", "quiz", n = 20)

produire("aires", "decouverte")
produire("aires", "synthese")
produire("aires", "synthese", format = "pdf")
produire("aires", "quiz", n = 20)

produire("cercle", "decouverte")
produire("cercle", "synthese")
produire("cercle", "synthese", format = "pdf")
produire("cercle", "quiz", n = 20)

produire("parallelogrammes", "decouverte")
produire("parallelogrammes", "synthese")
produire("parallelogrammes", "synthese", format = "pdf")
produire("parallelogrammes", "quiz", n = 15)

produire("angles", "decouverte")
produire("angles", "synthese")
produire("angles", "synthese", format = "pdf")
produire("angles", "quiz", n = 15)
produire("angles", "quiz", niveau = "5E")

produire("aires", "decouverte")
produire("aires", "synthese")
produire("aires", "synthese", format = "pdf")
produire("aires", "quiz", n = 15)

produire("perimetres", "decouverte")
produire("perimetres", "synthese")
produire("perimetres", "synthese", format = "pdf")
produire("perimetres", "quiz", n = 15)

produire("volumes", "decouverte")
produire("volumes", "synthese")
produire("volumes", "synthese", format = "pdf")
produire("volumes", "quiz", n = 15)

produire("geometrie_espace", "decouverte", niveau = "5E")
produire("geometrie_espace", "synthese", niveau = "5E")
produire("geometrie_espace", "synthese", format = "pdf")
produire("geometrie_espace", "quiz", n = 15)

produire("translations_vecteurs", "decouverte")
produire("translations_vecteurs", "synthese")
produire("translations_vecteurs", "synthese", format = "pdf")
produire("translations_vecteurs", "quiz", n = 15)

produire("algorithmique_programmation", "decouverte")
produire("algorithmique_programmation", "synthese")
produire("algorithmique_programmation", "synthese", format = "pdf")
produire("algorithmique_programmation", "quiz", n = 15)

produire("boule_sphere", "decouverte")
produire("boule_sphere", "synthese")

######################################################################
# BREVET
######################################################################

# GEOMETRIE
produire_brevet("GEO-A-001")
produire_brevet("GEO-B-001")
produire_brevet("GEO-C-001")
produire_brevet("GEO-D-001")
produire_brevet("GEO-D-002")
produire_brevet("GEO-D-003")
# STAT
produire_brevet("STAT-A-001")
produire_brevet("STAT-B-001")
# PROBA
produire_brevet("PROBA-A-001")
produire_brevet("PROBA-A-002")
produire_brevet("PROBA-A-003")
produire_brevet("PROBA-B-001")
produire_brevet("PROBA-C-001")
produire_brevet("PROBA-D-001")
# ALGO
source("inst/graphiques/aide_scratch.R")
produire_brevet("ALGO-A-001")
produire_brevet("ALGO-A-002")
produire_brevet("ALGO-A-003")
produire_brevet("ALGO-B-001")
# FONC
produire_brevet("FONC-A-001")
produire_brevet("FONC-A-002")
produire_brevet("FONC-A-003")
produire_brevet("FONC-B-001")
produire_brevet("FONC-B-002")
# PROP
produire_brevet("PROP-A-001")
produire_brevet("PROP-A-002")
produire_brevet("PROP-B-001")
# TRIGO
produire_brevet("TRIGO-A-001")
produire_brevet("TRIGO-A-002")
produire_brevet("TRIGO-B-002")
produire_brevet("TRIGO-C-001")
produire_brevet("TRIGO-C-003")
# EQ
produire_brevet("EQ-A-003")
produire_brevet("EQ-B-002")
produire_brevet("EQ-C-001")
# MIX
produire_brevet("MIX-A-001")
produire_brevet("MIX-B-001")
produire_brevet("MIX-C-001")
produire_brevet("MIX-D-001")


source("inst/brevet/controles/audit.R")
resultats = rapport_audit_brevet()
resultats |> dplyr::filter(statut != "OK")

produire_brevet(c("GEO-A-001", "STAT-B-001",
                  "ALGO-A-003", "PROP-A-001"),
                format = "pdf")




