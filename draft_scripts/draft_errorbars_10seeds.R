#draft_errorbars_10seeds.R

load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp1_Holiday_vs_10kPerson_Es201610.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp2_811Holiday_vs_10kPersonAndEvent_Es201610.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp1_Holiday_vs_Person_10kEn201610.RData")

source(paste(getwd(),"/modeling/model_funs.R",sep=""))

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
  
  c50_data1 <- list()
  c50_data1_acc <- list()
  c50_data1_p <- list()
  c50_data1_r <- list()
  for(i in 1:length(list_seeds)){
    print(paste0("iteration: ",i,", seed: ",as.numeric(list_seeds[[i]])))
    # print(i)
    c50_data1[[i]] <- modelWithC50_10fold(dt_data = dt_data1,
                                          name_model = 'c50_data1',id_model = '_1_',
                                          path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                          randomSeed = as.numeric(list_seeds[i]))
    c50_data1_acc[[i]] <- c50_data1[[i]]$acc_mean
    c50_data1_p[[i]] <- c50_data1[[i]]$precision_mean
    c50_data1_r[[i]] <- c50_data1[[i]]$recall_mean
  }
  
  c50_data1_acc_mean <- mean(unlist(c50_data1_acc))
  c50_data1_p_mean <- mean(unlist(c50_data1_p))
  c50_data1_r_mean <- mean(unlist(c50_data1_r))
  
  c50_data1_acc_sd <- sd(unlist(c50_data1_acc))
  c50_data1_p_sd <- sd(unlist(c50_data1_p))
  c50_data1_r_sd <- sd(unlist(c50_data1_r))
  
  results[[k]] <- list()
  results[[k]]$mean_metrics <- list()
  results[[k]]$mean_metrics$accuracy <- c50_data1_acc_mean
  results[[k]]$mean_metrics$presicion <- c50_data1_p_mean
  results[[k]]$mean_metrics$recall <- c50_data1_r_mean
  
  results[[k]]$sd_metrics <- list()
  results[[k]]$sd_metrics$accuracy <- c50_data1_acc_sd
  results[[k]]$sd_metrics$presicion <- c50_data1_p_sd
  results[[k]]$sd_metrics$recall <- c50_data1_r_sd
  
}

setOfAcc <- list()
setOfp <- list()
setOfr <- list()
for(i in 1:5){
  setOfAcc[[i]] <- results[[i]]$mean_metrics$accuracy
  setOfp[[i]] <- results[[i]]$mean_metrics$presicion
  setOfr[[i]] <- results[[i]]$mean_metrics$recall
}
setOfAcc <- unlist(setOfAcc)
setOfp <- unlist(setOfp)
setOfr <- unlist(setOfr)

setOfFmeasure <- (2*setOfp*setOfr)/(setOfp+setOfr)

setOfAcc_sdError <- list()
setOfp_sdError <- list()
setOfr_sdError <- list()
for(i in 1:5){
  setOfAcc_sdError[[i]] <- results[[i]]$sd_metrics$accuracy
  setOfp_sdError[[i]] <- results[[i]]$sd_metrics$presicion
  setOfr_sdError[[i]] <- results[[i]]$sd_metrics$recall
}
setOfAcc_sdError <- unlist(setOfAcc_sdError)
setOfp_sdError <- unlist(setOfp_sdError)
setOfr_sdError <- unlist(setOfr_sdError)
setOfFmeasure_sdError <- (2*setOfp_sdError*setOfr_sdError)/(setOfp_sdError+setOfr_sdError)


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
            error_y = ~list(value = setOfAcc_sdError,
                            color = 'rgb(30,30,30)')) %>%
  add_trace(y = ~setOfp, name = 'precision', type = 'scatter', 
            mode = 'lines+markers', line = list(color = 'rgb(50,50,200)'),
            error_y = ~list(value = as.factor(setOfp_sdError),
                            color = 'rgb(50,50,200)')) %>%
  add_trace(y = ~setOfr, name = 'recall', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgb(200,50,50)'),
            error_y = ~list(value = setOfr_sdError,
                            color = 'rgb(200,50,50)')) %>%
  add_trace(y = ~setOfFmeasure, name = 'f-measure', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgba(200,50,200,1)'),
            error_y = ~list(value = setOfFmeasure_sdError,
                            color = 'rgba(200,50,200,1)')) %>%
  layout(title = "imbalance study Holiday vs Person C5.0 ES201610",
         xaxis = list(title= "data relation 'positive:negative'"),
         yaxis = list(title= "metrics"))

p
