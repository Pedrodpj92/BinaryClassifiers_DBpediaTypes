#!/usr/bin/env Rscript
#obtainData_exp1_HvsP_ES.R

source(paste(getwd(),"/get_sparqlData_and_Preprocess.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
npc1 <- 811
nc1 <- list()
nc1[[1]] <- "<http://dbpedia.org/ontology/Person>"
nc1[[2]] <- "<http://dbpedia.org/ontology/Event>"
nnc1 <- list()
# nnc1[[1]] <- 406
# nnc1[[2]] <- 406
nnc1[[1]] <- 5000
nnc1[[2]] <- 5000
nr <- 1
urlEnDBpedia <- "http://dbpedia.org/sparql"
qL <- 10000
dProp_URI  <- "^<http://dbpedia.org/ontology/"

#"datSPARQL" will be a general name when we wish to sabe in .RData output from get_oneClassBinaryModel
dataSPARQL <- get_sparqlData_and_Preprocess(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            urlEndpoint = urlEnDBpedia,queryLimit = qL,
                                            domain_propertiesURI = dProp_URI)

save(dataSPARQL, file = paste0(getwd(),"/inputData/En201610/data_exp2_811Holiday_vs_10kPersonAndEvent_Es201610.RData"))


