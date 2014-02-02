
# This function takes a data frame containing raw eyetracking samples
# and returns a data frame containing fixations.
detect.fixations <- function(samples, vel.threshold=10, smooth=T) {

  # Discard unnecessary columns:
  samples <- samples[c("x", "y", "trial", "time")]

  if (smooth) {
    # Keep and reuse original first and last coordinates as they can't
    # be smoothed:
    x <- samples$x[c(1,nrow(samples))]
    y <- samples$y[c(1,nrow(samples))]
    kernel.size <- smooth*2+1
    kernel <- rep(1/kernel.size, kernel.size)
    samples$x <- filter(samples$x, kernel)
    samples$y <- filter(samples$y, kernel)
    # Plug in the original values:
    samples$x[c(1,nrow(samples))] <- x
    samples$y[c(1,nrow(samples))] <- y
  }
    
  samples <- detect.saccades(samples, vel.threshold)
  
  if (all(!samples$saccade))
    stop("No saccades were detected.  Something went wrong.")
  
  fixations <- aggregate.fixations(samples)
  
  fixations
  
}

# Package-internal functions:

# This function takes a data frame of the samples and aggregates the
# samples into fixations.  This requires that the samples have been
# annotated using the function detect.saccades.
aggregate.fixations <- function(samples) {
    
  # In saccade.events a 1 marks the start of a saccade and a -1 the
  # end of a saccade.
    
  saccade.events <- sign(c(0, diff(samples$saccade)))

  trial.numeric  <- as.integer(factor(samples$trial))
  trial.events   <- sign(c(0, diff(trial.numeric)))

  # New fixations start either when a saccade ends or when a trial
  # ends:
  samples$fixation.id <- cumsum(saccade.events==-1|trial.events==1)
  
  # Discard samples that occurred during saccades:
  samples <- samples[!samples$saccade,,drop=F]
  
  fixations <- with(samples, data.frame(
    trial   = tapply(trial, fixation.id, function(x) x[1]),
    start   = tapply(time,  fixation.id, min),
    end     = tapply(time,  fixation.id, max),
    x       = tapply(x,     fixation.id, mean),
    y       = tapply(y,     fixation.id, mean),
    sd.x    = tapply(x,     fixation.id, sd),
    sd.y    = tapply(y,     fixation.id, sd),
    peak.vx = tapply(vx,    fixation.id, max),
    peak.vy = tapply(vy,    fixation.id, max),
    stringsAsFactors=F))

  fixations$dur <- fixations$end - fixations$start
  
  fixations
  
}


# Implementation of the Engbert & Kliegl algorithm for the
# detection of saccades.  This function takes a data frame of the
# samples and adds three columns:
#
# - A column named "saccade" which contains booleans indicating
#   whether the sample occurred during a saccade or not.
# - Columns named vx and vy which indicate the horizontal and vertical
#   speed.
detect.saccades <- function(samples, vel.threshold) {

  vx <- filter(samples$x, -1:1/2)
  vy <- filter(samples$y, -1:1/2)

  # We don't want NAs, as they make our life difficult later
  # on.  Therefore, fill in missing values:
  vx[1] <- vx[2]
  vy[1] <- vy[2]
  vx[length(vx)] <- vx[length(vx)-1]
  vy[length(vy)] <- vy[length(vy)-1]

  # NOTE: SK takes the sqrt of the following values whereas E&K
  # don't.  Seems to be a mistake in the paper.
  
  msdx <- sqrt(median(vx**2, na.rm=T) - median(vx, na.rm=T)**2)
  msdy <- sqrt(median(vy**2, na.rm=T) - median(vy, na.rm=T)**2)

  radiusx <- msdx * vel.threshold
  radiusy <- msdy * vel.threshold

  sacc <- ((vx/radiusx)**2 + (vy/radiusy)**2) > 1
  samples$saccade <- ifelse(is.na(sacc), F, sacc)
  samples$vx <- vx
  samples$vy <- vy

  samples

}

