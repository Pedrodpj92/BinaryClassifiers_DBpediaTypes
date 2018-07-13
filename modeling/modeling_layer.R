#modeling_layer

source(paste(getwd(),"/modeling/model_funs.R",sep=""))


#for now, only is used random forest with cross-validation 10 fold, but it can change
modeling_layer <- function(dt_learning, numberPositiveCases=NULL, numberNegativeCases=NULL,
                           name_algorithm="RF_H2O", name_model, id_model, path_model, randomSeed){
  #to-do:check if dt_learning is data frame type and id_model is integer type
  
  #in case of interest of study inbalance cases, number of positive/negative could be chosen here
  #why is not in previous part? Essentially, it is quite cost asking to SPARQL endpoint, so these
  #retrieving data phase is apart of this other kind of selection, because selection on R data frame
  #is incomparably faster than SPARQL selection
  
  available_models <- list()
  available_models[[1]] <- "RF_H2O"
  available_models[[2]] <- "C5.0"
  
  
  # if(name_algoritm %in% available_models){
  #   if(name_algorithm == available_models$RF_H2O){
  #     # trainedModel <- simpleRandomForest(dt_learning, name_model, id_model, path_model, randomSeed)
  #   }
  switch (name_algorithm,
          RF_H2O={
            print("using Random Forest")
            trainedModel <- simpleRandomForest(dt_learning, name_model, id_model, path_model, randomSeed)
          },
          C5.0={
            print("using C5.0")
            trainedModel <- modelWithC50_10fold(dt_learning, name_model, id_model, path_model, randomSeed)
          },{
            algorithms_toPrint <- paste(available_models,collapse = ", ")
            stop(paste0("please, check available models, select one of next name algorithms: ",algorithms_toPrint))
          }
          
  )
  # }else{
  #   stop(paste0("please, check available models, select one of next name algorithms: ",available_models))
  # }
  
  
  return(trainedModel)
}

modeling_layer_prediction <- function(dt_data, name_file, path_model){
  
  predictionsDone <- simpleRandomForest_Prediction(dt_data, name_file, path_model)
  
  return(predictionsDone)
}
