#!/usr/bin/env Rscript
#get_sparqlData_and_Preprocess.R

source(paste(getwd(),"/collecting/collecting_layer.R",sep=""))
source(paste(getwd(),"/preprocessing/preprocessing_layer.R",sep=""))

#Description:
# do sparql collection process, prepare data and save in .RData format

get_sparqlData_and_Preprocess <- function(positiveClass, numberPositiveCases,
                                          negativeClasses, numberNegativeCases,
                                          urlEndpoint, queryLimit,
                                          domain_propertiesURI=NULL){
  print(paste0("pero que estoy teniendo en el valor de domain_propertiesURI: ", domain_propertiesURI))
  
  data_collected <- collecting_layer(positiveClass, numberPositiveCases,
                                     negativeClasses, numberNegativeCases,
                                     urlEndpoint, queryLimit,domain_propertiesURI)
  
  positive_types <- data_collected[[1]]
  positive_properties <- data_collected[[2]]
  negative_types <- data_collected[[3]]
  negative_properties  <- data_collected[[4]]
  
  learningSet <- preprocessing_layer(positive_types, positive_properties,
                                     negative_types, negative_properties,domain_propertiesURI)
  
  achievedData <- list()
  achievedData$data_collected <- data_collected
  achievedData$predictingSet <- learningSet
  
  return(achievedData)
}
