\docType{package}
\name{saccades}
\alias{saccades}
\alias{saccades-package}
\title{Detection of saccades and fixations in raw eyetracking data}
\description{
Detection of saccades and fixations in raw eyetracking
data.
}
\details{
The main contribution of this package is a function for
detecting fixations in a stream of eye positions.  The
detection is done using an algorithm for saccade detection
proposed by Ralf Engbert and Reinhold Kliegl (see reference
below).  Anything that happens between two saccades is
considered to be a fixation.  This software is therefore
not suited for data sets with smooth-pursuit eye movements.}
\author{
Titus von der Malsburg \email{malsburg@posteo.de}
}
\references{
Ralf Engbert, Reinhold Kliegl: Microsaccades uncover the
orientation of covert attention, Vision Research, 2003.

Titus von der Malsburg, Choice of saccade detection
algorithm has a considerable impact on eye tracking
measures, in Proceedings of the European Conference on Eye
Movements, 2009, Southampton.
}
\seealso{
\code{\link{detect.fixations}},
\code{\link{diagnostic.plot}},
\code{\link{calculate.summary}}
}
\keyword{eye movements}
\keyword{eyetracking}

