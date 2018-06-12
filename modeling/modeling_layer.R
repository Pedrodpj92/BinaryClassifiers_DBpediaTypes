#modeling_layer

source(paste(getwd(),"/modeling/model_funs.R",sep=""))


#for now, only is used random forest with cross-validation 10 fold, but it can change
modeling_layer <- function(dt_learning, id_model, randomSeed){
  #chack if dt_learning is data frame type and id_model is integer type
  
  #in future will appear if-else/swich case to chose several models, as well as more parameters
  trainedModel <- simpleRandomForest(dt_learning, id_model, randomSeed)
  
  return(trainedModel)
}

modeling_layer_prediction <- function(dt_predict, id_model){
  
  predictionsDone <- simpleRandomForest_Prediction(dt_predict, id_model)
  
  return(predictionsDone)
}
