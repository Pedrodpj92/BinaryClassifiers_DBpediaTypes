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
                             urlEndpoint, queryLimit,domain_propertiesURI=NULL,
                             initialResourceOffset=0){
  
  
  #Estos e deberia comprobar en las funciones, cuando se puede comprobar que es un entero, no una lista
  if(!is.numeric(numberPositiveCases)){# || !is.numeric(numberNegativeCases)){
    if(!numberPositiveCases%%1==0){# || !numberNegativeCases%%1==0){ this is a list, must be checked in a different way
      stop(paste0("Error, numberPositiveCases and numberNegativeCases should be integer: ",numberOfRequest), call.=FALSE)
    }
  }
  if(numberPositiveCases<1){# || numberPositiveCases){ 
    stop(paste0("Error, numberOfRequest should be greater than 0: ",numberOfRequest), call.=FALSE)  
  }
  
  if(length(numberNegativeCases)!=length(negativeClasses)){
    stop(paste0("Error, numberNegativeCases and negativeClasses should have the same number of elements: ",
                numberNegativeCases," // ",negativeClasses), call.=FALSE)
  }
  
  positiveDataFound <- ask_res_and_prop_fromType(positiveClass,
                                                 numberPositiveCases,
                                                 urlEndpoint,queryLimit,domain_propertiesURI)
  positive_types <- positiveDataFound[[1]]
  positive_properties <- positiveDataFound[[2]]
  
  # before wrap in ask_res_and_prop_fromType
  # resources_offset <- 0
  # needsContinue <- TRUE
  # currentPositiveCases <- numberPositiveCases
  # 
  # stackedPosResources <- data.frame(t(c("s","p","o")))
  # colnames(stackedPosResources) <- c("s","p","o")
  # 
  # stackedPosProperties <- data.frame(t(c("s","p")))
  # colnames(stackedPosProperties) <- c("s","p")
  # 
  # while(needsContinue){
  #   
  #   positive_types <- ask_resources(positiveClass, resources_offset, currentPositiveCases, urlEndpoint, queryLimit)
  #   resources_found <- nrow(positive_types)
  #   positive_types$s <- as.character(positive_types$s)
  #   positive_types$s <- as.factor(positive_types$s)
  #   
  #   if(resources_found>1){
  #     resources_offset <- resources_offset+resources_found
  #     positive_properties <- ask_properties(positive_types, urlEndpoint, queryLimit)
  #     
  #     if(!is.null(domain_propertiesURI)){
  #       positive_properties <- positive_properties[grep(domain_propertiesURI,positive_properties[,2]),]
  #     }
  #     
  #     positive_properties$s <- as.character(positive_properties$s)
  #     positive_properties$s <- as.factor(positive_properties$s)
  #     
  #     remainingPosResources <- positive_types[positive_types$s %in% positive_properties$s,]
  #     
  #     stackedPosResources <- rbind(stackedPosResources,remainingPosResources)
  #     stackedPosProperties <- rbind(stackedPosProperties,positive_properties)
  #     
  #     if(nrow(stackedPosResources)>=numberPositiveCases){
  #       needsContinue <- FALSE
  #       
  #     }else{
  #       currentPositiveCases <- currentPositiveCases-nrow(remainingPosResources)
  #       print("some resources had not proper properties, so new resources will be requested")
  #     }
  #     
  #   }else{
  #     stop(paste0("Error, resources with positive Class ",positiveClass," have not been found"), call.=FALSE)
  #   }
  #   
  # }
  # positive_types <- positive_types[-1,]
  # positive_types <- stackedPosResources
  # positive_types$s <- as.character(positive_types$s)
  # positive_types$s <- as.factor(positive_types$s)
  # positive_properties <- positive_properties[-1,]
  # positive_properties <- stackedPosProperties
  # positive_properties$s <- as.character(positive_properties$s)
  # positive_properties$s <- as.factor(positive_properties$s)
  
  
  #about resources, old version, now we need to iterate about new resources in order to get enought
  #with proper properties
  # positive_types <- ask_resources(positiveClass, 0, numberPositiveCases, urlEndpoint, queryLimit)
  # 
  # if(nrow(positive_types)>1){
  #   positive_properties <- ask_properties(positive_types, urlEndpoint, queryLimit)
  # }else{
  #   stop(paste0("Error, resources with positive Class ",positiveClass," have not been found"), call.=FALSE)
  # }
  
  
  
  negative_types <- vector("list",length(numberNegativeCases))
  negative_properties <- vector("list",length(numberNegativeCases))
  
  
  negative_offsets_types <- length(numberNegativeCases)
  negative_offsets_types <- rep(0, negative_offsets_types)#initialize each offset to request resources
  negativeDataFound <- vector("list",length(numberNegativeCases))
  
  for(i in 1:length(numberNegativeCases)){
    print(paste0("let's ask ",numberNegativeCases[[i]]," resources about ",negativeClasses[[i]]," type"))
    negativeDataFound[[i]] <- ask_res_and_prop_fromType(negativeClasses[[i]],numberNegativeCases[[i]],
                                                        urlEndpoint,queryLimit,domain_propertiesURI)
    negative_types[[i]] <- negativeDataFound[[i]][[1]]
    negative_properties[[i]] <- negativeDataFound[[i]][[2]]
  }
  
  #Currently using previous function, cannot review all resources before properties, but enought resources can be reached now when
  #not proper properties are found from resources
  #this loop is divided in order to retrieve all resources first, in case of there would be some problem on them
  # for(i in 1:length(numberNegativeCases)){
  #   print(paste0("let's ask ",numberNegativeCases[[i]]," resources about ",negativeClasses[[i]]," type"))
  #   negative_types[[i]] <- ask_resources(negativeClasses[[i]], 0, numberNegativeCases[[i]], urlEndpoint, queryLimit)
  # }
  # #about properties
  # for(i in 1:length(numberNegativeCases)){
  #   if(nrow(negative_types[[i]])>1){
  #     negative_properties[[i]] <- ask_properties(negative_types[[i]], urlEndpoint, queryLimit) 
  #   }else{
  #     warning(paste0("Warning, resources with negative Class ",negativeClasses[[i]]," have not been found. ",
  #                    "Would be enought with the rest of negative cases? Please, considerer it"))
  #   }
  # }
  
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





