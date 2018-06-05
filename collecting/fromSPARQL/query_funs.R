#query_funs.R

#Description:
#Functions about retrieve RDF data using SPARQL

#remember, numberRequest are on resources, not on triples, points when describing input/output and functions details

#Notes:
#Each query only gets the N first occurences limited by numberRequest, it does not process ramdom samples



ask_resources <- function(classType, numberRequest, urlEndpoint, queryLimit){
  library(SPARQL)
  if(!is.character(classType) || !is.numeric(numberRequest) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  #in case of would be real numbers instance of integers
  numberRequest <- round(numberRequest)
  queryLimit <- round(queryLimit)
  
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
    comprobador <- data.frame(t(c("s","p","o")))
    dt_auxiliar <- data.frame(t(c("s","p","o")))
    colnames(dt_auxiliar) <- c("s","p","o")
    remainingLines <- numberRequest
    while(nrow(comprobador)!=0 && (i*queryLimit)<numberRequest){
      print("starting loop")
      qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                      as.character(i*queryLimit), #each iteration gets queryLimit
                                      queryParte2))
      comprobador <- qd$results
      dt_auxiliar <- rbind(dt_auxiliar,qd$results)
      i <- i+1
      remainingLines <- remainingLines-queryLimit
      print(paste0("ending iteration pagination query ",i))
      Sys.sleep(1)#endpoint common particularities
    }
    #deleting first dummy row
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
    if(remainingLines<0){
      dt_results <- head(dt_results,remainingLines)#remove last lines which are more than requested
    }
  }
  
  if(nrow(dt_results)<numberRequest){
    warning(paste0("requested ",numberRequest," results but only were retrieved ",nrow(dt_results)," results"))  
  }
  
  return(dt_results)
}

ask_properties_perResource <- function(resource, urlEndpoint, queryLimit){
  library(SPARQL)
  if(!is.character(resource) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  
  queryLimit <- round(queryLimit)
  
  #esto dara una query que no devolvera nada, para no hacer malgasto, simplemente comprobar
  # print(resource)
  # resource <- gsub(pattern = '%', replacement = "", x = resource, fixed = TRUE)
  # print(resource)
  invalidCharacters <- c('%')#problems if we would have to add a whole japanise dictionary for instance
  
  if(!resource %in% invalidCharacters){
    queryParte1 <- paste0("
                          select distinct (",resource,") as ?s ?p ?o
                        where {
                        ",resource," ?p ?o .
                        } OFFSET ")
    
    queryParte2 <- paste0(" LIMIT ",queryLimit)
    i <- 0
    comprobador <- data.frame(t(c("s","p","o")))
    dt_auxiliar <- data.frame(t(c("s","p","o")))
    colnames(dt_auxiliar) <- c("s","p","o")
    stackedResources <- 0
    while(nrow(comprobador)!=0){#we want N resources, NOT N triples
      # print("starting loop")
      qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                      as.character(i*queryLimit), #each iteration gets queryLimit
                                      queryParte2))
      comprobador <- qd$results
      dt_auxiliar <- rbind(dt_auxiliar,qd$results)
      i <- i+1
      # print(paste0("ending iteration pagination query ",i))
      Sys.sleep(1)#endpoint common particularities
    }
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
    
    return(dt_results)
  }
  
  ask_properties_iterative <- function(dt_resources, urlEndpoint, queryLimit){
    #check types
    
    dt_auxiliar <- data.frame(t(c("s","p","o")))
    colnames(dt_auxiliar) <- c("s","p","o")
    for(i in 1:nrow(dt_resources)){
      dt_auxiliar <- rbind(dt_auxiliar,ask_properties_perResource(as.character(dt_resources[i,1]),urlEndpoint,queryLimit))
      print(paste0("resource number ",i))
    }
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
    dt_results$s <- as.character(dt_results$s)
    dt_results$s <- as.factor(dt_results$s)
    return(dt_results)
  }else{
    dt_auxiliar <- data.frame(t(c("s","p","o")))
    dt_auxiliar <- dt_auxiliar[-1,]
    
    return(dt_auxiliar)
  }
}

