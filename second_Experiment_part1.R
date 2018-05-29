#second_Experiment_part1.R
#comparing Holiday versus Person and Event
#809 Holiday vs 500 Person and 500 Event
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

personProp <- read.csv(file=paste(getwc(),"/someDataSPARQL/es201610/personProperties.ttl",sep=""),
                       header=FALSE, sep=" ", encoding = "UTF-8", stringsAsFactors = FALSE, quote = "")
names(personProp) <- c("s","p")

eventProp <- read.csv(file=paste(getwc(),"/someDataSPARQL/es201610/eventProperties.ttl",sep=""),
                       header=FALSE, sep=" ", encoding = "UTF-8", stringsAsFactors = FALSE, quote = "")
names(eventProp) <- c("s","p")

#seleccion
holidayCases <- original_types[grep("^<http://dbpedia.org/ontology/Holiday>",original_types$o),]
personCases <- original_types[grep("^<http://dbpedia.org/ontology/Person>",original_types$o),]
eventCases <- original_types[grep("^<http://dbpedia.org/ontology/Event>",original_types$o),]

set.seed(as.numeric(1234))
personCases_selection <- personCases[sample(x = nrow(personCases), size = 500, replace = FALSE),]
set.seed(as.numeric(1234))
eventCases_selection <- eventCases[sample(x = nrow(eventCases), size = 500, replace = FALSE),]

holidayProperties <- holidayProp[holidayProp$s %in% holidayCases$s,]
holidaySinProperties <- holidayCases[!(holidayCases$s %in% holidayProperties$s),]

personProperties <- personProp[personProp$s %in% personCases_selection$s,]
eventProperties <- eventProp[eventProp$s %in% eventCases_selection$s,]

types <- rbind(holidayCases,personCases_selection,eventCases)
properties <- rbind(holidayProperties,personProperties,eventProperties)

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
rf_model_Holiday_vs_PersonAndEvent <- h2o.randomForest(
  model_id="rf_model_Holiday_vs_PersonAndEvent",
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
h2o.saveModel(rf_model_Holiday_vs_PersonAndEvent, path=paste(getwc(),"/someModelsHoliday/",sep=""))

