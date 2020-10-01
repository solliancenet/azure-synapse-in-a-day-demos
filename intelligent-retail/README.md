# Azure Synapse in a day demos - Intelligent retail

- [Azure Synapse in a day demos - Intelligent retail](#azure-synapse-in-a-day-demos---intelligent-retail)
  - [Overview](#overview)
  - [What we will do in the lab](#what-we-will-do-in-the-lab)
    - [Part 1: Data collection](#part-1-data-collection)
    - [Part 2: Data aggregation](#part-2-data-aggregation)
    - [Part 3: Data Analysis](#part-3-data-analysis)
    - [Part 4: Security](#part-4-security)
    - [Part 5: Data visualization](#part-5-data-visualization)
  - [Hands-on lab story description](#hands-on-lab-story-description)
  - [Hands-on environment](#hands-on-environment)
  - [Exercise 0: Download lab files](#exercise-0-download-lab-files)
  - [Exercise 1: Environment setup](#exercise-1-environment-setup)
    - [Task 1: Create an Azure Synapse workspace](#task-1-create-an-azure-synapse-workspace)
    - [Task 2: Set up blob data owner](#task-2-set-up-blob-data-owner)
    - [Task 3: Set up user access administrator](#task-3-set-up-user-access-administrator)
    - [Task 4: Create a SQL pool](#task-4-create-a-sql-pool)
    - [Task 5: Create an Apache Spark pool](#task-5-create-an-apache-spark-pool)
    - [Task 6: Install Power BI Desktop](#task-6-install-power-bi-desktop)
    - [Task 7: Log in to Synapse Studio](#task-7-log-in-to-synapse-studio)

## Overview

Azure Synapse Analytics (hereafter Synapse) is an evolution of the Azure SQL Data Warehouse and a data analytics platform with conventional data warehouse functionality in addition to integration of certain functionality related to data analysis, such as data integration, distributed processing, BI, and machine learning.

In the past, each function, from data collection and processing to analysis and visualization, had to be built individually, but if you take advantage of Synapse, you can achieve all of this on the same platform.

In this classroom seminar, you studied Synapse conceptually by learning functional overviews and usage scenarios. With this hands-on training, we hope that you will further deepen your understanding of its features by building a data analytics platform on Synapse following stories as well as embodying actual usage concepts from the distribution industry.

![The overview diagram is shown.](media/synapse-analytics-overview.png "Azure Synapse Analytics")

## What we will do in the lab

This hands-on training consists of five parts, and by having you perform all the parts, you will gain a comprehensive understanding of the features of Synapse. An overview of each of the parts is provided below.

### Part 1: Data collection

Using IoT Hub and Stream Analytics, you will collect data from IoT devices, and store it in file format in Data Lake Storage.

### Part 2: Data aggregation

You will process data stored in Data Lake Storage in various formats using data flow to process it for easy handling in subsequent processing. In addition, you will aggregate the processed data with distributed processing using Spark and load it into a data warehouse (SQL pool) for analysis. You will also automate these flows using a pipeline.

### Part 3: Data Analysis

Using SQL on-demand, you will explore and analyze data stored in Data Lake Storage in various formats.
In addition, you will use machine learning models to make demand forecasts from large-scale data.

### Part 4: Security

To use Synapse Analytics securely, you will learn about the network settings and access rights settings.

### Part 5: Data visualization

Using a BI tool (Power BI), you will visualize aggregate data stored in the data warehouse to make it easier for your business to use.

## Hands-on lab story description

![Story header.](media/story-ctc-smart-shelf.png "Story: Data analysis in stores with CTC Smart Shelf")

In a supermarket where the CTC Smart Shelf is located, real-time links to Synapse of customer behavior in front of the shelf and personal attribute data obtained from the shelf makes individual optimized marketing and real-time, multi-faceted analysis possible. In addition, by associating weather data and other open data linked externally with a variety of data obtained from the store and analyzing it in a machine learning model, you can also forecast demand.

![The data flow is shown.](media/story-diagram1.png "Story diagram 1")

![A smart shelf is a next-generation display case equipped with an AI camera and a weight sensor on the shelf itself. The AI camera acquires customer attributes, such as age, gender, and length of stay (age and gender are estimated by Cognitive Service Face API). The weight sensor acquires customer behavior, such as picking up and returning goods to the shelf. Based on this information, analysis of the behavior and attributes of customers that pick up and return home with products (= customers who make purchases) is performed, making next-generation in-store analysis possible. Based on customer information and sales information, information is distributed interactively to the display and electronic shelf tags mounted on the shelf to enable promotions, such as dynamic pricing and personalized marketing.](media/story-smart-shelf-description.png "What is CTC Smart Shelf?")

## Hands-on environment

The following is a diagram of the data analytics infrastructure that you will build in this hands-on training:

![The lab diagram is shown.](media/lab-diagram.png "Lab diagram")

## Exercise 0: Download lab files

## Exercise 1: Environment setup

Time required: 20 minutes

To perform this hands-on training, you will prepare the following items in this exercise:

- Create an Azure Synapse workspace
- Create a SQL pool
- Create an Apache Spark pool
- Install Power BI Desktop

### Task 1: Create an Azure Synapse workspace

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
    | Resource group | `synapse-lab-retail` | Select **Create new**, then enter the name. |
    | Workspace name | `synapselabretail` + your initials + `asws` (example: `synapselabretailjdhasws`) | Lowercase alphanumeric characters only |
    | Region | Select the region closest to you, such as `West US`. | |
    | Select Data Lake Storage Gen2 | From subscription | Default settings |
    | Account name | `synapselabretail` + your initials + `adls` (example: `synapselabretailjdhadls`) | Select **Create new** (lowercase alphanumeric characters only) |

5. Select **Create new** for `File system name`, type **datalake** in the name field, then select **OK**.

    ![The form is shown as described.](media/create-synapse-2.png "Create Synapse workspace 2")

6. Check the `Assign myself the Storage Blob Data Contributor role` checkbox, then select **Next: Security**.

    ![The checkbox is checked and the Next button is highlighted.](media/create-synapse-3.png "Create Synapse workspace 3")

    > **Role of storage in Synapse workspace**
    >
    > Azure Data Lake Storage Gen2 (ADLS Gen2) selected when creating the Synapse workspace is considered the workspace's primary storage account, and it is used to store backing data files for Synapse SQL Serverless (SQL on-demand) and Spark tables, as well as Spark job execution logs.
    >
    > You can also access files in storage from SQL on-demand and Apache Spark directly for processing.

7. In the `Security` form, enter the values shown in the table below, then select **Next: Networking**.

    ![The security settings are displayed.](media/create-synapse-4.png "Create Synapse workspace security settings")

    | Parameters | Settings | Remarks |
    | --- | --- | --- |
    | Admin username | Any | Select the Azure subscription used for this lab. |
    | Password | `handson_P@ssw0rd` | Enter the password. |
    | Confirm password | `handson_P@ssw0rd` | Re-enter the same password. |
    | System assigned managed identity | Check the box (On) | Allow pipelines running as the workspace's system assigned identity to access SQL pools. |

8. In the `Networking` form, enter the values shown in the table below, then select **Review + create**.

    ![The network settings are displayed.](media/create-synapse-5.png "Create Synapse workspace network settings")

    | Parameters | Settings |
    | --- | --- |
    | Enable managed virtual network | Check the box (On) |
    | Allow connections from all IP addresses | Check the box (On) |

9. Review the settings, then select **Create**. It takes around five minutes to create the workspace.

    ![The Create button is highlighted.](media/create-synapse-6.png "Create Synapse workspace review")

### Task 2: Set up blob data owner

Data access permissions on the data lake must be set separately from the resource's permissions.

1. When the Azure Synapse Analytics workspace deployment completes, navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

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

3. Select the **User Access Administrator** role. Select **User, group, or service principal** under assign access to. Search for and select your Azure account, then select **Save**.

    ![The add role assignment form is configured as described.](media/synapse-add-role-assignment.png "Add role assignment")

### Task 4: Create a SQL pool

1. Return to the `synapse-lab-retail` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. Select **SQL pools** in the left-hand menu, then select **+ New**.

    ![The new button is highlighted.](media/synapse-sql-pools-new.png "SQL pools")

3. Enter **`SqlPool`** for the name and set the performance level to **DW100c**. Select **Review + create**.

    ![The form is configured as described.](media/synapse-sql-pools-new-form.png "Create SQL pool")

4. Confirm the settings, then select **Create**.

    ![The Create button is highlighted.](media/synapse-sql-pools-new-review.png "Review + create")

### Task 5: Create an Apache Spark pool

1. Return to the `synapse-lab-retail` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. Select **Apache Spark pools** on the left-hand menu, then select **+ New**.

    ![The new button is highlighted.](media/synapse-spark-pools-new.png "Apache Spark pools")

3. Enter **`SparkPool`** for the name, select the **Small (4 vCPU / 32 GB)** node size, and enable **Autoscale**. Set the number of nodes to a minimum of **3** and a maximum of **10**. Select **Review + create**.

    ![The form is configured as described.](media/synapse-spark-pools-new-form.png "Create Apache Spark pool")

4. Confirm the settings, then select **Create**.

    ![The Create button is highlighted.](media/synapse-spark-pools-new-review.png "Review + create")

### Task 6: Install Power BI Desktop

### Task 7: Log in to Synapse Studio

1. Return to the `synapse-lab-retail` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, select the **Workspace web URL** to navigate to Synapse Studio for this workspace.

    ![The workspace web URL is highlighted.](media/synapse-workspace-url.png "Workspace web URL")

    After authenticating your account, you should see the Synapse Studio home page for your workspace.

    ![The home page for the workspace is displayed.](media/synapse-workspace-home.png "Synapse Studio home")

3. If you see the Getting started dialog, select **Close**.

    ![The close button is highlighted.](media/synapse-studio-getting-started.png "Getting started")
