saccades
========

An R package for saccade and fixation detection in eyetracking data.  It uses the algorithm for saccade detection proposed by Ralf Engbert and Reinhold Kliegl.  Any period occurring between two saccades is considered to be a fixation. 

This software is a re-implementation of a package that I wrote earlier and that we used heavily in our research.  However, I wrote the old package when I was new to R and many things are clumsy and unnecessarily complex.  Hence, the rewrite.

The code in this repository is not for production use as it is under construction and largely untested.

Things that I plan to add in the future are tools for reading common file formats for eyetracking data and tools for assessing the quality of the fixation detection.  A lot of this code already exists in the old package and I will migrate it in small steps.  For example, we have a parser for EDF files that uses the edf-library provided by SR Research.  That means that this parser is highly efficient and robust.

If you want to play with the package, this is how you get started:

    > library(saccades)
	> data(eyemovements.raw)
	> samples <- eyemovements.raw$samples
	> head(samples)
				time     x      y trial
	51 880446504 53.18 375.73     1
	52 880450686 53.20 375.79     1
	53 880454885 53.35 376.14     1
	54 880459060 53.92 376.39     1
	55 880463239 54.14 376.52     1
	56 880467426 54.46 376.74     1
	> fixations <- detect.fixations(samples)
	> head(fixations[c(1,2,3,4,5,10)])
	  trial     start       end        x         y    dur
	0     1 880446504 880517668 53.81296 377.40741  71164
	1     1 880538588 880538588 35.38333 377.95667      0
	2     1 880546938 880722726 39.84698 379.65969 175788
	3     1 880743655 880743655 63.33000 380.37000      0
	4     1 880752009 880823151 59.75037 379.89278  71142
	5     1 880873375 880873375 21.96000  52.49667      0

As you can see, there are problems such as fixations with zero duration.  These are single-sample fixations that are an artifact of noise in the velocity profile: the velocity of the eyes falls below the threshold but raises above the threshold in the next sample.  Easy to fix but not done yet.

Other problems: only one eye can be analyzed at a time and there's no blink detection.
