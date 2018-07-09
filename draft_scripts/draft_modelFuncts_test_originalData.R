
source(paste(getwd(),"/modeling/model_funs.R",sep=""))



dt_learning <-dataSPARQL$predictingSet

c50_testingHvsP_ES <- modelWithC50_10fold(dt_data = dt_learning,
                                          name_model = 'deMomentoNoImporta',id_model = '_1',
                                          path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                          randomSeed = 1234)
c50_testingHvsP_ES$acc_mean



dt_learning <-dataSPARQL$predictingSet
rf_testingHvsP_ES <- simpleRandomForest(dt_data = dt_learning,
                                          name_model = 'deMomentoNoImporta',id_model = '_1',
                                          path_model = paste0(getwd(),'/testing_unbalanceModels_output/'),
                                          randomSeed = 1234)
acc_rf_testingHvsP_ES <- get_acuracyfromConfMat_bin(confMat = h2o.confusionMatrix(rf_testingHvsP_ES))
acc_rf_testingHvsP_ES





##amoldar dataset original
# dt_learning <- ex3_features_holiday_all_es_201610
# dt_learning <- ex3_features_holiday_all_en_201610

# dt_learning <- ex1_features_holiday_person_es_201610
# dt_learning <- ex2_features_holiday_person_event_es_201610

# dt_learning <- ex1_features_holiday_person_en_201610
dt_learning <- ex2_features_holiday_person_event_en_201610


dt_learning <- cbind(dt_learning[,2:ncol(dt_learning)],dt_learning[,1])
colnames(dt_learning)[ncol(dt_learning)] <- c('Class')
dt_learning$s <- 'dummy_resource'


dt_learning <- cbind(dt_learning[,ncol(dt_learning)], dt_learning[,1:(ncol(dt_learning)-1)])
colnames(dt_learning)[1] <- c('s')
colnames(dt_learning)

dt_learning$Class <- as.factor(dt_learning$Class)

