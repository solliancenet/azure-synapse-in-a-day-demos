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

In this task, you will use the Azure Portal to create a new Azure Resource Group for this lab.

1. Log into the [Azure Portal](https://portal.azure.com).

2. On the top-left corner of the portal, select the menu icon to display the menu.

    ![The portal menu icon is displayed.](media/portal-menu-icon.png "Menu icon")

3. In the left-hand menu, select **Resource Groups**.

4. At the top of the screen select the **Add** button.

   ![Add Resource Group Menu](media/add-resource-group-menu.png 'Resource Group Menu')

5. Create a new resource group with the name **synapse-lab-fraud-detection**, ensuring that the proper subscription and region nearest you are selected. **Please note** that currently, the only regions available for deploying to the Azure Database for PostgreSQL Hyperscale (Citus) deployment option are East US, East US 2, West US 2, North Central US, Canada Central, Australia East, Southeast Asia, North Europe, UK South, and West Europe. It is therefore recommended that you choose one of these regions for your resource group and all created resources. Once you have chosen a location, select **Review + Create**.

   ![Create Resource Group](media/create-resource-group.png 'Resource Group')

6. On the Summary blade, select **Create** to provision your resource group.

### Listing the Resources Created During the Hands-On Training

The following are the resources you will create over the course of this hands-on training.

| No | Name | Type | Resource details |
| 1 | `synapselabfraud` + your initials + `asws` (example: `synapselabfraudjdhasws`) | Synapse workspace | Creates an Azure Synapse Analytics workspace. |
| 2 | `synapselabfraud` + your initials + `adls` (example: `synapselabfraudjdhadls`) | Storage account | Creates a StorageV2 (general-purpose v2) storage account. |
| 3 | `sqllabfraud` | SQL pool | Creates an SQL pool. |
| 4 | `sparklabfraud` | Apache Spark Pool | Creates an Apache Spark pool. |
| 5 | PowerBI | Virtual machine | Prepares a virtual environment for running the Power BI Desktop app. |

> **Note**: We will create the resources throughout the hands-on training, so do not create any of these resources yet.

### Prepare a Virtual Machine to Run Power BI Desktop

To proceed with the steps described in this hands-on training, you'll need to use the Power BI Desktop app that is installed in the Windows 10 environment.

In this step, you will create a virtual machine running Windows 10 and then install Power BI.

1. In the [Azure portal](https://portal.azure.com), type in "virtual machines" in the top search menu and then select **Virtual machines** from the results.

    ![In the Services search result list, Virtual machines is selected.](media/azure-create-vm-search.png 'Virtual machines')

2. Select **+ Add** on the Virtual machines page and then select the **Virtual machine** option.

3. In the **Basics** tab, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Subscription                   | _select the appropriate subscription_              |
   | Resource group                 | _select `synapse-lab-fraud-detection`_             |
   | Virtual machine name           | _`powerbi`_                                        |
   | Region                         | _select the resource group's location_             |
   | Availability options           | _select `No infrastructure redundancy required`_   |
   | Image                          | _select `Windows 10 Pro, Version 1809 - Gen1`_     |
   | Azure Spot instance            | _select `No`_                                      |
   | Size                           | _select `Standard_D2s_v3`_                         |
   | Username                       | _select `powerbiuser`_                             |
   | Password                       | _enter a password you will remember_               |
   | Key pair name                  | _select `modernize-app-vm_key`_                    |
   | Public inbound ports           | _select `Allow selected ports`_                    |
   | Select inbound ports           | _select `RDP (3389)`_                              |
   | Licensing                      | _select the option to confirm that you have an  eligible Windows 10 license with multi-tenant hosting rights._ |

   ![The form fields are completed with the previously described settings.](media/azure-create-vm-1.png 'Create a virtual machine')

4. Select **Review + create**. On the review screen, select **Create**.  After the deployment completes, select **Go to resource** to go to the virtual machine.

    ![The Go to resource option is selected.](media/azure-create-vm-2.png 'Go to resource')

5. Select **Connect** from the actions menu and choose **RDP**.

    ![The option to connect to the virtual machine via RDP is selected.](media/azure-vm-connect.png 'Connect via RDP')

6. On the **Connect** tab, select **Download RDP File**.

    ![Download the RDP file to connect to the Power BI virtual machine.](media/azure-vm-connect-2.png 'Download RDP File')

7. Open the RDP file and select **Connect** to access the virtual machine.  When prompted for credentials, enter `powerbiuser` for the username and the password you chose.

    ![Connect to a remote host.](media/azure-vm-connect-3.png 'Connect to a remote host')

8. Launch the Microsoft App Store from the Windows 10 taskbar.

    ![Launch the Microsoft Store.](media/vm-launch-app-store.png 'Microsoft Store')

9. Enter **power bi** into the search menu and select **Power BI Desktop** from the results.

    ![The Power BI Desktop app is selected.](media/vm-install-power-bi.png 'Power BI Desktop')

10. Select **Get** to install Power BI Desktop on the virtual machine.

    ![The option to get Power BI is selected.](media/vm-download-power-bi.png 'Get Power BI Desktop')

11. After installation completes, select **Launch** to open Power BI Desktop.

    ![The option to launch Power BI is selected.](media/vm-launch-power-bi.png 'Launch Power BI Desktop')

### Provision Azure Data Lake Storage Gen2

Azure Data Lake Storage Gen2 will be critical for several integration points throughout the hands-on lab.

1. Navigate to the [Azure portal](https://portal.azure.com).

2. Select **+ Create a resource**, type in "storage account" in the search field, then select **Storage account** from the results.

   ![On the new resource page, Storage account is selected.](media/azure-create-storage-account-search.png 'Storage Account')

3. Select **Create** on the Storage account details page.

4. Within the **Storage account** form, complete the following:

   | Field                          | Value                                       |
   | ------------------------------ | ------------------------------------------  |
   | Subscription                   | _select the appropriate subscription_       |
   | Resource group                 | _select `synapse-lab-fraud-detection`_      |
   | Storage account name           | _`synapselabfraud` + your initials + `adls` (example: `synapselabfraudjdhadls`)_ |
   | Location                       | _select the resource group's location_      |
   | Pricing tier                   | _select Standard_                           |
   | Account kind                   | _select StorageV2 (general purpose v2)_     |
   | Replication                    | _select Locally-redundant storage (LRS)_    |
   | Access tier                    | _select Hot_                                |

    ![The form fields are completed with the previously described settings.](media/azure-create-storage-account-1.png 'Storage Account Settings')

    Then select **Next : Networking >**.

5. Leave the networking settings at their default values: a connectivity method of **Public endpoint (all networks)** and a network routing preference of **Microsoft network routing (default)**.  Select **Next : Data protection >** and leave these settings at their default values.

6. Select **Next : Advanced >**. In the Data Lake Gen2 section, enable **Hierarchical namespace**.

    ![The Hierarchical namespace option is enabled.](media/azure-create-storage-account-2.png 'Storage Account Advanced Settings')

7. Select **Review + create**. On the review screen, select **Create**.

### Provision an Azure Synapse Analytics Workspace

1. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics (workspaces preview)** from the results.

    ![In the Services search result list, Azure Synapse Analytics (workspaces preview) is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics (workspaces preview)')

2. Select **+ Add** on the Azure Synapse Analytics (workspaces preview) page.

3. Within the **Create Synapse workspace** form, complete the following:

   | Field                                                | Value                                            |
   | ---------------------------------------------------- | ------------------------------------------       |
   | Subscription                                         | _select the appropriate subscription_            |
   | Resource group                                       | _select `synapse-lab-fraud-detection`_           |
   | Workspace name                                       | _`synapselabfraud` + your initials + `asws` (example: `synapselabfraudjdhasws`)_  |
   | Region                                               | _select the resource group's location_           |
   | Select Data Lake Storage Gen2                        | _select `From subscription`_                     |
   | Account name                                         | _select the storage account you created earlier_ |
   | File system name                                     | _select `Create new` and enter `synapse`_        |
   | Assign myself the Storage Blob Data Contributor role | _ensure the box is checked_                      |

   ![The form fields are completed with the previously described settings.](media/azure-create-synapse-1.png 'Create Synapse workspace')

   > **Note**: Please replace the `#SUFFIX#` tag in the workspace name with a suffix you would like to use. Names of workspaces must be globally unique.

   You might see the following error after entering a workspace name:  **The Azure Synapse resource provider (Microsoft.Synapse) needs to be registered with the selected subscription.** If you see this error, select **Click here to register**, located between the Subscription and Resource group.

   ![The link to register the Synapse resource provider to a subscription is selected.](media/azure-create-synapse-register.png 'Register Synapse to subscription')

   > **Important**: Be sure to check the box which reads "Assign myself the Storage Blob Data Contributor role on the Data Lake Storage Gen2 account"!  If you do not check this box, you will be unable to complete certain exercises unless you add your account as a Storage Blob Data Contributor later.

4. Select **Next : Security + networking >** to move on to the Security and Networking page.  On the Security and Networking page, enter a valid password you will remember. Leave the other options at their default values.

    ![The Security and Networking page with a valid password entered.](media/azure-create-synapse-2.png 'Security and Networking')

5. Select **Review + create**. On the review screen, select **Create**.  Provisioning takes **up to 10** minutes.

### Upload Materials Required for the Hands-On Training

1. Navigate to the **synapse-lab-fraud-detection** resource group in the [Azure portal](https://portal.azure.com).

    ![The resource group named azure-synapse-lab-fraud-detection-rg is selected.](media/azure-synapse-lab-fraud-detection-rg.png 'The Synapse fraud detection lab resource group')

    If you do not see the resource group in the Recent resources section, type in "resource groups" in the top search menu and then select **Resource groups** from the results.

    ![In the Services search result list, Resource groups is selected.](media/azure-resource-group-search.png 'Resource groups')

    From there, select the **synapse-lab-fraud-detection** resource group.

2. Select the **synapselabfraud###adls** storage account which you created before the hands-on lab. Note that there may be multiple storage accounts, so be sure to choose the one you created.

    ![The storage account named synapselabfraudjdhadls is selected.](media/azure-storage-account-select.png 'The synapselabfraudjdhadls storage account')

3. In the **Data Lake Storage** section, select **Containers**. Then, select the **synapse** container you created before the hands-on lab.

    ![The Container named synapse is selected.](media/azure-storage-account-synapse.png 'The synapse storage container')

4. Select the **Upload** option. In the Files section, select the folder icon to upload files. Navigate to where you saved **CityList.csv** and choose this file for upload. Then select **Upload** to finish uploading the file.  Repeat the process for **CountryList.csv**, **CreditCard.csv**, and **rf_model.onnx** files.

    ![The historical maintenance record data is uploaded.](media/azure-synapse-upload.png 'Historical maintenance record')

5. In the **Settings** menu, select **Access keys**.  Then, copy the **Storage account name** and **key1 Key** values and paste them into a text editor for later use.

    ![The storage account name and access key are copied.](media/azure-storage-access-keys.png 'Access keys')

### Create a SQL Pool

1. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics (workspaces preview)** from the results.

    ![In the Services search result list, Azure Synapse Analytics (workspaces preview) is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics (workspaces preview)')

2. Select the workspace you created before the hands-on lab.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapselabfraudjdhasws workspace')

3. In the Synapse workspace, select **+ New SQL pool** to create a new SQL pool.

    ![The Synapse workspace page with New SQL Pool selected.](media/azure-create-synapse-3.png 'Synapse workspace')

4. Enter a SQL pool name of `synapsesql` and select a performance level of DW100c.

    ![The form fields are completed with the previously described settings.](media/azure-create-synapse-4.png 'Create SQL pool')

5. Select **Review + create**. On the review screen, select **Create**.  Provisioning takes **up to 10** minutes. While this is underway, it is safe to continue to the next task.

### Create a Spark Pool

1. In the Synapse workspace, select **+ New Apache Spark pool** to create a new Spark pool.

    ![The Synapse workspace page with New Spark Pool selected.](media/azure-create-synapse-5.png 'Synapse workspace Spark pool')

2. In the **Create Apache Spark pool** window, complete the following:

    | Field                          | Value                                              |
    | ------------------------------ | ------------------------------------------         |
    | Apache Spark pool name         | _`synapsespark`_                                   |
    | Autoscale                      | _select `disabled`_                                |
    | Node size                      | _select `Small (4 vCPU / 32 GB)`_                  |
    | Number of nodes                | _select `3`_                                       |

    ![In the Create Apache Spark pool output, form field entries are filled in.](media/azure-synapse-create-spark-pool.png 'Create Apache Spark pool output')

3. Select **Review + create**. On the review screen, select **Create**.  Provisioning may take several minutes.

### Create a SQL On-Demand Database

1. Select **Launch Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

2. Select the **Develop** tab from the Synapse studio.

    ![The Develop option is selected.](media/azure-synapse-develop.png 'Develop')

3. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

4. Ensure that you are connected to the **SQL on-demand** option. Then, enter the following script into the script window and select **Run**.

    ```sql
    CREATE DATABASE synapse
    ```

    ![Create a new database.](media/azure-synapse-on-demand-db.png 'Create a synapse database')

5. Change the name of the script in the properties to **CreateOnDemandDB**.

    ![The script is named CreateOnDemandDB.](media/azure-synapse-createondemanddb.png 'CreateOnDemandDB')

### Prepare to Call a Machine Learning Model

1. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

2. Choose the **synapsesql** connection option and the **synapsesql** database from the database drop-down list.

    ![The synapsesql database is selected.](media/azure-synapse-develop-synapsesql.png 'synapsesql database')

3. Change the name of the script in the properties to **CreateONNXModel**.

    ![The script is named CreateONNXModel.](media/azure-synapse-createonnxmodel.png 'CreateONNXModel')

4. Enter the following code into the script window.

    ```sql
    CREATE EXTERNAL TABLE [synapse].[Models]
    (
        [Model] [varbinary](max) NULL
    )
    WITH
    (
        LOCATION = 'rf_model.onnx',
        DATA_SOURCE = [CSVDataSource],
        FILE_FORMAT = [CSVFileFormat],
        REJECT_TYPE = VALUE,
        REJECT_VALUE = 0
    );
    ```

5. Select the **Publish all** option.

    ![The publish all option is selected.](media/azure-synapse-publish-all.png 'Publish all')

6. Select the **Publish** option to save these scripts.

    ![The Publish option is selected.](media/azure-synapse-publish.png 'Publish')

### Create a Power BI Workspace

1. In a new tab or window, navigate to the Power BI website, [https://powerbi.microsoft.com/](https://powerbi.microsoft.com/).  Select **Sign in** and sign in.

    ![The Sign in option is selected.](media/power-bi-sign-in.png 'Sign in')

2. Select the **Workspaces** menu and then choose **Create workspace**.

    ![The Create a workspace option is selected.](media/power-bi-create-workspace.png 'Create a workspace')

3. In the Create a workspace menu, enter **FraudDetection** as the name and select **Save**.

    ![The FraudDetection workspace is saved.](media/power-bi-create-workspace-1.png 'FraudDetection workspace')

4. Return to the Synapse studio.  Select the **Home** option.

    ![The Home option is selected.](media/azure-synapse-home.png 'Home')

5. Select the **Visualize** option.

    ![The Visualize option is selected.](media/azure-synapse-visualize.png 'Visualize')

6. In the **Connect to Power BI** tab, complete the following and then select **Connect** to create a new Power BI connection.

    | Field                          | Value                                              |
    | ------------------------------ | ------------------------------------------         |
    | Name                           | _`FraudDetectionWorkspace`_                        |
    | Tenant                         | _select your Power BI tenant_                      |
    | Workspace name                 | _select the `FraudDetection` workspace_            |

    ![In the Connect to Power BI tab, form field entries are filled in.](media/azure-synapse-connect-power-bi.png 'Connect to Power BI')

## Exercise 1:  Scoring predictions from T-SQL using a pre-trained model

You will use masked data, obtained by applying principal component analysis to credit card transaction data, to evaluate which transactions are fraudulent and to analyze trends in elapsed time and fraud amounts.

### Task 1:  Dataset Creation

1. In the [Azure portal](https://portal.azure.com), type in "azure synapse analytics" in the top search menu and then select **Azure Synapse Analytics (workspaces preview)** from the results.

    ![In the Services search result list, Azure Synapse Analytics (workspaces preview) is selected.](media/azure-create-synapse-search.png 'Azure Synapse Analytics (workspaces preview)')

2. Select the workspace you created before the hands-on lab.

    ![The Azure Synapse Analytics workspace for the lab is selected.](media/azure-synapse-select.png 'synapselabfraudjdhasws workspace')

3. Select **Launch Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

4. Select the **Develop** tab from the Synapse studio.

    ![The Develop option is selected.](media/azure-synapse-develop.png 'Develop')

5. From the **+** menu, choose **SQL script** to open a new script.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

6. Choose the **synapsesql** connection option and the **synapsesql** database from the database drop-down list.

    ![The synapsesql database is selected.](media/azure-synapse-develop-synapsesql.png 'synapsesql database')

7. Change the name of the script to **CreateSchema**.

    ![The script is named CreateSchema.](media/azure-synapse-script-createschema.png 'CreateSchema')

8. Enter the following code into the script window.  Then, select **Run** to execute the code.

    ```sql
    CREATE SCHEMA synapse
    ```

    ![The create schema script has been run.](media/azure-synapse-script-createschema.png 'Create Schema')

9. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

10. Change the name of this script to **CreateMasterKey**.  Enter the following into the script window, changing `{Password}` to a password you can remember.  Then, select **Run** to execute the code.

    ```sql
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '{Password}'
    ```

    ![The master key creation script has been run.](media/azure-synapse-script-createmasterkey.png 'Create Master Key')

11. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

12. Change the name of this script to **CreateAzureStorageAccountKey**.  Enter the following into the script window, filling in your storage account name and access key.  Then, select **Run** to execute the code.

    ```sql
    CREATE DATABASE SCOPED CREDENTIAL AzureStorageAccountKey
    WITH IDENTITY = '<Your Storage Account>',
    SECRET = '<Your Access Key>';
    ```

    ![The database scoped credential has been created.](media/azure-synapse-script-create-dsc.png 'Create Database Scoped Credential')

13. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

14. Change the name of this script to **CreateCSVDataSource**.  Enter the following into the script window, filling in your storage account name and access key.  Then, select **Run** to execute the code.

    ```sql
    CREATE EXTERNAL DATA SOURCE CSVDataSource WITH
    (
        TYPE = HADOOP,
        LOCATION = 'wasbs://synapse@<Your Storage Account>.blob.core.windows.net',
        CREDENTIAL = AzureStorageAccountKey
    );
    ```

    ![The external data source has been created.](media/azure-synapse-create-data-source.png 'Create External Data Source')

15. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

16. Change the name of this script to **CreateCSVFileFormat**.  Enter the following into the script window, filling in your storage account name and access key.  Then, select **Run** to execute the code.

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
    ```

    ![The external file format has been created.](media/azure-synapse-script-create-fileformat.png 'Create External File Format')

17. From the **+** menu, choose **SQL script** to open a new script.  Ensure that you are connected to the **synapsesql** SQL pool and the **synapsesql** database.

    ![Create a new SQL script.](media/azure-synapse-new-script.png 'SQL script')

18. Change the name of this script to **CreateExternalCreditCard**.  Enter the following into the script window, filling in your storage account name and access key.  Then, select **Run** to execute the code.

    ```sql
    CREATE EXTERNAL TABLE synapse.exCreditCard
    (
            [Time] varchar(20),
            [V1] float,[V2] float,[V3] float,[V4] float,[V5] float,[V6] float,[V7] float,[V8] float,[V9] float,[V10] float,
            [V11] float,[V12] float,[V13] float,[V14] float,[V15] float,[V16] float,[V17] float,[V18] float,[V19] float,[V20] float,
            [V21] float,[V22] float,[V23] float,[V24] float,[V25] float,[V26] float,[V27] float,[V28] float,
            [Amount] float,[Class] varchar(20),[id] varchar(20)
    )
    WITH
    (
            LOCATION = 'CreditCard.csv',
            DATA_SOURCE = [CSVDataSource],
            FILE_FORMAT = [CSVFileFormat]
    );
    ```

    ![The external table has been created.](media/azure-synapse-script-create-externalcc.png 'Create External Table')

19. Select the **Data** option from the menu.  Navigate to **synapsesql** and then **External tables**.  Right-click on the **synapse.exCreditCard** table and choose **New SQL script** and then **Select TOP 100 rows**.

    ![Select the top 100 rows is selected.](media/azure-synapse-script-select-top100.png 'Select TOP 100 rows')

20. Select the **Properties** icon to display the menu.  Rename the name to **SelectExternalCreditCard**.  Then, select **Publish all**.

    ![The publish all option is selected.](media/azure-synapse-publish-all-2.png 'Publish all')

21. Select the **Publish** option to save these scripts.

    ![The Publish option is selected.](media/azure-synapse-publish-2.png 'Publish')

### Task 2:  Query Development
