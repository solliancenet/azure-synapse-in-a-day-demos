# Azure Synapse in a day demos - Infrastructure

- [Azure Synapse in a day demos - Infrastructure](#azure-synapse-in-a-day-demos---infrastructure)
  - [Overview](#overview)
    - [Pre-requisites](#pre-requisites)
  - [Building analytic solutions with Azure Synapse Analytics (Basic)](#building-analytic-solutions-with-azure-synapse-analytics-basic)
    - [About the latest data analysis infrastructure](#about-the-latest-data-analysis-infrastructure)
    - [Scenario](#scenario)
    - [Hands-on architecture](#hands-on-architecture)
  - [Exercise 0: Download lab files](#exercise-0-download-lab-files)
  - [Exercise 1: Deploy Azure Synapse Analytics](#exercise-1-deploy-azure-synapse-analytics)
    - [Task 1: Create Azure Synapse Analytics workspace](#task-1-create-azure-synapse-analytics-workspace)
    - [Task 2: Set up blob data owner](#task-2-set-up-blob-data-owner)
    - [Task 3: Set up user access administrator](#task-3-set-up-user-access-administrator)
    - [Task 4: Log in to Synapse Studio](#task-4-log-in-to-synapse-studio)
  - [Exercise 2: Moving data to the data lake using Copy activity](#exercise-2-moving-data-to-the-data-lake-using-copy-activity)
    - [About Synapse Pipeline](#about-synapse-pipeline)
    - [Task 1: Create a Linked Service](#task-1-create-a-linked-service)
    - [Task 2: Create a Copy pipeline](#task-2-create-a-copy-pipeline)
  - [Exercise 3: Create a SQL Pool and table](#exercise-3-create-a-sql-pool-and-table)
    - [Task 1: Create a SQL Pool](#task-1-create-a-sql-pool)
    - [Task 2: Create table](#task-2-create-table)
  - [Exercise 4: Implement Spark ETL with the GUI](#exercise-4-implement-spark-etl-with-the-gui)
    - [Task 1: Create ADLS Gen2 Linked Service](#task-1-create-adls-gen2-linked-service)
    - [Task 2: Create mapping data flow sources](#task-2-create-mapping-data-flow-sources)
    - [Task 3: Create a filter](#task-3-create-a-filter)
    - [Task 4: Add calculated columns](#task-4-add-calculated-columns)
    - [Task 5: Select columns](#task-5-select-columns)
    - [Task 6: Aggregation process](#task-6-aggregation-process)
    - [Task 7: Data join process](#task-7-data-join-process)
    - [Task 8: Data output](#task-8-data-output)
    - [Task 9: Create and run Pipeline](#task-9-create-and-run-pipeline)
    - [Task 10: View the transformed data](#task-10-view-the-transformed-data)
  - [Exercise 5: Visualize with Power BI](#exercise-5-visualize-with-power-bi)
    - [Task 1: Connect Power BI Desktop](#task-1-connect-power-bi-desktop)
    - [Task 2: Create a report](#task-2-create-a-report)
    - [Task 3: Save Power BI Desktop report](#task-3-save-power-bi-desktop-report)
    - [Task 4: Create a Power BI workspace (optional)](#task-4-create-a-power-bi-workspace-optional)
    - [Task 5: Create a Power BI Linked Service (optional)](#task-5-create-a-power-bi-linked-service-optional)
    - [Task 6: Create a Power BI dataset (optional)](#task-6-create-a-power-bi-dataset-optional)
  - [Build a predictive maintenance solutions with Azure Synapse Analytics (Advanced)](#build-a-predictive-maintenance-solutions-with-azure-synapse-analytics-advanced)
    - [About Lambda Architecture](#about-lambda-architecture)
    - [Scenario](#scenario-1)
    - [Hands-on architecture](#hands-on-architecture-1)
  - [Exercise 6: Create stream processing](#exercise-6-create-stream-processing)
    - [Task 1: IoT Hub resource creation](#task-1-iot-hub-resource-creation)
    - [Task 2: Event source settings](#task-2-event-source-settings)
    - [Task 3: Create and configure Stream Analytics resources](#task-3-create-and-configure-stream-analytics-resources)
  - [Exercise 7: Explore Data with Query-as-a-Service](#exercise-7-explore-data-with-query-as-a-service)
    - [Task 1: Query for Parquet files](#task-1-query-for-parquet-files)
    - [Task 2: Create a view](#task-2-create-a-view)
    - [Task 3: Create near-real-time dashboards](#task-3-create-near-real-time-dashboards)
  - [Exercise 8: Create a structured process for large amounts of data with Spark](#exercise-8-create-a-structured-process-for-large-amounts-of-data-with-spark)
    - [Task 1: Create a Spark pool](#task-1-create-a-spark-pool)
    - [Task 2: Develop Spark ETL](#task-2-develop-spark-etl)
  - [Exercise 9: Spark ML learning/inference and SQL pool load](#exercise-9-spark-ml-learninginference-and-sql-pool-load)
    - [Task 1: Import and execute notebook](#task-1-import-and-execute-notebook)
  - [Exercise 10: Visualize with Power BI](#exercise-10-visualize-with-power-bi)
    - [Task 1: Create connections and relationships](#task-1-create-connections-and-relationships)
  - [Exercise 11: End processing](#exercise-11-end-processing)
    - [Task 1: Pause the SQL pool](#task-1-pause-the-sql-pool)
    - [Task 2: Stop Stream Analytics](#task-2-stop-stream-analytics)
    - [Task 3: Stop Virtual Devices application](#task-3-stop-virtual-devices-application)

## Overview

This is a hands-on lab for infrastructure, telecommunications, transportation, and manufacturing using Azure Synapse Analytics. It provides step-by-step procedures for basic analysis platform construction, IoT sensor data visualization, and predictive maintenance features.

### Pre-requisites

To complete this lab, you must meet the following pre-requisites:

1. Microsoft Azure subscription must be pay-as-you-go or MSDN.

    a. Trial subscriptions will not work.

2. Install [Power BI Desktop](https://aka.ms/pbidesktopstore).

3. Windows desktop machine (or Azure VM with a Windows 10 image) for the IoT Device emulator.

4. [Power BI Pro license](https://powerbi.microsoft.com/power-bi-pro/) (can start a trial version of Pro).

    > If you have permission to publish reports to your Workspace (≠My Workspace), you can create Power BI Reports on Synapse. (Required: Power BI Pro license). If not, you can create a Report solely with Power BI Desktop.

## Building analytic solutions with Azure Synapse Analytics (Basic)

### About the latest data analysis infrastructure

The modern data analytics infrastructure, called the Modern Data Warehouse pattern, is based on the following points to address big data:

- Scalability

    By focusing on a managed infrastructure of PaaS, scalability that is difficult to get on-premises can be achieved. By incorporating a distributed processing infrastructure such as Spark, data processing in petabytes can be performed quickly.

- Use of data lakes

    The data lake accumulates unstructured data, such as JSON and image data. By implementing structured processing by distributed processing, visualization of data that has been difficult to use in the past and the use of AI will be promoted.

In traditional Azure data analytic infrastructures, the solution was for architects to combine PaaS such as Azure Data Factory, Azure Databricks, Azure SQL Data Warehouse, and Azure Data Lake Storage to accommodate a variety of workloads.

**Traditional Azure analytic infrastructure configuration**

![The traditional analytics pattern is displayed.](media/traditional-azure-analytics.png "Traditional Azure Analytics")

With Azure Synapse Analytics, enjoy advantages of traditional scalable cloud data analytic infrastructures while:

- Building analytical infrastructures more quickly
- Reducing infrastructure complexity
- Reducing costs and improving development efficiency with integrated workspace and management screen

**Azure Synapse Analytics**

![Synapse Analytics takes the place of ADF, Azure Databricks, and Azure SQL Data Warehouse.](media/azure-synapse-analytics.png "Azure Synapse Analytics")

### Scenario

Build a flight delay visualization solution. With Azure Synapse Analytics, an analytic infrastructure can be built in a short time frame.

This lab will guide you through the basic deployment of Azure Synapse Analytics and creating DWH, and practicing GUI-based distributed ETL processing and reporting.

### Hands-on architecture

You will configure an architecture such as the following:

> TODO: Update image

To build the architecture, complete the following tasks:

1. Deploy Azure Synapse Analytics
2. Create a link between flight delay data in the data lake
3. Create a SQL Pool
4. Create distributed ETL processing in the GUI with Mapping Data Flow
5. Visualize flight delay

## Exercise 0: Download lab files

Time required: 5 minutes

The lab files are located in a GitHub repo. You must unzip the file and extract it to your desktop so you can access them throughout the lab.

1. Download the ZIP file for the lab from <https://github.com/solliancenet/azure-synapse-in-a-day-demos/archive/master.zip>.

2. Extract the files to **`C:\`**. This will create a folder named `azure-synapse-in-a-day-demos-master` at the root of your C: drive.

    ![The extract zipped folders dialog is displayed.](media/unzip.png "Extract Compressed (Zipped) Folders")

3. Navigate to `C:\azure-synapse-in-a-day-demos-master\infrastructure\source` to view the files.

    ![The extracted files are displayed in Windows Explorer.](media/extracted-files.png "Extracted files")

## Exercise 1: Deploy Azure Synapse Analytics

Time required: 15 minutes

The first step is to deploy and configure the resources. It's easy to do from the Azure Portal.

> TODO: Update image

### Task 1: Create Azure Synapse Analytics workspace

1. Navigate to the Azure portal (<https://portal.azure.com>) to create the Azure Synapse Analytics workspace.

2. In the search menu, type **Synapse**, then select **Azure Synapse Analytics (workspaces preview)**.

    ![Synapse is highlighted in the search box, and the Azure Synapse Analytics workspace preview item in the results is highlighted.](media/search-synapse.png "Synapse search")

3. Select **Add**.

    ![The add button is selected.](media/synapse-add.png "Add")

4. In the `Create Synapse workspace` form, enter the values shown in the table below. For the Azure Data Lake Storage Gen2 account name, select **Create new**, enter the account name, then select **OK**.

    ![The form is shown as described below.](media/create-synapse-1.png "Create Synapse workspace 1")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | Resource group | `synapse-lab-infrastructure` | Select **Create new**, then enter the name. |
    | Workspace name | `synapselabinfra` + your initials + `asws` (example: `synapselabinfrajdhasws`) | Lowercase alphanumeric characters only |
    | Region | Select the region closest to you, such as `West US`. | |
    | Select Data Lake Storage Gen2 | From subscription | Default settings |
    | Account name | `synapselabinfra` + your initials + `adls` (example: `synapselabinfrajdhadls`) | Select **Create new** (lowercase alphanumeric characters only) |

5. Select **Create new** for `File system name`, type **datalake** in the name field, then select **OK**.

    ![The form is shown as described.](media/create-synapse-2.png "Create Synapse workspace 2")

6. Check the `Assign myself the Storage Blob Data Contributor role` checkbox, then select **Next: Security and networking**.

    ![The checkbox is checked and the Next button is highlighted.](media/create-synapse-3.png "Create Synapse workspace 3")

7. Review the settings, then select **Review + create**.

    ![The network settings are displayed.](media/create-synapse-4.png "Create Synapse workspace network settings")

8. Review the settings, then select **Create**. It takes around five minutes to create the workspace.

    ![The Create button is highlighted.](media/create-synapse-5.png "Create Synapse workspace review")

### Task 2: Set up blob data owner

Data access permissions on the data lake must be set separately from the resource's permissions.

1. When the Azure Synapse Analytics workspace deployment completes, navigate to the `synapse-lab-infrastructure` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-infrastructure`, then select the **synapse-lab-infrastructure** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the storage account you created when you deployed the Azure Synapse Analytics workspace.

    ![The storage account is highlighted in the resource group.](media/resource-group-storage-account.png "Resource group")

3. Within the storage account, select **Access control (IAM)**. Select **+ Add**, then **Add role assignment**.

    ![The access control blade is displayed.](media/storage-iam.png "Access control")

4. Select the **Storage Blob Data Owner** role. Select **Azure AD user, group, or service principal** under assign access to. Search for and select your Azure account, then select **Save**.

    ![The add role assignment form is configured as described.](media/storage-add-role-assignment.png "Add role assignment")

### Task 3: Set up user access administrator

1. Return to the `synapse-lab-infrastructure` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. Within the Synapse workspace, select **Access control (IAM)**. Select **+ Add**, then **Add role assignment**.

    ![The access control blade is displayed.](media/synapse-iam.png "Access control")

3. Select the **User Access Administrator** role. Select **Azure AD user, group, or service principal** under assign access to. Search for and select your Azure account, then select **Save**.

    ![The add role assignment form is configured as described.](media/synapse-add-role-assignment.png "Add role assignment")

### Task 4: Log in to Synapse Studio

1. Return to the `synapse-lab-infrastructure` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, select the **Workspace web URL** to navigate to Synapse Studio for this workspace.

    ![The workspace web URL is highlighted.](media/synapse-workspace-url.png "Workspace web URL")

    After authenticating your account, you should see the Synapse Studio home page for your workspace.

    ![The home page for the workspace is displayed.](media/synapse-workspace-home.png "Synapse Studio home")

3. If you see the Getting started dialog, select **Close**.

    ![The close button is highlighted.](media/synapse-studio-getting-started.png "Getting started")

## Exercise 2: Moving data to the data lake using Copy activity

Time required: 30 minutes

In this exercise, you will import a large amount of data into the primary data lake account.

> TODO: Update image

### About Synapse Pipeline

The data integration feature, Synapse Pipeline, is designed with the following concepts:

* **Linked Service**: Contains definitions about the connection, such as the database and server information.
* **Dataset**: Browses the Linked Service and defines table information, for example.
* **Activity**: Browses, for example, a Dataset to define processing such as data movement.
* **Pipeline**: Defines the order and conditions in which Activities are run.
* **Integration Runtime**: Defines the processing infrastructure used by Linked Services and Activities.
* **Trigger**: Defines when and how the Pipeline will run.

### Task 1: Create a Linked Service

1. Select the **Manage** hub, **Linked services**, then select **+ New**.

    ![The new linked service option is highlighted.](media/new-linked-service.png "New linked service")

2. Select **Azure Blob Storage**, then select **Continue**.

    ![Azure Blob Storage and the Continue button are highlighted.](media/new-linked-service-blob-storage.png "New linked service")

3. Enter each setting described below, then select **Test connection**. When the connection is successful, select **Create**.

    ![The new linked service form is displayed.](media/new-linked-service-holsource.png "New linked service")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `HOLSource` | |
    | Description | No entry required | Default settings |
    | Connect via integration runtime | AutoResolveIntegrationRuntime | Default settings |
    | Authentication method | SAS URL | |
    | SAS URL | `https://solliancepublicdata.blob.core.windows.net` | |
    | SAS token| '' | Enter two single quotes |
    | Test connection | To linked service | Default settings |

### Task 2: Create a Copy pipeline

1. Select the **Orchestrate** hub, select **+**, then select **Pipeline**.

    ![The new pipeline link is highlighted.](media/new-pipeline.png "New pipeline")

2. For **Name**, enter `ImportData`, then select **Properties** to close the dialog.

    ![The properties dialog is displayed.](media/import-data-name.png "ImportData pipeline name")

3. Expand **Move & transform** under the Activities menu. Drag and drop the **Copy data** activity onto the canvas area to the right.

    ![The copy data activity has an arrow pointing to where it was added to the canvas.](media/import-data-add-copy-data.png "Add copy data activity")

4. Select the **Source** tab, then select **+ New** next to the source dataset.

    ![The source tab and new button are both highlighted.](media/import-data-source-new.png "Source")

5. Select **Azure Blob Storage**, then select **Continue**.

    ![Azure Blob Storage and the Continue button are highlighted.](media/import-data-source-new-blob-storage.png "New dataset")

6. Select the **Binary** format, then select **Continue**.

    ![Binary and the Continue button are highlighted.](media/import-data-source-new-blob-storage-binary.png "Select format")

7. Enter each setting as displayed in the table below, and then select **OK**.

    ![The form is completed as described in the table below.](media/import-data-source-new-blob-storage-properties.png "Set properties")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `holsource` | Be careful not to include extra spaces when copying |
    | Linked service | HOLSource | Select the linked service you created earlier |
    | File path | `synapse-in-a-day/infrastructure` | Enter `synapse-in-a-day` in the first field, and `infrastructure` in the second field. *Note*: you may see an error if you try to browse, due to the lack of list permissions on the entire public data source. To review the contents, select the drop down arrow and select "From specified path" |

8. Select the **Sink** tab, then select **+ New** next to the sink dataset.

    ![The sink tab and new button are both highlighted.](media/import-data-sink-new.png "Sink")

9. Select **Azure Data Lake Storage Gen2**, then select **Continue**.

    ![Azure Data lake Storage Gen2 and the Continue button are highlighted.](media/import-data-sink-new-adls.png "New dataset")

10. Select the **Binary** format, then select **Continue**.

    ![Binary and the Continue button are highlighted.](media/import-data-source-new-blob-storage-binary.png "Select format")

11. Enter each setting as displayed in the table below, and then select **OK**.

    ![The form is completed as described in the table below.](media/import-data-sink-new-adls-properties.png "Set properties")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `holdist` | Be careful not to include extra spaces when copying |
    | Linked service | Select the default storage for your workspace (`<Synapse workspace name>-WorkspaceDefaultStorage`) | |
    | File path | `datalake` | Enter `datalake` in the first field |

12. Select **Publish all**, then select **Publish** in the dialog.

    ![Publish all is highlighted.](media/publish-all.png "Publish all")

    > ※	For the remainder of the lab, select **Publish** as appropriate to save your work.

13. Select **Add trigger**, then select **Trigger now**.

    ![The add trigger and trigger now menu options are displayed.](media/import-data-trigger.png "Trigger now")

14. Select **OK** to run the trigger.

    ![The OK button is highlighted.](media/import-data-trigger-pipeline-run.png "Pipeline run")

15. Select the **Monitor** hub, then **Pipeline runs**. If the pipeline run status is `Succeeded` after a few minutes, then the pipeline run successfully completed.

    ![The pipeline run successfully completed.](media/import-data-monitor.png "Monitor pipeline runs")

16. Select the **Data** hub, select the **Linked** tab, expand storage accounts, then select **datalake** underneath the primary storage account. You will see the imported data on the right-hand side.

    ![The datalake data is displayed.](media/datalake-files.png "Datalake files")

## Exercise 3: Create a SQL Pool and table

Time required: 20 minutes

> TODO: Update image

SQL Pool is one of the analytic runtimes in Azure Synapse Analytics that help you ingest, transform, model, and analyze your data.

A SQL pool offers T-SQL based compute and storage capabilities. After creating a SQL pool in your Synapse workspace, data can be loaded, modeled, processed, and delivered for faster analytic insight.

### Task 1: Create a SQL Pool

1. Select the **Manage** hub.

    ![The manage hub is highlighted.](media/manage-hub.png "Manage hub")

2. Select **SQL pools**, then select **+ New**.

    ![The SQL pools blade is displayed.](media/new-sql-pool.png "SQL pools")

3. Enter **aiaddw** for the SQL pool name, select the **DW100c** performance level, then select **Review + create**.

    ![The form is displayed as described.](media/new-sql-pool-form.png "Create SQL pool")

4. Select **Create** in the review blade.

5. Wait for the SQL pool deployment to complete. You may need to periodically select **Refresh** to update the status.

    ![The SQL pool is deploying and the refresh button is highlighted.](media/sql-pool-deploying.png "SQL pools")

### Task 2: Create table

1. Select the **Develop** hub.

    ![The Develop hub is selected.](media/develop-hub.png "Develop hub")

2. Select **+**, then select **SQL script**.

    ![The new SQL script is selected.](media/new-sql-script.png "New SQL script")

3. Enter **Create DelaySummary** in the Name value within the Properties blade. Select the **aiaddw** SQL pool you created in the previous task. Paste the script below into the script area, then select **Run**.

    ```sql
    --Set up Polybase
    CREATE MASTER KEY

    --Create destination table
    CREATE TABLE [dbo].[DelaySummary]
    ( 
        [Year] int NULL,
        [Month] int NULL,
        [DayofMonth] int NULL,
        [DayOfWeek] int NULL,
        [OriginAirportCode] [nvarchar](10)  NULL,
        [DepDelayCount] [bigint] NULL,
        [DepDelay15Count] [bigint] NULL,
        [AIRPORT_ID] [nvarchar](20) NULL,
        [AIRPORT] [nvarchar](100)  NULL,
        [DISPLAY_AIRPORT_NAME] [nvarchar](100) NULL,
        [LATITUDE] [nvarchar](20)  NULL,
        [LONGITUDE] [nvarchar](20)  NULL
    ) WITH
    (
        DISTRIBUTION = ROUND_ROBIN,
        CLUSTERED COLUMNSTORE INDEX
    )
    GO
    ```

    ![The DelaySummary script is displayed.](media/delaysummary-script.png "New SQL script")

4. After you run the script, you should see a status that the script executed successfully.

    ![The script successfully completed.](media/delaysummary-script-successful.png "Query executed successfully")

5. Select **Publish all**, then select **Publish** in the dialog.

    ![Publish all is highlighted.](media/publish-all.png "Publish all")

    > ※	For the remainder of the lab, select **Publish** as appropriate to save your work.

6. Select the **Data** hub.

    ![The data hub is selected.](media/data-hub.png "Data hub")

7. Select the **Workspace** tab, expand **Databases**, expand the **aiaddw** SQL pool, and expand **Tables**. You will see the `DelaySummary` table. If it does not appear, select **Refresh**.

    ![The DelaySummary table is displayed.](media/delaysummary-table.png "DelaySummary table")

## Exercise 4: Implement Spark ETL with the GUI

Time required: 45 minutes

> TODO: Update image

Mapping data flows are visually designed data transformations in Azure Data Factory. Data flows allow data engineers to develop data transformation logic without writing code. The resulting data flows are executed as activities within Azure Data Factory pipelines that use scaled-out Apache Spark clusters. Data flow activities can be operationalized using existing Azure Data Factory scheduling, control, flow, and monitoring capabilities.

Mapping data flows provide an entirely visual experience with the Synapse Studio GUI, with no coding required. Your data flows run on ADF-managed execution clusters for scaled-out data processing. Azure Data Factory handles all the code translation, path optimization, and execution of your data flow jobs.

### Task 1: Create ADLS Gen2 Linked Service

1. Select the **Manage** hub, **Linked services**, then select **+ New**.

    ![The new linked service option is highlighted.](media/new-linked-service.png "New linked service")

2. Select **Azure Data Lake Storage Gen2**, then select **Continue**.

    ![Azure Blob Storage and the Continue button are highlighted.](media/new-linked-service-adls.png "New linked service")

3. Enter each setting described below, then select **Test connection**. When the connection is successful, select **Create**.

    ![The new linked service form is displayed.](media/new-linked-service-key-adls.png "New linked service")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `key_adls` | |
    | Description | No entry required | Default settings |
    | Connect via integration runtime | AutoResolveIntegrationRuntime | Default settings |
    | Authentication method | Account Key | Default settings |
    | Account selection method | From Azure subscription | Default settings |
    | Azure subscription | Any | Select the Azure subscription for this lab |
    | Storage account name | Any | Select the storage account you created when deploying the workspace |

### Task 2: Create mapping data flow sources

Create datasets to extract "Flight delay" and "Airport master data".

1. Select the **Develop** hub.

    ![The Develop hub is selected.](media/develop-hub.png "Develop hub")

2. Select **+**, then select **Data flow**.

    ![The new Data flow is selected.](media/new-data-flow.png "New Data flow")

3. Select the **Data flow debug** switch.

    ![The data flow debug switch is highlighted.](media/data-flow-debug-switch.png "Data flow debug")

4. Select **OK** in the `Turn on data flow debug` dialog.

    ![The OK button is highlighted.](media/data-flow-debug-dialog.png "Turn on data flow debug")

5. Set **FlightDelayETL** for the Name in the Properties blade. Select **Properties** to close the blade, then select **Add Source** on the canvas.

    ![The name property is highlighted, along with the properties button and the Add Source box on the canvas.](media/flightdelay-name.png "Mapping data flow canvas")

6. For **Output stream name**, enter **AirportCodeLocationLookupClean**, and select **+ New** next to **Source dataset**.

    ![The source settings fields are highlighted.](media/flightdelay-airportcode-source.png "Source settings")

7. Select **Azure Data Lake Storage Gen2**, then select **Continue**.

    ![Azure Data lake Storage Gen2 and the Continue button are highlighted.](media/import-data-sink-new-adls.png "New dataset")

8. Select the **DelimitedText** format, then select **Continue**.

    ![Binary and the Continue button are highlighted.](media/import-data-source-new-adls-delimited.png "Select format")

9. Enter each setting as displayed in the table below, and then select **OK**.

    ![The form is completed as described in the table below.](media/flightdelay-new-adls-properties.png "Set properties")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `csv_AirportCodeLocationLookupClean` | Be careful not to include extra spaces when copying |
    | Linked service | Select the default storage for your workspace (`<Synapse workspace name>-WorkspaceDefaultStorage`) | |
    | File path | `datalake` | Select file from "From specified path" in the next step |

10. Select the **TravelDatasets** folder, then select **AirportCodeLocationLookupClean.csv** and select **OK**.

    ![The folder and file are selected as described.](media/flightdelay-new-adls-airportcodelookup.png "Choose a file or folder")

11. Check **First row as header**, ensure the **From connection / store** import schema option is selected, then select **OK**.

    ![The checkbox is highlighted.](media/flightdelay-airportcode-source-form.png "Set properties")

12. Select **Add Source** on the canvas below the source you just added.

    ![Add Source is highlighted on the canvas.](media/flightdelay-add-source.png "Add Source")

13. For **Output stream name**, enter **FlightDelaysWithAirportCodes**, and select **+ New** next to **Source dataset**.

    ![The output stream name and new button are highlighted.](media/flightdelay-withairportcodes-source.png "Source")

14. Select **Azure Data Lake Storage Gen2**, then select **Continue**.

    ![Azure Data lake Storage Gen2 and the Continue button are highlighted.](media/import-data-sink-new-adls.png "New dataset")

15. Select the **DelimitedText** format, then select **Continue**.

    ![Binary and the Continue button are highlighted.](media/import-data-source-new-adls-delimited.png "Select format")

16. Enter each setting as displayed in the table below, and then select **OK**.

    ![The form is completed as described in the table below.](media/flightdelay-withairportcodes-new-adls-properties.png "Set properties")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `csv_FlightDelaysWithAirportCodes` | Be careful not to include extra spaces when copying |
    | Linked service | Select the default storage for your workspace (`<Synapse workspace name>-WorkspaceDefaultStorage`) | |
    | File path | `datalake` | Select file from "From specified path" in the next step |

17. Select the **TravelDatasets** folder, then select **FlightDelaysWithAirportCodes.csv** and select **OK**.

    ![The folder and file are selected as described.](media/flightdelay-new-adls-withairportcodes.png "Choose a file or folder")

18. Check **First row as header**, ensure the **From connection / store** import schema option is selected, then select **OK**.

    ![The checkbox is highlighted.](media/flightdelay-withairportcodes-source-form.png "Set properties")

### Task 3: Create a filter

Create a filter for the records.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner, and then select **Filter**.

    ![The plus button and Filter menu option are highlighted.](media/flightdelay-add-filter.png "Filter")

2. Under "Filter on", select **Enter filter...**.

    ![The enter filter box is highlighted.](media/flightdelay-filter-enter-filter.png "Filter settings")

3. Copy and paste the following query into the query area to the right of FUNCTIONS. Select **Refresh** to review the data preview, then select **Save and finish**.

    ```javascript
    toInteger(DepDelay) > 0
    ```

    ![The filter area, refresh button, and save button are all highlighted.](media/flightdelay-filter-builder.png "Visual expression builder")

### Task 4: Add calculated columns

In this data, a delay of `1:30` is represented as `130`. Create a delay time column with the name "CRSDepHour" so that it can be represented as a `1.3` hour delay.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner of the stream (from the new filter you just created), and then select **Derived Column**.

    ![The plus button and Derived Column menu option are highlighted.](media/flightdelay-withairportcodes-add-derivedcolumn.png "Derived Column")

2. Under Columns, type **CRSDepHour**, and then select **Expression**.

    ![The derived column's settings blade is displayed.](media/flightdelay-withairportcodes-derivedcolumn-columns.png "Derived column's settings")

3. Copy and paste the following query into EXPRESSION FOR FIELD "CRSDEPHOUR". Select **Refresh** to review the Data rpeview, and then select **Save and finish**.

    ```javascript
    floor(toInteger(CRSDepTime)/100)
    ```

    ![The CRSDEPHOUR expression builder is displayed.](media/flightdelay-withairportcodes-derivedcolumn-expression.png "Visual expression builder")

### Task 5: Select columns

Add an action to eliminate unnecessary columns so that only the required columns remain.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner of the stream (from the new derived column action you just created), and then select **Select**.

    ![The plus button and Select menu option are highlighted.](media/flightdelay-withairportcodes-add-select.png "Select")

2. Check **DerivedColumn1's column** to check all columns. Then remove checks from the following nine items: Make sure that **all other items** besides the following nine are checked, and then select **Delete**.

    - Year
    - Month
    - DayofMonth
    - DayOfWeek
    - CRSDepTime
    - DepDelay
    - DepDel15
    - OriginAirportCode
    - CRSDepHour

![The items to delete are checked.](media/flightdelay-withairportcodes-select-columns.png "Select settings")

### Task 6: Aggregation process

Add aggregation processing so that delays are aggregated at the granularity of the year, month, day, and airport.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner of the stream (from the new select action you just created), and then select **Aggregate**.

    ![The plus button and Aggregate menu option are highlighted.](media/flightdelay-withairportcodes-add-aggregate.png "Aggregate")

2. Select the drop-down arrow on the right of Columns to add the following five columns. Click **+** to add an item:

    - Year
    - Month
    - DayofMonth
    - DayOfWeek
    - OriginAirportCode

    ![The dropdown arrow and plus button are highlighted.](media/flightdelay-withairportcodes-aggregate-columns.png "Columns")

3. Verify that all five columns have been added, then select **Aggregates**.

    ![The Aggregates header is highlighted.](media/flightdelay-withairportcodes-aggregate-columns-aggregate.png "Aggregates")

4. In Columns, type **DepDelayCount**, and then select **Expression**.

    ![The DepDelayCount column is highlighted.](media/flightdelay-withairportcodes-aggregate-add-depdelaycount.png "DepDelayCount")

5. Paste the following expression into EXPRESSION FOR FIELD "DEPDELAYCOUNT" and select **Save and finish**:

    ```javascript
    sum(1)
    ```

    ![The expression is highlighted.](media/flightdelay-withairportcodes-aggregate-depdelaycount-expression.png "Visual expression builder")

6. Select **+** to the right of the column you just added, then select **Add column**.

    ![The add column menu item is highlighted.](media/flightdelay-withairportcodes-aggregate-add-column.png "Add column")

7. In Columns, type **DepDelay15Count**, and then select **Expression**.

    ![The DepDelayCount column is highlighted.](media/flightdelay-withairportcodes-aggregate-add-depdelay15count.png "DepDelayCount")

8. Paste the following expression into EXPRESSION FOR FIELD "DEPDELAY15COUNT" and select **Save and finish**:

    ```javascript
    sum(toInteger(DepDel15))
    ```

    ![The expression is highlighted.](media/flightdelay-withairportcodes-aggregate-depdelay15count-expression.png "Visual expression builder")

### Task 7: Data join process

Combine data sources.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner of the stream (from the new aggregate action you just created), and then select **Join**.

    ![The plus button and Join menu option are highlighted.](media/flightdelay-add-join.png "Join")

2. Within the Join settings form, enter each setting as described in the table below.

    ![The Join settings form is configured as described in the table below.](media/flightdelay-join-settings.png "Join settings")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Output stream name | `Join1` | Default settings |
    | Left stream | `Aggregate1` | |
    | Right stream | `AirportCodeLocationLookupClean` | This is the first data source you added |
    | Join type | `Inner` | Default settings |
    | Left: Aggregate1's column | `OriginAirportCode` | |
    | Right: AirportCodeLocationLookupClean's column | `AIRPORT` | |

### Task 8: Data output

Add a sink process to output to the SQL Pool and create a dataset that defines the destination table information.

1. Under the `FlightDelaysWithAirportCodes` source, select **+** in the lower-right corner of the stream (from the new join action you just created), and then select **Sink**.

    ![The plus button and Sink menu option are highlighted.](media/flightdelay-add-sink.png "Sink")

2. Select **+ New** next to the Sink dataset.

    ![The new dataset button is highlighted.](media/flight-delay-sink-dataset-new.png "Sink")

3. Select **Azure Synapse Analytics (formerly SQL DW)**, then select **Continue**.

    ![Azure Synapse Analytics is selected in the list.](media/flightdelay-sink-dataset-synapse.png "New dataset")

4. Enter each setting as displayed in the table below, and then select **OK**.

    ![The form is completed as described in the table below.](media/flightdelay-sink-dataset-properties.png "Set properties")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Name | `dw_DelaySummary` | Be careful not to include extra spaces when copying |
    | Linked service | Select the default SQL server for your workspace (`<Synapse workspace name>-WorkspaceDefaultSqlServer`) | |
    | Table name | None | Default settings, set in subsequent steps |
    | Import schema | None | Default settings |

5. Select **Open** next to the Sink dataset.

    ![The Open button is highlighted.](media/flightdelay-sink-dataset-open.png "Sink")

6. Under the **Connection** tab of the dataset properties, enter **aiaddw** SQL pool name for the **DBName** value. Select **Refresh** next to the table list, then select **dbo.DelaySummary** from the list.

    ![The form values are configured as described.](media/dw-delaysummary-properties.png "dw_DelaySummary properties")

7. Select the **FlightDelayETL** tab to switch back to the mapping data flow. Select **Sink1**, select the **Settings** tab, then select **Truncate table** in the Table action options list. Make sure **Enable staging** is also checked.

    ![The form values are configured as described.](media/flightdelay-sink-settings.png "Sink settings")

8. Select **Publish all**, then select **Publish** in the dialog.

    ![Publish all is highlighted.](media/publish-all.png "Publish all")

### Task 9: Create and run Pipeline

1. Select the **Orchestrate** hub, select **+**, then select **Pipeline**.

    ![The new pipeline link is highlighted.](media/new-pipeline.png "New pipeline")

2. For **Name**, enter `FlightDelay`, then select **Properties** to close the dialog.

    ![The properties dialog is displayed.](media/flightdelay-pipeline-name.png "FlightDelay pipeline name")

3. Expand **Move & transform** under the Activities menu. Drag and drop the **Data flow** activity onto the canvas area to the right.

    ![The data flow activity has an arrow pointing to the canvas.](media/flightdelay-pipeline-add-data-flow.png "Add data flow activity")

4. In the Adding data flow dialog, select **Use existing data flow**, select **FlightDelayETL** from the existing data flow list, then select **Finish**.

    ![The form is configured as described.](media/flightdelay-pipeline-add-data-flow-dialog.png "Adding data flow")

5. Select the **Settings** tab, select **key_adls** from the **Staging linked service** list, then enter **datalake** in the container field and **polybase** in the folder field of the **Staging storage folder** setting.

    ![The settings form is configured as described.](media/flightdelay-pipeline-data-flow-settings.png "Data flow settings")

6. Select **Publish all**, then select **Publish** in the dialog.

    ![Publish all is highlighted.](media/publish-all.png "Publish all")

7. Select **Add trigger**, then select **Trigger now**.

    ![The trigger now option is highlighted.](media/flightdelay-pipeline-trigger-now.png "Trigger now")

8. Select **OK** to run the trigger.

    ![The OK button is highlighted.](media/import-data-trigger-pipeline-run.png "Pipeline run")

9. Select the **Monitor** hub, then **Pipeline runs**. If the pipeline run status is `Succeeded` after a few minutes, then the pipeline run successfully completed.

    ![The pipeline run successfully completed.](media/flightdelay-pipeline-monitor.png "Monitor pipeline runs")

> **Note**: Mapping Data Flow runs with a minimum overhead of at least five to six minutes. This is because you are creating a Spark processing environment each time you run it. If you are using an ETL pipeline using Mapping Data Flow, plan your batch schedule with time in mind for creating a processing environment.

> **Note**: Some of the imported data has a prepared dataset that has been amplified to 100 million items under the name "FlightDelaysWithAirportCodes100M.csv". With this csv data, you can see the scalability of Mapping Data Flow for 100 million data processes.

### Task 10: View the transformed data

When the data flow pipeline has successfully completed, view the data it wrote to the `dbo.DelaySummary` SQL pool table.

1. Select the **Data** hub.

    ![The data hub is selected.](media/data-hub.png "Data hub")

2. Select the **Workspace** tab, expand **Databases**, expand the **aiaddw** SQL pool, and expand **Tables**. Right-click on the `DelaySummary` table, select  **New SQL script**, then select **Select TOP 100 rows**.

    ![The DelaySummary table is displayed.](media/delaysummary-table-new-script.png "DelaySummary table")

3. View the results of the executed script. Notice that the derived columns, joined columns, and aggregates you added to the Mapping Data Flow appear in the result set.

    ![The query result set is displayed.](media/delaysummary-table-result-set.png "DelaySummary table result set")

## Exercise 5: Visualize with Power BI

Time required: 15 minutes

> TODO: Update image

Power BI reports can be created, edited, and viewed from within Synapse Studio. This level of integration allows you to easily get data into your Power BI workspace. It also minimizes your need to switch tabs and navigate between services in the browser.

### Task 1: Connect Power BI Desktop

1. Return to the `synapse-lab-infrastructure` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, copy the **SQL endpoint** value.

    ![The SQL endpoint is highlighted.](media/synapse-workspace-sql-endpoint.png "Synapse Workspace")

3. Open Power BI Desktop. Close the sign-in window with the **X** on the upper-right corner.

    ![The X button is highlighted.](media/pbi-home.png "Power BI Desktop")

4. Select **Get Data**, then select **Azure** in the left-hand menu of the dialog that appears. Select **Azure Synapse Analytics (SQL DW)**, then select **Connect**.

    ![The options are highlighted as described.](media/pbi-get-data.png "Get Data")

5. Set the **Server** value to your copied SQL endpoint, and enter **aiaddw** for the **Database** name. Select the **DirectQuery** data connectivity mode, then click **OK**.

    ![The connection settings are configured as described.](media/pbi-connection.png "SQL Server database")

6. Select **Microsoft account** on the left-hand menu. **Sign in**, then click **Connect**.

    ![The authentication form is displayed.](media/pbi-auth.png "Authentication")

7. Click the box to the left of **DelaySummary**, which will load the data in the preview to the right. Click **Load**.

    ![Load the data.](media/pbi-load.png "Load")

### Task 2: Create a report

1. Click **Map** under Visualizations, then drag and drop **OriginAirportCode** into the **Legend** field. Refer to the table below for setting the other fields.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Legend | `OriginAirportCode` | |
    | Latitude | `LATITUDE` | Select **Don't summarize** |
    | Longitude | `LONGITUDE` | Select **Don't summarize** |
    | Size | `DepDelayCount` | |

    ![The Map visualization is configured as described.](media/pbi-map.png "Map visualization")

    > **Note**: By default, latitude and longitude are treated as aggregate values. Click the drop-down arrow and select **Don't summarize**.

    ![The don't summarize menu option is highlighted.](media/pbi-do-not-summarize.png "Don't summarize")

2. Click an empty location on the report area. Under Visualizations, click **Stacked Column Chart**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Axis | `DayofMonth` | |
    | Values | `DepDelayCount` | |

    ![The chart is configured as described.](media/pbi-stacked-column-chart.png "Stacked Column Chart visualization")

3. Click an empty location on the report area. Under Visualizations, click **Treemap**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Group | `OriginAirportCode` | |
    | Values | `DepDelayCount` | |

    ![The visualization is configured as described.](media/pbi-treemap.png "Treemap visualization")

4. Clicking on a visual narrows down the data for the other visuals. (It may take a few seconds to load the data.)

    ![The LAS value is highlighted on the treemap, and the data for the other visuals is filtered based on the selection.](media/pbi-filter.png "The LAS value is highlighted on the treemap")

### Task 3: Save Power BI Desktop report

1. Click the **Save** icon on the top-left of Power BI Desktop. Enter a file name, such as **FlightDelays**, then click **Save** to save the report file.

    ![The Save icon and file save dialog are shown.](media/pbi-save.png "Save")

### Task 4: Create a Power BI workspace (optional)

If you have a Power BI Pro license and have create permissions, perform the following to create a new Power BI workspace for this lab. If not, you may skip the rest of the tasks in this exercise.

1. Sign in to Power BI service (https://powerbi.microsoft.com/landing/signin/)

2. Select **Workspaces**, then select **Create a workspace**.

    ![The create a workspace button is highlighted.](media/pbi-create-workspace-link.png "Create a workspace")

3. Type **AIAD_SynapseWorkspace** for the workspace name, then select **Save**.

    ![The workspace name and save button are highlighted.](media/pbi-create-workspace.png "Create a workspace")

### Task 5: Create a Power BI Linked Service (optional)

If you were able to create a Power BI workspace, you can continue with this task. Otherwise, skip ahead to the next exercise.

1. Select the **Manage** hub, **Linked services**, then select **+ New**.

    ![The new linked service option is highlighted.](media/new-linked-service.png "New linked service")

2. Select **Power BI**, then select **Continue**.

    ![Power BI is highlighted.](media/new-linked-service-pbi.png "New linked service")

3. Make sure the correct Tenant is selected, then select the **AIAD_SynapseWorkspace** option from the **Workspace name** list. Select **Create** to continue.

    ![The form is configured as described.](media/new-linked-service-pbi-form.png "New linked service (Power BI)")

    > If the new Power BI workspace is not displayed, the tenant to which the AD account belongs and the tenant where the Power BI workspace is created may be different.

### Task 6: Create a Power BI dataset (optional)

If you were able to create a Power BI workspace, you can continue with this task. Otherwise, skip ahead to the next exercise.

1. Select the **Develop** hub.

    ![The Develop hub is selected.](media/develop-hub.png "Develop hub")

2. Expand the **Power BI** group, then expand the **AIAD_SynapseWorkspace** Linked Service. Select **Power BI datasets**, then select **+ New Power BI dataset** in the blade to the right.

    ![The new Power BI dataset button is highlighted.](media/new-pbi-dataset.png "New Power BI dataset")

3. Select **Start**.

    ![The Start button is highlighted.](media/new-pbi-dataset-start.png "New Power BI dataset")

4. Select the **aiaddw** SQL pool that you created, then select **Continue**.

    ![The aiaddw SQL pool and Continue button are highlighted.](media/new-bi-dataset-source.png "Select a data source")

5. Select **Download**. Open the downloaded Power BI Desktop data source (`.pbids`) file.

    ![The download button is highlighted.](media/new-pbi-dataset-download.png "Download pbids file")

6. Power BI Desktop launches when you open the `.pbids` file. When the navigator pops up, click the check box next to **DelaySummary**, then click **Load**.

    ![The Power BI dataset is loaded.](media/pbi-ds-navigator.png "Navigator")

7. Click **DirectQuery**, then click **OK**.

    ![The DirectQuery radio and OK button are highlighted.](media/pbi-ds-connection-settings.png "Connection settings")

8. Click **File**, then **Publish**. Click **Publish to Power BI**.

    ![The Publish dialog is displayed.](media/pbi-ds-publish.png "Publish")

9. Click **Save**.

    ![The Save button is highlighted.](media/pbi-ds-save.png "Save")

10. Enter a file name, such as **FlightDelaysDS**, then click **Save**.

    ![The save as dialog is shown.](media/pbi-ds-save-file.png "Save As")

11. Sign in to your Power BI account.

    ![The Power BI sign in form is displayed.](media/pbi-ds-sign-in.png "Sign in")

12. Select the **AIAD_SynapseWorkspace** workspace, then click **Select**.

    ![Select the workspace, then click select.](media/pbi-ds-select-workspace.png "Publish to Power BI")

13. When Power BI Desktop finishes publishing, sign in to the Power BI service (<https://powerbi.microsoft.com/landing/signin/>). Select the **AIAD_SynapseWorkspace** workspace on the left, then select the **Datasets** tab. Select **...(More options)** under the Actions column of the `FlightDelaysDS` dataset, then select **Settings**.

    ![The dataset actions more options list is displayed with the Settings menu item highlighted.](media/pbi-more-options.png "More options")

14. Select **Edit credentials**.

    ![Edit credentials is highlighted.](media/pbi-dataset-settings.png "Settings")

15. Select the **OAuth2** authentication method and set the privacy level for this data source to **Public**. **Check the box** to have report viewers use their own Power BI identities in DirectQuery mode, then select **Sign in**.

    ![The dataset credentials are configured as described.](media/pbi-dataset-credentials.png "Configure FlightDelaysDS")

16. Return to Synapse Studio, then select **Continue**.

    ![Continue is highlighted.](media/new-pbi-dataset-download-continue.png "Download pbids file")

17. Select **Close and refresh**.

    ![The close and refresh button is highlighted.](media/new-pbi-dataset-close.png "Close and refresh")

18. Select **Power BI datasets**, then select the **New Power BI report** icon on the `FlightDelaysDS` dataset.

    ![The New Power BI report icon is highlighted.](media/pbi-datasets-new-report.png "Power BI datasets")

19. When the screen for the new report opens, run the report.

    ![The new Power BI report is displayed.](media/pbi-new-report.png "New report")

## Build a predictive maintenance solutions with Azure Synapse Analytics (Advanced)

### About Lambda Architecture

The Lambda architecture is a common pattern in Big Data infrastructures.

![Lambda architecture.](media/lambda-architecture.png "Lambda architecture")

(https://docs.microsoft.com/azure/architecture/data-guide/big-data/#lambda-architecture)

- **Batch layer, service layer**

    Distributed processing has made it possible to process large amounts of data within business hours. Perform accumulation and distribution processing on the batch layer. By deploying the results of calculations on the service layer, you can analyze large amounts of data while ensuring separation of calculated results and raw data.
    Periodic data processing flows sourced from pre-accumulated data are defined as cold paths.

- **Speed layer**

    Processing at the batch layer usually causes latency. The speed layer complements the weakness of latency during batch processing and enables real-time analysis of stream data arriving within batch processing schedule intervals. Continuous data processing flows sourced from stream data are defined as hot paths.

### Scenario

Build solutions for analysis and predictive maintenance of sensor data in aircraft engines. In predictive maintenance, it is possible to improve maintenance efficiency by predicting how long maintenance will be required (remaining service time: RUL) by using a model trained with machine learning.

The lambda architecture can be constructed on Azure with Azure Synapse Analytics and PaaS for IoT data.

This section of the lab demonstrates near-real-time visualization of engine sensor data defined in JSON, distributed and machine learning processing for accumulated large amounts of data, and DWH loading and visualization.

### Hands-on architecture

> TODO: Update image

To build the architecture, complete the following tasks:

- Create real-time aggregation of sensor data and raw data storage processing in the data lake
- Create SQL query view to processed sensor data in data lake
- Run sensor data near-real-time visualization report
- Perform structured processing with Spark
- Process scoring and create load processing to DWH
- Run sensor data analysis report

## Exercise 6: Create stream processing

Time required: 30 minutes

> TODO: Update image

Create IoT Hub, Stream Analytics, receive sensor data, and implement real-time processing.

Stream Analytics coordinates sensor data received in JSON format with the data lake, and outputs the results of the average value at 30-second intervals in parallel as a parquet file.

**Note:**

The ability to output from Azure Stream Analytics to Synapse SQL Pool with high throughput of 200 MB/s has been announced.

Using Azure Stream Analytics with Azure Synapse Analytics: (https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-integrate-azure-stream-analytics)

**Note:**

Synapse Link with Cosmos DB can now be converted to column-oriented format with No-ETL to take advantage of data in column-oriented formats, such as Parquet file conversion.

Azure Synapse Link for Azure Cosmos DB: (https://docs.microsoft.com/azure/cosmos-db/synapse-link)

### Task 1: IoT Hub resource creation

1. Navigate to the Azure portal (<https://portal.azure.com>) to create the IoT Hub resource.

2. In the search menu, type **IoT Hub**, then select **IoT Hub**.

    ![IoT Hub is highlighted in the search box, and the IoT Hub item in the results is highlighted.](media/search-iot-hub.png "IoT Hub search")

3. Select **Add**.

    ![The add button is selected.](media/iot-hub-add.png "Add")

4. In the `Create Synapse workspace` form, enter the values shown in the table below. Select **Review + create**.

    ![The form is shown as described below.](media/create-iot-hub.png "Create IoT Hub")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | Resource group | `synapse-lab-infrastructure` | Select existing resource group you have been using for this lab |
    | Region | Select the region closest to you, such as `West US`. | |
    | Workspace name | `synapselabinfra` + your initials + `ioth` (example: `synapselabinfrajdhioth`) | Lowercase alphanumeric characters only |

5. Review the settings, then select **Create**. It takes a few minutes to create the resource.

    ![The Create button is highlighted.](media/create-iot-hub-create.png "Create IoT Hub")

6. When the deployment completes, navigate to the IoT Hub resource by selecting **Go to resource**. Alternately, you may navigate to the `synapse-lab-infrastructure` resource group and select the IoT Hub resource there.

    ![Go to resource is highlighted.](media/iot-hub-deployed.png "Your deployment is complete")

7. Select **IoT devices** in the left-hand menu, then select **+ New** in the IoT devices blade.

    ![The IoT devices menu item is highlighted, as well as the New button on its blade.](media/iot-devices.png "IoT devices")

8. Enter **vdev01** as the Device ID, select the **Symmetric key** authentication type, **Check** auto-generate key, and **Enable** the option to connect this device to an IoT Hub. Select **Save**.

    ![The form is configured as described.](media/iot-device-create.png "Create a device")

9. Select the device ID of the new device you created.

    ![The new IoT device is highlighted.](media/iot-device-select.png "IoT device")

10. Copy the **Primary Key** and save it to Notepad or similar text editor for later.

    ![The device's primary key is highlighted.](media/iot-device-primary-key.png "Primary key")

11. Navigate back to the IoT Hub resource and select **Built-in endpoints** on the left-hand menu. Scroll down to **Consumer Groups**. In the **Create a new consumer group** box, enter **streamanalytics**. Select **Save** to apply your changes.

    ![The streamanalytics consumer group is highlighted.](media/iot-hub-consumer-group.png "Built-in endpoints")

### Task 2: Event source settings

In this task, we configure the `IoTVirtualDevices` virtual device simulator that simulates and sends sensor data to Azure.

1. Select **Overview** in the left-hand menu of your IoT Hub. Copy the **Hostname** value and save it to Notebook or similar text editor for later.

    ![Hostname is highlighted in the Overview blade.](media/iot-hub-hostname.png "Overview")

2. Navigate to the location on your computer or Windows VM where you extracted the ZIP file for this lab. If you extracted it to `C:\`, navigate to `C:\azure-synapse-in-a-day-demos-master\infrastructure\source\IoTVirtualDevices\Release`. Open **IoTVirtualDevices.exe.config**.

    ![The config file is highlighted.](media/iotvirtualdevices-path.png "Windows Explorer")

3. Enter the **IoT Hub hostname** that you copied previously and save the configuration file, overwriting the previous value.

    ![The setting to update is highlighted.](media/config-hostname.png "Configuration file")

    ```xml
    <setting name="IOT_HUB_NAME" serializeAs="String">
        <value> YOUR_IOT_HUB_HOSTNAME_HERE </value>
    </setting>
    ```

4. Close the file and, in the same directory, open **device_info.csv**. Enter the **Primary key** for the IoT device that you copied earlier, then save the file.

    ![The file and primary key value are both highlighted.](media/config-device-info.png "device_info.csv")

    ```text
    DEVICE_ID,DEVICE_TYPE,SIGNING_KEY,DESCRIPTION
    vdev01,1,YOUR_PRIMARY_KEY_HERE,AIAD
    ```

5. Close the file and, in the same directory, right-click **IoTVirtualDevices.exe** and select **Run as administrator**.

    ![The executable and Run as administrator option are both highlighted.](media/run-exe-administrator.png "Run as administrator")

6. If you receive a prompt asking you if you want to allow this app from an unknown publisher to make changes to your device, click **Yes**.

    ![The Yes button is highlighted.](media/unknown-publisher.png "Unknown publisher")

7. When the Virtual Devices application starts, click **File**, and then click **Normal Telemetry Data File Load**.

    ![Select File, then Normal Telemetry Data File Load.](media/app-file-normal.png "Virtual Devices")

8. Select **data_sample.csv** in the `IoTVirtualDevices\Release\` folder, then select **Open**.

    ![The file is highlighted.](media/app-file-normal-open.png "Open file")

9. Click **OK** in the dialog that appears after loading.

    ![The OK button is highlighted.](media/app-file-loaded.png "File loaded")

10. Click the **Virtual Device Stopped** button to get started.

    ![Select the Virtual Device Stopped button.](media/app-stopped.png "Virtual Device Stopped")

11. **Virtual Device Processing** is displayed.

    ![The button is highlighted.](media/app-processing.png "Virtual Device Processing")

12. Navigate to IoT Hub in the portal and, in the **Overview** blade, view the **IoT Hub Usage** chart. You should see the **Messages used today** count increase each time you **Refresh**.

    ![The described items are highlighted in the Overview blade.](media/iot-hub-messages-used-today.png "IoT Hub overview")

### Task 3: Create and configure Stream Analytics resources

1. Navigate to the Azure portal (<https://portal.azure.com>) to create the IoT Hub resource.

2. In the search menu, type **stream**, then select **Stream Analytics jobs**.

    ![Stream is highlighted in the search box, and the Stream Analytics jobs item in the results is highlighted.](media/search-sa.png "Stream search")

3. Select **Add**.

    ![The add button is selected.](media/sa-add.png "Add")

4. In the `New Stream Analytics job` form, enter the values shown in the table below. Select **Create**.

    ![The form is shown as described below.](media/create-sa.png "Create IoT Hub")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Job name | `synapselabinfra` + your initials + `asa` (example: `synapselabinfrajdhasa`) | Lowercase alphanumeric characters only |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | Resource group | `synapse-lab-infrastructure` | Select existing resource group you have been using for this lab |
    | Region | Select the region closest to you, such as `West US`. | |
    | Hosting environment | Cloud | |
    | Streaming units | 1 | |

5. The resource should be ready in a few seconds. After it deploys, select **Go to resource**.

    ![Go to resource is highlighted.](media/sa-deployed.png "Your deployment is complete")

6. Select **Inputs** on the left-hand menu, select **+ Add stream input**, then **IoT Hub** in the drop-down menu.

    ![The IoT Hub menu item is highlighted.](media/sa-add-iot-hub-input.png "Inputs")

7. In the `IoT Hub` form, enter the values shown in the table below. Select **Save**.

    ![The form is shown as described below.](media/sa-add-iot-hub-input-form.png "Create IoT Hub")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Input alias | `ioth` | |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | IoT Hub | Any | Select the IoT Hub service you created for this lab |
    | Endpoint | Messaging | Default settings |
    | Shared access policy name | `iothubowner` | Default settings |
    | Consumer group | `streamanalytics` | Select the consumer group you created earlier |
    | Event serialization format | JSON | Default settings |
    | Encoding | UTF-8 | Default settings |
    | Event compression type | None | Default settings |

8. Select **Outputs** on the left-hand menu, select **+ Add**, then **Blob Storage/Data Lake Storage Gen2** in the drop-down menu.

    ![The storage menu item is highlighted.](media/sa-add-storage-input.png "Outputs")

9. In the `Blob Storage/Data Lake Storage Gen2` form, enter the values shown in the table below. Select **Save**.

    ![The form is shown as described below.](media/sa-add-storage-input-form.png "Create Storage output")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Output alias | `datalake-raw` | |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | Storage account | Any | Select the data lake storage account you created when you deployed Synapse Analytics |
    | Container | `datalake` (choose use existing) | |
    | Path pattern | `sensor-stream/{date}` | |
    | Date format | `YYY/MM/DD` | Default settings |
    | Time format | HH | Default settings |
    | Event serialization format | JSON | Default settings |
    | Encoding | UTF-8 | Default settings |
    | Format | Line separated | Default settings |
    | Minimum rows | `2000` | |
    | Hours/minutes | `0` hours, `1` minute | |
    | Authentication mode | Connection string | Default settings |

10. Select **Outputs** on the left-hand menu, select **+ Add**, then **Blob Storage/Data Lake Storage Gen2** in the drop-down menu to add another output.

    ![The storage menu item is highlighted.](media/sa-add-storage-input.png "Outputs")

11. In the `Blob Storage/Data Lake Storage Gen2` form, enter the values shown in the table below. Select **Save**.

    ![The form is shown as described below.](media/sa-add-storage-input-form-curated.png "Create Storage output")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Output alias | `datalake-curated` | |
    | Subscription | Any | Select the Azure subscription used for this lab. |
    | Storage account | Any | Select the data lake storage account you created when you deployed Synapse Analytics |
    | Container | `datalake` (choose use existing) | |
    | Path pattern | `curated/sensor_asa/{date}` | |
    | Date format | `YYY/MM/DD` | Default settings |
    | Time format | HH | Default settings |
    | Event serialization format | Parquet | Default settings |
    | Encoding | UTF-8 | Default settings |
    | Format | Line separated | Default settings |
    | Minimum rows | `2000` | Default settings |
    | Hours/minutes | `0` hours, `1` minute | Default settings |
    | Authentication mode | Connection string | Default settings |

12. Select **Query** in the left-hand menu. Copy and paste the following query into the query area on the right, then select **Save query**.

    ```sql
    --Use 30 second average
    SELECT
        DeviceId,
        Period,
        Cycle,
        dateadd(hour,9,system.timestamp) as JSTTime,
        AVG(Sensor11) as Sensor11,
        AVG(Sensor14) as Sensor14,
        AVG(Sensor15) as Sensor15,
        AVG(Sensor9) as Sensor9
    INTO [datalake-curated]
    FROM ioth TIMESTAMP BY EventEnqueuedUtcTime
    GROUP BY
        DeviceId,
        Period,
        Cycle,
        TUMBLINGWINDOW(ss,30);

    -- Use raw data as-is
    SELECT
        *
    INTO [datalake-raw]
    FROM ioth TIMESTAMP BY EventEnqueuedUtcTime
    ```

    ![The query is displayed.](media/sa-query.png "Query")

13. Select **Overview** in the left-hand menu, then select **Start**.

    ![The Start button is highlighted on the Overview blade.](media/sa-start.png "Start")

14. In the Start job dialog, select **Start** to begin the job.

    ![The Start button is highlighted.](media/sa-start-dialog.png "Start")

## Exercise 7: Explore Data with Query-as-a-Service

Time required: 15 minutes

> TODO: Update image

In addition to the traditional SQL data warehouse functionality, Azure Synapse Analytics has added SQL serverless as a way to execute SQL queries directly against the data lake. SQL serverless does not have persistent tables, but is billed based on query run time, enabling rapid data search and cost optimization.

### Task 1: Query for Parquet files

1. Return to Synapse Studio (<https://web.azuresynapse.net/>) and select the **Data** hub.

    ![The data hub is selected.](media/data-hub.png "Data hub")

2. Select the **Linked** tab, expand the primary storage (data lake) account, and open the **datalake** container. Select the **curated** folder. If this folder is not visible, refresh the view after the Stream Analytics query runs for a few minutes.

    ![The curated folder is selected.](media/curated-folder.png "Curated folder")

3. Open the **sensor_asa** folder.

    ![The sensor_asa folder is highlighted.](media/sensor-asa-folder.png "sensor_asa folder")

4. Navigate through the sub-folders until you get to the list of Parquet files. Right-click the Parquet file stored at the bottom of the list and select **New SQL script**, then **Select TOP 100 rows**.

    ![The Parquet files are listed.](media/parquet-file.png "Select top 100 rows")

    > **Note**: You will not see the same folder structure since they are automatically generated based on the current date.

5. Select **Run** to execute the query. You should see the file contents listed in the results below after the query execution completes.

    ![The query is displayed and the Run button is highlighted.](media/query-parquet.png "Query")

### Task 2: Create a view

1. Clear the query and replace it with the following, then select **Run** to execute.

    ```sql
    --Create user database for SQL on-demand
    CREATE DATABASE [AIAD]
    ```

2. Select AIAD in the **Use database** list. You may need to select the **Refresh** button to find it in the list. If this doesn't work, change the **Connect to** to `aiaddw`, then back to `SQL on-demand`.

    ![AIAD is selected.](media/query-select-database.png "Use database")

3. Clear the query and replace it with the query below. **Replace YOUR_STORAGE_ACCOUNT_NAME with your storage account name**, using the primary data lake storage account as a reference.

    ![The edited query is displayed.](media/query-create-view.png "Query")

    ```sql
    --Create a View for Datalake
    CREATE VIEW v_sensor_ondemand AS
    SELECT
        *,
        convert(date,left(JSTTIME,10)) as JSTDate
    FROM
        OPENROWSET(
            BULK 'https://YOUR_STORAGE_ACCOUNT_NAME.dfs.core.windows.net/datalake/curated/sensor_asa/*/*/*/*.parquet',
            FORMAT='PARQUET'
        ) AS [r]
    --Condition clauses can be stated for the partition structure of the folder
    WHERE 
        r.filepath(1) = YEAR(getdate())
    AND r.filepath(2) = MONTH(getdate())
    ```

4. Select **Run** to execute the query.

5. Clear the query and replace it with the query below, then select **Run**.

    ![The select view query successfully ran.](media/query-select-view.png "Query")

    ```sql
    -- Verify number of Views
    SELECT
        COUNT(1)
    FROM
        v_sensor_ondemand
    ```

### Task 3: Create near-real-time dashboards

1. Return to the `synapse-lab-infrastructure` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, copy the **SQL on-demand endpoint** value.

    ![The SQL on-demand endpoint is highlighted.](media/synapse-workspace-sql-od-endpoint.png "Synapse Workspace")

3. Open Power BI Desktop. Close the sign-in window with the **X** on the upper-right corner.

    ![The X button is highlighted.](media/pbi-home.png "Power BI Desktop")

4. Select **Get Data**, then select **Azure** in the left-hand menu of the dialog that appears. Select **Azure Synapse Analytics (SQL DW)**, then select **Connect**.

    ![The options are highlighted as described.](media/pbi-get-data.png "Get Data")

5. Set the **Server** value to your copied SQL on-demand endpoint, and enter **AIAD** for the **Database** name. Select the **DirectQuery** data connectivity mode, then click **OK**.

    ![The connection settings are configured as described.](media/pbi-connection-od.png "SQL Server database")

6. Select **Microsoft account** on the left-hand menu. **Sign in**, then click **Connect**.

    ![The authentication form is displayed.](media/pbi-auth-od.png "Authentication")

7. Click the box to the left of **v_sensor_ondemand**, which will load the data in the preview to the right. Click **Load**.

    ![Load the data.](media/pbi-load-od.png "Load")

8. Under Visualizations, select **Line chart**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Axis | `JSTTime` | |
    | Legend | `DeviceId` | |
    | Values | `Sensor9` | |

    ![The chart is configured as described.](media/pbi-line-chart.png "Line chart")

9. Click an empty location in the report area. Under Visualizations, select **Slicer**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Field | `DeviceId` | |

    ![The chart is configured as described.](media/pbi-slicer.png "Slicer")

    > When you select a Device Id in the slicer, it filters all other visualizations by that value.

10. Click an empty location in the report area. Under Visualizations, select **Card**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Field | `JSTTime` | Select the dropdown next to JSTTime and select **Earliest**. |

    ![The chart is configured as described.](media/pbi-card.png "Card")

11. Click an empty location in the report area. Click **Format** (Paint Roller), and then click **Page refresh off** to turn it on. Set the duration to **1 minute**.

    ![Auto-refresh is turned on.](media/pbi-refresh.png "Refresh")

12. Click the **Save** icon on the top-left. Enter **SensorOnDemand** for the file name and click **Save**. You will use this file in a later exercise.

    ![The save dialog is displayed.](media/pbi-save-od.png "Save")

## Exercise 8: Create a structured process for large amounts of data with Spark

Time required: 10 minutes

> TODO: Update image

In addition to SQL analysis, Synapse Analytics enables analysis and development with Spark, a distributed processing framework for OSS. By using Spark, you can select a development language (Python, Scala, .Net) tailored to your skill set and develop a structure to process large-scale data at high speed.

### Task 1: Create a Spark pool

Spark pools are configured as an environment running Spark and are automatically stopped/scaled according to usage, resulting in cost-optimized, on-demand ETL processing.

1. Return to Synapse Studio (<https://web.azuresynapse.net/>) and select the **Manage** hub, **Apache Spark pools**, then select **+ New**.

    ![The New button on the Apache Spark pools blade is highlighted.](media/sp-new.png "Apache Spark pools: New")

2. Enter each setting as shown in the table below, then select **Review + create**.

    ![The form is configured as described.](media/sp-new-form.png "Create Apache Spark pool")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Apache Spark pool name | `aiadspark` | |
    | Node size | Small | |
    | Autocale | Enabled | Default settings |
    | Number of nodes | 3-40 | Default settings |

3. Review the settings, then select **Create**.

    ![The create button is highlighted.](media/sp-new-review.png "Create")

### Task 2: Develop Spark ETL

Synapse Studio's Notebook UI is provided as an interface for developing Spark. Using your notebook, you can interact with Spark ETL and create simple charts.

In this task, you will use the `SensorPrep.ipynb` notebook in the `source/ETLandPREDICT` folder.

1. Select the **Develop** hub.

    ![The Develop hub is selected.](media/develop-hub.png "Develop hub")

2. Select **+**, then select **Import** from the drop-down menu.

    ![The Import menu item is selected.](media/develop-import.png "Import")

3. Navigate to the folder where you extracted the ZIP file for this lab. If you extracted the files to `C:\`, navigate to `C:\azure-synapse-in-a-day-demos-master\infrastructure\source\ETLandPREDICT` and select **SensorPrep.ipynb**.

    ![The SensorPrep file is highlighted.](media/sensorprep-file.png "Open")

4. With the `SensorPrep` notebook open, edit the storage `account_name` value in **Cell 2**. Enter just the account name (eg. `synapselabinfrajdhadls`) and not the fully-qualified name.

    ![The account name variable is highlighted.](media/sensorprep-cell2.png "Edit Cell 2")

5. With **Cell 2** selected, press **Shift+Enter**. The contents of **Cell 2** will run and the cursor moves to **Cell 3**. Similarly, press **Ctrl+Enter** to run the selected cell and remain there without moving on to the next cell.

    ![Cell 2 is highlighted.](media/sensorprep-cell2-run.png "Run Cell 2")

6. When you execute **Cell 10**, change the view to **Chart** in the cell results. Select **View options** and configure the settings as displayed below, then select **Apply**.

    ![The chart and its options are displayed as described.](media/sensorprep-cell10.png "Cell 10 visualization")

    | Parameters | Settings |
    | --- | --- |
    | Chart type | Line chart |
    | Key | `timestamp_PST` |
    | Values | `Period`, `Sensor11` |
    | Series Group | |
    | Aggregation | MAX |
    | Aggregation over all results | Unchecked |

## Exercise 9: Spark ML learning/inference and SQL pool load

Time required: 10 minutes

> TODO: Update image

In addition to ETL processing, you can run machine learning workloads using Spark ML within a Spark Notebook. You can also use the Azure Machine Learning Python SDK from within a Spark Notebook in Synapse to perform automatic machine learning, a feature of Azure Machine Learning.

### Task 1: Import and execute notebook

Train and run machine learning models in a Spark pool and load the predicted results into a SQL pool.

1. Select the **Develop** hub.

    ![The Develop hub is selected.](media/develop-hub.png "Develop hub")

2. Select **+**, then select **Import** from the drop-down menu.

    ![The Import menu item is selected.](media/develop-import.png "Import")

3. Navigate to the folder where you extracted the ZIP file for this lab. If you extracted the files to `C:\`, navigate to `C:\azure-synapse-in-a-day-demos-master\infrastructure\source\ETLandPREDICT` and select **TrainAndScoreRULModel.ipynb**.

    ![The TrainAndScoreRULModel file is highlighted.](media/trainmodel-file.png "Open")

4. Run the notebook to run SparkML and load the data into your SQL pool.

## Exercise 10: Visualize with Power BI

Time required: 10 minutes

> TODO: Update image

Create a sensor summary report in Power BI.

### Task 1: Create connections and relationships

1. Return to the `synapse-lab-infrastructure` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, copy the **SQL endpoint** value.

    ![The SQL endpoint is highlighted.](media/synapse-workspace-sql-endpoint.png "Synapse Workspace")

3. Open Power BI Desktop and open the **SensorOnDemand.pbix** report if it is not already open. Click **Get Data**, choose **Azure** from the left-hand menu, select **Azure Synapse Analytics (SQL DW)**, then click **Connect**.

    ![The Get Data dialog is displayed.](media/pbi-get-data-sensor.png "Get Data")

4. Select **Get Data**, then select **Azure** in the left-hand menu of the dialog that appears. Select **Azure Synapse Analytics (SQL DW)**, then select **Connect**.

    ![The options are highlighted as described.](media/pbi-get-data.png "Get Data")

5. Set the **Server** value to your copied SQL endpoint, and enter **aiaddw** for the **Database** name. Select the **DirectQuery** data connectivity mode, then click **OK**.

    ![The connection settings are configured as described.](media/pbi-connection.png "SQL Server database")

6. **Optional**: If you are prompted to sign in, select **Microsoft account** on the left-hand menu. **Sign in**, then click **Connect**.

    ![The authentication form is displayed.](media/pbi-auth.png "Authentication")

7. Check the check boxes next to **PREDICT_SensorRUL** and **Sensor**, then click **Load**.

    ![The two tables are checked and the Load button is highlighted.](media/pbi-load-2-tables.png "Navigator")

8. If you get prompted by Power BI Desktop that adding new data sources presents a potential security risk, click **OK** to build the model.

    ![The OK button is highlighted.](media/pbi-security-risk.png "Potential security risk")

9. Select the **Modeling** tab, then click **Manage relationships** in the menu.

    ![Manage relationships is highlighted.](media/pbi-modeling-tab.png "Modeling tab")

10. Click **New**.

    ![The New button is highlighted.](media/pbi-relationships-new.png "Manage relationships")

11. Select the **PREDICT_SensorRUL** table in the first drop-down list, then select **Sensor** in the second drop-down list. Click **OK** to apply the table relationship. Notice that it automatically selected `DeviceId` as the relationship key and set the cardinality to `1:*`.

    ![The two tables are added and the OK button is highlighted.](media/pbi-relationships-predict-sensor.png "Create relationship")

12. Click **New** to create a new relationship.

    ![The New button is highlighted.](media/pbi-relationship-new2.png "Manage relationships")

13. Select the **PREDICT_SensorRUL** table in the first drop-down list, then select **v_sensor_ondemand** in the second drop-down list. Click **OK to apply the table relationship. This adds a relationship to the SQL serverless (On-demand) view you created earlier.

    ![The two tables are added and the OK button is highlighted.](media/pbi-relationships-predict-od.png "Create relationship")

14. Click **Close**.

    ![The Close button is highlighted.](media/pbi-relationship-new3.png "Manage relationships")

15. On the Report tab, click **+** to add a new report.

    ![The + button is highlighted on the report tab.](media/pbi-new-tab.png "New report")

16. Click an empty location in the report area. Under Visualizations, select **Table**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Field | `DeviceId` | `PREDICT_SensorRUL` table |
    | Field | `RUL` | `PREDICT_SensorRUL` table |
    | Field | `avgSensor9` | `PREDICT_SensorRUL` table |
    | Field | `avgSensor11` | `PREDICT_SensorRUL` table |
    | Field | `avgSensor14` | `PREDICT_SensorRUL` table |
    | Field | `avgSensor15` | `PREDICT_SensorRUL` table |

    ![The chart is configured as described.](media/pbi-table.png "Table")

17. Click an empty location in the report area. Under Visualizations, select **Clustered column chart**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Axis | `DeviceId` | `PREDICT_SensorRUL` table |
    | Legend | | |
    | Values | `Cycle` | `Sensor` table |

    ![The chart is configured as described.](media/pbi-clustered-column.png "Clustered column chart")

18. Click **Cycle** and select **Maximum**. This lets us verify how many cycles were sustained before required maintenance for each Device.

    ![The Maximum value is selected for Cycle.](media/pbi-cycle-max.png "Max of Cycle")

19. Click an empty location in the report area. Under Visualizations, select **Line chart**, then use the table below to set the field values.

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Axis | `Cycle` | `Sensor` table |
    | Legend | `DeviceId` | `PREDICT_SensorRUL` table|
    | Values | `Sensor11` | `Sensor` table |

    ![The chart is configured as described.](media/pbi-line-chart2.png "Line chart")

20. Click **Sensor11** to and select **Average** to make sure that the sensor blur is growing in the second half of the cycle prior to maintenance.

    ![The Average value is selected for Sensor11.](media/pbi-sensor11-avg.png "Average of Sensor11")

21. **Save** the report.

## Exercise 11: End processing

Time required: 5 minutes

You have reached the end of the lab. Follow the steps below to end processing and pause the SQL pool to save costs if you need to keep the lab environment available for additional labs.

> **Note**: If you no longer need the lab environment, delete the `synapse-lab-infrastructure` resource group to remove all lab resources.

### Task 1: Pause the SQL pool

1. Return to Synapse Studio (<https://web.azuresynapse.net/>) and select the **Manage** hub.

    ![The manage hub is selected.](media/manage-hub.png "Manage hub")

2. Select **SQL pools** then select the Pause button (**||**) on the `aiaddw` SQL pool.

    ![The pause button is highlighted.](media/pause-sql-pool.png "SQL pools")

### Task 2: Stop Stream Analytics

1. Navigate to the `synapse-lab-infrastructure` resource group in the Azure portal. Locate and open the **Stream Analytics job**.

    ![The Stream Analytics job is highlighted.](media/resource-group-stream-analytics.png "Stream Analytics job")

2. In the **Overview** blade, select **Stop** then **Yes** to confirm.

    ![The Stop button and Yes button are highlighted.](media/stream-analytics-stop.png "Stop job")

### Task 3: Stop Virtual Devices application

1. Stop the **IoTVirtualDevices** application by clicking **Virtual Device Processing** or closing the window to exit the app.

    ![The app window is shown.](media/virtual-device-processing.png "Virtual Devices")

<!-- ## Appendix

### Native scoring with T-SQL PREDICT

You can use the T-SQL PREDICT function by registering a learned model created with Azure ML or Spark ML with SQL Pool. This feature allows data batch scoring on your data warehouse without having to navigate out of Synapse Studio.

#### Register model files

Import the model file with SQL. To do this, use the `ETLandPREDICT/RegisterModel.sql` file. -->