####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_2_3_apply_optimalRF.R')

stationInfo <- read.csv('../../../RF/rf_input/test_stations.csv')
outputDir <- '../../../RF/validate/'
dir.create(outputDir, showWarnings = F, recursive = T)

#### test model - predict residuals for test stations ####
#### qstatevars
# load trained model
print('qstatevars: reading trained RF...')
optimal_ranger <- readRDS('../../../RF/train/trainedRF_qstatevars.rds')
print('calculation: initiated')
KGE_list <- mclapply(1:nrow(stationInfo), key='qstatevars',apply_optimalRF, mc.cores=32)
# bind and save KGE table
rf.eval <- do.call(rbind,KGE_list)
write.csv(rf.eval, paste0(outputDir, 'KGE_qstatevars.csv'), row.names = F)

#### all predictors
print('allpredictors: reading trained RF...')
optimal_ranger <- readRDS('../../../RF/train/trainedRF_allpredictors.rds')
print('calculation: initiated')
KGE_list <- mclapply(1:nrow(stationInfo), key='allpredictors',apply_optimalRF, mc.cores=32)
rf.eval <- do.call(rbind,KGE_list)
write.csv(rf.eval, paste0(outputDir, 'KGE_allpredictors.csv'), row.names = F)
