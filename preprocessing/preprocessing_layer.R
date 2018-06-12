#preprocessing_layer.R

source(paste(getwd(),"/preprocessing/convert_funs.R",sep=""))


#Description
#This section has as goal to reshape and modify collected data in order to feed Machine Learning models properly at next phase.

#Input
# - 


#Output
# - 


#Exceptions


#Notes
# - Types data frames in this version are not really used, it is enought with properties, but in this way some checks could be done and will be ready for future updates


preprocessing_layer <- function(positive_types, positive_properties,
                                negative_types, negative_properties,domain_propertiesURI=NULL){
  
  stackedNegativeProperties <- vector('list',length(negative_properties))
  for(i in 1:length(negative_properties)){
    stackedNegativeProperties <- rbind(stackedNegativeProperties,negative_properties[[i]])
  }
  
  properties <- rbind(positive_properties,stackedNegativeProperties)
  positiveResources <- data.frame(table(positive_properties$s))
  # if(!is.null(domain_propertiesURI)){
  #   learning_Matriz <- properties_toColumns(properties,domain_propertiesURI)
  # }else{
  #   learning_Matriz <- properties_toColumns(properties)
  # }
  learning_Matriz <- properties_toColumns(properties,domain_propertiesURI)
  
  
  #adding class
  learning_Matriz$Class <- 0
  learning_Matriz[learning_Matriz$s %in% positiveResources$Var1,]$Class <- 1
  learning_Matriz$Class <- as.character(learning_Matriz$Class)
  learning_Matriz$Class <- as.factor(learning_Matriz$Class)
  
  return(learning_Matriz)
}

preprocessing_layer_prediction <- function(trainingData,properties_list,domain_propertiesURI=NULL){
  
  stackedProperties <- vector('list',length(properties_list))
  for(i in 1:length(properties_list)){
    stackedProperties <- rbind(stackedProperties,properties_list[[i]])
  }
  predicting_Matriz <- properties_toColumns(stackedProperties,domain_propertiesURI)
  
  #In this way, properties where not appear in training data will be cut off from predicting matrix,
  #and new "dummy" properties will added where not appear in predicting matrix (but they does in training data) 
  predicting_Matriz <- adaptColumns_DT2_like_DT1(dt1 = trainingData, dt2 = predicting_Matriz)
  
  return(predicting_Matriz)
}
  
  
  