# Azure Synapse in a day demos - Fraud detection

- [Azure Synapse in a day demos - Fraud detection](#azure-synapse-in-a-day-demos---fraud-detection)
  - [Pre-Requisites](#pre-requisites)
    - [Hosted lab environment](#hosted-lab-environment)
  - [Overview](#overview)
    - [The Challenge for Businesses](#the-challenge-for-businesses)
    - [Objectives and Goals](#objectives-and-goals)
  - [Description of the Datasets in Use](#description-of-the-datasets-in-use)
    - [Description of the Credit Card Fraud Detection Dataset](#description-of-the-credit-card-fraud-detection-dataset)
    - [Description of the City Latitude and Longitude List Dataset](#description-of-the-city-latitude-and-longitude-list-dataset)
    - [Description of the Country Code List Dataset](#description-of-the-country-code-list-dataset)
  - [About Principal Component Analysis](#about-principal-component-analysis)
  - [Machine Learning Algorithm Used for Scoring in Exercise 1](#machine-learning-algorithm-used-for-scoring-in-exercise-1)
  - [Lab pre-requisite: Create a Power BI Workspace](#lab-pre-requisite-create-a-power-bi-workspace)
  - [Exercise 1:  Scoring predictions from T-SQL using a pre-trained model](#exercise-1--scoring-predictions-from-t-sql-using-a-pre-trained-model)
    - [Task 1: Dataset Creation](#task-1-dataset-creation)
    - [Task 2:  Query Development](#task-2--query-development)
    - [Task 3:  Power BI Report Development](#task-3--power-bi-report-development)
  - [Exercise 2:  Perform Ad Hoc Queries from the Storage Account](#exercise-2--perform-ad-hoc-queries-from-the-storage-account)
    - [Task 1:  Create a Dataset](#task-1--create-a-dataset)
    - [Task 2:  Create a View](#task-2--create-a-view)
    - [Task 3:  Power BI Fraud Map Report Development](#task-3--power-bi-fraud-map-report-development)
  - [After the hands-on lab](#after-the-hands-on-lab)
    - [Task 1: Delete Lab Resources](#task-1-delete-lab-resources)
    - [Task 2:  Delete the Power BI Workspace](#task-2--delete-the-power-bi-workspace)

## Pre-Requisites

**Please note**: If you are not running this lab in a hosted environment, complete the [lab setup instructions](Setup.md) before continuing.

- Power BI Pro or Premium license. You may try Pro free for 60 days if you have not previously signed up for a free trial.

### Hosted lab environment

If you are using a hosted CloudLabs lab environment, you will find your environment details in the email address you provided during registration. You can also find the information by selecting the **Environment Details** tab **(1)** on the landing page for the `Azure Synapse in A Day - Fraud detection` lab.

Use the buttons **(2)** to copy your username and password when prompted to log in to the Azure portal and Power BI account. The **UniqueId (3)** is referenced throughout the lab guide and is used as part of resource naming for the Azure artifacts. When you need to sign in to the lab VM, use the provided **VM username and password (4)** after connecting to the **VM DNS name (5)** with your remote connection application, such as RDP.

![The lab environment details are displayed.](media/hosted-lab-details.png "Environment Details")

When you need to log in to the lab VM, select the **Virtual Machines** tab **(1)** and check the VM status **(2)**. If the VM is **deallocated**, you must start it by selecting the **Start** button **(3)** under Actions.

![The Virtual Machines details are displayed.](media/lab-virtual-machines.png "Virtual Machines")

## Overview

Over the past few years, there has been a significant worldwide increase in the unauthorized use of credit cards in mail order and online payments, as these are transactions in which no credit card is actually presented to the vendor. Unless some sort of countermeasures are taken, this will cause enormous damage to credit card users and credit card companies.

### The Challenge for Businesses

In order to prevent unauthorized use, it is crucial to be able to infer the possibility of unauthorized transactions and to detect fraud from transaction details. We also recognize that the prompt identification of unauthorized transactions is an urgent issue for credit card companies and financial institutions.

They need to be able to quickly understand and analyze the trends of unauthorized spending for each time period and the geographical characteristics of unauthorized use, and to learn how to take concrete preventive measures.

### Objectives and Goals

In this hands-on training, we will learn specific methods for using the SQL On-Demand feature in Azure Synapse Analytics to convert credit card fraud detection data and of geographical characteristics data that have been deployed in CSV format into Azure Data Lake Storage Gen2 into data, without any program development. You will also learn how to conduct sophisticated analysis of this data using Power BI reports.

In Exercise 1, we will explore the trends of unauthorized spending for each time period, as observed from the fraud detection results extracted by machine learning.

In Exercise 2, we will explore the geographical characteristics of unauthorized use, as observed from data that combines latitude/longitude information of the cities in which credit cards have been used.

## Description of the Datasets in Use

We will use three types of datasets in this hands-on training.

| Data Source | Dataset | File Name |
| --- | --- | --- |
| Kaggle | Credit card fraud detection | Creditcard.csv |
| Open Weather | List of city latitudes and longitudes | Citylist.csv |
| ISO3166-1 | List of country codes | Countrylist.csv |

### Description of the Credit Card Fraud Detection Dataset

The credit card fraud detection dataset uses data obtained by converting the data from transactions made by European cardholders in September 2013 that was converted by principal component analysis (PCA). It is considered inappropriate to provide the original features and more background information about the data, due to personal information protection issues associated with GDPR that came into effect in May 2017.

(Source: [https://kaggle.com/mlg-ulb/creditcardfraud](https://kaggle.com/mlg-ulb/creditcardfraud))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | Time | Time | Contains the number of seconds elapsed between each transaction and the first transaction in the dataset. |
| 2 - 29 | V1, V2, ... V28 | PCA conversion results | Data obtained by converting the data in the column that affects the detection of fraud from credit card transaction data using principal component analysis (PCA). |
| 30 | Amount | Amount | Credit card transaction amount |
| 31 | Class | Fraudulent/Non-fraudulent | A column that determines whether a transaction is fraudulent or non-fraudulent, as defined for a fraud detection machine learning model. (0=Non-fraudulent, 1=Fraudulent) |
| 32 | Id | City ID | A column which associates credit card transactions with city IDs in the city latitude and longitude list.  For this hands-on training, columns have been added and data has been processed/edited to include these city IDs. |

### Description of the City Latitude and Longitude List Dataset

Use CSV data from the city latitude and longitude list that is published in OpenWeather, a company that publishes the latitude and longitude data of cities around the world.

(Source: [https://openweathermap.org](https://openweathermap.org))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | Id | City ID | A surrogate key representing the city |
| 2 | Name | City name | The city name |
| 3 | State | State | The state name, if applicable |
| 4 | alpha2 | Two-character country code | ISO3166-1 alpha-2 (two-digit country code) |
| 5 | Lon | Longitude | Value showing the longitude of the city |
| 6 | Lat | Latitude | Value showing the latitude of the city |

### Description of the Country Code List Dataset

CSV data created from a list of international standards for codes showing ISO3166-1 country names and administrative districts and territories.

(Source: [https://jp.wikipedia.org/wiki/ISO_3166-1](https://jp.wikipedia.org/wiki/ISO_3166-1))

| No | Column ID | Column Name | Description |
| -- | --------- | ----------- | ----------- |
| 1 | companyjp | Country Name (Japanese) | Contains the Japanese-language name of the country |
| 2 | companyen | Country Name (English) | Contains the English-language name of the country |
| 3 | numeric | Numeric Code | ISO3166-1 numeric code |
| 4 | alpha3 | Three-character country code | ISO3166-1 alpha-3 (three-character country code) |
| 5 | alpha2 | Two-character country code | ISO3166-1 alpha-2 (two-character country code) |
| 6 | location | Location | Contains the Japanese-language location |
| 7 | subdivision | Subdivision Code | ISO 3166-2 subdivision code |

## About Principal Component Analysis

Principal component analysis (PCA) is by far the most commonly used dimension reduction algorithm in machine learning.

![Feature extraction using principal component analysis.](media/pca-feature-extraction.png "Feature extraction using principal component analysis")

The credit card fraud detection dataset only uses data whose feature values have been extracted by principal component analysis. It is considered inappropriate to provide the original features and more background information about the raw data that contains things like the individual's name, the store name and the purchased product(s) in the credit card transaction, due to personal information protection issues associated with GDPR that came into effect in May 2017.

![The process of principal component analysis.](media/pca-process.png "The process of principal component analysis")

Following is a hypothetical image of credit card transactions prior to calculating each principal component axis.

![Sample source data prior to principal component analysis.](media/pca-sample-data.png "Sample source data prior to principal component analysis")

Principal component analysis is a common algorithm that is also available in Azure ML Studio.

## Machine Learning Algorithm Used for Scoring in Exercise 1

The machine learning algorithm that we will use in Exercise 1 to do the scoring by calling the learned model from T-SQL will be the linear regression algorithm from Python's `scikit-learn` machine learning library.

Linear regression is a machine learning model that predicts response variables from the values of explanatory variables using a regression equation.

`scikit-learn` contains `sklearn.linear_model.LinearRegression` as the class for making predictions based on linear regression. We will use this as the algorithm for the machine learning model prepared for this hands-on training scenario.

To deploy a model in `scikit-learn` format in an SQL pool in Azure Synapse Analytics Studio, you must convert it to an ONNX-format model. For more details, visit [http://onnx.ai/sklearn-onnx/index.html](http://onnx.ai/sklearn-onnx/index.html).

Azure Synapse Analytics Studio also offers libraries other than scikit-learn that support conversion to the ONNX model. For more details, visit [https://github.com/onnx/tutorials#converting-to-onnx-format](https://github.com/onnx/tutorials#converting-to-onnx-format).

In this hands-on training, we'll use T-SQL to score an ONNX-format machine learning model that has been developed and trained with scikit-learn by deploying it in a SQL pool in Azure Synapse Analytics Studio.

## Lab pre-requisite: Create a Power BI Workspace

1. In a new tab or window, navigate to the Power BI website, [https://powerbi.microsoft.com/](https://powerbi.microsoft.com/).  Select **Sign in** and sign in.

    ![The Sign in option is selected.](media/power-bi-sign-in.png 'Sign in')

2. Select the **Workspaces** menu and then choose **Create workspace**.

    ![The Create a workspace option is selected.](media/power-bi-create-workspace.png 'Create a workspace')

3. If you are prompted to upgrade to Power BI Pro, select **Try free**. Select **Got it** to confirm the pro subscription.

4. In the Create a workspace menu, enter **FraudDetection** as the name and select **Save**. If the name "FraudDetection" is not available, append a set of unique characters to the name, such as the `UniqueId` value if you are using a hosted lab environment, or your initials.

    ![The FraudDetection workspace is saved.](media/power-bi-create-workspace-1.png 'FraudDetection workspace')

5. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics** from the results.

    ![In the Services search result list, Azure Synapse Analytics is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics')

6. Select the workspace you created before the hands-on lab, or that is provided by your hosted lab environment.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapselabfraudjdhasws workspace')

7. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

8. On the home page, select the **Visualize** option.

    ![The Visualize option is selected.](media/azure-synapse-visualize.png 'Visualize')

9. In the **Connect to Power BI** tab, complete the following and then select **Connect** to create a new Power BI connection.

    | Field                          | Value                                              |
    | ------------------------------ | ------------------------------------------         |
    | Name                           | _`FraudDetectionWorkspace`_                        |
    | Tenant                         | _select your Power BI tenant_                      |
    | Workspace name                 | _select the `FraudDetection` workspace_            |

    ![In the Connect to Power BI tab, form field entries are filled in.](media/azure-synapse-connect-power-bi.png 'Connect to Power BI')

## Exercise 1:  Scoring predictions from T-SQL using a pre-trained model

Duration: 45 minutes

You will use masked data, obtained by applying principal component analysis to credit card transaction data, to evaluate which transactions are fraudulent and to analyze trends in elapsed time and fraud amounts.

### Task 1: Dataset Creation

1. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics** from the results.

    ![In the Services search result list, Azure Synapse Analytics is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics')

2. Select the workspace you created before the hands-on lab, or that is provided by your hosted lab environment.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapselabfraudjdhasws workspace')

3. Select the `synapsesql` dedicated SQL pool on the Overview pane of the Synapse workspace.

    ![The dedicated SQL pool is selected.](media/select-dedicated-sql-pool.png "SQL pools")

4. If the dedicated SQL pool is currently paused, select **Resume**.

    ![The resume button is highlighted.](media/dedicated-sql-pool-resume.png "Resume")

5. When prompted whether you are sure you want to resume the pool, select **Yes**.

6. Select **Overview** in the left-hand menu **after** the SQL pool resumes.

    ![The Overview link is highlighted.](media/synapse-workspace-select-overview.png "Overview")

7. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

8. Select the **Develop** tab from Synapse studio.

    ![The Develop option is selected.](media/azure-synapse-develop.png 'Develop')

9. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

10. Choose the **synapsesql** connection option and the **synapsesql** database from the database drop-down list.

    ![The synapsesql database is selected.](media/azure-synapse-develop-synapsesql.png 'synapsesql database')

11. Change the name of the script to **CreateSchema**.

    ![The script is named CreateSchema.](media/azure-synapse-script-createschema.png 'CreateSchema')

12. Enter the following code into the script window. Then, select **Run** to execute the code.

    ```sql
    CREATE SCHEMA synapse
    ```

    ![The Run button is highlighted.](media/azure-synapse-create-schema-script-run.png "Run")

13. From the **+** menu, choose **SQL script** to open a new script. Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

14. Change the name of this script to **CreateMasterKey**. Enter the following into the script window, changing `{Password}` to a password you can remember. Then, select **Run** to execute the code.

    ```sql
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '{Password}'
    ```

    ![The master key creation script has been run.](media/azure-synapse-script-createmasterkey.png 'Create Master Key')

15. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

16. Change the name of this script to **CreateAzureStorageAccountKey**. Connect to the **synapsesql** dedicated SQL pool, then enter the following into the script window, filling in your storage account name and access key. Select **Run** to execute the code.

    ```sql
    CREATE DATABASE SCOPED CREDENTIAL AzureStorageAccountKey
    WITH IDENTITY = '<Your Storage Account>',
    SECRET = '<Your Access Key>';
    ```

    ![The database scoped credential has been created.](media/azure-synapse-script-create-dsc.png 'Create Database Scoped Credential')

    To find the storage account name and access key, navigate to the resource group for your lab and open the provisioned Azure storage account. Select **Access keys** in the left-hand menu. Here you can copy the **Storage account name** and paste it in place of `<Your Storage Account>` in the SQL script, and copy the **Key** to replace `<Your Access Key>` in the SQL script.

    ![The storage account name and key are highlighted.](media/storage-account-keys.png "Access keys")

17. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

18. Change the name of this script to **CreateCSVDataSource**. Enter the following into the script window, filling in your storage account name in place of `<Your Storage Account>`. Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database. Then, select **Run** to execute the code.

    ```sql
    CREATE EXTERNAL DATA SOURCE CSVDataSource WITH
    (
        TYPE = HADOOP,
        LOCATION = 'wasbs://synapse@<Your Storage Account>.blob.core.windows.net',
        CREDENTIAL = AzureStorageAccountKey
    );
    ```

    ![The external data source has been created.](media/azure-synapse-create-data-source.png 'Create External Data Source')

19. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

20. Change the name of this script to **CreateCSVFileFormat**. Enter the following into the script window to create two external file formats. One is for reading the source CSV files and the other is to read the machine learning (ML) model file. Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database. Then, select **Run** to execute the code.

    ```sql
    CREATE EXTERNAL FILE FORMAT CSVFileFormat
    WITH (  
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"',
            FIRST_ROW = 2,
            USE_TYPE_DEFAULT=TRUE
        )
    );
    GO

    CREATE EXTERNAL FILE FORMAT csv
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '',
            DATE_FORMAT = '',
            USE_TYPE_DEFAULT = False
        )
    );
    GO
    ```

    ![The external file format has been created.](media/azure-synapse-script-create-fileformat.png 'Create External File Format')

21. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

22. Change the name of this script to **CreateExternalCreditCard**. Enter the following into the script window to create an external table for the credit card CSV data and an external table for the ML model. Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database. Then, select **Run** to execute the code.

    ```sql
    CREATE EXTERNAL TABLE synapse.exCreditCard
    (
            [Time] float,
            [V1] float,[V2] float,[V3] float,[V4] float,[V5] float,[V6] float,[V7] float,[V8] float,[V9] float,[V10] float,
            [V11] float,[V12] float,[V13] float,[V14] float,[V15] float,[V16] float,[V17] float,[V18] float,[V19] float,[V20] float,
            [V21] float,[V22] float,[V23] float,[V24] float,[V25] float,[V26] float,[V27] float,[V28] float,
            [Amount] float,[Class] bigint,[id] bigint
    )
    WITH
    (
            LOCATION = 'CreditCard.csv',
            DATA_SOURCE = [CSVDataSource],
            FILE_FORMAT = [CSVFileFormat]
    );
    GO

    CREATE EXTERNAL TABLE synapse.[MLModelExt]
    (
    [Model] [varbinary](max) NULL
    )
    WITH
    (
        LOCATION='credit_card_model.onnx.hex' ,
        DATA_SOURCE = [CSVDataSource] ,
        FILE_FORMAT = csv ,
        REJECT_TYPE = VALUE ,
        REJECT_VALUE = 0
    );
    GO
    ```

    ![The external table has been created.](media/azure-synapse-script-create-externalcc.png 'Create External Table')

23. Select the **Data** hub in the left-hand menu.

    ![Data hub.](media/data-hub.png "Data hub")

24. Expand **Databases** under the Workspace tab, expand **synapsesql**, then expand **External tables**. Right-click on the **synapse.exCreditCard** table and choose **New SQL script** and then **Select TOP 100 rows**.

    ![Select the top 100 rows is selected.](media/azure-synapse-script-select-top100.png 'Select TOP 100 rows')

25. Select the **Properties** icon to display the menu. Rename the name to **SelectExternalCreditCard**. Then, select **Publish all**.

    ![The publish all option is selected.](media/azure-synapse-publish-all-2.png 'Publish all')

26. Select the **Publish** option to save these scripts.

    ![The Publish option is selected.](media/azure-synapse-publish-2.png 'Publish')

### Task 2:  Query Development

1. Navigate to the **Develop** hub.

    ![Develop hub.](media/develop-hub.png "Develop hub")

2. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

3. Change the name of this script to **SelectIntoCreditCard**. Enter the following into the script window to create an external table for the credit card CSV data and an external table for the ML model. Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database. Then, select **Run** to execute the script and let it insert data into a new `synapse.CreditCard` table.

    ```sql
    DECLARE @modelexample varbinary(max) = (SELECT [Model] FROM synapse.[MLModelExt]);

    SELECT
    d.*, p.*
    INTO synapse.CreditCard
    FROM PREDICT(MODEL = @modelexample,
        DATA = synapse.exCreditCard AS d,
        RUNTIME = ONNX) WITH (output_label bigint) AS p;
    ```

    ![The scored credit card prediction table has been created.](media/azure-synapse-script-create-creditcard.png 'Run predictions')

4. In the **Tables** folder for **synapsesql**, select the ellipsis (...) and choose **Refresh** to see the `synapse.CreditCard` table.

    ![The list of tables is refreshed.](media/azure-synapse-refresh-tables.png 'Refresh')

5. In the **synapse.CreditCard** table entry, select the ellipsis (...) and choose **New SQL Script** and then **Select TOP 100 rows** to open a new script pre-populated with a SQL query.

    ![The option to select the top 100 rows in the credit card predictions table is selected.](media/azure-synapse-creditcard-select.png 'Select TOP 100 rows')

    The `Output_label` field shows the prediction from the model.

    ![The output label field is highlighted.](media/azure-synapse-creditcard-select-output.png "Query results")

### Task 3:  Power BI Report Development

1. Open the RDP file from the Before the Hands-On Lab section and select **Connect** to access the virtual machine.  When prompted for credentials, enter `powerbiuser` for the username and the password you chose, or which were provided to you in your hosted lab environment details.

    ![Connect to a remote host.](media/azure-vm-connect-3.png 'Connect to a remote host')

2. Open a browser in the virtual machine.  In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics** from the results.

    ![In the Services search result list, Azure Synapse Analytics is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics')

3. Select the workspace you created before the hands-on lab.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapse-lab-fraud-detection workspace')

4. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

5. Select the **Develop** hub.

    ![Develop hub.](media/develop-hub.png "Develop hub")

6. Drill down into **Power BI** and then **FraudDetectionWorkspace**. Select **Power BI datasets**.

    ![The Open option is selected.](media/azure-synapse-power-bi-dataset-open.png 'Open')

    If you do not see the **Power BI** section under Develop, select **Refresh** in the upper-right corner of Synapse Studio to refresh the UI.

    ![The refresh button is highlighted.](media/synapse-studio-refresh.png "Refresh")

7. Select **+ New Power BI dataset**.

    ![The New Power BI dataset option is selected.](media/azure-synapse-power-bi-dataset-new.png 'New Power BI dataset')

8. Select **Start** to begin the process.

    ![The option to start is selected.](media/power-bi-new-dataset-1.png 'Start')

9. Select the **synapsesql** SQL pool to use as a data source and then select **Continue**.

    ![The synapse SQL pool is selected.](media/power-bi-new-dataset-2.png 'Synapse SQL Pool')

10. Select **Download** to download the Power BI dataset file.  After download completes, select **Continue**.

    ![The Power BI dataset file is downloaded.](media/power-bi-new-dataset-3.png 'Download pbids file')

11. Open the downloaded Power BI dataset file in Power BI Desktop.  When prompted to enter a username and password, select **Database** and enter the Synapse username and password you created before the hands-on lab, or which was provided to you as part of a hosted environment. The username will be **asa.sql.admin**. Then select **Connect** to connect to the SQL pool.

    ![The credentials for the Synapse admin user are entered.](media/power-bi-new-dataset-4.png 'Connect to SQL Pool')

12. On the Navigator page, select the **synapse.CreditCard** table and then select **Load**.

    ![The credit card table are selected.](media/power-bi-new-dataset-5.png 'Navigator')

13. In the Connection settings modal dialog, select **Import** and then select **OK**.

    ![The Import option is selected.](media/power-bi-new-dataset-6.png 'Connection settings')

14. Once the table is loaded, select the **Data** tab and then select the **Time** column.  In the Format section, select the drop-down list and choose **Decimal number**.

    ![The Time column is changed to a decimal data type.](media/power-bi-new-dataset-7.png 'Decimal number')

15. Right-click the Time column and choose **Sort ascending**.

    ![The Sort ascending option is selected.](media/power-bi-new-dataset-8.png 'Sort ascending')

16. Choose the **Report** view and then select the **Clustered column chart** option.  Select and drag the **Time** attribute into the **Axis** field to make time the X axis.  From there, select and drag the **Amount** attribute into the **Values** field to make amount the Y axis.

    ![The amount by time report has been created.](media/power-bi-amount-by-time.png 'Amount by Time')

17. Expand out the **Filters** pane. Select and drag the **Class** attribute into the **Filters on this visual** menu.  Change the filter type to **Basic filtering** and select **1** to filter down to fraudulent transactions.

    ![The amount by time report filter has been added.](media/power-bi-amount-by-time-filter.png 'Amount by Time filter')

18. Save the file as **FraudDetectionReport**.

    ![The Power BI report is saved.](media/power-bi-fraud-detection-report.png 'FraudDetectionReport')

19. In the **File** menu, select **Publish** and then **Publish to Power BI**.

    ![The Publish to Power BI option is selected.](media/power-bi-publish.png 'Publish to Power BI')

20. Sign into your Power BI workspace.

    ![The option to sign into Power BI is selected.](media/power-bi-login.png 'Sign in')

21. Select the **FraudDetection** workspace and then choose **Select**.

    ![The FraudDetection workspace is selected.](media/power-bi-select-destination.png 'Select a destination')

22. After the Power BI report deploys, return to Azure Synapse Analytics Studio and select **Continue** and then **Close and refresh**.  Select the **Power BI reports** menu and then the **FraudDetectionReport** to review the published report.

    ![The fraud detection report is now available.](media/azure-synapse-fraud-detection-report.png 'Fraud Detection Report')

## Exercise 2:  Perform Ad Hoc Queries from the Storage Account

Duration: 50 minutes

Plot the trends of the cities where unauthorized use of credit cards occurred and the amounts on a map, so that you can ascertain the geographical factors associated with frequent unauthorized use and the cities where large losses frequently occur.

### Task 1:  Create a Dataset

This first task will export credit card predictions from the prior exercise into CSV format.

1. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics** from the results.

    ![In the Services search result list, Azure Synapse Analytics is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics')

2. Select the workspace you created before the hands-on lab.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapselabfraudjdhasws workspace')

3. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

4. Select the **Manage** tab from Synapse studio.

    ![The Manage option is selected.](media/azure-synapse-manage.png 'Manage')

5. Select the **Linked services** option from the External connections section. Then select **+ New** to add a new linked service.

    ![The option to add a new linked service is selected.](media/azure-synapse-new-linked-service.png 'New linked service')

6. Enter **synapse** into the search menu and select the **Azure Synapse Analytics (formerly SQL DW)** option. Then, select **Continue**.

    ![The option to add a new Azure Synapse Analytics linked service is selected.](media/azure-synapse-new-linked-service-1.png 'New Azure Synapse Analytics service')

7. In the **New linked service** tab, complete the following and then select **Create** to create a new linked service connection.

    | Field                           | Value                                              |
    | ------------------------------  | ------------------------------------------         |
    | Name                            | _`FraudDetectionSynapse`_                          |
    | Connect via integration runtime | _select `AutoResolveIntegrationRuntime`_           |
    | Account selection method        | _select `From Azure subscription`_                 |
    | Azure subscription              | _select your Azure subscription_                   |
    | Server name                     | _`synapselabfraud` + unique id (example: `synapselabfraud311554`)_ |
    | Database name                   | _select `synapsesql`_                              |
    | Authentication type             | _select `SQL authentication`_                      |
    | User name                       | _enter `asa.sql.admin`_                             |
    | Password                        | _enter the password you created earlier or that was provided to you for your hosted lab environment_           |

    ![In the New linked service tab, form field entries are filled in.](media/azure-synapse-new-linked-service-2.png 'New linked service')

8. Select the **Data** tab from Synapse studio.

    ![The Data option is selected.](media/azure-synapse-data.png 'Data')

9. Drill down the SQL pool tables and then select the ellipsis (...) next to the **synapse.CreditCard** table.  From there, select **Data flow** to open a new data flow.

    ![Create a new Data flow.](media/azure-synapse-new-data-flow.png 'Data flow')

10. Name the data flow **DataflowCreditCard** and the integration dataset name **DatasetSqlPoolCreditCard**. Then, select **Create** to create the data flow.

    ![Names are provided for the data flow and dataset.](media/azure-synapse-dataflowcreditcard.png 'DataflowCreditCard')

11. Name the source **sourceCreditCard**.  Then select the **Open** option next to the Dataset.

    ![The output stream name is sourceCreditCard.](media/azure-synapse-sourcecreditcard.png 'Output stream name')

12. In the Linked service menu, select **FraudDetectionSynapse**.  Then, in the Table menu, select **synapse.CreditCard**.

    ![The output stream name is sourceCreditCard.](media/azure-synapse-sourcecreditcard-2.png 'Output stream name')

13. Select the **DataflowCreditCard** tab to return to the data flow.  Then, select the **+** option next to the source and choose **Select** from the Schema modifier list.

    ![The schema modifier Select is selected.](media/azure-synapse-new-select.png 'Select')

14. Change the name of the new output stream to **SelectCreditCard**.

    ![The output stream name is SelectCreditCard.](media/azure-synapse-selectcreditcard.png 'Output stream name')

15. Select the **+** option next to the source and choose **Sink** from the Destination list.

    ![The destination Sink is selected.](media/azure-synapse-new-sink.png 'Sink')

16. Change the name of the new output stream to **SinkCreditCard**.  Then select the **+ New** option to create a new Dataset.

    ![The new Dataset option is selected.](media/azure-synapse-sinkcreditcard.png 'New Dataset')

17. From the New integration dataset menu, select **Azure Data Lake Storage Gen2** and then select **Continue**.

    ![The new Dataset option is selected.](media/azure-synapse-sink-dlsgen2.png 'New Dataset')

18. On the Select format menu, choose **DelimitedText** for the output type and then select **Continue**.

    ![The delimited text option is selected.](media/azure-synapse-sink-format.png 'Select format')

19. Enter **outputCreditCardCSV** as the file name.  Then, from the Linked service menu, choose **+ New**.

    ![The new linked service is selected.](media/azure-synapse-sink-properties.png 'Set properties')

20. In the **New linked service** menu, complete the following and then select **Create** to create a new Azure Data Lake Storage Gen2 linked service.

    | Field                          | Value                                              |
    | ------------------------------ | ------------------------------------------         |
    | Name                           | _`SynapseLabFraudADLS`_ |
    | Authentication method          | _select `Account key`_                             |
    | Account selection method       | _select `From Azure subscription`_                 |
    | Azure subscription             | _select your Azure subscription_                   |
    | Storage account name           | _`synapselabfraud` + unique id (example: `synapselabfraud312535`)_ |

    ![The new linked service is selected.](media/azure-synapse-linked-service.png 'Set properties')

21. In the Set properties menu, in the File path section, enter **synapse** into the **File System** box.  Then, select the **First row as header** option and select **OK**.

    ![The output properties are set.](media/azure-synapse-linked-service-file-path.png 'File path')

22. Enable data flow debugging by toggling the **Data flow debug** option.

    ![The data flow debug option is selected.](media/azure-synapse-data-flow-debug.png 'Data flow debug')

23. Choose the **AutoResolveIntegrationRuntime** integration runtime, select **1 hour** for time to live, and select **OK**. It may take several minutes for setup to complete.

    ![The data flow debug option is selected.](media/azure-synapse-data-flow-ir.png 'Data flow debug')

24. After the debugger starts, select **Publish all**.

    ![The Publish all option is selected.](media/azure-synapse-data-flow-publish-all.png 'Publish all')

25. Select the **Publish** option to save your changes.

    ![The Publish option is selected.](media/azure-synapse-data-flow-publish.png 'Publish')

26. Navigate to the **Integrate** hub.

    ![Integrate hub.](media/integrate-hub.png "Integrate hub")

27. Select **+** and then choose **Pipeline** to create a new pipeline.

    ![The new Pipeline option is selected.](media/azure-synapse-pipeline.png 'Pipeline')

28. Set the name of the pipeline to **PipelineCreditCard**.

    ![The new Pipeline has a name.](media/azure-synapse-pipelinecreditcard.png 'PipelineCreditCard')

29. Drill down into the **Move & transform** menu and bring a **Data flow** onto the canvas.

    ![Create a data flow.](media/azure-synapse-pipeline-dataflow.png 'Data flow')

30. In the Adding data flow tab, select **DataflowCreditCard** from the Existing data flow drop-down list.  Then, select **OK** to continue.

    ![The data flow is selected.](media/azure-synapse-pipeline-dataflow-1.png 'Data flow')

31. Select the data flow and then navigate to the **Settings** menu.  In the PolyBase sub-menu, change the Staging linked service to **SynapseLabFraudADLS**, the staging storage folder's container to **synapse** and folder to **creditcard**.

    ![The PolyBase settings are created.](media/azure-synapse-pipeline-dataflow-settings.png 'Settings')

32. Select **Debug** to run the pipeline.

    ![The option to debug the newly-created pipeline is selected.](media/azure-synapse-pipeline-dataflow-debug.png 'Debug')

33. Wait until the Output tab has a **Succeeded** status message. You may need to periodically select the **Refresh** button to view the updated status.

    ![The debug run has succeeded.](media/azure-synapse-pipeline-dataflow-succeeded.png 'Debug Succeeded')

34. Select the **Data** tab from Synapse studio.

    ![The Data option is selected.](media/azure-synapse-data.png 'Data')

35. Navigate to the **synapselabfraud###asws** option and navigate to **synapse (Primary)**.  In the root directory, there will be two files which start with **part-00001-**.  Right-click on the file which is 101.2 MB and choose **Rename**.

    ![The Rename option is selected for the scored credit card data.](media/azure-synapse-rename.png 'Rename')

36. Change the file name to **CreditCardScored.csv** and select **Apply**.

    ![The scored credit card data file has been renamed.](media/azure-synapse-rename-1.png 'Rename file')

37. Right-click on the **CreditCardScored.csv** file and select **Preview**.

    ![The Preview option has been renamed.](media/azure-synapse-preview.png 'Preview')

38. Ensure that the **CreditCardScored.csv** file has the correct shape.

    ![The scored credit card file has been loaded with the appropriate column names.](media/azure-synapse-preview-file.png 'CreditCardScored.csv')

### Task 2:  Create a View

1. Select the **Develop** tab from Synapse studio.

    ![The Develop option is selected.](media/azure-synapse-develop.png 'Develop')

2. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

3. Ensure that you are connected to the **Built-in** option. Then, enter the following script into the script window and select **Run**.

    ```sql
    CREATE DATABASE synapse
    ```

    ![Create a new database.](media/azure-synapse-on-demand-db.png 'Create a synapse database')

4. Change the name of the script in the properties to **CreateServerlessDB**.

    ![The script is named CreateServerlessDB](media/azure-synapse-createserverlessdb.png "CreateServerlessDB")

5. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

6. Ensure that you are connected to the **Built-in** option. Then, in the Use database drop-down, select **synapse**.

    ![The synapse database is selected.](media/azure-synapse-synapse-database.png 'Use database synapse')

7. Change the name of the script to **CreateViewCreditCardLonLat**.

    ![The script is named CreateViewCreditCardLonLat.](media/azure-synapse-createview.png 'New script name')

8. Copy and paste the following into the script window. Change the three `synapselabfraud###` references to the primary ADLS Gen2 storage account for the Synapse workspace. Then select **Run** to execute the script.

    ```sql
    CREATE VIEW dbo.CreditCardLonLat AS
    SELECT
            credit.Time,
            city.name,
            city.lon,
            city.lat,
            city.alpha2,
            country.companyen,
            credit.V1,
            credit.V2,
            credit.V3,
            credit.V4,
            credit.V5,
            credit.V6,
            credit.V7,
            credit.V8,
            credit.V9,
            credit.V10,
            credit.V11,
            credit.V12,
            credit.V13,
            credit.V14,
            credit.V15,
            credit.V16,
            credit.V17,
            credit.V18,
            credit.V19,
            credit.V20,
            credit.V21,
            credit.V22,
            credit.V23,
            credit.V24,
            credit.V25,
            credit.V26,
            credit.V27,
            credit.V28,
            credit.Amount,
            credit.Class,
            credit.id
    FROM
    OPENROWSET(
            BULK 'https://synapselabfraud###.blob.core.windows.net/synapse/CreditCardScored.csv',
            FORMAT = 'CSV',
            FIELDTERMINATOR =',',
            FIRSTROW = 2,
            ESCAPECHAR = '\\'
        )
        WITH (
            [Time] float,
            [V1] float,[V2] float,[V3] float,[V4] float,[V5] float,[V6] float,[V7] float,[V8] float,[V9] float,[V10] float,
            [V11] float,[V12] float,[V13] float,[V14] float,[V15] float,[V16] float,[V17] float,[V18] float,[V19] float,[V20] float,
            [V21] float,[V22] float,[V23] float,[V24] float,[V25] float,[V26] float,[V27] float,[V28] float,
            [Amount] float,[Class] int,[id] varchar(20)
        ) AS [credit]
    LEFT JOIN
    OPENROWSET(
            BULK 'https://synapselabfraud###.dfs.core.windows.net/synapse/CityList.csv',
            FORMAT = 'CSV',
            FIELDTERMINATOR =',',
            FIRSTROW = 2,
            ESCAPECHAR = '\\'
        )
        WITH (
            [id] VARCHAR (20) ,
            [name] VARCHAR (100) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
            [state] VARCHAR (10) ,
            [alpha2] VARCHAR (2) ,
            [lon] float,
            [lat] float
        ) AS [city] ON
        credit.id = city.id
    LEFT JOIN
    OPENROWSET(
            BULK 'https://synapselabfraud###.dfs.core.windows.net/synapse/CountryList.csv',
            FORMAT = 'CSV',
            FIELDTERMINATOR =',',
            FIRSTROW = 2,
            ESCAPECHAR = '\\'
        )
        WITH (
            [companyjp] VARCHAR (20) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
            [companyen] VARCHAR (100) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
            [numeric] decimal,
            [alpha3] VARCHAR (3) ,
            [alpha2] VARCHAR (2) ,
            [location] VARCHAR (100) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
            [subvivision] VARCHAR (15) COLLATE Latin1_General_100_CI_AI_SC_UTF8
        ) AS [country] ON
        city.alpha2 = country.alpha2
    ```

### Task 3:  Power BI Fraud Map Report Development

1. Open the RDP file from the Before the Hands-On Lab section and select **Connect** to access the virtual machine.  When prompted for credentials, enter `powerbiuser` for the username and the password you chose.

    ![Connect to a remote host.](media/azure-vm-connect-3.png 'Connect to a remote host')

2. Open a browser in the virtual machine.  In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics** from the results.

    ![In the Services search result list, Azure Synapse Analytics is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics')

3. Select the workspace you created before the hands-on lab.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'The fraud detection Synapse workspace')

4. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

5. Select the **Develop** tab from Synapse studio.

    ![The Develop option is selected.](media/azure-synapse-develop.png 'Develop')

6. Drill down into the **Power BI** menu and then the **FraudDetection** menu, followed by **Power BI datasets**.  Choose the **+ New Power BI dataset** option.

    ![Create a new Power BI dataset.](media/azure-synapse-new-power-bi-dataset.png 'New Power BI dataset')

7. Hover over the **synapsesql** serverless SQL database and then select **Download .pbids file**.

    ![The option to download a Power BI dataset file is selected.](media/power-bi-pbids.png 'New Power BI dataset')

8. Open the downloaded Power BI dataset file in Power BI Desktop. If you are prompted to sign in to the Power BI dataset, select **Microsoft account** in the left-hand menu, then click the **Sign in** button to enter your Azure credentials.

    ![The Microsoft account tab and sign in button are highlighted.](media/power-bi-serverless-signin.png "SQL Server database")

9. After signing in with your Azure credentials, click **Connect**.

    ![The Connect button is highlighted.](media/power-bi-serverless-signin2.png "SQL Server database")

10. On the Navigator page, select the **CreditCardLonLat** view and then select **Load**.

    ![The credit card longitude and latitude view is selected.](media/power-bi-lonlat-1.png 'Navigator')

11. In the Connection settings modal dialog, select **Import** and then select **OK**.

    ![The Import option is selected.](media/power-bi-new-dataset-6.png 'Connection settings')

12. Select the **lat** column. In the **Column tools** tab, select the drop-down for Summarization and select **Don't summarize**. Select the drop-down for Data category and choose **Latitude**. Repeat this for the **lon** column, setting the Data category to **Longitude** and Summarization to **Don't summarize**.

    ![The lat column has a data category of Latitude.](media/power-bi-new-lonlat-lat.png 'Data category')

13. Select the **ArcGIS Maps for Power BI** visualization and drag it onto the canvas. Expand it to fill the canvas.

    ![The ArcGIS Map visualization is selected.](media/power-bi-new-lonlat-gismap.png "ArcGIS Maps for Power BI Visualization")

    > **Note**: You do not need to sign in to the ArcGIS service.

14. Drag the **Amount** data field into `Size` and `Color`, the **lat** data field into `Latitude`, and the **lon** data field into `Longitude`.

    ![The credit card data fields are added to the map.](media/power-bi-new-lonlat2.png 'Visualizations and Filters')

15. Drag the **Class** data field into the **Filters on this visual** section. In the Filter type drop-down, select **Basic filtering**.

    ![The Class filter has been added to the map visual.](media/power-bi-new-lonlat-3.png 'Filters on this visual')

16. Change the filter on **Class** to include only fraudulent transactions by checking the **1 checkbox**. This report allows you to understand the geographical features of the unauthorized use of credit cards and to implement concrete measures to temporarily restrict the use of credit cards in cities that show the beginnings of a concentration of unauthorized uses of credit cards for large amounts.

    ![The Class filter has been added to the map visual.](media/power-bi-new-lonlat4.png 'Filters on this visual')

## After the hands-on lab

Duration: 10 minutes

> **Note**: Only complete these steps if you are not using a hosted lab environment and deployed these resources in your own Azure subscription.

### Task 1: Delete Lab Resources

1. Log into the [Azure Portal](https://portal.azure.com).

2. On the top-left corner of the portal, select the menu icon to display the menu.

    ![The portal menu icon is displayed.](media/portal-menu-icon.png "Menu icon")

3. In the left-hand menu, select **Resource Groups**.

4. Navigate to and select the `synapse-lab-fraud-detection` resource group.

5. Select **Delete resource group**.

    ![On the synapse-lab-fraud-detection resource group, Delete resource group is selected.](media/azure-delete-resource-group-1.png 'Delete resource group')

6. Type in the resource group name (`synapse-lab-fraud-detection`) and then select **Delete**.

    ![Confirm the resource group to delete.](media/azure-delete-resource-group-2.png 'Confirm resource group deletion')

### Task 2:  Delete the Power BI Workspace

1. Navigate to [Power BI](https://app.powerbi.com) and log in if prompted.

2. In the Workspaces menu, select the **...** menu option for the **FraudDetection** workspace and then choose **Workspace settings**.

    ![The workspace settings option is selected.](media/power-bi-workspace-settings.png 'Workspace settings')

3. In the Settings panel, select **Delete workspace** to delete the workspace.

    ![The option to delete a workspace is selected.](media/power-bi-delete-workspace.png 'Delete workspace')

You should follow all steps provided *after* attending the Hands-on lab.
