#query_funs.R

#Description:
#Functions about retrieve RDF data using SPARQL

#Notes:
#Each query only gets the N first occurences limited by numberRequest, it does not process ramdom samples

library(SPARQL)

ask_types <- function(classType, numberRequest, urlEndpoint, queryLimit){
  
  if(!is.character(classType) || !is.integer(numberRequest) || !is.character(urlEndpoint) || !is.integer(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  
  #pagination, SPARQL as maximun returns queryLimit elements so offset and limit query modifiers are needed.
  if(numberRequest<queryLimit){
    stringQuery <- paste0("
                    select distinct ?s (<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>) as ?p (",classType,") as ?o
                    where {
                    ?s a ", classType," .
                    } limit ",numberRequest)
    qd <- SPARQL(urlEndpoint,stringQuery)
    dt_results <- qd$results
  }else{
    queryParte1 <- paste0("
                    select distinct ?s (<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>) as ?p (",classType,") as ?o
                    where {
                    ?s a ",classType," .
                    } OFFSET ")
    
    queryParte2 <- paste0(" LIMIT ",queryLimit)
    i <- 0
    comprobador <- data.frame(t(c("1","2","3")))
    dt_auxiliar <- data.frame(t(c("1","2","3")))
    colnames(dt_auxiliar) <- c("s","p","o")
    while(nrow(comprobador)!=0 || (i*queryLimit)>numberRequest){
      qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                  as.character(i*queryLimit), #each iteration gets queryLimit
                                  queryParte2))
      comprobador <- qd$results
      dt_auxiliar <- rbind(dt_auxiliar,qd$results)
      i <- i+1
      Sys.sleep(2)#endpoint common particularities
    }
    #deleting first dummy row
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
  }
  
  return(dt_results)
}


ask_properties <- function(classType, numberRequest, urlEndpoint, queryLimit){
  if(!is.character(classType) || !is.integer(numberRequest) || !is.character(urlEndpoint) || !is.integer(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  
  #pagination, SPARQL as maximun returns queryLimit elements so offset and limit query modifiers are needed.
  if(numberRequest<queryLimit){
    stringQuery <- paste0("
                          select distinct ?s ?p ?o
                          where {
                          ?s a ", classType," .
                          ?s ?p ?o .
                          } limit ",numberRequest)
    qd <- SPARQL(urlEndpoint,stringQuery)
    dt_results <- qd$results
  }else{
    queryParte1 <- paste0("
                          select distinct ?s ?p ?o
                          where {
                          ?s a ",classType," .
                          ?s ?p ?o .
                          } OFFSET ")
    
    queryParte2 <- paste0(" LIMIT ",queryLimit)
    i <- 0
    comprobador <- data.frame(t(c("1","2","3")))
    dt_auxiliar <- data.frame(t(c("1","2","3")))
    colnames(dt_auxiliar) <- c("s","p","o")
    while(nrow(comprobador)!=0 || (i*queryLimit)>numberRequest){
      qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                   as.character(i*queryLimit), #each iteration gets queryLimit
                                   queryParte2))
      comprobador <- qd$results
      dt_auxiliar <- rbind(dt_auxiliar,qd$results)
      i <- i+1
      Sys.sleep(2)#endpoint common particularities
    }
    #deleting first dummy row
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
  }
  
  return(dt_results)
}
