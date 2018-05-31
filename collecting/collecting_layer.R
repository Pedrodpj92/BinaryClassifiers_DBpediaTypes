#collecting_layer.R

source(paste(getwd(),"/collecting/fromSPARQL/query_funs.R",sep=""))

#Description:
#Layer focused on retrieve data about classes (types) requested, both positive and negative ones.

#Input:
# - positiveClass (String)
# - numberPositiveCases (integer)
# - negativeClasses (List <String>)
# - numberNegativeCases (List <integer>)
# - URL's endpoint SPARQL (String)

#Exceptions
# - Non proper parameter types
# - No data collected (from any query)
# - Number of cases (positive either negative) must be greater than 0
#(if numberPositiveCases<1 || sum(numberNegativeCases)<0 then trhows ex)

#Warnings
# - Data collected less than request (either positive or some negative)

#Notes
# Class Strings should include "less than" and "greater than" symbols (<URI>)

collecting_layer <- function(positiveClass, numberPositiveCases,
                             negativeClasses, numberNegativeCases,
                             urlEndpoint, queryLimit){
  
  
  #Estos e deberia comprobar en las funciones, cuando se puede comprobar que es un entero, no una lista
  if(!is.integer(numberPositiveCases) || !is.integer(numberNegativeCases)){
    stop(paste0("Error, numberPositiveCases and numberNegativeCases should be integer: ",numberOfRequest), call.=FALSE)
  }
  if(numberPositiveCases<1 || numberPositiveCases){
    stop(paste0("Error, numberOfRequest should be greater than 0: ",numberOfRequest), call.=FALSE)  
  }
  
  
  positive_types <- ask_types(positiveClass, numberPositiveCases, urlEndpoint, queryLimit)
  positive_properties <- ask_properties(positiveClass, numberPositiveCases, urlEndpoint, queryLimit)
  
  if(length(numberNegativeCases)!=length(negativeClasses)){
    stop(paste0("Error, numberNegativeCases and negativeClasses should have the same number of elements: ",
                numberNegativeCases," // ",negativeClasses), call.=FALSE)
  }
  negative_types <- vector("list",numberNegativeCases)
  negative_properties <- vector("list",numberNegativeCases)
  for(i in 1:length(numberNegativeCases)){
    negative_types[[i]] <- ask_types(negativeClasses[[i]], numberNegativeCases[[i]], urlEndpoint, queryLimit)
    negative_properties[[i]] <- ask_properties(negativeClasses[[i]], numberNegativeCases[[i]], urlEndpoint, queryLimit) 
  }
  
  queryResults <- vector("list",4)
  queryResults[[1]] <- positive_types
  queryResults[[2]] <- positive_properties
  queryResults[[3]] <- negative_types
  queryResults[[4]] <- negative_properties
  
  return(queryResults)
}

