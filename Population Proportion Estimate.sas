proc import datafile="/home/u63556443/Adult data.csv"
out = Adults
dbms = csv
replace;
delimiter=';';
getnames=no;
run;

title "Estimating population proportion using /SRSWOR,SRSWR,STRATIFIED,CLUSTER/";

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

data Adults_bin;
    set Adults;
    income_high = (Predicted_income_category = ">50K"); /* 1 if >50K, 0 otherwise */
run;

/*1)-ESTIMATING POPULATION PROPORTION USING SRSWOR*/
proc surveyselect data=Adults_bin out=srswo
    method=srs 
    n=1000
    seed=202503;
run;

proc surveymeans data=srswo mean stderr clm;
    var income_high;
run;

/*2)-ESTIMATING POPULATION PROPORTION USING SRSWR*/
proc surveyselect data=Adults_bin out=srswr
    method=urs  /* with replacement */
    n=1000
    seed=202503;
run;

proc surveymeans data=srswr mean stderr clm;
    var income_high;
run;

/*ESTIMATING POPULATION PROPORTION USING STRATIFIED SAMPLING*/
proc sort data=Adults_bin out=Adults_sorted;
    by sex;
run;

proc surveyselect data=Adults_sorted out=stratified
    method=srs
    sampsize=(500 500) /* equal sample sizes from Male and Female */
    seed=202503;
    strata sex;
run;

proc surveymeans data=stratified mean stderr clm;
    strata sex;
    var income_high;
run;

/*ESTIMATING POPULATION PROPORTION USING CLUSTER SAMPLING*/
proc surveyselect data=Adults_bin out=cluster_sample
    method=srs 
    n=10
    seed=202503;
    cluster native_country;
run;

proc surveymeans data=cluster_sample mean stderr clm;
    cluster native_country;
    var income_high;
run;