#convert_funs.R

#Description
# Manipulates data to give the proper shape



properties_toColumns <- function(dt_properties,domain_propertiesURI=NULL){
  
  library(reshape2)
  # learning_Matriz <- dt_properties[,c(1,2)]
  if(!is.null(domain_propertiesURI)){
    dt_properties <- dt_properties[grep(domain_propertiesURI,dt_properties[,2]),]
  }
  dt_properties$s <- as.character(dt_properties$s)
  dt_properties$s <- as.factor(dt_properties$s)
  dt_properties$p <- as.character(dt_properties$p)
  dt_properties$p <- as.factor(dt_properties$p)
  learning_Matriz <- dt_properties[,c(1,2)]
  
  learning_Matriz <- dcast(learning_Matriz, s ~ p, fill=0)
  learning_Matriz2 <- learning_Matriz[,2:ncol(learning_Matriz)]
  
  prueba <- as.data.frame(lapply(learning_Matriz2, function(x) ifelse(x>0, 1, x)))
  prueba <- cbind(learning_Matriz[,1],prueba)
  colnames(prueba) <- colnames(learning_Matriz)
  learning_Matriz <- prueba
  
  s <- learning_Matriz[,1]
  learning_Matriz <- learning_Matriz[,-1]
  learning_Matriz <- learning_Matriz[,order(colnames(learning_Matriz))]
  learning_Matriz <- cbind(s,learning_Matriz)
  
  return(learning_Matriz)
}

#two data frames returned by preprocessing_layer (which uses properties_toColumns function), where columns from dt2 are transformed in order to
#adapt to dt1 columns. That implies delete columns from dt2 where are not in dt1 and add "empty" (with 0 values) columns
#from dt1 to dt2.
adaptColumns_DT2_like_DT1 <- function(dt1In, dt2In){#we assume that there are resource column and Class column in each dt
  
  dt1 <- dt1In
  dt2 <- dt2In
  
  names_dt1 <- colnames(dt1)
  names_dt1 <- names_dt1[-ncol(dt1)]
  names_dt1 <- names_dt1[-1]#we do not want order first resource column nor class column
  
  names_dt2 <- colnames(dt2)
  names_dt2 <- names_dt2[-ncol(dt2)]
  names_dt2 <- names_dt2[-1]#we do not want order first resource column nor class column
  
  # resources_dt1 <- dt1[,1]
  s <- dt2[,1] #resource dt2
  Class <- dt2[,ncol(dt2)]
  names_dt1_without_dt2 <- names_dt1[!names_dt1 %in% names_dt2]
  names_dt1_with_dt2 <- names_dt1[names_dt1 %in% names_dt2]
  
  dt2_modified <- dt2[,names_dt1_with_dt2]
  dt2_modified[, names_dt1_without_dt2] <- 0
  
  dt2_modified <- dt2_modified[,order(colnames(dt2_modified))]
  dt2_modified <- cbind(s,dt2_modified,Class)
  
  return(dt2_modified)
}
