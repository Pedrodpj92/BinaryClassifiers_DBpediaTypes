#collecting_layer.R

source(paste(getwd(),"/collecting/fromSPARQL/query_funs.R",sep=""))

#Description
#Layer focused on retrieve data about classes (types) requested, both positive and negative ones.

#Input
# - positiveClass (String)
# - numberPositiveCases (integer)
# - negativeClasses (List <String>)
# - numberNegativeCases (List <integer>)
# - URL's endpoint SPARQL (String)

#Output
# - queryResults: list with every result get from queries as data frames

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
  if(!is.numeric(numberPositiveCases)){# || !is.numeric(numberNegativeCases)){
    if(!numberPositiveCases%%1==0){# || !numberNegativeCases%%1==0){ this is a list, must be checked in a different way
      stop(paste0("Error, numberPositiveCases and numberNegativeCases should be integer: ",numberOfRequest), call.=FALSE)
    }
  }
  if(numberPositiveCases<1){# || numberPositiveCases){ 
    stop(paste0("Error, numberOfRequest should be greater than 0: ",numberOfRequest), call.=FALSE)  
  }
  
  #about resources
  positive_types <- ask_resources(positiveClass, 0, numberPositiveCases, urlEndpoint, queryLimit)
  
  if(length(numberNegativeCases)!=length(negativeClasses)){
    stop(paste0("Error, numberNegativeCases and negativeClasses should have the same number of elements: ",
                numberNegativeCases," // ",negativeClasses), call.=FALSE)
  }
  
  
  negative_types <- vector("list",length(numberNegativeCases))
  # for(i in 1:length(numberNegativeCases)){
  #   negative_types[[i]] <- ask_resources(negativeClasses[[i]], 0, numberNegativeCases[[i]], urlEndpoint, queryLimit)
  #   negative_properties[[i]] <- ask_properties(negative_types[[i]], urlEndpoint, queryLimit) 
  # }
  
  #this loop is divided in order to retrieve all resources first, in case of there would be some problem on them
  for(i in 1:length(numberNegativeCases)){
    print(paste0("let's ask ",numberNegativeCases[[i]]," resources about ",negativeClasses[[i]]," type"))
    print(paste0("other parameter queryLimit: ",queryLimit))
    negative_types[[i]] <- ask_resources(negativeClasses[[i]], 0, numberNegativeCases[[i]], urlEndpoint, queryLimit)
  }
  
  #about properties
  # positive_properties <- ask_properties(positiveClass, numberPositiveCases, urlEndpoint, queryLimit) #OLD version
  if(nrow(positive_types)>1){
    positive_properties <- ask_properties(positive_types, urlEndpoint, queryLimit)
  }else{
    stop(paste0("Error, resources with positive Class ",positiveClass," have not been found"), call.=FALSE)
  }
  
  
  negative_properties <- vector("list",length(numberNegativeCases))
  for(i in 1:length(numberNegativeCases)){
    if(nrow(negative_types[[i]])>1){
      negative_properties[[i]] <- ask_properties(negative_types[[i]], urlEndpoint, queryLimit) 
    }else{
      warning(paste0("Warning, resources with negative Class ",negativeClasses[[i]]," have not been found. ",
                     "Would be enought with the rest of negative cases? Please, considerer it"))
    }
  }
  
  # queryResults <- vector("list",4)
  queryResults <- list()
  # queryResults[[1]] <- positive_types
  # queryResults[[2]] <- positive_properties
  # queryResults[[3]] <- negative_types
  # queryResults[[4]] <- negative_properties
  queryResults$positive_resources <- positive_types
  queryResults$positive_properties <- positive_properties
  queryResults$negative_resources <- negative_types
  queryResults$negative_properties <- negative_properties
  
  return(queryResults)
}



