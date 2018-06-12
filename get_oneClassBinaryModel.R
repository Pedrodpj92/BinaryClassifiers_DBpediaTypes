#!/usr/bin/env Rscript
#get_oneClassBinaryModel.R

source(paste(getwd(),"/collecting/collecting_layer.R",sep=""))
source(paste(getwd(),"/preprocessing/preprocessing_layer.R",sep=""))
source(paste(getwd(),"/modeling/modeling_layer.R",sep=""))

#Description:
#Retrieve triples doing SPARQL queries in order to train a binary model to diference resources
#to belong to a DBpedia class or not. Return the trained model with metrics.

#Input:
# - positiveClass (String)
# - numberPositiveCases (integer)
# - negativeClasses (List <String>)
# - numberNegativeCases (List <integer>)
# - numberOfRequest (integer)
# - URL's endpoint SPARQL (String)
# - queryLimit (integer), it would be wonderful have something like configuration settings, to give this values
# - domain_propertiesURI (string), optional, string filter to grep some specific properties, for instance, only belonging to DBpedia ontology

#Exceptions
# - NumberOfRequest must be an integer
# - Number of request must be greater than 1
#(if numberOfRequest<1 then throws ex)

#Return
# - Reference to each phase outputs (list with lists with several and heterogeneous objects)
# - Print input parameters and output metrics (accuracy, precision and recall, maybe f-measure too)


###################
#@@@ collecting; from SPARQL
#Do some SPARQL queries in order to obtain triples belonging to properties and resources with
#a positive class passed in a String as arguments
#Do some another SPARQL queries to obtain triples beloging to properties and resources with
#negative classes passed in a list as argument
#   - Input: positive class, number of positive cases, negative classes list, number of negative cases, url endpoint
#   - Return 4 data frames in a list with 3 columns each one, column names always "s","p","o"
#     > Positive resources with types (resource, a, positiveClass)
#     > Positive resources with properties (resource, p, nonImportantData)
#     > Negative resources with types (resource, a, negativeClasses)
#     > Negative resources with properties (resource, p, nonImportantData)

##################
#@@@ preprocessing;
#Transform triples properly to obtain a learning matrix
#   - Input: 4 data frames with types and propertios about positive class and negative classes
#   - properties are binary columns 1/0 (yes/no)
#   - class column are 1 for positive class and 0 for the rest (negative classes)
#   - Return data frame object, learningSet, save in hard disk?

#############
#@@@ modeling;
#Pass data to a Random Forest model, from H2O library
#   - Input: 1 data frame, learningSet
#   - Cross-Validation, 10 folds
#   - Return model object with metrics (accuracy, precission, recall), save in hard disk?


get_oneClassBinaryModel <- function(positiveClass, numberPositiveCases,
                                    negativeClasses, numberNegativeCases,
                                    numberOfRequest, urlEndpoint, queryLimit,domain_propertiesURI=NULL#,randomSeed
){
  if(!is.numeric(numberOfRequest)){
    if(!numberOfRequest%%1==0){
      stop(paste0("Error, numberOfRequest should be an integer: ",numberOfRequest), call.=FALSE)
    }
  }
  if(numberOfRequest<1){
    stop(paste0("Error, numberOfRequest should be greater than 0: ",numberOfRequest), call.=FALSE)
  }
  stackRequest <- vector("list",numberOfRequest)
  for(i in 1:numberOfRequest){
    
    print(paste0(Sys.time()," -> starting request number ",i))
    print(paste0(Sys.time()," -> starting collection phase"))
    
    #phase 1
    data_collected <- collecting_layer(positiveClass, numberPositiveCases,
                                       negativeClasses, numberNegativeCases,
                                       urlEndpoint, queryLimit)
    positive_types <- data_collected[[1]]
    positive_properties <- data_collected[[2]]
    negative_types <- data_collected[[3]]
    negative_properties  <- data_collected[[4]]
    
    print(paste0(Sys.time()," -> starting preprocessing phase"))
    #phase 2
    # if(!is.null(domain_propertiesURI)){
    #   learningSet <- preprocessing_layer(positive_types, positive_properties,
    #                                      negative_types, negative_properties,domain_propertiesURI)
    # }else{
    #   learningSet <- preprocessing_layer(positive_types, positive_properties,
    #                                      negative_types, negative_properties)
    # }
    learningSet <- preprocessing_layer(positive_types, positive_properties,
                                       negative_types, negative_properties,domain_propertiesURI)
    
    print(paste0(Sys.time()," -> starting modeling phase"))
    #phase 3
    trainedModel <- modeling_layer(learningSet,i,1234)
    
    #save iteration data and results
    # aux_listStepCover <- vector("list",3)
    # aux_listStepCover[[1]] <- data_collected
    # aux_listStepCover[[2]] <- learningSet
    # aux_listStepCover[[3]] <- trainedModel
    
    aux_listStepCover <- list()
    aux_listStepCover$data_collected <- data_collected
    aux_listStepCover$learningSet <- learningSet
    aux_listStepCover$trainedModel <- trainedModel
    stackRequest[[i]] <- aux_listStepCover
    print(paste0(Sys.time()," -> ending request number ",i))
  }
  
  return(stackRequest)
}

