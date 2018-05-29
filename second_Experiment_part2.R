#first_Experiment.R
#809 Holdiday vs 1000 (random) types subClassOf Thing
library(reshape2)
library(h2o)


#carga de datos
original_types <- read.csv(file=paste(getwc(),"/inputData/Es201610/instance_types_completo_es.ttl",sep=""),
                           header=FALSE, sep=" ", encoding = "UTF-8", stringsAsFactors = FALSE)
original_types$V4 <- NULL
names(original_types) <- c("s","p","o")

holidayProp <- read.csv(file=paste(getwc(),"/someDataSPARQL/es201610/holidayProperties.ttl",sep=""),
                        header=FALSE, sep=" ", encoding = "UTF-8", stringsAsFactors = FALSE, quote = "")
names(holidayProp) <- c("s","p")

level1Prop <- read.csv(file=paste(getwc(),"/someDataSPARQL/es201610/level1Properties.ttl",sep=""),
                       header=FALSE, sep=" ", encoding = "UTF-8", stringsAsFactors = FALSE, quote = "")
names(level1Prop) <- c("s","p")


#seleccion
holidayCases <- original_types[grep("^<http://dbpedia.org/ontology/Holiday>",original_types$o),]

activityCases <- original_types[grep("^<http://dbpedia.org/ontology/Activity>",original_types$o),]
agentCases <- original_types[grep("^<http://dbpedia.org/ontology/Agent>",original_types$o),]
anatomicalStructureCases <- original_types[grep("^<http://dbpedia.org/ontology/AnatomicalStructureCases>",original_types$o),]
awardCases <- original_types[grep("^<http://dbpedia.org/ontology/Award>",original_types$o),]
biomoleculeCases <- original_types[grep("^<http://dbpedia.org/ontology/Biomolecule>",original_types$o),]
chemicalSubstanceCases <- original_types[grep("^<http://dbpedia.org/ontology/ChemicalSubstance>",original_types$o),]
colourCases <- original_types[grep("^<http://dbpedia.org/ontology/Colour>",original_types$o),]
currencyCases <- original_types[grep("^<http://dbpedia.org/ontology/Currency>",original_types$o),]
deviceCases <- original_types[grep("^<http://dbpedia.org/ontology/Device>",original_types$o),]
diseaseCases <- original_types[grep("^<http://dbpedia.org/ontology/Disease>",original_types$o),]
eventCases <- original_types[grep("^<http://dbpedia.org/ontology/Event>",original_types$o),]
foodCases <- original_types[grep("^<http://dbpedia.org/ontology/Food>",original_types$o),]
languageCases <- original_types[grep("^<http://dbpedia.org/ontology/Language>",original_types$o),]
meanOfTransportationCases <- original_types[grep("^<http://dbpedia.org/ontology/MeanOfTransportation>",original_types$o),]
speciesCases <- original_types[grep("^<http://dbpedia.org/ontology/Species>",original_types$o),]
sportCompetitionResultCases <- original_types[grep("^<http://dbpedia.org/ontology/SportcompetitionResult>",original_types$o),]
topicalConceptCases <- original_types[grep("^<http://dbpedia.org/ontology/TopicalConcept>",original_types$o),]
workCases <- original_types[grep("^<http://dbpedia.org/ontology/Work>",original_types$o),]
placeCases <- original_types[grep("^<http://dbpedia.org/ontology/Place>",original_types$o),]



