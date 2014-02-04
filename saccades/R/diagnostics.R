
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
#' samples and fixations.  Red dots represent the x-coordinate and
#' orange dots the y-coordinate.  The gray vertical lines indicate the
#' on- and offsets of saccades and horizontal lines the coordinates of
#' the fixations. Instructions for navigating the plot are displayed
#' on the console.
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

#' Calculates some summary statistics for a set of fixations.
#'
#' @param fixations a data frame containing the fixations that were
#' detected in the samples.
#' @param silent logical.  If true, no statistics are printed.
#' @section Details: Calculates the number of trials, the average
#' duration of trials, the average number of fixations in trials, the
#' average duration of the fixations, the average spatial dispersion
#' in the fixations, and the average peak velocity that occurred
#' during fixations.  Where appropriate standard deviations are given
#' as well.
#' @return A named list containing the statistics.
#' @export
#' @examples
#' data(eyemovements.raw)
#' samples <- eyemovements.raw$samples
#' fixations <- detect.fixations(samples)
#' calculate.summary(fixations)
calculate.summary <- function(fixations, silent=F) {
  
  message.orig <- message
  message <- function(...) if(!silent) message.orig(...)
  
  f <- function(x) format(x, digits=2)
  r <- function(x) round(x, digits=2)

  stats <- list()

  stats$trials.with.data <- length(unique(fixations$trial))
  message("Number of trials:\t\t", stats$trials.with.data)

  s <- tapply(fixations$start, fixations$trial, min)
  e <- tapply(fixations$end, fixations$trial, max)
  tdur <- e - s
  stats$mean.trial.duration <- r(mean(tdur))
  stats$sd.trial.duration <- r(sd(tdur))
  message("Duration of trials:\t\t", stats$mean.trial.duration,
          "\t(sd: ", stats$sd.trial.duration, ")")
    
  n <- tapply(fixations$start, fixations$trial, length)
  stats$mean.fixations.per.trial <- r(mean(n))
  stats$sd.fixations.per.trial <- r(sd(n))
  message("No. of fixations per trial:\t", stats$mean.fixations.per.trial,
          "\t(sd: ", stats$sd.fixations.per.trial, ")")

  stats$mean.fixation.dur <- r(mean(fixations$dur))
  stats$sd.fixation.dur <- r(sd(fixations$dur))
  message("Duration of fixations:\t\t",
          stats$mean.fixation.dur,
          "\t(sd: ", stats$sd.fixation.dur, ")")

  stats$mean.dispersion.x <- r(mean(fixations$sd.x, na.rm=T))
  stats$mean.dispersion.y <- r(mean(fixations$sd.y, na.rm=T))
  stats$sd.dispersion.x <- r(sd(fixations$sd.x, na.rm=T))
  stats$sd.dispersion.y <- r(sd(fixations$sd.y, na.rm=T))
  message("Dispersion horizontal:\t\t",
          stats$mean.dispersion.x,
          "\t(sd: ", stats$sd.dispersion.x, ")")
  message("Dispersion vertical:\t\t",
          stats$mean.dispersion.y,
          "\t(sd: ", stats$sd.dispersion.y, ")")
          
  stats$mean.peak.vx <- r(mean(fixations$peak.vx, na.rm=T))
  stats$mean.peak.vy <- r(mean(fixations$peak.vy, na.rm=T))
  stats$sd.peak.vx <- r(sd(fixations$peak.vx, na.rm=T))
  stats$sd.peak.vy <- r(sd(fixations$peak.vy, na.rm=T))
  message("Peak velocity horizontal:\t",
          stats$mean.peak.vx,
          "\t(sd: ", stats$sd.peak.vx, ")")
  message("Peak velocity vertical:\t\t",
          stats$mean.peak.vy,
          "\t(sd: ", stats$sd.peak.vy, ")")

  stats

}

zip <- function(...) {
  x <- cbind(...)
  t(x)[1:length(x)]
}
