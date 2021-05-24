* Encoding: UTF-8.

*following code down to row 50 is in dataset A.

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=pain sex age STAI_trait pain_cat cortisol_serum mindfulness hospital
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN SKEWNESS SESKEW KURTOSIS SEKURT
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.
* note that some variables are on ordinal scale wich makes them inaproprate to interpret via mean etc, just ignore these numbers and look at frequencies in stead. 

RECODE sex ('female'=0) ('male'=1) INTO Male.
EXECUTE.

CROSSTABS
  /TABLES=sex BY Male
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

RECODE hospital ('hospital_1'=1) ('hospital_2'=2) ('hospital_3'=3) ('hospital_4'=4) 
    ('hospital_5'=5) ('hospital_6'=6) ('hospital_7'=7) ('hospital_8'=8) ('hospital_9'=9) 
    ('hospital_10'=10) INTO Hospital_variable.
EXECUTE.

CROSSTABS
  /TABLES=hospital BY Hospital_variable
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

MIXED pain WITH age Male STAI_trait pain_cat mindfulness cortisol_serum
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=Male STAI_trait pain_cat mindfulness cortisol_serum age | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(Hospital_variable) COVTYPE(VC)
  /SAVE=FIXPRED.

DESCRIPTIVES VARIABLES=FXPRED_1
  /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.

MIXED pain WITH age Male STAI_trait pain_cat mindfulness cortisol_serum
 /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
 SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE) 
 /FIXED=| SSTYPE(3)
 /METHOD=REML
 /PRINT=SOLUTION
 /RANDOM=INTERCEPT | SUBJECT(Hospital_variable) COVTYPE(VC).

* -------------------------------- below I have started to use dataset B  

RECODE sex ('female'=0) ('male'=1) INTO Male.
EXECUTE.

CROSSTABS
  /TABLES=sex BY Male
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

RECODE hospital ('hospital_11'=11) ('hospital_12'=12) ('hospital_13'=13) ('hospital_14'=14) 
    ('hospital_15'=15) ('hospital_16'=16) ('hospital_17'=17) ('hospital_18'=18) ('hospital_19'=19) 
    ('hospital_20'=20) INTO Hospital_variable.
EXECUTE.

DATASET ACTIVATE DataSet1.
CROSSTABS
  /TABLES=hospital BY Hospital_variable
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

COMPUTE variance_explained_byDataA=2.48 - 0.02 * age + 0.20 * Male - 0.05 * STAI_trait + 0.08 * 
    pain_cat - 0.19 * mindfulness + 0.63 * cortisol_serum.
EXECUTE.

DATASET ACTIVATE DataSet1.
COMPUTE Residuals=pain - predicted_pain_byDataA.
EXECUTE.

COMPUTE RSS_resudualsumofsq=Residuals * Residuals.
EXECUTE.

DESCRIPTIVES VARIABLES=RSS_resudualsumofsq
  /STATISTICS=SUM.

DESCRIPTIVES VARIABLES=pain
  /STATISTICS=MEAN.

*mean for pain = 4.85, added a new variable with all observations= 4.85.

COMPUTE TS_residual_mean_prediction=pain - prediction_by_mean.
EXECUTE.

COMPUTE TSS_totalsumofsq=TS_residual_mean_prediction * TS_residual_mean_prediction.
EXECUTE.

DESCRIPTIVES VARIABLES=TSS_totalsumofsq
  /STATISTICS=SUM.




