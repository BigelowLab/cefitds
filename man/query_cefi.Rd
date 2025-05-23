% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tds.R
\name{query_cefi}
\alias{query_cefi}
\title{Retrieve a CEFI data catalog}
\usage{
query_cefi(
  region = "northwest_atlantic",
  domain = "full_domain",
  product = c("decadal_forecast", "hindcast", "long_term_projection",
    "seasonal_forecast", "seasonal_forecast_initialization", "seasonal_reforecast")[2],
  period = c("daily", "monthly", "yearly")[2],
  format = c("raw", "regrid")[2],
  what = "latest",
  vars = c("btm_o2", "btm_temp"),
  as = c("node", "table"),
  ...
)
}
\arguments{
\item{region}{chr the name of the region}

\item{domain}{chr or NULL, the name of the domain (default is "full_domain")}

\item{product}{chr or NULL, the name of the product}

\item{period}{chr or NULL, the product period (default = "monthly")}

\item{format}{chr or NULL, one of "raw" or "regrid" (default)}

\item{what}{chr or NULL, the suite to retrieve, generally "latest"}

\item{vars}{chr or NULL, that short_name variables of interest}

\item{as}{chr one of "node", "table" (default)}

\item{...}{other arguments for \code{cefi_top()}}
}
\value{
a CatalogNode or a \code{cefi_dataset_nodes} class list of DatasetNode objects
}
\description{
Retrieve a CEFI data catalog
}
