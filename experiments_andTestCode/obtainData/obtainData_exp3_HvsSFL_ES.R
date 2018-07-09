#!/usr/bin/env Rscript
#obtainData_exp1_HvsP_ES.R

source(paste(getwd(),"/get_sparqlData_and_Preprocess.R",sep=""))

pc1 <- "<http://dbpedia.org/ontology/Holiday>"
npc1 <- 811
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
nnc1[[1]] <- 40
nnc1[[2]] <- 40
nnc1[[3]] <- 40
nnc1[[4]] <- 40
nnc1[[5]] <- 40
nnc1[[6]] <- 40
nnc1[[7]] <- 40
nnc1[[8]] <- 40
nnc1[[9]] <- 40
nnc1[[10]] <- 40
nnc1[[11]] <- 40
nnc1[[12]] <- 40
nnc1[[13]] <- 40
nnc1[[14]] <- 40
nnc1[[15]] <- 40
nnc1[[16]] <- 40
nnc1[[17]] <- 40
nnc1[[18]] <- 40
nnc1[[19]] <- 91
urlEsDBpedia <- "http://es.dbpedia.org/sparql"
qL <- 10000

dProp_URI  <- "^<http://dbpedia.org/ontology/"

#"datSPARQL" will be a general name when we wish to sabe in .RData output from get_oneClassBinaryModel
dataSPARQL <- get_sparqlData_and_Preprocess(positiveClass = pc1, numberPositiveCases = npc1,
                                            negativeClasses = nc1, numberNegativeCases = nnc1,
                                            urlEndpoint = urlEsDBpedia,queryLimit = qL,
                                            domain_propertiesURI = dProp_URI)

save(dataSPARQL, file = paste0(getwd(),"/inputData/Es201610/data_exp3_Holiday_vs_SeveralFirstLevel_Es201610.RData"))


