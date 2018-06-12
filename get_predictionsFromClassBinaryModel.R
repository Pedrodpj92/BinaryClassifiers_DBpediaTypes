#get_predictionsFromClassBinaryModel.R

source(paste(getwd(),"/collecting/collecting_layer.R",sep=""))
source(paste(getwd(),"/preprocessing/preprocessing_layer.R",sep=""))
source(paste(getwd(),"/modeling/modeling_layer.R",sep=""))

#Description
#Receive a list created by get_oneClassBinaryModel function to reuse its trained model to predict if
#resources belong or not to a specific type.
#These resources are transfered as a data frame, where first column is each resouce themselves and second column properties.
#An optional parameter can be given with a data frame with related types to resources used to predict,
#so in this way can be useful as validation and testing model.

#Input
# - 


get_predictionsFromClassBinaryModel <- function(classBinaryModel_object,
                                                positiveClass, numberPositiveCases,
                                                negativeClasses, numberNegativeCases,
                                                numberOfRequest, urlEndpoint, queryLimit,domain_propertiesURI=NULL#,randomSeed
){
  
  library(caret)
  
  #when several iterations were done, here will be a loop
  firstIt <- classBinaryModel_object[[1]]
  trainingData <- firstIt$learningSet
  binaryModel <- firstIt$trainedModel
  
  # data_collected <- collecting_layer_prediction_experiments()
  #by now, it is enought with same collection process
  #(of course, would be necessary different resources agains trained data,
  #so, it is planned for use a different urlEndpoint, but requesting similar data
  #for instance, train with Spanish DBpedia and validate(?)/test/predict with English)
  data_collected <- collecting_layer(positiveClass, numberPositiveCases,
                                     negativeClasses, numberNegativeCases,
                                     urlEndpoint, queryLimit)
  
  # predictingSet <- preprocessing_layer_prediction(trainingData = trainingData,
  #                                                 properties_list = )
  predictingSet <- preprocessing_layer_prediction(trainingData,
                                                  positive_types, positive_properties,
                                                  negative_types, negative_properties,domain_propertiesURI)
  #predictions should be done without Class column
  predictionsDone <- modeling_layer_prediction(dt_predict = predictingSet[,-ncol(predictingSet)],id_model = binaryModel)
  
  #doing confusion matrix with original types (Class) and predictions
  # comparativePerResource <- cbind(predictingSet[,c(1,ncol(predictingSet))],predictionsDone$predict)#CHECK
  realTypes <- predictingSet[,ncol(predictingSet)]
  predictedTypes <- predictionsDone$predict #CHECK
  confusionMatrixTypes <- confusionMatrix(realTypes,predictedTypes)
  print(confusionMatrixTypes)
  
  stackRequest <- list()
  stackRequest$data_collected <- data_collected
  stackRequest$predictingSet <- predictingSet
  stackRequest$predictionsDone <- predictionsDone
  stackRequest$confusionMatrixTypes <- confusionMatrixTypes
  
  return(stackRequest)
}








