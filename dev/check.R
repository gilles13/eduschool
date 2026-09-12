if (!requireNamespace("devtools", quietly = TRUE)) stop("Installer devtools pour ce script.")

# BiocManager n a pas besoin de valider sa version en ligne pour eduschool.
# Evite un acces recurrent a bioconductor.org pendant les checks locaux.
options(BIOCONDUCTOR_ONLINE_VERSION_DIAGNOSIS = FALSE)

devtools::document()
devtools::test()
devtools::check()
