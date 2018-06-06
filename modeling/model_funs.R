#model_funs.R

simpleRandomForest <- function(dt_data, id_model, randomSeed){
  library(h2o)
  
  
  h2o.init(
    nthreads=-1            ## -1: use all available threads
    #max_mem_size = "2G"
  )
  
  learning <- as.h2o(x = dt_data, destination_frame = "learning.hex")
  rf_model <- h2o.randomForest(
    model_id=paste0("rf_model_",id_model),
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
  # no disk acces for now
  # h2o.saveModel(rf_model, path=paste(getwd(),"/someModelsHoliday/",sep=""))
  
  return(rf_model)
}

