saccades
========

An R package for saccade and fixation detection in eyetracking data.  It uses the algorithm for saccade detection proposed by Ralf Engbert and Reinhold Kliegl.  Any period occurring between two saccades is considered to be a fixation. 

This software is a re-implementation of a package that I wrote earlier and that we used heavily in our research.  However, I wrote the old package when I was new to R and many things are clumsy and unnecessarily complex.  Hence, the rewrite.

The code in this repository is not for production use as it is under construction and largely untested.

Things that I plan to add in the future are tools for reading common file formats for eyetracking data and tools for assessing the quality of the fixation detection.  A lot of this code already exists in the old package and I will migrate it in small steps.  For example, we have a parser for EDF files that uses the edf-library provided by SR Research.  That means that this parser is highly efficient and robust.

## Getting started

If you want to play with the package, this is how you get started:

    > library(saccades)
    > data(samples)
    > head(samples)
		  time     x      y trial
	1    0 53.18 375.73     1
	2    4 53.20 375.79     1
	3    8 53.35 376.14     1
	4   12 53.92 376.39     1
	5   16 54.14 376.52     1
	6   20 54.46 376.74     1
    > fixations <- detect.fixations(samples)
    > head(fixations[c(1,4,5,10)])
	  trial        x         y  dur
	0     1 53.81296 377.40741   71
	1     1 39.68156 379.58711  184
	2     1 59.99267 379.92467   79
	3     1 18.97898  56.94046  147
	4     1 40.28365  39.03599  980
	5     1 47.36547  35.39441 1310

If you want to examine the results of the saccade detection visually, you can use the function `diagnostic.plot`:

    > diagnostic.plot(samples, fixations)

This function will open an interactive plot showing the original samples and the detected fixations.  The plot can be used to navigate the whole data set using the mouse or keyboard.  Here's a screenshot:

![Screenshot of diagnostic plot](https://raw.github.com/tmalsburg/saccades/master/Screenshots/diagnostic.plot.smooth.15.png)

The dots are the raw samples.  Red dots represent the x-coordinate and orange the y-coordinate.  The vertical lines mark the on- and offsets of fixations. The horizontal lines (difficult to see in the screenshot) represent the fixations.

The function `calculate.summary` prints some summary statistics about the detected fixations:

    > stats <- calculate.summary(fixations)
    > round(stats, digits=2)
                                   mean       sd
    Number of trials              10.00       NA
    Duration of trials         37015.70 16513.25
    No. of fixations per trial    97.00    44.22
    Duration of fixations        340.00   458.29
    Dispersion horizontal          2.60    13.16
    Dispersion vertical            2.31     8.41
    Peak velocity horizontal       0.06    22.18
    Peak velocity vertical        -0.16    13.53

## Blinks

The package currently doesn't offer blink detection.  However, blinks are fairly easy to spot.  In the graph below you can see a blink.  It starts with something that looks like a saccade, then there's a fixation on the coordinates `(0,0)`, and then another saccade (`(0,0)` is what SMI eyetrackers give you when there was track loss).

![A blink](https://raw.github.com/tmalsburg/saccades/master/Screenshots/diagnostic.plot.blink.png)
