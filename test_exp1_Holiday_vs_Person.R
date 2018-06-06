#!/usr/bin/env Rscript
#test_exp1_Holiday_vs_Person.R

source(paste(getwd(),"/get_oneClassBinaryModel.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
npc1 <- 1000
nc1 <- list()
nc1[[1]] <- "<http://dbpedia.org/ontology/Person>"
nnc1 <- list()
nnc1[[1]] <- 1000
nr <- 1
urlEsDBpedia <- "http://es.dbpedia.org/sparql"
qL <- 10000
test_experiment1 <- get_oneClassBinaryModel(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            numberOfRequest = nr, urlEndpoint = urlEsDBpedia, queryLimit = qL)

save(test_experiment1, file = paste0(getwd(),"/exp1_Holiday_vs_Person.RData"))

