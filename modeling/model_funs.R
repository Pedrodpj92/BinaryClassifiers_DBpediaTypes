#model_funs.R

simpleRandomForest <- function(dt_data, name_model, id_model, path_model, randomSeed){
  library(h2o)
  
  
  h2o.init(
    nthreads=-1            ## -1: use all available threads
    #max_mem_size = "2G"
  )
  
  learning <- as.h2o(x = dt_data, destination_frame = "learning.hex")
  rf_model <- h2o.randomForest(
    model_id=paste0(name_model,id_model),
    training_frame=learning, 
    # validation_frame=dt_data[,2:ncol(dt_data)],
    x=2:(ncol(learning)-1),
    y=ncol(learning),
    nfolds = 10,
    ntrees = 200,
    max_depth = 120,
    stopping_rounds = 3,
    score_each_iteration = T,
    seed = randomSeed)
  summary(rf_model)
  h2o.saveModel(rf_model, path=path_model)
  
  h2o.shutdown(prompt = FALSE)
  
  return(rf_model)
}


simpleRandomForest_Prediction <- function(dt_data, name_file, path_model){
  library(h2o)
  h2o.init(
    nthreads=-1            ## -1: use all available threads
    #max_mem_size = "2G"
  )
  trainedModel <- h2o.loadModel(path = paste0(path_model,name_file))
  predicting <- as.h2o(dt_data)
  rf_predictions <- h2o.predict(trainedModel,predicting[,c(2:ncol(predicting))])
  
  rf_predictions <- as.data.frame(rf_predictions)
  
  h2o.shutdown(prompt = FALSE)
  return(rf_predictions)
}

