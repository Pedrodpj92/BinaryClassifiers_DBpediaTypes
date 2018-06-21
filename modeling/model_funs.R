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


modelWithC50_10Kfold <- function(dt_data, name_model, id_model, path_model, randomSeed){
  
  library(plyr)
  library(C50)
  
  
  list_indexes <- createFolds(y = dt_learning$Class, k = 10) #to do folds
  list_folds <- list()
  for(i in 1:length(list_indexes)){
    list_folds[[i]] <- dt_learning[list_indexes[[i]],]
  }
  
  list_learning <- list()
  for(i in 1:length(list_folds)){
    list_learning[[i]]$test <- ldply(list_folds[[i]], data.frame)
    list_learning[[i]]$training <- ldply(list_folds[[-i]], data.frame)
    list_learning[[i]]$trainedModel <- C50::C5.0(list_learning[[i]]$training[2:(ncol(list_learning[[i]]$training)-1)], list_learning[[i]]$training[2:ncol(list_learning[[i]]$training),])
    
    predictedTypes <- predict(object = list_learning[[i]]$trainedModel, newdata = list_learning[[i]]$test[,2:(ncol(list_learning[[i]]$test)-1)])
    predictedTypes <- predictedTypes$predict
    realTypes <- list_learning[[i]]$test[,(ncol(list_learning[[i]]$test))]
    confusionMatrixTypes <- table(predictedTypes,realTypes)
    
    list_learning[[i]]$confusionMatrixTypes <- confusionMatrixTypes
    
  }
  
  
  
  
  final_trainedModel <- C50::C5.0(dt_data[2:(ncol(dt_data)-1)], dt_data[2:ncol(dt_data),])
  
}

