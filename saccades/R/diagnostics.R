
#' Shows the raw samples and the detected fixations in an interactive
#' plot.  This plot can be used to screen the data and to diagnose
#' problems with the fixation detection.
#'
#' @title Interactive diagnostic plot of samples and fixations
#' @param samples a data frame containing the raw samples as recorded
#' by the eyetracker.  This data frame has four columns:
#' \describe{
#'  \item{time:}{the time at which the sample was recorded}
#'  \item{trial:}{the trial to which the sample belongs}
#'  \item{x:}{the x-coordinate of the sample}
#'  \item{y:}{the y-coordinate of the sample}
#' }
#' Samples have to be listed in chronological order.  The velocity
#' calculations assume that the sampling frequency is constant.
#' @param fixations a data frame containing the fixations that were
#' detected in the samples.
#' @section Details: The function will open an interactive plot showing the
#' samples and fixations.  Instructions for navigating the plot are
#' displayed on the console.
#' @return A recording of the final plot.  Can be re-plotted using
#' \code{replayPlot()}.
#' @export
#' @examples
#' \dontrun{
#' data(eyemovements.raw)
#' samples <- eyemovements.raw$samples
#' fixations <- detect.fixations(samples)
#' diagnostic.plot(samples, fixations)
#' }
diagnostic.plot <- function(samples, fixations) {

  f <- fixations
  n <- nrow(f)

  maxxy <- max(f[1:20,]$x, f[1:20,]$y)
  minxy <- min(f[1:20,]$x, f[1:20,]$y)
  gmaxxy <- max(samples$x, samples$y)
  gminxy <- min(samples$x, samples$y)
  
  X11(type="Xlib")
  par(mar=c(2,2,0,0))
  with(samples, plot(time, x, pch=20, cex=0.3, col="red",
                     ylim=c(minxy, maxxy),
                     xlim=c(f$start[1], f$start[20])))
  with(samples, points(time, y, pch=20, cex=0.3, col="orange"))
  with(f, lines(zip(start, end, NA), rep(x,each=3)))
  with(f, lines(zip(start, end, NA), rep(y,each=3)))
  with(f, lines(zip(start, start, NA), rep(c(gminxy,gmaxxy,NA), n), col="lightgrey"))
  with(f, lines(zip(end, end, NA), rep(c(gminxy,gmaxxy,NA), n), col="lightgrey"))

  zm()
  
}

zip <- function(...) {
  x <- cbind(...)
  t(x)[1:length(x)]
}
