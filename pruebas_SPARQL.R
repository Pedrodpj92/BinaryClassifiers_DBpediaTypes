#pruebas_SPARQL.R

library(SPARQL)

endpoint <- "http://es.dbpedia.org/sparql"
# endpoint <- "http://dbpedia.org/sparql"


# queryParte1 <- "select distinct ?s, ?p
# where {
#   ?s a <http://dbpedia.org/ontology/Holiday> .
#   ?s ?p ?loquesea .
# } OFFSET "

# queryParte1 <- "select distinct ?s, ?p
# where {
# ?s a <http://dbpedia.org/ontology/Person> .
# ?s ?p ?loquesea .
# } OFFSET "

# queryParte1 <- "select distinct ?s, ?p
# where {
# ?s a <http://dbpedia.org/ontology/Event> .
# ?s ?p ?loquesea .
# } OFFSET "

#esta no funciona porque no esta cargada la ontologia
# queryParte1 <- "select distinct ?s, ?p
# where {
# ?s a ?tn1 .
# ?tn1 rdfs:subClassOf <http://www.w3.org/2002/07/owl#Thing> .
# ?s ?p ?loquesea .
# } OFFSET "

#vamos haciendo UNIONs entre los tipos que queramos
queryParte1 <- "select distinct ?s, ?p
where {
  {
    ?s a <http://dbpedia.org/ontology/Activity> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Agent> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/AnatomicalStructure> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Award> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Biomolecule> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/ChemicalSubstance> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Colour> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Currency> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Device> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Disease> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Event> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Food> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Language> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/MeanOfTransportation> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Species> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/SportCompetitionResult> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/TopicalConcept> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Work> .
    ?s ?p ?loquesea .
  }
union
  {
    ?s a <http://dbpedia.org/ontology/Place> .
    ?s ?p ?loquesea .
  }
} OFFSET "


queryParte2 <- " LIMIT 10000"


i <- 0
comprobador <- data.frame(t(c("1","2")))
dt_auxiliar <- data.frame(t(c("1","2")))
colnames(dt_auxiliar) <- c("s","p")
while(nrow(comprobador)!=0){
  qd <- SPARQL(endpoint,paste(queryParte1,
                              as.character(i*10000), #cada iteracion coge 10000
                              queryParte2,sep=""))
  comprobador <- qd$results
  dt_auxiliar <- rbind(dt_auxiliar,qd$results)
  i <- i+1
}
#eliminamos la primera fila que estaba para poder hacer los rbinds
dt_auxiliar <- dt_auxiliar[-1,]

# holidayProperties <- dt_auxiliar
personProperties <- dt_auxiliar
# eventProperties <- dt_auxiliar
# tn1Properties <- dt_auxiliar

# write.table(holidayProperties, file = paste(getwc(),"/omeDataSPARQL/holidayProperties.ttl",sep=""),
            # fileEncoding = "UTF-8", sep = " ", row.names=FALSE, col.names = FALSE, quote = FALSE)
# 
# write.table(personProperties, file = paste(getwc(),"/someDataSPARQL/personProperties.ttl",sep=""),
            # fileEncoding = "UTF-8", sep = " ", row.names=FALSE, col.names = FALSE, quote = FALSE)
# 
# write.table(eventProperties, file = paste(getwc(),"/someDataSPARQL/eventProperties.ttl",sep=""),
            # fileEncoding = "UTF-8", sep = " ", row.names=FALSE, col.names = FALSE, quote = FALSE)
# 
write.table(tn1Properties, file = paste(getwc(),"/someDataSPARQL/tn1Properties.ttl",sep=""),
            fileEncoding = "UTF-8", sep = " ", row.names=FALSE, col.names = FALSE, quote = FALSE)

#queries de interes
# select distinct ?s, ?p
# where {
#   ?s a <http://dbpedia.org/ontology/Holiday> .
#   ?s ?p ?loquesea .
# }
# 
# select distinct ?s, ?p
# where {
#   ?s a <http://dbpedia.org/ontology/Person> .
#   ?s ?p ?loquesea .
# }
# 
# select distinct ?s, ?p
# where {
#   ?s a <http://dbpedia.org/ontology/Event> .
#   ?s ?p ?loquesea .
# }
# 
# #todos los de nivel 1
# select distinct ?s, ?p
# where {
#   ?s a ?tn1 .
#   ?tn1 rdfs:subClassOf <http://www.w3.org/2002/07/owl#Thing> .
#   ?s ?p ?loquesea .
# }


