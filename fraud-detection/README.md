# Azure Synapse in a day demos - Fraud detection

## Overview

### Pre-Requisites

To complete this lab, you must meet the following pre-requisites:

1. Microsoft Azure subscription must be pay-as-you-go or MSDN.

    a. Trial subscriptions will not work.

2. The hands-on training content contains requires sections that require basic knowledge and operations of Azure, Azure SQL, and Data Factory.

3. Prepare an environment and subscription for your intended hands-on Azure environment.

4. The hands-on training content contains a section marked {Participant's ID that was specified at the start of the hands-on training}. We will issue an ID to each participant at the start of the hands-on training. Enter your ID and proceed.

### Hands-On Training Theme

Over the past few years, there has been a significant worldwide increase in the unauthorized use of credit cards in mail order and online payments, as these are transactions in which no credit card is actually presented to the vendor. Unless some sort of countermeasures are taken, this will cause enormous damage to credit card users and credit card companies.

#### The Challenge for Businesses

In order to prevent unauthorized use, it is crucial to be able to infer the possibility of unauthorized transactions and to detect fraud from transaction details. We also recognize that the prompt identification of unauthorized transactions is an urgent issue for credit card companies and financial institutions.

They need to be able to quickly understand and analyze the trends of unauthorized spending for each time period and the geographical characteristics of unauthorized use, and to learn how to take concrete preventive measures.

#### Objectives and Goals

In this hands-on training, we will learn specific methods for using the SQL On-Demand feature in Azure Synapse Analytics to convert the CSV files of credit card detection data and of geographical characteristics data that have been deployed in Azure Data Lake Storage Gen2 into data, without any program development. You will also learn how to conduct sophisticated analysis of this data using Power BI reports.

In Exercise 1, we will explore the trends of unauthorized spending for each time period, as observed from the fraud detection results extracted by machine learning.

In Exercise 2, we will explore the geographical characteristics of unauthorized use, as observed from data that combines latitude/longitude information of the cities in which credit cards have been used.

At the end of each exercise, we will check that the goals for the objectives shown above have been attained.

### Description of the Datasets in Use

We will use three types of datasets in this hands-on training.

| Data Source | Dataset | File Name |
| --- | --- | --- |
| Kaggle | Credit card fraud detection | Creditcard.csv |
| Open Weather | List of city latitudes and longitudes | Citylist.csv |
| ISO3166-1 | List of country codes | Countrylist.csv |

#### Description of the Credit Card Fraud Detection Dataset

The credit card fraud detection dataset uses data obtained by converting the data from transactions made by European cardholders in September 2013 that was converted by principal component analysis (PCA). It is considered inappropriate to provide the original features and more background information about the data, due to personal information protection issues associated with GDPR that came into effect in May 2017.

(Source: [https://kaggle.com/mlg-ulb/creditcardfraud](https://kaggle.com/mlg-ulb/creditcardfraud))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | Time | Time | Contains the number of seconds elapsed between each transaction and the first transaction in the dataset. |
| 2 - 29 | V1, V2,... V28 | PCA conversion results | Data obtained by converting the data in the column that affects the detection of fraud from credit card transaction data using principal component analysis (PCA). |
| 30 | Amount | Amount | Credit card transaction amount |
| 31 | Class | Fraudulent/Non-fraudulent | A column that determines whether a transaction is fraudulent or non-fraudulent, as defined for a fraud detection machine learning model. (0=Non-fraudulent, 1=Fraudulent) |
| 32 | Id | City ID | A columns that associate credit card transactions with city IDs in the city latitude and longitude list (For this hands-on training, columns have been added and data has been processed/edited.) |

#### Description of the City Latitude and Longitude List Dataset

Use CSV data from the city latitude and longitude list that is published in OpenWeather, a company that publishes the latitude and longitude data of cities around the world.

(Source: [https://openweathermap.org](https://openweathermap.org))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | Id | City ID | Contains the number of seconds elapsed between each transaction and the first transaction in the dataset. |
| 2 | Name | City name | Data obtained by converting the data in the column that affects the detection of fraud from credit card transaction data using principal component analysis (PCA). |
| 3 | State | Amount | Credit card transaction amount |
| 4 | alpha2 | Two-digit country code | ISO3166-1 alpha-2 (two-digit country code) |
| 5 | Lon | Longitude | Value showing the longitude of the city |
| 6 | Lat | Latitude | Value showing the latitude of the city |

#### Description of the Country Code List Dataset

CSV data created from a list of international standards for codes showing ISO3166-1 country names and administrative districts and territories.

(Source: [https://ja.wikipedia.org/wiki/ISO_3166-1](https://ja.wikipedia.org/wiki/ISO_3166-1))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | companyjp | City ID | Contains the number of seconds elapsed between each transaction and the first transaction in the dataset. |
| 2 | companyen | City name | Data obtained by converting the data in the column that affects the detection of fraud from credit card transaction data using principal component analysis (PCA). |
| 3 | Alpha3 | Three-digit country code | ISO3166-1 alpha-3 (three-digit country code) |
| 4 | alpha2 | Two-digit country code | ISO3166-1 alpha-2 (two-digit country code) |
| 5 | Lon | Longitude | Value showing the longitude of the city |
| 6 | Lat | Latitude | Value showing the latitude of the city |

### About Principal Component Analysis

Principal component analysis (PCA) is by far the most commonly used dimension reduction algorithm in machine learning.

The credit card fraud detection dataset only uses data whose feature values have been extracted by principal component analysis. It is considered inappropriate to provide the original features and more background information about the raw data that contains things like the individual's name, the store name and the purchased product(s) in the credit card transaction, due to personal information protection issues associated with GDPR that came into effect in May 2017.

Image the results obtained by quantifying the values of each column in the image of the sample source data and calculating each principal component axis with the credit card fraud detection dataset.

Principal component analysis is a common algorithm that is also available in Azure ML Studio.

![Feature extraction using principal component analysis.](media/pca-feature-extraction.png "Feature extraction using principal component analysis")

![The process of principal component analysis.](media/pca-process.png "The process of principal component analysis")

![Sample source data prior to principal component analysis.](media/pca-sample-data.png "Sample source data prior to principal component analysis")

### Machine Learning Algorithm Used for Scoring in Exercise 1

The machine learning algorithm that we'll use in Exercise 1 to do the scoring by calling the learned model from T-SQL will be the linear regression algorithm from Python's `scikit-learn` machine learning library.

Linear regression is a machine learning model that predicts response variables from the values of explanatory variables using a regression equation.

`scikit-learn` contains `sklearn.linear_model.LinearRegression` as the class for making predictions based on linear regression. We will use this as the algorithm for the machine learning model prepared for this hands-on training scenario.

To deploy a model in `scikit-learn` format in an SQL pool in Azure Synapse Analytics Studio, you must convert it to an ONNX-format model. For more details, visit [http://onnx.ai/sklearn-onnx/index.html](http://onnx.ai/sklearn-onnx/index.html).

Azure Synapse Analytics Studio also offers libraries other than scikit-learn that support conversion to the ONNX model. For more details, visit [https://github.com/onnx/tutorials#converting-to-onnx-format](https://github.com/onnx/tutorials#converting-to-onnx-format).

In this hands-on training, we'll use T-SQL to score an ONNX-format machine learning model that has been developed and trained with scikit-learn by deploying it in a SQL pool in Azure Synapse Analytics Studio.

### Description of the Scenario

This is an image of the overall picture of the scenario architecture. Users will perform the hands-on training for Exercises 1 and 2. These exercises will cover integration with T-SQL, SQL On-Demand, and Power BI in Azure Synapse Analytics, as well as their advanced security features.

TODO:  overall picture of the scenario architecture image...

### List of Content Used in the Hands-On Training

This hands-on training uses the following developed content by executing queries about it and deploying it.

| No | Content ID | Type | Content details |
| -- | ---------- | ---- | --------------- |
| 1 | rf_model.onnx | ML model | Upload a machine learning (linear regression) ONNX model that has been trained to detect credit card fraud. |
| 2 | CreateONNXModel | SQL | A query to deploy an ONNX model that has been put in Azure Storage Gen2 in an SQL pool. |
| 3 | CreateAzureStorageAccountKey | SQL | The definition file for the storage account and storage account key for reading and writing files in Azure Storage Gen2 using the SQL On-Demand pool. |
| 4 | CreateCSVDataSource | SQL | The definition file for the endpoint and storage account in Azure Storage Gen2 that are accessed from the SQL On-Demand pool. |
| 5 | CreateCSVFileFormat | SQL | The definition file for the format of the file format in Azure Storage Gen2 from the SQL On-Demand pool. |
| 6 | CreateExternalCreditCard | SQL | A query to create an external view for loading a CSV file of the credit card fraud detection dataset put in Azure Storage Gen2 from the SQL pool. |
| 7 | SelectIntoCreditCard | SQL | A query that outputs data to a new table in the SQL pool by attaching the results of the scoring of the credit card fraud detection dataset with an ML model. |
| 8 | CreateCreditCardLonLat | SQL | A query that outputs to a new table the result that was created by using SQL On-Demand to integrate the city latitude and longitude list in Azure Storage Gen2 with the country code list dataset and the CSV file output from the new table that was created in Exercise 1 using Data Factory. |
| 9 | Number of fraud detections in the elapsed time period | Power BI report | A report that generates a graph of the changes in the number of fraud detections for each elapsed time period using T-SQL results. |
| 10 | Map of fraud detection locations | Power BI report | A report that generates a map of fraud detection locations that are colored based on the size of the amount involved. |

## Preparations

### What to Do First

#### Create a Resource Group

