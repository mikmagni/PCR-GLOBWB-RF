#uncalibrated
gof_col_select = 'pcr_uncalibrated' # or 'pcr_RFcorrected'
title = 'Uncalibrated PCR-GLOBWB'
legend_yn=F

KGE_uncalibrated <- KGE_map(rf.eval=rf.eval.allpredictors, breaks=breaks,labels=labels,
                            gof_col=gof_col_select, title=title, legend_yn=legend_yn,
                            KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_uncalibrated <- KGE_boxplot(rf.eval=rf.eval.allpredictors, gof_col=gof_col_select,
#                                 KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)

#RF_corrected with only q/statevars
gof_col_select = 'pcr_RFcorrected'
title = 'RF-corrected (qmeteostatevars)'
legend_yn=F

KGE_corrected_qstatevars <- KGE_map(rf.eval=rf.eval.qstatevars, breaks=breaks,labels=labels,
                                    gof_col=gof_col_select, title=title, legend_yn=legend_yn,
                                    KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_corrected_qstatevars <- KGE_boxplot(rf.eval=rf.eval.qstatevars, gof_col=gof_col_select,
#                                         KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
gof_col_select = 'pcr_RFcorrected'
title = 'RF-corrected (meteoCatchAttr)'
legend_yn=F
KGE_corrected_meteoCatchAttr <- KGE_map(rf.eval=rf.eval.meteoCatchAttr, breaks=breaks,labels=labels,
                                        gof_col=gof_col_select, title=title, legend_yn=legend_yn,
                                        KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)

#rf_corrected with additional static predictors (catchment attributes)
gof_col_select = 'pcr_RFcorrected'
title = 'RF-corrected (allpredictors)'
legend_yn=T

KGE_corrected_allpred <- KGE_map(rf.eval=rf.eval.allpredictors, breaks=breaks,labels=labels,
                                 gof_col=gof_col_select, title=title, legend_yn=legend_yn, 
                                 KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_corrected_allpred <- KGE_boxplot(rf.eval=rf.eval.allpredictors, gof_col=gof_col_select,
#                                      KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected) 

#xgboost_corrected with all predictors  
#rf_corrected with additional static predictors (catchment attributes)
# gof_col_select = 'pcr_RFcorrected'
# title = 'XGBoost (all predictors)'
# legend_yn=F
# 
# KGE_corrected_XGB <- KGE_map(rf.eval=rf.eval.xgboost, breaks=breaks,labels=labels,
#                                  gof_col=gof_col_select, title=title, legend_yn=legend_yn, 
#                                  KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_corrected_XGB <- KGE_boxplot(rf.eval=rf.eval.xgboost, gof_col=gof_col_select,
#                                      KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected) 
#patched plot
combined <- KGE_uncalibrated / KGE_corrected_meteoCatchAttr  | 
   KGE_corrected_qstatevars / KGE_corrected_allpred 
combined <- combined + plot_layout(guides = "collect", width=c(2,2)) &
  guides(fill = guide_legend(override.aes = list(size = 5))) &
  theme(legend.position = 'bottom',
        legend.title = element_text(size=12),
        legend.text = element_text(size=10))