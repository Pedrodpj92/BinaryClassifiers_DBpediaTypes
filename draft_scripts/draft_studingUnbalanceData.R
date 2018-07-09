
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp1_Holiday_vs_10kPerson_Es201610.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp2_811Holiday_vs_10kPersonAndEvent_Es201610.RData")
load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp1_Holiday_vs_Person_10kEn201610.RData")

source(paste(getwd(),"/modeling/model_funs.R",sep=""))

dt_learning <- dataSPARQL$predictingSet

positiveCases <- dt_learning[dt_learning$Class == '1',]
negativeCases <- dt_learning[dt_learning$Class == '0',]

set.seed(1234)
dt_100Pos_index <- sample(nrow(positiveCases),100)
dt_100Pos <- positiveCases[dt_100Pos_index,]

set.seed(1234)
dt_100Neg_index <- sample(nrow(negativeCases),100)
dt_100Neg <- negativeCases[dt_100Neg_index,]

set.seed(1234)
dt_500Neg_index <- sample(nrow(negativeCases),500)
dt_500Neg <- negativeCases[dt_500Neg_index,]

set.seed(1234)
dt_1000Neg_index <- sample(nrow(negativeCases),1000)
dt_1000Neg <- negativeCases[dt_1000Neg_index,]

set.seed(1234)
dt_5000Neg_index <- sample(nrow(negativeCases),5000)
dt_5000Neg <- negativeCases[dt_5000Neg_index,]

dt_10000Neg <- negativeCases

dt_1per1 <- rbind(dt_100Pos,dt_100Neg)
dt_1per5 <- rbind(dt_100Pos,dt_500Neg)
dt_1per10 <- rbind(dt_100Pos,dt_1000Neg)
dt_1per50 <- rbind(dt_100Pos,dt_5000Neg)
dt_1per100 <- rbind(dt_100Pos,dt_10000Neg)

# rf_1per1 <- simpleRandomForest(dt_data = dt_1per1,
#                                name_model = 'rf_1per1',id_model = '_1',
#                                path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
#                                randomSeed = 1234)
# acc_rf_1per1 <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per1))
# p_acc_rf_1per1 <- get_precisionfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per1))
c50_1per1 <- modelWithC50_10fold(dt_data = dt_1per1,
                                 name_model = 'c50_1per1',id_model = '_1',
                                 path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                 randomSeed = 1234)

# rf_1per5 <- simpleRandomForest(dt_data = dt_1per5,
#                                name_model = 'rf_1per5',id_model = '_1',
#                                path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
#                                randomSeed = 1234)
# acc_rf_1per5 <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per5))
# p_acc_rf_1per5 <- get_precisionfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per5))
c50_1per5 <- modelWithC50_10fold(dt_data = dt_1per5,
                                 name_model = 'c50_1per5',id_model = '_1',
                                 path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                 randomSeed = 1234)

# rf_1per10 <- simpleRandomForest(dt_data = dt_1per10,
#                                 name_model = 'rf_1per10',id_model = '_1',
#                                 path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
#                                 randomSeed = 1234)
# acc_rf_1per10 <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per10))
# p_acc_rf_1per10 <- get_precisionfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per10))
c50_1per10 <- modelWithC50_10fold(dt_data = dt_1per10,
                                  name_model = 'c50_1per10',id_model = '_1',
                                  path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                  randomSeed = 1234)

# rf_1per50 <- simpleRandomForest(dt_data = dt_1per50,
#                                 name_model = 'rf_1per50',id_model = '_1',
#                                 path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
#                                 randomSeed = 1234)
# acc_rf_1per50 <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per50))
# p_acc_rf_1per50 <- get_precisionfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per50))
c50_1per50 <- modelWithC50_10fold(dt_data = dt_1per50,
                                  name_model = 'c50_1per50',id_model = '_1',
                                  path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                  randomSeed = 1234)

# rf_1per100 <- simpleRandomForest(dt_data = dt_1per100,
#                                  name_model = 'rf_1per100',id_model = '_1',
#                                  path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
#                                  randomSeed = 1234)
# acc_rf_1per100 <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per100))
# p_acc_rf_1per100 <- get_precisionfromConfMat_bin(confMat = h2o.confusionMatrix(rf_1per100))
c50_1per100 <- modelWithC50_10fold(dt_data = dt_1per100,
                                   name_model = 'c50_1per100',id_model = '_1',
                                   path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                   randomSeed = 1234)

# print(acc_rf_1per1)
# print(acc_rf_1per5)
# print(acc_rf_1per10)
# print(acc_rf_1per50)
# print(acc_rf_1per100)
# 
# print(p_acc_rf_1per1)
# print(p_acc_rf_1per5)
# print(p_acc_rf_1per10)
# print(p_acc_rf_1per50)
# print(p_acc_rf_1per100)

