% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classify.R
\name{classify}
\alias{classify}
\title{Mechanistic Network Classification}
\usage{
classify(
  network,
  directed = FALSE,
  method = "DD",
  net_kind = "matrix",
  DD_kind = "all",
  DD_weight = 1,
  cause_orientation = "row",
  max_norm = FALSE,
  resolution = 100,
  resolution_min = 0.01,
  resolution_max = 0.99,
  reps = 3,
  processes = c("ER", "PA", "DM", "SW", "NM"),
  power_max = 5,
  connectance_max = 0.5,
  divergence_max = 0.5,
  mutation_max = 0.5,
  null_reps = 50,
  best_fit_kind = "avg",
  best_fit_sd = 0.01,
  ks_dither = 0,
  ks_alternative = "two.sided",
  cores = 1,
  size_different = FALSE,
  DD_resize = "smaller",
  null_dist_trim = 1,
  verbose = TRUE
)
}
\arguments{
\item{network}{The network to be classified.}

\item{directed}{Defaults to TRUE. Whether the target network is directed.}

\item{method}{This determines the method used to compare networks at the heart of the classification. Currently "DD" (Degree Distribution) and "align" (the align function which compares networks by the entropy of diffusion on them) are supported. Future versions will allow user-defined methods. Defaults to "DD".}

\item{net_kind}{If the network is an adjacency matrix ("matrix") or an edge list ("list"). Defaults to "matrix".}

\item{DD_kind}{= A vector of network properties to be used to compare networks. Defaults to "all", which is the average of the in- and out-degrees.}

\item{DD_weight}{= Weights of each network property in DD_kind. Defaults to 1, which is equal weighting for each property.}

\item{cause_orientation}{= The orientation of directed adjacency matrices. Defaults to "row".}

\item{max_norm}{Binary variable indicating if each network property should be normalized so its max value (if a node-level property) is one. Defaults to FALSE.}

\item{resolution}{Defaults to 100. The first step is to find the version of each process most similar to the target network. This parameter sets the number of parameter values to search across. Decrease to improve performance, but at the cost of accuracy.}

\item{resolution_min}{Defaults to 0.01. The minimum parameter value to consider. Zero is not used because in many processes it results in degenerate systems (e.g. entirely unconnected networks). Currently process agnostic. Future versions will accept a vector of values, one for each process.}

\item{resolution_max}{Defaults to 0.99. The maximum parameter value to consider. One is not used because in many processes it results in degenerate systems (e.g. entirely connected networks). Currently process agnostic. Future versions will accept a vector of values, one for each process.}

\item{reps}{Defaults to 3. The number of networks to simulate for each parameter. More replicates increases accuracy by making the estimation of the parameter that produces networks most similar to the target network less idiosyncratic.}

\item{processes}{Defaults to c("ER", "PA", "DD", "SW", "NM"). Vector of process abbreviations. Currently only the default five are supported. Future versions will accept user-defined network-generating functions and associated parameters. ER = Erdos-Renyi random. PA = Preferential Attachment. DD = Duplication and Divergence. SW = Small World. NM = Niche Model.}

\item{power_max}{Defaults to 5. The maximum power of attachment in the Preferential Attachment process (PA).}

\item{connectance_max}{= Defaults to 0.5. The maximum connectance parameter for the Niche Model.}

\item{divergence_max}{= Defaults to 0.5. The maximum divergence parameter for the Duplication and Divergence/Mutation mechanisms.}

\item{mutation_max}{= Defaults to 0.5. The maximum mutation parameter for the Duplication and Mutation mechanism.}

\item{null_reps}{Defaults to 50. The number of best fit networks to simulate that will be used to create a null distribution of distances between networks within the given process, which will then be used to test if the target network appears unusually distant from them and therefore likely not governed by that process.}

\item{best_fit_sd}{Defaults to 0.01. Standard Deviation used to simulate networks with a similar but not identical best fit parameter. This is important because simulating networks with the identical parameter artificially inflates the false negative rate by assuming the best fit parameter is the true parameter. For large resolution and reps values this will become true, but also computationally intractable for realistically large systems.}

\item{ks_dither}{Defaults to 0. The KS test cannot compute exact p-values when every pairwise network distance is not unique. Adding small amounts of noise makes each distance unique. We are not aware of a study on the impacts this has on accuracy so it is set to zero by default.}

\item{ks_alternative}{Defaults to "two.sided". Governs the KS test. Assuming best_fit_sd is not too large, this can be set to "greater" because the target network cannot be more alike identically simulated networks than they are to each other. In practice we have found "greater" and "less" produce numerical errors. Only "two.sided", "less", and "greater" are supported through stats::ks.test().}

\item{cores}{Defaults to 1. The number of cores to run the classification on. When set to 1 parallelization will be ignored.}

\item{size_different}{= If there is a difference in the size of the networks used in the null distribution. Defaults to FALSE.}

\item{DD_resize}{= If networks being compared are a different size, this parameter determines if upscaling "larger" or downscaling "smaller" occurs. Unlikely to be relevant here. Defaults to "smaller".}

\item{null_dist_trim}{= Number between zero and one that determines how much of each network comparison distribution (unknown network compared to simulated networks, simulated networks compared to each other) should be used. Prevents p-value convergence with large sample sizes. Defaults to 1, which means all comparisons are used (no trimming).}

\item{verbose}{Defaults to TRUE. Whether to print all messages.}
}
\value{
A dataframe with 3 columns and as many rows as processes being tested (5 by default). The first column lists the processes. The second lists the p-value on the null hypothesis that the target network did come from that row's process. The third column gives the estimated parameter for that particular process.
}
\description{
Tests a network against hypothetical generating processes using a comparative network inference.
}
\details{
Note: Currently each process is assumed to have a single governing parameter.
}
\examples{
# Adjacency matrix
size <- 10
network <- matrix(sample(c(0,1), size = size^2, replace = TRUE), nrow = size, ncol = size)
classify(network)

}
\references{
Langendorf, R. E. & Burgess, M. G. Empirically classifying network mechanisms. In Preparation for PNAS.
}
