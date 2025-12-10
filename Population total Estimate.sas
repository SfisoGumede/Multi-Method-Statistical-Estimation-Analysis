proc import datafile="/home/u63556443/Adult data.csv"
out = Adults
dbms = csv
replace;
delimiter=';';
getnames=no;
run;

title "Estimating population total using /SRSWOR,SRSWR,STRATIFIED,CLUSTER/";
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

/*1)-ESTIMATING POPULATION TOTAL USING SRSWOR*/
proc surveyselect data=Adults out=srswo
    method=srs 
    n=1000
    seed=202503;
run;

proc surveymeans data=srswo sum stderr clsum;
    var hours_per_week;
run;

/*2)-ESTIMATING POPULATION TOTAL USING SRSWR*/
proc surveyselect data=Adults out=srswr
    method=urs 
    n=1000 
    seed=202503;
run;

proc surveymeans data=srswr sum stderr clsum;
    var hours_per_week;
run;

/*3)-ESTIMATING POPULATION TOTAL USING STRATIFIED SAMPLING*/
proc sort data=Adults out=Adults_sorted;
    by sex;
run;

proc surveyselect data=Adults_sorted out=stratified
    method=srs
    sampsize=(500 500)  /* equal sample sizes from Male and Female */
    seed=202503;
    strata sex;
run;

proc surveymeans data=stratified sum stderr clsum;
    strata sex;
    var hours_per_week;
    
run;

/*4)-ESTIMATING POPULATION TOTAL USING CLUSTER SAMPLING*/
proc surveyselect data=Adults out=cluster_sample
    method=srs 
    n=10
    seed=202503;
    cluster native_country;
run;

proc surveymeans data=cluster_sample sum stderr clsum;
    cluster native_country;
    var hours_per_week;
run;