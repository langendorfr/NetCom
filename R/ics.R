#' @title Induced Conserved Structure (ICS)
#'
#' @description Calculates the Induced Conserved Structure proposed by Patro and Kingsford (2012) of an alignment between two networks.
#'
#' @param network_1_input The first network being aligned, which must be in matrix form. If the two
#' networks are of different sizes, it will be easier to interpret the output if this is the smaller one.
#'
#' @param network_2_input The second network, which also must be a matrix.
#'
#' @param alignment A matrix, such as is output by the function NetCom, where the first two columns contain
#' corresponding node IDs for the two networks that were aligned.
#' 
#' @param flip Defaults to FALSE. Set to TRUE if the first network is larger than the second. This is necessary 
#' because ICS is not a symmetric measure of alignment quality. 
#'
#' @return A number ranging between 0 and 1. If the Induced Conserved Structure is 1, the two networks are
#' isomorphic (identical) under the given alignment.
#' 
#' @references Patro, R., & Kingsford, C. (2012). Global network alignment using multiscale spectral signatures. Bioinformatics, 28(23), 3105-3114.
#'
#' @examples
#' # Note that ICS is only defined on unweighted networks.
#' net_one <- round(matrix(runif(25,0,1), nrow=5, ncol=5))
#' net_two <- round(matrix(runif(25,0,1), nrow=5, ncol=5))
#' 
#' ics(net_two, net_two, align(net_one, net_two)$alignment)
#' 
#' @export

ics <- function(network_1_input, network_2_input, alignment, flip = FALSE)
{
  # Check to make sure the networks are unweighted. ICS is not defined on weighted networks.
  if ((sum(network_1_input %in% c(0,1)) != nrow(network_1_input) * ncol(network_1_input)) | (sum(network_2_input %in% c(0,1)) != nrow(network_2_input) * ncol(network_2_input))) {
    return("ICS is only defined on unweighted networks.") 
  } else {
    
    # This step serves entirely to pave the way for future development allowing linked lists as inputs
    matrix_1_input <- network_1_input
    matrix_2_input <- network_2_input
  
    # Restructure the networks according to the alignment
    ICS_1 <- matrix_1_input[alignment[ , 1], alignment[ , 1]]
    ICS_2 <- matrix_2_input[alignment[ , 2], alignment[ , 2]]
  
    ICS_numerator <- sum((ICS_1 == ICS_2) & ICS_1 != 0) # Do not count similar absences of edges
  
    # This is necessary because ICS is not a symmetric measure of alignment quality.
    if (flip == TRUE) {
      ICS_denominator <- sum(ICS_1)
    } else {
      # The default behavior
      ICS_denominator <- sum(ICS_2)   
    }
  
    ICS <- ICS_numerator/ICS_denominator
  
    return(ICS)
  } 
}
