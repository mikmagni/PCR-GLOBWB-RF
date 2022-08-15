####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_2_1_hyperTuning.R')

#~ subsample <- '1'
#~ train_data <- vroom(paste0('../../../RF/rf_input/', 'subsample_',subsample,
#~ 				'/train_table_allpredictors.csv'), show_col_type=F)

#~ outputDir <- paste0('../../../RF/tune/subsample_',subsample,'/')
#~ dir.create(outputDir, showWarnings = F, recursive = T)


#--------------RF---------------
#-----------1. Tune parameter---------------#
num.threads <- 24 
min.node.size = 5
tuned_mtry <- read.csv('tuned_mtry.csv', header=F)

for(subsample in 1:5){
    
    print(paste0('subsample: ', subsample))
    #select subsample predictors
    train_data <- vroom(paste0('../../../RF/rf_input/', 'subsample_',subsample,
				'/train_table_allpredictors.csv'), show_col_type=F)

    outputDir <- paste0('../../../RF/tune/subsample_',subsample,'/')
    dir.create(outputDir, showWarnings = F, recursive = T)
    
    print(tuned_mtry[,subsample])
    #tuning
    #### all predictors ####
    print('tuning: allpredictors')

    rf_input <- train_data %>% select(., -datetime)
    
    mtry <- tuned_mtry[1,subsample]
    
    hyper_grid <- expand.grid(
      ntrees = c(10,50,100,150),
#~       ntrees = 200, #only use 200 trees for rapid tuning
#~       mtry = seq(22,30, by=1)
      mtry = mtry
    )

    hyper_trains <- lapply(1:nrow(hyper_grid), hyper_tuning)

    for(i in 1:nrow(hyper_grid)){
      hyper_grid$ntrees[i]   <- hyper_trains[[i]]$num.trees
      hyper_grid$mtry[i]     <- hyper_trains[[i]]$mtry
      hyper_grid$OOB_RMSE[i] <- sqrt(hyper_trains[[i]]$prediction.error)
    }
      
    print(paste0('output csv file: ', outputDir, 'hyper_grid_allpredictors_ntrees_10-150.csv'))
    write.csv(hyper_grid, paste0(outputDir, 'hyper_grid_allpredictors_ntrees_10-150.csv'), row.names = F)


    #### qmeteostatevars ####
    print('tuning: qMeteoStatevars')
    

    rf_input <- train_data %>% select(., -datetime) %>% 
      select(.,obs:nonIrrWaterConsumption)
      
    mtry <- tuned_mtry[2,subsample]
    
    hyper_grid <- expand.grid(
      ntrees = c(10,50,100,150),
#~       ntrees = 200, #only use 200 trees for rapid tuning
#~       mtry = seq(12,20, by=1)
      mtry = mtry
    )

    hyper_trains <- lapply(1:nrow(hyper_grid), hyper_tuning)

    for(i in 1:nrow(hyper_grid)){
      hyper_grid$ntrees[i]   <- hyper_trains[[i]]$num.trees
      hyper_grid$mtry[i]     <- hyper_trains[[i]]$mtry
      hyper_grid$OOB_RMSE[i] <- sqrt(hyper_trains[[i]]$prediction.error)
    }
      
    print(paste0('output csv file: ', outputDir, 'hyper_grid_qMeteoStatevars_ntrees_10-150.csv'))
    write.csv(hyper_grid, paste0(outputDir, 'hyper_grid_qMeteoStatevars_ntrees_10-150.csv'), row.names = F)
      
      
    #### meteo, catchattr ####
    print('tuning: meteoCatchAttr')
    rf_input <- train_data %>% select(., -datetime) %>% 
      select(obs, precipitation:referencePotET, airEntry1:tanSlope)

    mtry <- tuned_mtry[3,subsample]
    hyper_grid <- expand.grid(
      ntrees = c(10,50,100,150),
#~       ntrees = 200, #only use 200 trees for rapid tuning
#~       mtry = seq(12,20, by=1)
      mtry = mtry
    )

    hyper_trains <- lapply(1:nrow(hyper_grid), hyper_tuning)

    for(i in 1:nrow(hyper_grid)){
      hyper_grid$ntrees[i]   <- hyper_trains[[i]]$num.trees
      hyper_grid$mtry[i]     <- hyper_trains[[i]]$mtry
      hyper_grid$OOB_RMSE[i] <- sqrt(hyper_trains[[i]]$prediction.error)
    }
      
    print(paste0('output csv file: ', outputDir, 'hyper_grid_meteoCatchAttr_ntrees_10-150.csv'))
    write.csv(hyper_grid, paste0(outputDir, 'hyper_grid_meteoCatchAttr_ntrees_10-150.csv'), row.names = F)

}
