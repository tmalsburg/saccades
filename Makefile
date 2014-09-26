build: saccades_0.1.tar.gz

documentation: saccades/R/saccade_recognition.R
	cd saccades; R -e 'library(roxygen2); roxygenize()'

saccades_0.1.tar.gz: saccades/R/saccade_recognition.R saccades/R/diagnostics.R saccades/DESCRIPTION saccades/NAMESPACE saccades/data/eyemovements.raw.rda saccades/data/raw_eyemovements.rda saccades/data/eyemovements.fix.rda documentation
	R CMD build saccades

check: saccades.Rcheck/00check.log

saccades.Rcheck/00check.log: saccades_0.1.tar.gz
	R CMD check saccades_0.1.tar.gz

install: check
	R CMD INSTALL saccades_0.1.tar.gz
