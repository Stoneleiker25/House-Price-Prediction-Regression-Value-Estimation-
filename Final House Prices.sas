/* Load Sample Submission */
proc import datafile="C:\Users\stoneleiker.AUTH\Desktop\AI Project\SAS_HousePrices\sample_submission.csv"
	out=sample
	dbms=csv
	replace;
	getnames=yes;
run;

/* Load train data */
proc import datafile="C:\Users\stoneleiker.AUTH\Desktop\AI Project\SAS_HousePrices\train.csv"
	out=train
	dbms=csv
	replace;
	getnames=yes;
run;

/* Load test data */
proc import datafile="C:\Users\stoneleiker.AUTH\Desktop\AI Project\SAS_HousePrices\test.csv"
	out=test
	dbms=csv
	replace;
	getnames=yes;
run;

/* Feature engineering for train */
data train;
    set train;
    TotalSF = TotalBsmtSF + _1stFlrSF + _2ndFlrSF;
    HouseAge = YrSold - YearBuilt;
    IsRemodeled = (YearRemodAdd > YearBuilt);
    TotalBath = FullBath + 0.5 * HalfBath + BsmtFullBath + 0.5 * BsmtHalfBath;
    Source = "Train";
    logSalePrice = log(SalePrice);
run;

/* Feature engineering for test */
data test;
    set test;
    TotalSF = TotalBsmtSF + _1stFlrSF + _2ndFlrSF;
    HouseAge = YrSold - YearBuilt;
    IsRemodeled = (YearRemodAdd > YearBuilt);
    TotalBath = FullBath + 0.5 * HalfBath + BsmtFullBath + 0.5 * BsmtHalfBath;
    Source = "Test";
run;

/* Sort before merging test + sample */
proc sort data=test; by Id; run;
proc sort data=sample; by Id; run;

/* Merge test with sample to get placeholder SalePrice */
data test_full;
    merge test (in=a) sample (in=b);
    by Id;
    if a;
run;

/* Combine train and test_full */
data combined_all;
    set train test_full;
run;

/* Grouped analysis of SalePrice by key variables */
proc means data=combined_all(where=(Source="Train")) mean;
    class Neighborhood;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class GarageCars;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class Fireplaces;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class KitchenQual;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class OverallQual;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class TotalBath;
    var SalePrice;
run;

proc means data=combined_all(where=(Source="Train")) mean;
    class HouseAge;
    var SalePrice;
run;

proc print data=combined_all;
    where TotalBath in (5, 6) and Source = "Train";
    var Id SalePrice Neighborhood OverallQual GarageCars GrLivArea HouseAge;
run;

proc print data=combined_all;
    where TotalBath in (4, 4.5) and Source = "Train";
    var Id SalePrice Neighborhood OverallQual GarageCars GrLivArea HouseAge;
run;

/* Remove rows in test_full with any missing predictor */
data test_full;
    set test_full;
    if nmiss(GrLivArea, TotalSF, OverallQual, TotalBath, GarageCars, HouseAge) = 0;
run;

/* Train model and score test_full */
proc glmselect data=train;
    model logSalePrice = GrLivArea TotalSF OverallQual TotalBath GarageCars HouseAge;
    score data=test_full out=predicted_test_full predicted;
run;

/* Regression output for reference */
proc reg data=train;
    model logSalePrice = GrLivArea TotalSF OverallQual TotalBath GarageCars HouseAge;
run;
quit;

/* Check predicted variable name */
proc contents data=predicted_test_full;
run;

/* Replace P_logSalePrice with the actual name shown in proc contents */
data final_submission;
    set predicted_test_full;
    SalePrice = exp(P_logSalePrice);
    keep Id SalePrice;
run;

/* Preview predictions */
proc print data=final_submission (obs=10);
run;

/* Score on training data to compare predicted vs actual */
proc glmselect data=train;
    model logSalePrice = GrLivArea TotalSF OverallQual TotalBath GarageCars HouseAge;
    score data=train out=train_scored predicted;
run;

data compare_actual_predicted;
    set train_scored;
    PredictedPrice = exp(P_logSalePrice);
    ActualPrice = SalePrice;
    keep Id ActualPrice PredictedPrice;
run;

proc print data=compare_actual_predicted (obs=10);
run;

/* Export to CSV */
proc export data=final_submission
    outfile="C:\Users\stoneleiker.AUTH\Desktop\AI Project\SAS_HousePrices\predicted_prices.csv"
    dbms=csv
    replace;
run;
