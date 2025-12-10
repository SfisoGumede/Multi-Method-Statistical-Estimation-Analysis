proc import datafile="/home/u63556443/Adult data.csv"
out = Adults
dbms = csv
replace;
delimiter=';';
getnames=no;
run;

data Adults;
  set Adults;
  rename VAR1 = age
		 VAR2 = workclass
		 VAR3 = education
		 VAR4 = education_num
		 VAR5 = marital_status
		 VAR6 = occupation
		 VAR7 = relationship
		 VAR8 = race
		 VAR9 = sex
		 VAR10 = capital_gain
		 VAR11 = capital_los
		 VAR12 = hours_per_week
		 VAR13 = native_country
		 VAR14 = Predicted_income_category;
run;


title "ESTIMATNG POPULATION MEAN";
/*****************************************************
          POPULATION MEAN
 *****************************************************/
/* 1)/*-ESTIMATING POPULATION MEAN USING SRSWOR */
proc surveyselect data=Adults out=srswo
    method=srs 
    n=1000
    seed=202503;
run;

proc surveymeans data=srswo mean stderr clm;
    var hours_per_week;
run;

/* 2)/*-ESTIMATING POPULATION MEAN USING SRSWR */
proc surveyselect data=Adults out=srswr
    method=urs 
    n=1000
    seed=202503
    outhits;
   
run;

proc surveymeans data=srswr mean stderr clm;
    var hours_per_week;
run;

/* 3)/*-ESTIMATING POPULATION MEAN USING STRATIFIED SAMPLING */
proc sort data=Adults out=Adults_sorted;
    by sex;
run;

proc surveyselect data=Adults_sorted out=stratified
    method=srs
    sampsize=(500 500)  /* equal sample sizes from Male and Female*/
    seed=202503;
    strata sex;
run;

proc surveymeans data=stratified mean stderr clm;
    strata sex;
    var hours_per_week;
    
run;

/* 4)-ESTIMATING POPULATION MEAN USING CLUSTER SAMPLING */
proc surveyselect data=Adults out=cluster_sample
    method=srs 
    n=10
    seed=202503;
    cluster native_country;
run;

proc surveymeans data=cluster_sample mean stderr clm;
    cluster native_country;
    var hours_per_week;
run;

proc surveyselect data=Adults out=srswr
    method=urs 
    n=1000
    seed=202503
    outhits;
   
run;
