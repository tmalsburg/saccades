build: saccades_0.2-1.tar.gz

documentation: saccades/R/saccade_recognition.R saccades/R/diagnostics.R
	cd saccades; R -e 'library(roxygen2); roxygenize()'

saccades_0.2-1.tar.gz: documentation saccades/R/saccade_recognition.R saccades/R/diagnostics.R saccades/DESCRIPTION saccades/data/samples.rda saccades/data/fixations.rda 
	R CMD build --resave-data saccades

check: saccades.Rcheck/00check.log documentation

saccades.Rcheck/00check.log: saccades_0.2-1.tar.gz
	R CMD check --as-cran saccades_0.2-1.tar.gz

install: check
	sudo R CMD INSTALL saccades_0.2-1.tar.gz
