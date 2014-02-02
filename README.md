saccades
========

An R package for saccade and fixation detection in eyetracking data.  It uses the algorithm for saccade detection proposed by Ralf Engbert and Reinhold Kliegl.  Any period occurring between two saccades is considered to be a fixation. 

This software is a re-implementation of a package that I wrote earlier and that we used heavily in our research.  However, I wrote the old package when I was new to R and many things are clumsy and unnecessarily complex.  Hence, the rewrite.

The code in this repository is not for production use as it is under construction and largely untested.

Things that I plan to add in the future are tools for reading common file formats for eyetracking data and tools for assessing the quality of the fixation detection.  A lot of this code already exists in the old package and I will migrate it in small steps.  For example, we have a parser for EDF files that uses the edf-library provided by SR Research.  That means that this parser is highly efficient and robust.
