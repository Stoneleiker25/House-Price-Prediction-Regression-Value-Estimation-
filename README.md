# Predicting House Prices with SAS

## Project Overview  
This project predicts house sale prices using SAS for Kaggle’s [House Prices: Advanced Regression Techniques](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques). It uses regression modeling, engineered features, and grouped price analysis to estimate `SalePrice` based on property characteristics.

## Key Variables  
- 'SalePrice`: House sale price (target)  
- 'GrLivArea`: Above-ground living area  
- 'TotalSF`: Total square footage (basement + floors)  
- 'OverallQual`: Overall quality rating (1–10)  
- 'GarageCars`: Number of garage spots  
- 'HouseAge``YrSold" "YearBuilt`  
- 'TotalBath`: Combined full and half baths  

## Tools and Methods  
- **SAS Base**  
- 'proc glmselect" "proc reg``proc means`  
- Feature engineering using 'data step`  
- Log-transformed 'SalePrice` for stable modeling  
- Final export using 'proc export`  

## Model Results  
- **R-squared = 0.8206**  
   The model explains 82% of variation in prices, which is strong and reliable for housing prediction.  

## Kaggle Submission  
Kaggle requires only test predictions (Id 1461–2919), submitted as:

## Notes and Author  
Although Kaggle requires keeping train and test separate, I can merge both datasets in SAS or Excel using `Id` for analysis. This helps compare actual and predicted prices side by side. For competition, I submitted only the required test predictions. For future analysis or portfolio, I can create a full combined dataset using code or Excel copy-paste.

**Author:**  
Stone Leiker  
M.S. Analytics | SAS | AI Projects  
