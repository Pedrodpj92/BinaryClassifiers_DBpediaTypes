#!/usr/bin/env Rscript
#test_exp2_Holiday_vs_PersonAndEvent.R

source(paste(getwd(),"/get_oneClassBinaryModel.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
npc1 <- 1000
nc1 <- list()
nc1[[1]] <- "<http://dbpedia.org/ontology/Person>"
nc1[[2]] <- "<http://dbpedia.org/ontology/Event>"
nnc1 <- list()
nnc1[[1]] <- 500
nnc1[[2]] <- 500
nr <- 1
urlEsDBpedia <- "http://es.dbpedia.org/sparql"
qL <- 10000

rf_HvsPandE <- "randomForest_HolidayVsPersonAndEvent"
rf_path <- paste0(getwd(),"/")

test_experiment2 <- get_oneClassBinaryModel(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            nameModel = rf_HvsPandE, pathModel = rf_path,
                                            numberOfRequest = nr, urlEndpoint = urlEsDBpedia, queryLimit = qL)

save(test_experiment2, file = paste0(getwd(),"/exp2_Holiday_vs_PersonAndEvent.RData"))


