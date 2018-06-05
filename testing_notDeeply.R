#testing_notDeeply.R

#check testthat package when have time


#testing collecting layer and funs
source(paste(getwd(),"/collecting/fromSPARQL/query_funs.R",sep=""))
source(paste(getwd(),"/get_oneClassBinaryModel.R",sep=""))
#asking_resources funtion
#1 #OK!
asking_resources1_1holidays <- ask_resources(classType = "<http://dbpedia.org/ontology/Holiday>",
                                             numberRequest = 1,
                                             urlEndpoint = "http://es.dbpedia.org/sparql",
                                             queryLimit = 10000)

#2 #OK!
asking_resources2_300holidays <- ask_resources(classType = "<http://dbpedia.org/ontology/Holiday>",
                                               numberRequest = 300,
                                               urlEndpoint = "http://es.dbpedia.org/sparql",
                                               queryLimit = 10000)
asking_resources2andHalf_1000holidays <- ask_resources(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                       numberRequest = 1000,
                                                       urlEndpoint = "http://es.dbpedia.org/sparql",
                                                       queryLimit = 10000)

#3 #OK! (gives an error, should be improved error message?)
asking_resources3_wrongEndpoint <- ask_resources(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                 numberRequest = 300,
                                                 urlEndpoint = "http://es.dbpedia.org/sparqlFAKE",
                                                 queryLimit = 10000)

#4
asking_resources4_moreNumberRequestThanReturnValue <- ask_resources(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                                    numberRequest = 1000,
                                                                    urlEndpoint = "http://es.dbpedia.org/sparql",
                                                                    queryLimit = 10000)
#OK!

#5 #OK!
asking_resources5_1000Person <- ask_resources(classType = "<http://dbpedia.org/ontology/Person>",
                                              numberRequest = 1000,
                                              urlEndpoint = "http://es.dbpedia.org/sparql",
                                              queryLimit = 10000)



#6 OK! (after some debugging......)
asking_resources6_pagination30KPerson <- ask_resources(classType = "<http://dbpedia.org/ontology/Person>",
                                                       numberRequest = 30000,
                                                       urlEndpoint = "http://es.dbpedia.org/sparql",
                                                       queryLimit = 10000)

#7 OK!
asking_resources7_pagination32083Person <- ask_resources(classType = "<http://dbpedia.org/ontology/Person>",
                                                         numberRequest = 32083,
                                                         urlEndpoint = "http://es.dbpedia.org/sparql",
                                                         queryLimit = 10000)
#ask_properties function
#8 OK! after some changes
asking_properties1_1holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                               numberRequest = 1,
                                               urlEndpoint = "http://es.dbpedia.org/sparql",
                                               queryLimit = 10000)
#9 OK!
asking_properties2_30holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                numberRequest = 30,
                                                urlEndpoint = "http://es.dbpedia.org/sparql",
                                                queryLimit = 10000)
#10 FAIL! cannot handle order by and pagination at the same time
asking_properties3_1000holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                  numberRequest = 1000,
                                                  urlEndpoint = "http://es.dbpedia.org/sparql",
                                                  queryLimit = 10000)

#<http://dbpedia.org/resource/ANIMATOR_(festival)>
#<http://dbpedia.org/resource/Africa_Day>
#<http://dbpedia.org/resource/All_Saints'_Day>


#11 OK!
asking_propertiesPerResource1_AfricaDay <- ask_properties_perResource(resource = "<http://dbpedia.org/resource/Africa_Day>",
                                                                      urlEndpoint = "http://es.dbpedia.org/sparql",
                                                                      queryLimit = 10000)
#12 OK! 0 results returned when a fake resource URI is asked, without errors in execution
asking_propertiesPerResource1_fakeResource <- ask_properties_perResource(resource = "<http://dbpedia.org/resource/FakeResource>",
                                                                         urlEndpoint = "http://es.dbpedia.org/sparql",
                                                                         queryLimit = 10000)


#13 getting all properties for 5 resource
asking_properties0_5holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                               numberRequest = 5,
                                               urlEndpoint = "http://es.dbpedia.org/sparql",
                                               queryLimit = 10000)
#14 trying 1000 resources (this class have less than 1000 in EsDBpedia)
asking_properties1_26holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                numberRequest = 26,
                                                urlEndpoint = "http://es.dbpedia.org/sparql",
                                                queryLimit = 10000)

asking_properties2_1000holidays <- ask_properties(classType = "<http://dbpedia.org/ontology/Holiday>",
                                                  numberRequest = 1000,
                                                  urlEndpoint = "http://es.dbpedia.org/sparql",
                                                  queryLimit = 10000)

asking_properties3_1000Person <- ask_properties(classType = "<http://dbpedia.org/ontology/Person>",
                                                numberRequest = 1000,
                                                urlEndpoint = "http://es.dbpedia.org/sparql",
                                                queryLimit = 10000)

asking_properties4_10000Person <- ask_properties(classType = "<http://dbpedia.org/ontology/Person>",
                                                 numberRequest = 10000,
                                                 urlEndpoint = "http://es.dbpedia.org/sparql",
                                                 queryLimit = 10000)

asking_properties4_200000Person <- ask_properties(classType = "<http://dbpedia.org/ontology/Person>",
                                                  numberRequest = 200000,
                                                  urlEndpoint = "http://es.dbpedia.org/sparql",
                                                  queryLimit = 10000)

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


#<http://dbpedia.org/resource/Japanese_New_Year>
#<http://dbpedia.org/resource/Jefferson%E2%80%93Jackson_Day>
# prueba <- ask_properties_perResource("<http://dbpedia.org/resource/Japanese_New_Year>", "http://es.dbpedia.org/sparql", 10000)
# prueba2 <- ask_properties_perResource("<http://dbpedia.org/resource/Jefferson%E2%80%93Jackson_Day>", "http://es.dbpedia.org/sparql", 10000)



