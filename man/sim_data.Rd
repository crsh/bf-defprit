% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sim_data.R
\name{sim_data}
\alias{sim_data}
\title{Simulate data}
\usage{
sim_data(n_s, n_t, mu, nu, sigma_alpha, sigma_theta, sigma_epsilon)
}
\arguments{
\item{n_s}{\code{numeric}. Number of participants (also referred to as I).}

\item{n_t}{\code{numeric}. Number of trials (also referred to as K).}

\item{mu}{\code{numeric}. Grand mean.}

\item{nu}{\code{numeric}. Mean difference.}

\item{sigma_alpha}{\code{numeric}. Random intercept standard deviation.}

\item{sigma_theta}{\code{numeric}. Random slope standard deviation.}

\item{sigma_epsilon}{\code{numeric}. Error standard deviation.}
}
\value{
A \code{data.frame} with responses in column \code{y}, trial index in \code{t},
and factors coding \code{subject} as well as condition (\code{cond}).
}
\description{
Randomly simulates data for a two-level one-factorial design.
}
