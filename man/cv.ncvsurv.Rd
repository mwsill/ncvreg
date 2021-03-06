\name{cv.ncvsurv}
\alias{cv.ncvsurv}
\title{Cross-validation for ncvsurv}
\description{Performs k-fold cross validation for MCP- or SCAD-penalized
  survival models over a grid of values for the regularization
  parameter lambda.}
\usage{
cv.ncvsurv(X, y, ..., cluster, nfolds=10, seed, returnY=FALSE,
trace=FALSE)
}
\arguments{
  \item{X}{The design matrix, as in \code{ncvsurv}.}
  \item{y}{The response matrix, as in \code{ncvsurv}.}
  \item{...}{Additional arguments to \code{ncvsurv}.}
  \item{cluster}{\code{cv.ncvsurv} can be run in parallel across a
    cluster using the \code{parallel} package.  The cluster must be set
    up in advance using the \code{makeCluster} function from that
    pacakge.  The cluster must then be passed to \code{cv.ncvsurv} (see
    example).}
  \item{nfolds}{The number of cross-validation folds.  Default is 10.}
  \item{seed}{You may set the seed of the random number generator in
    order to obtain reproducible results.}
  \item{returnY}{Should \code{cv.ncvreg} return the linear predictors
    from the cross-validation folds?  Default is FALSE; if TRUE, this
    will return a matrix in which the element for row i, column j is the
    fitted value for observation i from the fold in which observation i
    was excluded from the fit, at the jth value of lambda.}
  \item{trace}{If set to TRUE, cv.ncvsurv will inform the user of its
    progress by announcing the beginning of each CV fold.  Default is
    FALSE.}
  }
\details{
  The function calls \code{ncvsurv} \code{nfolds} times, each time
  leaving out 1/\code{nfolds} of the data.  Because of the
  semiparametric nature of Cox regression, cross-validation is not
  clearly defined.  \code{cv.ncvsurv} uses the approach of calculating
  the full Cox partial likelihood using the cross-validated set of
  linear predictors.  Unfortunately, using this approach there is no
  clear way (yet) of determining standard errors, so \code{cv.ncvsurv},
  unlike \code{cv.ncvreg}, does not provide any.

  Other approaches to cross-validation for the Cox regression model have
  been proposed; the strenghts and weaknesses of the various methods for
  penalized regression in the Cox model are not well understood.
  Because of this, the approach used by \code{cv.ncvsurv} may change in
  the future as additional research is carried out.
  }
\value{
  An object with S3 class \code{"cv.ncvsurv"} inheriting from
  \code{"cv.ncvreg"} and containing:
  \item{cve}{The error for each value of \code{lambda}, averaged
    across the cross-validation folds.}
  \item{cvse}{NULL; see Details.}
  \item{lambda}{The sequence of regularization parameter values along
    which the cross-validation error was calculated.}
  \item{fit}{The fitted \code{ncvsurv} object for the whole data.}
  \item{min}{The index of \code{lambda} corresponding to
    \code{lambda.min}.}
  \item{lambda.min}{The value of \code{lambda} with the minimum
    cross-validation error.}
  \item{null.dev}{The cross-validated deviance for the first model along
    the grid of \code{lambda} (i.e., the cross-validated deviance for
    max(lambda), unless you have supplied your own \code{lambda}
    sequence, in which case this quantity is probably not meaningful).
    Although the actual null deviance can be calculated, it cannot be
    compared with the cross-validated deviance due to the manner in
    which deviance must be calculated for Cox regression models (see
    details).}
  }
\references{
  \itemize{
    \item Breheny P and Huang J. (2011) Coordinate descentalgorithms
    for nonconvex penalized regression, with applications to biological
    feature selection.  \emph{Annals of Applied Statistics}, \strong{5}:
    232-253.
    \url{myweb.uiowa.edu/pbreheny/publications/Breheny2011.pdf}

    \item Verweij PJ and van Houwelingen HC. (1993) Cross-validation in
    survival analysis.  \emph{Statistics in Medicine}, \strong{12}:
    2305-2314.
  }
}
\author{Patrick Breheny <patrick-breheny@uiowa.edu>}
\seealso{\code{\link{ncvsurv}}, \code{\link{plot.cv.ncvreg}}, \code{\link{summary.cv.ncvreg}}}
\examples{
data(Lung)
X <- Lung$X
y <- Lung$y

cvfit <- cv.ncvsurv(X, y)
summary(cvfit)
plot(cvfit)
plot(cvfit, type="rsq")

## requires loading the parallel package
\dontrun{
library(parallel)
cl <- makeCluster(4)
cvfit <- cv.ncvsurv(X, y, cluster=cl)}
}
