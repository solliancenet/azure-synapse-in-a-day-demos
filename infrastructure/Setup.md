# Azure Synapse in a day demos - Infrastructure

- [Azure Synapse in a day demos - Infrastructure](#azure-synapse-in-a-day-demos---infrastructure)
  - [Pre-requisites](#pre-requisites)
  - [Exercise 0: Download lab files](#exercise-0-download-lab-files)
  - [Exercise 1: Deploy Resources](#exercise-1-deploy-resources)
    - [Task 1: Create Azure Synapse Analytics workspace](#task-1-create-azure-synapse-analytics-workspace)
    - [Task 2: Set up blob data owner](#task-2-set-up-blob-data-owner)
    - [Task 3: Set up user access administrator](#task-3-set-up-user-access-administrator)
    - [Task 4: IoT Hub resource creation](#task-4-iot-hub-resource-creation)
    - [Task 5: Create and configure Stream Analytics resources](#task-5-create-and-configure-stream-analytics-resources)
  - [Exercise 2: Movie data to the data lake using Copy activity](#exercise-2-movie-data-to-the-data-lake-using-copy-activity)
    - [About Synapse Pipeline](#about-synapse-pipeline)
    - [Task 1: Log in to Synapse Studio](#task-1-log-in-to-synapse-studio)
    - [Task 2: Create a Linked Service](#task-2-create-a-linked-service)
    - [Task 3: Create a Copy pipeline](#task-3-create-a-copy-pipeline)
    - [Task 4: Create a SQL Pool](#task-4-create-a-sql-pool)
  - [Lab guide](#lab-guide)

## Pre-requisites

To complete this lab, you must meet the following pre-requisites:

1. Microsoft Azure subscription must be pay-as-you-go or MSDN.

    a. Trial subscriptions will not work.

2. Install [Power BI Desktop](https://aka.ms/pbidesktopstore).

3. Windows desktop machine (or Azure VM with a Windows 10 image) for the IoT Device emulator.

4. [Power BI Pro license](https://powerbi.microsoft.com/power-bi-pro/) (can start a trial version of Pro).

    > If you have permission to publish reports to your Workspace (≠My Workspace), you can create Power BI Reports on Synapse. (Required: Power BI Pro license). If not, you can create a Report solely with Power BI Desktop.

## Exercise 0: Download lab files

Time required: 5 minutes

The lab files are located in a GitHub repo. You must unzip the file and extract it to your desktop so you can access them throughout the lab.

1. Download the ZIP file for the lab from <https://github.com/solliancenet/azure-synapse-in-a-day-demos/archive/master.zip>.

2. Extract the files to **`C:\`**. This will create a folder named `azure-synapse-in-a-day-demos-master` at the root of your C: drive.

    ![The extract zipped folders dialog is displayed.](media/unzip.png "Extract Compressed (Zipped) Folders")

3. Navigate to `C:\azure-synapse-in-a-day-demos-master\infrastructure\source` to view the files.

    ![The extracted files are displayed in Windows Explorer.](media/extracted-files.png "Extracted files")

## Exercise 1: Deploy Resources

Time required: 15 minutes

The first step is to deploy and configure the resources. It's easy to do from the Azure Portal.

![The Azure Synapse Analytics area of the diagram is highlighted.](media/synapse.png "Azure Synapse Analytics")

### Task 1: Create Azure Synapse Analytics workspace

1. Navigate to the Azure portal (<https://portal.azure.com>) to create the Azure Synapse Analytics workspace.

2. In the search menu, type **Synapse**, then select **Azure Synapse Analytics**.

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

### Task 4: IoT Hub resource creation

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

### Task 5: Create and configure Stream Analytics resources

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

## Exercise 2: Movie data to the data lake using Copy activity

Time required: 30 minutes

In this exercise, you will import a large amount of data into the primary data lake account.

![The copy activity portion of the diagram is highlighted.](media/diagram-copy.png "Copy activity")

### About Synapse Pipeline

The data integration feature, Synapse Pipeline, is designed with the following concepts:

- **Linked Service**: Contains definitions about the connection, such as the database and server information.
- **Dataset**: Browses the Linked Service and defines table information, for example.
- **Activity**: Browses, for example, a Dataset to define processing such as data movement.
- **Pipeline**: Defines the order and conditions in which Activities are run.
- **Integration Runtime**: Defines the processing infrastructure used by Linked Services and Activities.
- **Trigger**: Defines when and how the Pipeline will run.

### Task 1: Log in to Synapse Studio

Synapse Studio is the web-based interface for working with your Azure Synapse Analytics workspace.

![The Azure Synapse Analytics area of the diagram is highlighted.](media/synapse.png "Azure Synapse Analytics")

1. Navigate to the Azure portal (<https://portal.azure.com>).

2. In the search menu, type **Synapse**, then select **Azure Synapse Analytics**.

    ![Synapse is highlighted in the search box, and the Azure Synapse Analytics workspace preview item in the results is highlighted.](media/search-synapse.png "Synapse search")

3. Select the Synapse Workspace that you created for this lab, or that was provided for you in the lab environment.

4. Select **Open** underneath **Open Synapse Studio** from the Synapse workspace page.

    ![Launch Synapse Studio is selected.](media/azure-synapse-launch-studio.png 'Launch Synapse Studio')

    After authenticating your account, you should see the Synapse Studio home page for your workspace.

    ![The home page for the workspace is displayed.](media/synapse-workspace-home.png "Synapse Studio home")

5. If you see the Getting started dialog, select **Close**.

    ![The close button is highlighted.](media/synapse-studio-getting-started.png "Getting started")

### Task 2: Create a Linked Service

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

### Task 3: Create a Copy pipeline

1. Select the **Integrate** hub, select **+**, then select **Pipeline**.

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

### Task 4: Create a SQL Pool

![The SQL Pool portion of the diagram is highlighted.](media/diagram-sql-pool.png "SQL Pool")

A dedicated SQL Pool is one of the analytic runtimes in Azure Synapse Analytics that help you ingest, transform, model, and analyze your data. It offers T-SQL based compute and storage capabilities. After creating a dedicated SQL pool in your Synapse workspace, data can be loaded, modeled, processed, and delivered for faster analytic insight.

1. Select the **Manage** hub.

    ![The manage hub is highlighted.](media/manage-hub.png "Manage hub")

2. Select **SQL pools**, then select **+ New**.

    ![The SQL pools blade is displayed.](media/new-sql-pool.png "SQL pools")

3. Enter **aiaddw** for the dedicated SQL pool name, select the **DW100c** performance level, then select **Review + create**.

    ![The form is displayed as described.](media/new-sql-pool-form.png "Create SQL pool")

4. Select **Create** in the review blade.

5. Wait for the SQL pool deployment to complete. You may need to periodically select **Refresh** to update the status.

    ![The SQL pool is deploying and the refresh button is highlighted.](media/sql-pool-deploying.png "SQL pools")

## Lab guide

Now that you have completed the lab setup, continue to the [step-by-step lab guide](README.md).
