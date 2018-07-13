#draft_errorbars_10seeds.R

# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp1_Holiday_vs_10kPerson_Es201610.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp2_811Holiday_vs_10kPersonAndEvent_Es201610.RData")
load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp1_Holiday_vs_Person_10kEn201610.RData")

source(paste(getwd(),"/modeling/model_funs.R",sep=""))

h2o.init(
  nthreads=-1            ## -1: use all available threads
  #max_mem_size = "2G"
)


dt_learning <- dataSPARQL$predictingSet

positiveCases <- dt_learning[dt_learning$Class == '1',]
negativeCases <- dt_learning[dt_learning$Class == '0',]

list_seeds <- list(1234,
                   2345,
                   3456,
                   4567,
                   5678,
                   6789,
                   7890,
                   1111,
                   5555,
                   9999)

list_negativeImbalance <- list(100,500,1000,5000,10000)
#j = variation seed on data; i = iteration on imbalance negative data
dt_seed_data <- list()
for(j in 1:length(list_seeds)){
  set.seed(j)
  dt_100Pos_index <- sample(nrow(positiveCases),100)
  dt_100Pos <- positiveCases[dt_100Pos_index,]
  dt_Neg_index <- list()
  dt_Neg <- list()
  dt_data <- list()
  for(i in 1:length(list_negativeImbalance)){
    set.seed(j)
    dt_Neg_index[[i]] <- sample(nrow(negativeCases),list_negativeImbalance[[i]])
    dt_Neg[[i]] <- negativeCases[dt_Neg_index[[i]],]
    dt_data[[i]] <- rbind(dt_100Pos,dt_Neg[[i]])
  }
  dt_seed_data[[j]] <- dt_data
}

#de momento 10 semillas en el algoritmo para un conjunto de datos (5 datasets desbalanceados), 
#si no serían 10 semillas para 10 conjuntos de datos (50 datasets, 500 ejecuciones, siendo 10 CV, 5000 entrenamientos)
list_data1 <- dt_seed_data[[1]]

results <- list()
for(k in 1:length(list_data1)){
  dt_data1 <- list_data1[[k]]
  print(paste0("dataset ",k,", nrow: ",nrow(dt_data1)))
  
  rf_data1 <- list()
  rf_data1_acc <- list()
  rf_data1_p <- list()
  rf_data1_r <- list()
  rf_data1_fm <- list()
  for(i in 1:length(list_seeds)){
    print(paste0("iteration: ",i,", seed: ",as.numeric(list_seeds[[i]])))
    # print(i)
    rf_data1[[i]] <- simpleRandomForest(dt_data = dt_data1,
                                          name_model = 'rf_data1',id_model = paste0('_',i,'_'),
                                          path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                          randomSeed = as.numeric(list_seeds[i]))
    # rf_data1_acc[[i]] <- rf_data1[[i]]$acc_mean
    # rf_data1_p[[i]] <- rf_data1[[i]]$precision_mean
    # rf_data1_r[[i]] <- rf_data1[[i]]$recall_mean
    
    validationMetrics <- rf_data1[[i]]@model$cross_validation_metrics_summary
    rf_data1_acc[[i]] <- validationMetrics["accuracy","mean"]
    rf_data1_p[[i]] <- validationMetrics["precision","mean"]
    rf_data1_r[[i]] <- validationMetrics["recall","mean"]
    rf_data1_fm[[i]] <- validationMetrics["f1","mean"]
    
  }
  
  rf_data1_acc_mean <- mean(as.numeric(unlist(rf_data1_acc)))
  rf_data1_p_mean <- mean(as.numeric(unlist(rf_data1_p)))
  rf_data1_r_mean <- mean(as.numeric(unlist(rf_data1_r)))
  rf_data1_fm_mean <- mean(as.numeric(unlist(rf_data1_fm)))
  
  rf_data1_acc_sd <- sd(as.numeric(unlist(rf_data1_acc)))
  rf_data1_p_sd <- sd(as.numeric(unlist(rf_data1_p)))
  rf_data1_r_sd <- sd(as.numeric(unlist(rf_data1_r)))
  rf_data1_fm_sd <- sd(as.numeric(unlist(rf_data1_fm)))
  
  results[[k]] <- list()
  results[[k]]$mean_metrics <- list()
  results[[k]]$mean_metrics$accuracy <- rf_data1_acc_mean
  results[[k]]$mean_metrics$presicion <- rf_data1_p_mean
  results[[k]]$mean_metrics$recall <- rf_data1_r_mean
  results[[k]]$mean_metrics$fmeasure <- rf_data1_fm_mean
  
  results[[k]]$sd_metrics <- list()
  results[[k]]$sd_metrics$accuracy <- rf_data1_acc_sd
  results[[k]]$sd_metrics$presicion <- rf_data1_p_sd
  results[[k]]$sd_metrics$recall <- rf_data1_r_sd
  results[[k]]$sd_metrics$fmeasure <- rf_data1_fm_sd
  
}

