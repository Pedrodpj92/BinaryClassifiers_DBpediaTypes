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
                                negative_types, negative_properties){
  
  stackedNegativeProperties <- vector('list',length(negative_properties))
  for(i in 1:length(negative_properties)){
    stackedNegativeProperties <- rbind(stackedNegativeProperties,negative_properties[[i]])
  }
  
  properties <- rbind(positive_properties,stackedNegativeProperties)
  positiveResources <- data.frame(table(positive_properties$s))
  
  learning_Matriz <- properties_toColumns(properties)
  
  #adding class
  learning_Matriz$Class <- 0
  learning_Matriz[learning_Matriz$s %in% positiveResources$Var1,]$Class <- 1
  learning_Matriz$Class <- as.character(learning_Matriz$Class)
  learning_Matriz$Class <- as.factor(learning_Matriz$Class)
  
  return(learning_Matriz)
}
  
  
  