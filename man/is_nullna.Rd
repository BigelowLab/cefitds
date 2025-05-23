% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{is_nullna}
\alias{is_nullna}
\title{Determine if an object is NULL or NA}
\usage{
is_nullna(x)
}
\arguments{
\item{x}{object to test, if not NULL then only the first value is
tested for NA-ness}
}
\value{
logical TRUE is \code{x} is NULL or \code{x[1]} is NA
}
\description{
Determine if an object is NULL or NA
}