ask_properties <- function(classType, numberRequest, urlEndpoint, queryLimit){
  #some cheks should be done
  
  resourcesCollected <- ask_resources(classType, numberRequest, urlEndpoint, queryLimit)
  relatedPredicatesCollected <- ask_properties_iterative(resourcesCollected, urlEndpoint, queryLimit)
  
  return(relatedPredicatesCollected)
}


#Not usefull for queries with more than 10K results
ask_properties_OLD <- function(classType, numberRequest, urlEndpoint, queryLimit){
  #This query is too complex to current SPARQL endpoints,
  #better 1 query for resources and after that 1 query per each resourcer in order to get properties
  library(SPARQL)
  if(!is.character(classType) || !is.numeric(numberRequest) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  #in case of would be real numbers instance of integers
  numberRequest <- round(numberRequest)
  queryLimit <- round(queryLimit)
  
  #pagination, SPARQL as maximun returns queryLimit elements so offset and limit query modifiers are needed.
  # if(numberRequest<queryLimit){
  #   stringQuery <- paste0("
  #                         select distinct ?s ?p ?o
  #                         where {
  #                         ?s a ", classType," .
  #                         ?s ?p ?o .
  #                         FILTER regex(?p, \"dbpedia.org\") .
  #                         } ORDER BY ?s limit ",numberRequest)
  #   qd <- SPARQL(urlEndpoint,stringQuery)
  #   dt_results <- qd$results
  # }else{
  queryParte1 <- paste0("
                          select distinct ?s ?p ?o
                          where {
                          ?s a ",classType," .
                          ?s ?p ?o .
                          FILTER regex(?p, \"dbpedia.org\") .
                          } ORDER BY ?s OFFSET ")
  
  queryParte2 <- paste0(" LIMIT ",queryLimit)
  i <- 0
  comprobador <- data.frame(t(c("s","p","o")))
  dt_auxiliar <- data.frame(t(c("s","p","o")))
  colnames(dt_auxiliar) <- c("s","p","o")
  # remainingLines <- numberRequest
  stackedResources <- 0
  while(nrow(comprobador)!=0 && stackedResources<numberRequest){#we want N resources, NOT N triples
    print("starting loop")
    qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                    as.character(i*queryLimit), #each iteration gets queryLimit
                                    queryParte2))
    comprobador <- qd$results
    dt_auxiliar <- rbind(dt_auxiliar,qd$results)
    i <- i+1
    stackedResources <- stackedResources+nrow(as.data.frame(table(comprobador$s)))#we want N resources, NOT N triples
    # print(stackedResources)
    # remainingLines <- remainingLines-queryLimit
    # print(remainingLines)
    print(paste0("ending iteration pagination query ",i))
    Sys.sleep(1)#endpoint common particularities
  }
  #deleting first dummy row
  dt_auxiliar <- dt_auxiliar[-1,]
  dt_results <- dt_auxiliar
  if((numberRequest-stackedResources)<0){
    onlyResources_dt_results <- as.data.frame(table(dt_results$s))
    onlyResources_dt_results <- head(onlyResources_dt_results,(numberRequest-stackedResources))#remove last resources which are more than requested
    onlyResources_dt_results$Var1 <- as.character(onlyResources_dt_results$Var1)
    dt_results$s <- as.character(dt_results$s)
    dt_results$p <- as.character(dt_results$p)
    dt_results$o <- as.character(dt_results$o)
    dt_results <- dt_results[dt_results$s %in% onlyResources_dt_results$Var1,]
    dt_results$s <- as.factor(dt_results$s)
    dt_results$p <- as.factor(dt_results$p)
    dt_results$o <- as.factor(dt_results$o)
  }
  # }
  
  if(nrow(dt_results)<numberRequest){
    warning(paste0("requested ",numberRequest," results but only were retrieved ",nrow(dt_results)," results"))  
  }
  
  return(dt_results)
}
