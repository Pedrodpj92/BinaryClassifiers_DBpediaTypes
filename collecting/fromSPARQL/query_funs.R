#query_funs.R

#Description:
#Functions about retrieve RDF data using SPARQL

#remember, numberRequest are on resources, not on triples, points when describing input/output and functions details

#Notes:
#Each query only gets the N first occurences limited by numberRequest, it does not process ramdom samples



ask_resources <- function(classType, offsetInitial, numberRequest, urlEndpoint, queryLimit){
  
  library(SPARQL)
  if(!is.character(classType)|| !is.numeric(offsetInitial) || !is.numeric(numberRequest) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  #in case of would be real numbers instance of integers
  numberRequest <- round(numberRequest)
  queryLimit <- round(queryLimit)
  if(numberRequest<queryLimit){
    queryLimit <- numberRequest
  }
  print("")
  print("")
  print("starting ask_resources function")
  print("")
  print(paste0("quering about DBpedia type: ",classType, " a total of ",numberRequest))
  #pagination, SPARQL as maximun returns queryLimit elements so offset and limit query modifiers are needed.
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
  # print(paste0("remainingLines anterior: ",remainingLines))
  while(nrow(comprobador)!=0 && (i*queryLimit)<numberRequest){
    print("starting loop")
    # print("doing next query:")
    # print(paste0(queryParte1,
    #              as.character(offsetInitial+i*queryLimit), #each iteration gets queryLimit
    #              queryParte2))
    qd <- SPARQL(urlEndpoint,paste0(queryParte1,
                                    as.character(offsetInitial+i*queryLimit), #each iteration gets queryLimit
                                    queryParte2))
    # print("")
    # print(paste0("query done: "))
    # print("")
    # print(paste0(queryParte1,
    #              as.character(offsetInitial+i*queryLimit), #each iteration gets queryLimit
    #              queryParte2))
    # print("")
    
    
    comprobador <- qd$results
    dt_auxiliar <- rbind(dt_auxiliar,qd$results)
    i <- i+1
    remainingLines <- remainingLines-queryLimit
    # print("")
    # print(paste0("printing variables values: "))
    # print(paste0("offsetInitial: ",offsetInitial))
    # print(paste0("i: ",i))
    # print(paste0("queryLimit: ",queryLimit))
    # print(paste0("remainingLines posterior: ",remainingLines))
    print("")
    print(paste0("ending iteration pagination query ",i," retrieved ",nrow(comprobador)," resources"))
    Sys.sleep(1)#endpoint common particularities
  }
  

  
  #deleting first dummy row
  dt_auxiliar <- dt_auxiliar[-1,]
  dt_results <- dt_auxiliar
  
  #first if is when we page several resources (more than 10K as maximum per query) and we need to delete some of last query
  getJustOneIf <- FALSE #really, grep another better example
  if(remainingLines<0 && (nrow(dt_results)+remainingLines)>0 && !getJustOneIf){
    dt_results <- head(dt_results,remainingLines)#remove last lines which are more than requested
    print(paste0("droping out excess of resources requested, now there are ",nrow(dt_results)))
    # print("enter in bad condition")
    # print(nrow(dt_results))
    # print(remainingLines)
    getJustOneIf <- TRUE
  }
  #this another if is when dt_results is more than request and there were not pagination needed
  if(numberRequest<nrow(dt_results) && !getJustOneIf){
    dt_results <- head(dt_results,numberRequest)
    print(paste0("droping out excess of resources requested, now there are ",nrow(dt_results)))
  }
  
  # print(nrow(dt_results))
  
  dropOut_problematiChars <- c('%')#this list can be bigger, some checks must be done with curl, like use '$'
  #there are some encode characteres with problems with RCurl, must check
  dt_results_reduced <- dt_results
  if(!nrow(dt_results)<1){
    for(i in 1:length(dropOut_problematiChars)){
      dt_results_reduced <- dt_results_reduced[!(grepl(dropOut_problematiChars[i],dt_results_reduced[,1], fixed = TRUE)),]
    }
  }

  
  if(nrow(dt_results_reduced)<nrow(dt_results) && nrow(dt_results_reduced)>0){#recursive function, in order to obtain the exact

    # print("")
    # print(paste0("les do some recursivity..."))
    # print("")
    # print(paste0("nrow(dt_results) --> ", nrow(dt_results)))
    # print(paste0("nrow(dt_results_reduced) --> ", nrow(dt_results_reduced)))
    # print("")
    new_requestedResources <- nrow(dt_results)-nrow(dt_results_reduced)
    # print(paste0("new_requestedResources --> ", new_requestedResources))
    # print("")
    new_initialOffset <- nrow(dt_results)+offsetInitial
    print(paste0("queried ",nrow(dt_results)," resources belonging to type: ",classType))
    print(paste0("some bad resources found, trying to get more, exactly: ",new_requestedResources))
    more_resources <- ask_resources(classType, new_initialOffset, new_requestedResources, urlEndpoint, queryLimit)
    dt_results <- rbind(dt_results, more_resources)
  }
  
  
  if(nrow(dt_results)<numberRequest){
    warning(paste0("Warning, requested ",numberRequest," results but only were retrieved ",nrow(dt_results)," results"))
    # stop(paste0("Warning, requested ",numberRequest," results but only were retrieved ",nrow(dt_results)," results")) 
  }
  
  # print(paste0("found resources belonging to type ",dt_results[1,3]," :"))
  # print(dt_results[,1])
  
  return(dt_results)
}

ask_properties_perResource <- function(resource, urlEndpoint, queryLimit){
  library(SPARQL)
  if(!is.character(resource) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  
  queryLimit <- round(queryLimit)
 
  invalidCharacters <- c('%')#problems if we would have to add a whole japanise dictionary for example
  print(resource)
  # if(!invalidCharacteresFound){
  if(!grepl(invalidCharacters, resource, fixed = TRUE)){
    
    queryParte1 <- paste0("
                          select (",resource,") as ?s ?p
                        where {
                        ",resource," ?p ?o .
                        } OFFSET ")
    
    queryParte2 <- paste0(" LIMIT ",queryLimit)
    i <- 0
    comprobador <- data.frame(t(c("s","p")))
    dt_auxiliar <- data.frame(t(c("s","p")))
    colnames(dt_auxiliar) <- c("s","p")
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
      Sys.sleep(1)#endpoint common particularities and limitations
    }
    dt_auxiliar <- dt_auxiliar[-1,]
    dt_results <- dt_auxiliar
    print(paste0("found ",nrow(dt_results)," properties"))
    print("")
    dt_results$s <- as.character(dt_results$s)
    dt_results$s <- as.factor(dt_results$s)
    dt_results$p <- as.character(dt_results$p)
    dt_results$p <- as.factor(dt_results$p)
    return(dt_results)
  }else{
    dt_auxiliar <- data.frame(t(c("s","p")))
    colnames(dt_auxiliar) <- c("s","p")
    dt_auxiliar <- dt_auxiliar[-1,]
    print("improper resource, skipping query")
    dt_auxiliar$s <- as.character(dt_auxiliar$s)
    dt_auxiliar$s <- as.factor(dt_auxiliar$s)
    dt_auxiliar$p <- as.character(dt_auxiliar$p)
    dt_auxiliar$p <- as.factor(dt_auxiliar$p)
    return(dt_auxiliar)
  }
}

ask_properties_iterative <- function(dt_resources, urlEndpoint, queryLimit){
  #check types
  print(paste0("asking properties per resource belonging to type ",dt_resources[1,3]))
  
  #watch out about data frame expected.... s,p,o or s,p
  # dt_auxiliar <- data.frame(t(c("s","p","o")))
  # colnames(dt_auxiliar) <- c("s","p","o")
  dt_auxiliar <- data.frame(t(c("s","p")))
  colnames(dt_auxiliar) <- c("s","p")
  for(i in 1:nrow(dt_resources)){
    print(paste0("resource number ",i))
    if(!is.na(dt_resources[i,1])){
      dt_auxiliar <- rbind(dt_auxiliar,
                           ask_properties_perResource(as.character(dt_resources[i,1]),urlEndpoint,queryLimit))
    }
  }
  dt_auxiliar <- dt_auxiliar[-1,]
  dt_results <- dt_auxiliar
  dt_results$s <- as.character(dt_results$s)
  dt_results$s <- as.factor(dt_results$s)
  dt_results$p <- as.character(dt_results$p)
  dt_results$p <- as.factor(dt_results$p)
  return(dt_results) 
}

# ask_properties <- function(classType, numberRequest, urlEndpoint, queryLimit){
#   #some cheks should be done
#   
#   resourcesCollected <- ask_resources(classType, numberRequest, urlEndpoint, queryLimit)
#   relatedPredicatesCollected <- ask_properties_iterative(resourcesCollected, urlEndpoint, queryLimit)
#   
#   return(relatedPredicatesCollected)
# }

#in this version, resourcesCollected are passed by parameter, replace classType
ask_properties <- function(resourcesCollected, urlEndpoint, queryLimit){
  #some cheks should be done
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
    warning(paste0("Warning, requested ",numberRequest," results but only were retrieved ",nrow(dt_results)," results"))  
  }
  
  return(dt_results)
}


ask_properties_perResource_OLD_retrievingObjects <- function(resource, urlEndpoint, queryLimit){
  library(SPARQL)
  if(!is.character(resource) || !is.character(urlEndpoint) || !is.numeric(queryLimit)){
    stop(paste0("Error, parameter types are not correct"), call.=FALSE)
  }
  
  queryLimit <- round(queryLimit)
  
  #esto dara una query que no devolvera nada, para no hacer malgasto, simplemente comprobar
  # print(resource)
  # resource <- gsub(pattern = '%', replacement = "", x = resource, fixed = TRUE)
  # print(resource)
  
  invalidCharacters <- c('%')#problems if we would have to add a whole japanise dictionary for example
  # invalidCharacters <- c('NA','%E2%80%93')
  #http://dbpedia.org/resource/Jefferson%E2%80%93Jackson_Day
  # invalidCharacteresFound <- FALSE
  # for(i in 1:length(invalidCharacters)){
  #   if(!grepl(invalidCharacters[i], resource, fixed = TRUE)){
  #     invalidCharacteresFound <- TRUE
  #   }
  # }
  print(resource)
  # if(!invalidCharacteresFound){
  if(!grepl(invalidCharacters, resource, fixed = TRUE)){
    
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
  }else{
    dt_auxiliar <- data.frame(t(c("s","p","o")))
    colnames(dt_auxiliar) <- c("s","p","o")
    dt_auxiliar <- dt_auxiliar[-1,]
    print("improper resource, skipping query")
    return(dt_auxiliar)
  }
}

