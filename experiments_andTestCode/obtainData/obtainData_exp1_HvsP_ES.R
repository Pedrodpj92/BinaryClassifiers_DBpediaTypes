#!/usr/bin/env Rscript
#obtainData_exp1_HvsP_ES.R

source(paste(getwd(),"/get_sparqlData_and_Preprocess.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
# npc1 <- 1000 #there are not 1000 Holiday resources in current endpoint
npc1 <- 811 #only 811
nc1 <- list()
nc1[[1]] <- "<http://dbpedia.org/ontology/Person>"
nnc1 <- list()
# nnc1[[1]] <- 1000
nnc1[[1]] <- 811 #so let's take the same amount on negative cases
nr <- 1
urlEsDBpedia <- "http://es.dbpedia.org/sparql"
qL <- 10000
dProp_URI  <- "^<http://dbpedia.org/ontology/"

#"datSPARQL" will be a general name when we wish to sabe in .RData output from get_oneClassBinaryModel
print(paste0("pero que estoy teniendo en el valor de domain_propertiesURI: ", dProp_URI))
dataSPARQL <- get_sparqlData_and_Preprocess(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            urlEndpoint = urlEsDBpedia,queryLimit = qL,
                                            domain_propertiesURI = dProp_URI)

save(dataSPARQL, file = paste0(getwd(),"/inputData/Es201610/data_exp1_Holiday_vs_Person_Es201610.RData"))