print("accuracy:")
print(c50_1per1$acc_mean)
print(c50_1per5$acc_mean)
print(c50_1per10$acc_mean)
print(c50_1per50$acc_mean)
print(c50_1per100$acc_mean)

print("")
print("precision:")
print(c50_1per1$precision_mean)
print(c50_1per5$precision_mean)
print(c50_1per10$precision_mean)
print(c50_1per50$precision_mean)
print(c50_1per100$precision_mean)

print("")
print("reall:")
print(c50_1per1$recall_mean)
print(c50_1per5$recall_mean)
print(c50_1per10$recall_mean)
print(c50_1per50$recall_mean)
print(c50_1per100$recall_mean)



get_acuracyfromConfMat_bin <- function(confMat){
  confMat_sol <- (confMat[1,1]+confMat[2,2])/(confMat[1,1]+confMat[1,2]+confMat[2,1]+confMat[2,2])
  return(confMat_sol)
}

get_precisionfromConfMat_bin <- function(confMat){
  confMat_sol <- (confMat[2,2])/(confMat[2,1]+confMat[2,2])
  return(confMat_sol)
}

# x_axis_acc <- c(1,2,3,4,5)
# # x_axis_acc <- c(1,5,10,50,100)
# 
# # setOfAcc <- c(acc_rf_1per1,
# #               acc_rf_1per5,
# #               acc_rf_1per10,
# #               acc_rf_1per50,
# #               acc_rf_1per100)
setOfAcc <- c(c50_1per1$acc_mean,
              c50_1per5$acc_mean,
              c50_1per10$acc_mean,
              c50_1per50$acc_mean,
              c50_1per100$acc_mean)
# 
# plot(x = x_axis_acc, xaxt = "n", y = setOfAcc, type = 'o', pch=20,ylab = 'accuracy',xlab = 'unbalance data relation "positive:negative"')
# axis(1, at=1:5, labels=c('1:1','1:5','1:10','1:50','1:100'))
# 
# 
# x_axis_p <- c(1,2,3,4,5)
# # x_axis_acc <- c(1,5,10,50,100)
# 
# # setOfp <- c(p_acc_rf_1per1,
# #             p_acc_rf_1per5,
# #             p_acc_rf_1per10,
# #             p_acc_rf_1per50,
# #             p_acc_rf_1per100)
setOfp <- c(c50_1per1$precision_mean,
            c50_1per5$precision_mean,
            c50_1per10$precision_mean,
            c50_1per50$precision_mean,
            c50_1per100$precision_mean)
# 
# 
# plot(x = x_axis_p, xaxt = "n", y = setOfp, type = 'o', pch=20,ylab = 'precision',xlab = 'unbalance data relation "positive:negative"')
# axis(1, at=1:5, labels=c('1:1','1:5','1:10','1:50','1:100'))
# 
# 
# 
# 
# x_axis_r <- c(1,2,3,4,5)
# 
setOfr <- c(c50_1per1$recall_mean,
            c50_1per5$recall_mean,
            c50_1per10$recall_mean,
            c50_1per50$recall_mean,
            c50_1per100$recall_mean)
# 
# plot(x = x_axis_r, xaxt = "n", y = setOfr, type = 'o', pch=20,ylab = 'recall',xlab = 'unbalance data relation "positive:negative"')
# axis(1, at=1:5, labels=c('1:1','1:5','1:10','1:50','1:100'))


# setOfFmeasure <- (2*p*r)/(p+r)
setOfFmeasure <- (2*setOfp*setOfr)/(setOfp+setOfr)

#pruebas con plotly....
library(plotly)

imbalance_labels <- c('1:1','1:5','1:10','1:50','1:100')

all_metrics <- data.frame(imbalance_labels,setOfAcc,setOfp,setOfr,setOfFmeasure)

all_metrics$imbalance_labels <- factor(all_metrics$imbalance_labels,
                                       levels = all_metrics[["imbalance_labels"]])

p <- plot_ly(all_metrics, x = ~imbalance_labels) %>%
  add_trace(y = ~setOfAcc, name = 'accuracy', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgb(30,30,30)')) %>%
  add_trace(y = ~setOfp, name = 'precision', type = 'scatter', 
            mode = 'lines+markers', line = list(color = 'rgb(50,50,200)')) %>%
  add_trace(y = ~setOfr, name = 'recall', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgb(200,50,50)')) %>%
  add_trace(y = ~setOfFmeasure, name = 'f-measure', type = 'scatter',
            mode = 'lines+markers', line = list(color = 'rgba(200,50,200,1)')) %>%
  layout(title = "imbalance study Holiday vs Person EN201610",
         xaxis = list(title= "data relation 'positive:negative'"),
         yaxis = list(title= "metrics"))

p


for(i in 1:10){
  print(c50_1per100$folds_learning[[i]]$confusionMatrixTypes)
}