setOfAcc <- list()
setOfp <- list()
setOfr <- list()
setOfFmeasure <- list()
for(i in 1:5){
  setOfAcc[[i]] <- results[[i]]$mean_metrics$accuracy
  setOfp[[i]] <- results[[i]]$mean_metrics$presicion
  setOfr[[i]] <- results[[i]]$mean_metrics$recall
  setOfFmeasure[[i]] <- results[[i]]$mean_metrics$fmeasure
}
setOfAcc <- unlist(setOfAcc)
setOfp <- unlist(setOfp)
setOfr <- unlist(setOfr)
setOfFmeasure <- unlist(setOfFmeasure)

setOfFmeasure_compara <- (2*setOfp*setOfr)/(setOfp+setOfr)

setOfAcc_sdError <- list()
setOfp_sdError <- list()
setOfr_sdError <- list()
setOfFmeasure_sdError <- list()
for(i in 1:5){
  setOfAcc_sdError[[i]] <- results[[i]]$sd_metrics$accuracy
  setOfp_sdError[[i]] <- results[[i]]$sd_metrics$presicion
  setOfr_sdError[[i]] <- results[[i]]$sd_metrics$recall
  setOfFmeasure_sdError[[i]] <- results[[i]]$sd_metrics$fmeasure
}
setOfAcc_sdError <- unlist(setOfAcc_sdError)
setOfp_sdError <- unlist(setOfp_sdError)
setOfr_sdError <- unlist(setOfr_sdError)
setOfFmeasure_sdError <- unlist(setOfFmeasure_sdError)

setOfFmeasure_sdError_compara <- (2*setOfp_sdError*setOfr_sdError)/(setOfp_sdError+setOfr_sdError)


library(plotly)

imbalance_labels <- c('1:1','1:5','1:10','1:50','1:100')

all_metrics <- data.frame(imbalance_labels,
                          setOfAcc,setOfAcc_sdError,
                          setOfp,setOfp_sdError,
                          setOfr,setOfr_sdError,
                          setOfFmeasure,setOfFmeasure_sdError)

all_metrics$imbalance_labels <- factor(all_metrics$imbalance_labels,
                                       levels = all_metrics[["imbalance_labels"]])

p <- plot_ly(all_metrics, x = ~imbalance_labels) %>%
  add_trace(y = ~setOfAcc, name = 'accuracy', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgb(30,30,30)'),
            error_y = ~list(type="data",
                            array = setOfAcc_sdError,
                            color = 'rgb(30,30,30)')) %>%
  add_trace(y = ~setOfp, name = 'precision', type = 'scatter', 
            mode = 'lines+markers', line = list(color = 'rgb(50,50,200)'),
            error_y = ~list(type="data",
                            array = as.factor(setOfp_sdError),
                            color = 'rgb(50,50,200)')) %>%
  add_trace(y = ~setOfr, name = 'recall', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgb(200,50,50)'),
            error_y = ~list(type="data",
                            array = setOfr_sdError,
                            color = 'rgb(200,50,50)')) %>%
  add_trace(y = ~setOfFmeasure, name = 'f-measure', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgba(200,50,200,1)'),
            error_y = ~list(type="data",
                            array = setOfFmeasure_sdError,
                            color = 'rgba(200,50,200,1)')) %>%
  layout(title = "imbalance study Holiday vs Person RF_H2O EN201610",
         xaxis = list(title= "data relation 'positive:negative'"),
         yaxis = list(title= "metrics"))

p
