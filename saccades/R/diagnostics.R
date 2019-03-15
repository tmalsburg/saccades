
#' Shows the raw samples and the detected fixations in an interactive
#' plot.  This plot can be used to screen the data and to diagnose
#' problems with the fixation detection.
#'
#' @title Interactive Diagnostic Plot of Samples and Fixations
#' @param samples a data frame containing the raw samples as recorded
#' by the eye-tracker.  This data frame has to have the following
#' columns:
#' \describe{
#'  \item{time:}{the time at which the sample was recorded}
#'  \item{x:}{the x-coordinate of the sample}
#'  \item{y:}{the y-coordinate of the sample}
#' }
#' Samples have to be listed in chronological order.  The velocity
#' calculations assume that the sampling frequency is constant.
#' @param fixations a data frame containing the fixations that were
#' detected in the samples.  This data frame has to have the following
#' columns:
#' \describe{
#'  \item{start:}{the time at which the fixations started}
#'  \item{end:}{the time at which the fixation ended}
#'  \item{x:}{the x-coordinate of the fixation}
#'  \item{y:}{the y-coordinate of the fixation}
#' }
#' @param start.event the number of the event at which the displayed
#'   segment starts.  Could be a fixation, blink, or artifact.
#' @param start.time the time at which the displayed segment
#'   starts.  Alternative to \code{start.event}.
#' @param duration the duration of the displayed segment.
#' @param interactive indicates whether an interactive plot will be
#'   displayed or an ordinary plot.
#' @section Details: The function will open an interactive plot showing the
#' samples and fixations.  Red dots represent the x-coordinate and
#' orange dots the y-coordinate.  The gray vertical lines indicate the
#' on- and offsets of saccades and horizontal lines the coordinates of
#' the fixations. Instructions for navigating the plot are displayed
#' on the console.
#' @return A recording of the final plot.  Can be re-plotted using
#' \code{\link[grDevices]{replayPlot}}.
#' @author Titus von der Malsburg \email{malsburg@@posteo.de}
#' @seealso \code{\link{detect.fixations}},
#' \code{\link{calculate.summary}}
#' @export
#' @examples
#' \dontrun{
#' data(samples)
#' fixations <- detect.fixations(samples)
#' diagnostic.plot(samples, fixations)
#' }
diagnostic.plot <- function(samples, fixations, start.event=1, start.time=NULL, duration=2000, interactive=TRUE, ...) {

  stopifnot(start.event >= 1)
  stopifnot(start.event <= nrow(fixations))
  stopifnot(start.time  >= min(samples$time))
  stopifnot(start.time  <= max(samples$time))

  if (is.null(start.time))
    start.time <- fixations$start[start.event]

  if (interactive) grDevices::dev.new()

  graphics::par(mar=c(2,2,0,0))
  if ("ylim" %in% list(...))
    with(samples,   plot(time, x, pch=20, cex=0.3, col="red",
                         ylim=c(min(fixations$x, fixations$y),
                                max(fixations$x, fixations$y)),
                         xlim=c(start.time, start.time+duration)))
  else
    with(samples,   plot(time, x, pch=20, cex=0.3, col="red",
                         xlim=c(start.time, start.time+duration), ...))
  with(samples,   points(time, y, pch=20, cex=0.3, col="orange"))
  with(fixations, lines(zip(start, end, NA), rep(x, each=3)))
  with(fixations, lines(zip(start, end, NA), rep(y, each=3)))
  with(fixations, abline(v=c(start, end), col="lightgrey"))
  
  if (interactive) {
    p <- grDevices::recordPlot()
    grDevices::dev.off()
    zoom::zm(rp=p)
  }

}

# Pairs plot using fixation x- and y-dispersion and duration and color
# for detected event type (black=fixation, red=blink, blue=too short,
# green=too dispersed).
diagnostic.plot.event.types <- function(fixations) {
  graphics::pairs( ~ log10(mad.x+0.001) + log10(mad.y+0.001) + log10(dur),
        data=fixations,
        col=fixations$event)
}

#' Calculates summary statistics about the trials and fixations in the
#' given data frame.
#'
#' @title Calculate Summary Statistics for a Set of Fixations.
#'
#' @param fixations a data frame containing the fixations that were
#' detected in the samples.  See
#' \code{\link[saccades]{detect.fixations}} for details about the
#' format.
#' @section Details: Calculates the number of trials, the average
#' duration of trials, the average number of fixations in trials, the
#' average duration of the fixations, the average spatial dispersion
#' in the fixations, and the average peak velocity that occurred
#' during fixations.  Where appropriate standard deviations are given
#' as well.  Use round to obtain a more readable version of
#' the resulting data frame.
#' @return A data frame containing the statistics.
#' @author Titus von der Malsburg \email{malsburg@@posteo.de}
#' @seealso \code{\link{diagnostic.plot}},
#' \code{\link{detect.fixations}}
#' @export
#' @examples
#' data(fixations)
#' stats <- calculate.summary(fixations)
#' round(stats, digits=2)
calculate.summary <- function(fixations) {
  
  stats <- data.frame(mean=double(8), sd=double(8), row.names=c("Number of trials", "Duration of trials", "No. of fixations per trial", "Duration of fixations", "Dispersion horizontal", "Dispersion vertical", "Peak velocity horizontal", "Peak velocity vertical"))

  stats["Number of trials",] <- c(length(unique(fixations$trial)), NA)

  s <- tapply(fixations$start, fixations$trial, min)
  e <- tapply(fixations$end, fixations$trial, max)
  tdur <- e - s
  stats["Duration of trials",] <- c(mean(tdur), stats::sd(tdur))
    
  n <- tapply(fixations$start, fixations$trial, length)
  stats["No. of fixations per trial",] <- c(mean(n), stats::sd(n))
  stats["Duration of fixations",] <- c(mean(fixations$dur), stats::sd(fixations$dur))

  stats["Dispersion horizontal",] <- c(mean(fixations$mad.x, na.rm=TRUE), stats::sd(fixations$mad.x, na.rm=TRUE))
  stats["Dispersion vertical",]   <- c(mean(fixations$mad.y, na.rm=TRUE), stats::sd(fixations$mad.y, na.rm=TRUE))
          
  stats["Peak velocity horizontal",] <- c(mean(fixations$peak.vx, na.rm=T), stats::sd(fixations$peak.vx, na.rm=T))
  stats["Peak velocity vertical",]   <- c(mean(fixations$peak.vy, na.rm=T), stats::sd(fixations$peak.vy, na.rm=T))

  stats

}

zip <- function(...) {
  x <- cbind(...)
  t(x)[1:length(x)]
}
