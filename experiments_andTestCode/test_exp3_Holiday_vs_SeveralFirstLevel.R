#!/usr/bin/env Rscript
#test_exp3_Holiday_vs_SeveralFirstLevel.R

source(paste(getwd(),"/get_oneClassBinaryModel.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
npc1 <- 1000
nc1 <- list()
nc1[[1]] <- "<http://dbpedia.org/ontology/Activity>"
nc1[[2]] <- "<http://dbpedia.org/ontology/Agent>"
nc1[[3]] <- "<http://dbpedia.org/ontology/AnatomicalStructure>"
nc1[[4]] <- "<http://dbpedia.org/ontology/Award>"
nc1[[5]] <- "<http://dbpedia.org/ontology/Biomolecule>"
nc1[[6]] <- "<http://dbpedia.org/ontology/ChemicalSubstance>"
nc1[[7]] <- "<http://dbpedia.org/ontology/Colour>"
nc1[[8]] <- "<http://dbpedia.org/ontology/Currency>"
nc1[[9]] <- "<http://dbpedia.org/ontology/Device>"
nc1[[10]] <- "<http://dbpedia.org/ontology/Disease>"
nc1[[11]] <- "<http://dbpedia.org/ontology/Event>"
nc1[[12]] <- "<http://dbpedia.org/ontology/Food>"
nc1[[13]] <- "<http://dbpedia.org/ontology/Language>"
nc1[[14]] <- "<http://dbpedia.org/ontology/MeanOfTransportation>"
nc1[[15]] <- "<http://dbpedia.org/ontology/Species>"
nc1[[16]] <- "<http://dbpedia.org/ontology/SportCompetitionResult>"
nc1[[17]] <- "<http://dbpedia.org/ontology/TopicalConcept>"
nc1[[18]] <- "<http://dbpedia.org/ontology/Work>"
nc1[[19]] <- "<http://dbpedia.org/ontology/Place>"
nnc1 <- list()
nnc1[[1]] <- 50
nnc1[[2]] <- 50
nnc1[[3]] <- 50
nnc1[[4]] <- 50
nnc1[[5]] <- 50
nnc1[[6]] <- 50
nnc1[[7]] <- 50
nnc1[[8]] <- 50
nnc1[[9]] <- 50
nnc1[[10]] <- 50
nnc1[[11]] <- 50
nnc1[[12]] <- 50
nnc1[[13]] <- 50
nnc1[[14]] <- 50
nnc1[[15]] <- 50
nnc1[[16]] <- 50
nnc1[[17]] <- 50
nnc1[[18]] <- 50
nnc1[[19]] <- 100
nr <- 1
urlEsDBpedia <- "http://es.dbpedia.org/sparql"
qL <- 10000

rf_HvsL1T <- "randomForest_HolidayVsLevel1Types"
rf_path <- paste0(getwd(),"/")

test_experiment3 <- get_oneClassBinaryModel(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            nameModel = rf_HvsL1T, pathModel = rf_path,
                                            numberOfRequest = nr, urlEndpoint = urlEsDBpedia, queryLimit = qL)

save(test_experiment3, file = paste0(getwd(),"/exp3_Holiday_vs_SeveralFirstLevel.RData"))


