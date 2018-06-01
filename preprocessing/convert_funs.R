#convert_funs.R

#Description
# Manipulates data to give the proper shape



properties_toColumns <- function(dt_properties){
  
  library(reshape2)
  learning_Matriz <- dt_properties[,c(1,2)]
  learning_Matriz <- dcast(learning_Matriz, s ~ p, fill=0)
  learning_Matriz2 <- learning_Matriz[,2:ncol(learning_Matriz)]
  
  prueba <- as.data.frame(lapply(learning_Matriz2, function(x) ifelse(x>0, 1, x)))
  prueba <- cbind(learning_Matriz[,1],prueba)
  colnames(prueba) <- colnames(learning_Matriz)
  learning_Matriz <- prueba
  
  return(learning_Matriz)
}