set.seed(as.numeric(1234))
activityCases_selection <- activityCases[sample(x = nrow(activityCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
agentCases_selection <- agentCases[sample(x = nrow(agentCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
anatomicalStructureCases_selection <- anatomicalStructureCases[sample(x = nrow(anatomicalStructureCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
awardCases_selection <- awardCases[sample(x = nrow(awardCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
biomoleculeCases_selection <- biomoleculeCases[sample(x = nrow(biomoleculeCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
chemicalSubstanceCases_selection <- chemicalSubstanceCases[sample(x = nrow(chemicalSubstanceCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
colourCases_selection <- colourCases[sample(x = nrow(colourCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
currencyCases_selection <- currencyCases[sample(x = nrow(currencyCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
deviceCases_selection <- deviceCases[sample(x = nrow(deviceCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
diseaseCases_selection <- diseaseCases[sample(x = nrow(diseaseCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
eventCases_selection <- eventCases[sample(x = nrow(eventCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
foodCases_selection <- foodCases[sample(x = nrow(foodCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
languageCases_selection <- languageCases[sample(x = nrow(languageCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
meanOfTransportationCases_selection <- meanOfTransportationCases[sample(x = nrow(meanOfTransportationCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
speciesCases_selection <- speciesCases[sample(x = nrow(speciesCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
sportCompetitionResultCases_selection <- sportCompetitionResultCases[sample(x = nrow(sportCompetitionResultCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
topicalConceptCases_selection <- topicalConceptCases[sample(x = nrow(topicalConceptCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
workCases_selection <- workCases[sample(x = nrow(workCases), size = 50, replace = FALSE),]
set.seed(as.numeric(1234))
placeCases_selection <- placeCases[sample(x = nrow(placeCases), size = 100, replace = FALSE),]


holidayProperties <- holidayProp[holidayProp$s %in% holidayCases$s,]
holidaySinProperties <- holidayCases[!(holidayCases$s %in% holidayProperties$s),]



activityProperties <- level1Prop[level1Prop$s %in% activityCases_selection$s,]
agentProperties <- level1Prop[level1Prop$s %in% agentCases_selection$s,]
anatomicalProperties <- level1Prop[level1Prop$s %in% anatomicalStructureCases_selection$s,]
awardProperties <- level1Prop[level1Prop$s %in% awardCases_selection$s,]
biomoleculeProperties <- level1Prop[level1Prop$s %in% biomoleculeCases_selection$s,]
chemicalProperties <- level1Prop[level1Prop$s %in% chemicalSubstanceCases_selection$s,]
colourProperties <- level1Prop[level1Prop$s %in% colourCases_selection$s,]
currencyProperties <- level1Prop[level1Prop$s %in% currencyCases_selection$s,]
deviceProperties <- level1Prop[level1Prop$s %in% deviceCases_selection$s,]
diseaseProperties <- level1Prop[level1Prop$s %in% diseaseCases_selection$s,]
eventProperties <- level1Prop[level1Prop$s %in% eventCases_selection$s,]
foodProperties <- level1Prop[level1Prop$s %in% foodCases_selection$s,]
languageProperties <- level1Prop[level1Prop$s %in% languageCases_selection$s,]
meanOfTransportationProperties <- level1Prop[level1Prop$s %in% meanOfTransportationCases_selection$s,]
speciesProperties <- level1Prop[level1Prop$s %in% speciesCases_selection$s,]
sportCompetitionResultProperties <- level1Prop[level1Prop$s %in% sportCompetitionResultCases_selection$s,]
topicalConceptProperties <- level1Prop[level1Prop$s %in% topicalConceptCases_selection$s,]
workProperties <- level1Prop[level1Prop$s %in% workCases_selection$s,]
placeProperties <- level1Prop[level1Prop$s %in% placeCases_selection$s,]


types <- rbind(holidayCases,
               activityCases_selection,
               agentCases_selection,
               anatomicalStructureCases_selection,
               awardCases_selection,
               biomoleculeCases_selection,
               chemicalSubstanceCases_selection,
               colourCases_selection,
               currencyCases_selection,
               deviceCases_selection,
               diseaseCases_selection,
               eventCases_selection,
               foodCases_selection,
               languageCases_selection,
               meanOfTransportationCases_selection,
               speciesCases_selection,
               sportCompetitionResultCases_selection,
               topicalConceptCases_selection,
               workCases_selection,
               placeCases_selection)

properties <- rbind(holidayProperties,
                    activityProperties,
                    agentProperties,
                    anatomicalProperties,
                    awardProperties,
                    biomoleculeProperties,
                    chemicalProperties,
                    colourProperties,
                    currencyProperties,
                    deviceProperties,
                    diseaseProperties,
                    eventProperties,
                    foodProperties,
                    languageProperties,
                    meanOfTransportationProperties,
                    speciesProperties,
                    sportCompetitionResultProperties,
                    topicalConceptProperties,
                    workProperties,
                    placeProperties)

learning_Matriz <- properties[,c(1,2)]
learning_Matriz <- dcast(learning_Matriz, s ~ p, fill=0)
learning_Matriz2 <- learning_Matriz[,2:ncol(learning_Matriz)]

prueba <- as.data.frame(lapply(learning_Matriz2, function(x) ifelse(x>0, 1, x)))
prueba <- cbind(learning_Matriz[,1],prueba)
colnames(prueba) <- colnames(learning_Matriz)
learning_Matriz <- prueba

#adding Class
holidayCases$p <- NULL
dt_learning <- merge(x = learning_Matriz, y = holidayCases, by = "s", all.x = TRUE)
dt_learning[is.na(dt_learning)] <- "0"
colnames(dt_learning)[ncol(dt_learning)] <- c("Class")
dt_learning[dt_learning$Class!='0',]$Class <- '1'
dt_learning$Class <- as.factor(dt_learning$Class)

#modelado
h2o.init(
  nthreads=-1            ## -1: use all available threads
  #max_mem_size = "2G"
)

learning <- as.h2o(x = dt_learning, destination_frame = "learning.hex")
rf_model_Holiday_vs_level1 <- h2o.randomForest(
  model_id="rf_model_Holiday_vs_level1",
  training_frame=learning, 
  # validation_frame=valid_test[,2:ncol(valid_test)],
  x=2:(ncol(learning)-1),
  y=ncol(learning),
  nfolds = 10,
  # fold_column = learning[,ncol(learning)],
  ntrees = 200,
  max_depth = 120,
  stopping_rounds = 3,
  score_each_iteration = T,
  seed = 1234)
h2o.saveModel(rf_model_Holiday_vs_level1, path=paste(getwc(),"/someModelsHoliday/",sep=""))


