#draft_trainES_predictEN.R

source(paste(getwd(),"/modeling/model_funs.R",sep=""))
source(paste(getwd(),"/preprocessing/convert_funs.R",sep=""))

# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp1_Holiday_vs_Person_Es201610.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp2_Holiday_vs_PersonAndEvent_Es201610.RData")
load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/Es201610/data_exp3_Holiday_vs_SeveralFirstLevel_Es201610.RData")
dt_training <- dataSPARQL$predictingSet
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp1_Holiday_vs_Person_En201610_guardado.RData")
# load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp2_Holiday_vs_PersonAndEvent_En201610.RData")
load("~/R_proyectos/BinaryClassifiers_DBpediaTypes/inputData/En201610/data_exp3_Holiday_vs_SeveralFirstLevel_En201610.RData")
dt_predicting_original <- dataSPARQL$predictingSet

dt_predicting <- adaptColumns_DT2_like_DT1(dt1In = dt_training, dt2In = dt_predicting_original)




rf_es201610 <- simpleRandomForest(dt_data = dt_training,
                                  name_model = "rf_HvsSFL_Es201610_originalData",
                                  id_model = "_1_",path_model = "modelsAlone/",randomSeed = 1234)





h2o.init(
  nthreads=-1
)
carga_rf_es201610 <- h2o.loadModel(path = paste0(getwd(),"/modelsAlone/","rf_HvsSFL_Es201610_originalData__1__1234"))

predicting <- as.h2o(dt_predicting)
rf_predictions <- h2o.predict(carga_rf_es201610,predicting[,c(2:ncol(predicting))])

rf_predictions <- as.data.frame(rf_predictions)
realTypes <- dt_predicting[,ncol(dt_predicting)]
predictedTypes <- rf_predictions$predict 
confusionMatrixTypes <- table(predictedTypes,realTypes)
print(confusionMatrixTypes)

rf_accuracy <- get_acuracyfromConfMat_bin(confusionMatrixTypes)
rf_precision <- get_precisionfromConfMat_bin(confusionMatrixTypes)
rf_recall <- get_recallfromConfMat_bin(confusionMatrixTypes)
rf_accuracy
rf_precision
rf_recall



