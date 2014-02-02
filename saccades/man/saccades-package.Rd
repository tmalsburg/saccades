\name{saccades-package}
\alias{saccades-package}
\alias{saccades}
\docType{package}
\title{ Detection of Saccades and Fixations in Raw Eye Tracking Data }
\description{
  The main contribution of this package is a function for detecting
  fixations in raw eye tracking data.
}
\details{
\tabular{ll}{
Package: \tab saccades\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-02-02\cr
License: \tab GPL v2\cr
LazyLoad: \tab yes\cr
}
-- An overview of how to use the package, including the most important --
-- functions --
}
\author{Titus von der Malsburg <malsburg@posteo.de>}
\references{ Ralf Engbert, Reinhold Kliegl: Microsaccades uncover the
orientation of covert attention, Vision Research, 2003.

Titus von der Malsburg, Choice of Saccade detection algorithm has a considerable
impact on eyetracking measures, in Proceedings of the European Conference on
Eye Movements, 2009, Southampton.}
\keyword{ package }
\seealso{
  \code{\link{detect_fixations}},
  \code{\link[em]{em}},
}
\examples{
data(eyemovements.raw)

# Detect fixations:
samples <- eyemovements.raw$samples
fixations <- detect.fixations(samples)

}
