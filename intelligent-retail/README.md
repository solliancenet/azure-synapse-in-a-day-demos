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
  - [Exercise 1: Environment setup](#exercise-1-environment-setup)
    - [Task 1: Create an Azure Synapse workspace](#task-1-create-an-azure-synapse-workspace)
    - [Task 2: Set up blob data owner](#task-2-set-up-blob-data-owner)
    - [Task 3: Set up user access administrator](#task-3-set-up-user-access-administrator)
    - [Task 4: Create a SQL pool](#task-4-create-a-sql-pool)
    - [Task 5: Create an Apache Spark pool](#task-5-create-an-apache-spark-pool)
    - [Task 6: Prepare a Virtual Machine to run data generator and Power BI Desktop](#task-6-prepare-a-virtual-machine-to-run-data-generator-and-power-bi-desktop)
    - [Task 7: Download lab files](#task-7-download-lab-files)
    - [Task 8: Install Azure Storage Explorer and upload lab files](#task-8-install-azure-storage-explorer-and-upload-lab-files)
    - [Task 9: Log in to Synapse Studio](#task-9-log-in-to-synapse-studio)
  - [Exercise 2: Data collection](#exercise-2-data-collection)
    - [Task 1: Deploy ARM template](#task-1-deploy-arm-template)
    - [Task 2: Create Azure Data Lake Storage Gen2 account](#task-2-create-azure-data-lake-storage-gen2-account)
    - [Task 3: Register an IoT device (for AI camera)](#task-3-register-an-iot-device-for-ai-camera)
    - [Task 4: Save IoT device connection information (for AI camera)](#task-4-save-iot-device-connection-information-for-ai-camera)
    - [Task 5: Register another IoT device (for weight sensor)](#task-5-register-another-iot-device-for-weight-sensor)
    - [Task 6: Save IoT device connection information (for weight sensor)](#task-6-save-iot-device-connection-information-for-weight-sensor)
    - [Task 7: Stream Analytics (for AI cameras) input settings](#task-7-stream-analytics-for-ai-cameras-input-settings)
    - [Task 8: Stream Analytics (for AI cameras) output settings](#task-8-stream-analytics-for-ai-cameras-output-settings)
    - [Task 9: Stream Analytics (for AI cameras) query settings](#task-9-stream-analytics-for-ai-cameras-query-settings)
    - [Task 10: Stream Analytics (for weight sensors) input settings](#task-10-stream-analytics-for-weight-sensors-input-settings)
    - [Task 11: Stream Analytics (for weight sensors) output settings](#task-11-stream-analytics-for-weight-sensors-output-settings)
    - [Task 12: Stream Analytics (for weight sensors) query settings](#task-12-stream-analytics-for-weight-sensors-query-settings)
      - [Additional information: Using reference data in Stream Analytics](#additional-information-using-reference-data-in-stream-analytics)
    - [Task 13: Prepare to send data](#task-13-prepare-to-send-data)
    - [Task 14: Send data](#task-14-send-data)
    - [Task 15: Verify sent data](#task-15-verify-sent-data)
  - [Exercise 3: Data aggregation](#exercise-3-data-aggregation)

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

## Exercise 1: Environment setup

Time required: 40 minutes

To perform this hands-on training, you will prepare the following items in this exercise:

- Create an Azure Synapse workspace
- Create a SQL pool
- Create an Apache Spark pool
- Create an Azure VM
  - Install Power BI Desktop
  - Install Node.js
- Download lab files

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

### Task 6: Prepare a Virtual Machine to run data generator and Power BI Desktop

To proceed with the steps described in this hands-on training, you need to install Node.js for the data generator, and need to use the Power BI Desktop app for Windows 10. In this step, you will create a virtual machine running Windows 10, install Node.js, then install Power BI.

1. In the [Azure portal](https://portal.azure.com), type in "virtual machines" in the top search menu and then select **Virtual machines** from the results.

    ![In the Services search result list, Virtual machines is selected.](media/azure-create-vm-search.png "Virtual machines")

2. Select **+ Add** on the Virtual machines page and then select the **Virtual machine** option.

3. In the **Basics** tab, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Subscription                   | _select the appropriate subscription_              |
   | Resource group                 | _select `synapse-lab-retail`_                      |
   | Virtual machine name           | _`powerbi` (or unique name if not available)_      |
   | Region                         | _select the resource group's location_             |
   | Availability options           | _select `No infrastructure redundancy required`_   |
   | Image                          | _select `Windows 10 Pro, Version 1809 - Gen1`_     |
   | Azure Spot instance            | _select `No`_                                      |
   | Size                           | _select `Standard_D2s_v3`_                         |
   | Username                       | _select `powerbiuser`_                             |
   | Password                       | _enter a password you will remember_               |
   | Public inbound ports           | _select `Allow selected ports`_                    |
   | Select inbound ports           | _select `RDP (3389)`_                              |
   | Licensing                      | _select the option to confirm that you have an  eligible Windows 10 license with multi-tenant hosting rights._ |

   ![The form fields are completed with the previously described settings.](media/azure-create-vm-1.png "Create a virtual machine")

4. Select **Review + create**. On the review screen, select **Create**. After the deployment completes, select **Go to resource** to go to the virtual machine.

    ![The Go to resource option is selected.](media/azure-create-vm-2.png "Go to resource")

5. Select **Connect** from the actions menu and choose **RDP**.

    ![The option to connect to the virtual machine via RDP is selected.](media/azure-vm-connect.png "Connect via RDP")

6. On the **Connect** tab, select **Download RDP File**.

    ![Download the RDP file to connect to the Power BI virtual machine.](media/azure-vm-connect-2.png "Download RDP File")

7. Open the RDP file and select **Connect** to access the virtual machine. When prompted for credentials, enter `powerbiuser` for the username and the password you chose. Select the option to allow the security certificate when prompted.

    ![Connect to a remote host.](media/azure-vm-connect-3.png "Connect to a remote host")

8. From the following URL, go to the Power BI Desktop download site and select **Download free**: Power BI Desktop: <https://powerbi.microsoft.com/desktop/>

    ![The download page is displayed.](media/pbi-desktop-download.png "Power BI Desktop download")

9. Install the software from the Microsoft store.

    ![The desktop software is installing in the Microsoft Store.](media/pbi-desktop-install.png "Power BI Desktop")

10. Navigate to <https://nodejs.org/en/download/>.

11. Select the **LTS** tab, then select the **64-bit** _Windows Installer (.msi)_ version. Download and run the installer.

    ![The 64-bit Windows Installer LTS version is highlighted.](media/install-nodejs-windows.png "Downloads")

12. Select all default options in the install dialog. When prompted whether to automatically install the necessary tools for Native Modules, **Check the box** next to `Automatically install the necessary tools...`.

    ![The check box is checked.](media/install-nodejs-tools.png "Tools for Native Modules")

13. When the installation is completed, a Command Prompt window will appear to install the additional tools for Node.js. When you see this, press any key to continue.

    ![The command prompt is displayed.](media/install-nodejs-command-prompt.png "Install Additional Tools for Node.js")

    > After pressing a key for this and the prompt that follows, let the install process continue to run in the background in PowerShell. You may continue with the lab steps that follow.

### Task 7: Download lab files

1. From your lab VM, navigate to <https://solliancepublicdata.blob.core.windows.net/synapse-in-a-day/retail/handson.zip> to download the ZIP file for this lab.

2. Navigate to the folder to which you downloaded the file. Right-click on the `handson.zip` file, then select **Extract All...**.

    ![The file is highlighted and Extract All is selected.](media/file-extract-all.png "Extract all")

3. Change the destination folder path to **`C:\handson`**, then click **Extract**.

    ![The folder destination is configured.](media/file-extract-destination.png "Select a Destination and Extract Files")

4. You should see three folders in the `C:\handson` directory after extracting the files.

    ![The three folders are displayed.](media/extracted-lab-files.png "Extracted lab files")

### Task 8: Install Azure Storage Explorer and upload lab files

There are files you need to upload to the primary ADLS Gen2 account for your Synapse workspace. To do this, you will use Azure Storage Explorer. If you already have Azure Storage Explorer installed, you can skip ahead to step 10 below.

1. Navigate to <https://aka.ms/portalfx/downloadstorageexplorer>.

2. Select **Download now**.

    ![The download now button is highlighted.](media/ase-download-now.png "Azure Storage Explorer: Download now")

3. When prompted, run the installer.

4. Select **Install for me only (recommended)**.

    ![Install for me only is highlighted.](media/ase-install-for-me.png "Select install mode")

5. Complete the install, choosing the default options.

6. When the install completes, select **Launch Microsoft Azure Storage Explorer**, then click **Finish**.

    ![The box is checked.](media/ase-finished.png "Install Finished")

7. When Azure Storage Explorer launches for the first time, you will be prompted to connect to Azure Storage. Select **Add an Azure Account**, then click **Next**.

    ![Add an Azure Account is selected.](media/ase-connect-1.png "Connect to Azure Storage")

8. Sign into the Azure account you are using for the lab, when prompted.

9. After signing into your account, select all your Azure subscriptions, then click **Apply**.

    ![All subscriptions are selected and the Apply button is highlighted.](media/ase-apply-subs.png "Select subscriptions")

10. Expand the Azure subscription you are using for this lab, then expand **Storage Accounts**. Locate and expand the primary ADLS Gen2 account you created when you provisioned your Synapse Analytics workspace. It will be named `synapselabretail` + your initials + `adls` (example: `synapselabretailjdhadls`). Right-click **Blob Containers** for the account, then select **Create Blob Container**.

    ![The storage account is expanded.](media/ase-create-blob-container.png "Create Blob Container")

11. Type **`sampledata`** for the container name, then hit Enter.

    ![The sampledata container is highlighted.](media/ase-sampledata.png "sampledata")

12. Open Windows Explorer and navigate to **`C:\handson\sampledata`**. Select all three folders and drag them into the **sampledata** container to upload them.

    ![The three folders are highlighted and an arrow points to the sampledata container in Azure Storage Explorer.](media/ase-drag-folders.png "Drag folders into sampledata")

13. After about 1 minute, you should see that all three folders successfully uploaded, along with 406 items, to the `sampledata` container.

    ![The files successfully uploaded to the sampledata container.](media/ase-sampledata-uploaded.png "Files successfully uploaded")

### Task 9: Log in to Synapse Studio

1. Return to the `synapse-lab-retail` resource group and select the Azure Synapse Analytics workspace within.

    ![The Synapse workspace is highlighted in the resource group.](media/resource-group-synapse-workspace.png "Resource group")

2. In the **Overview** blade, select the **Workspace web URL** or **Launch Synapse Studio** to navigate to Synapse Studio for this workspace.

    ![The workspace web URL is highlighted.](media/synapse-workspace-url.png "Workspace web URL")

    After authenticating your account, you should see the Synapse Studio home page for your workspace.

    ![The home page for the workspace is displayed.](media/synapse-workspace-home.png "Synapse Studio home")

3. If you see the Getting started dialog, select **Close**.

    ![The close button is highlighted.](media/synapse-studio-getting-started.png "Getting started")

## Exercise 2: Data collection

Time required: 20 minutes

In data collection, you will collect and process stream data flowing from IoT devices in real time and store it in the data lake.

You will learn:

- **Data Lake Storage construction**: Build a data lake to store collected data.

- **IoT Hub construction**: Build a gateway to connect devices in Azure end-to-end and enable secure two-way communication.

- **Stream Analytics construction**: Build workload to analyze and process streaming data flowing through IoT Hub in real time.

- **Send streaming data from IoT devices**: Using IoT Hub client, implement processing to send messages from a device to IoT Hub.

![Data flows from an smart shelf IoT device to IoT Hub. Stream Analytics processes the data and saves it to Azure Data Lake Storage Gen2.](media/diagram-data-collection.png "Data collection diagram")

### Task 1: Deploy ARM template

The ARM template deploys the following resources:

- Two IoT Hubs
- Two Stream Analytics jobs

1. Navigate to the Azure portal (<https://portal.azure.com>).

2. In the search menu, type **template deployment**, then select **Deploy a custom template**.

    ![Template deployment is highlighted in the search box, and the deploy a custom template item in the results is highlighted.](media/search-template.png "Template search")

3. Select **Build your own template in the editor**.

    ![The link is highlighted.](media/template-build-link.png "Custom deployment")

4. **Replace** the contents of the template with the following:

    ```json
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {
            "UniqueSuffix": {
                "type": "String",
                "metadata": {
                    "description": "Suffix added to all resource names to make them unique. Enter between 4 and 8 characters"
                }
            },
            "Region": {
                "type": "string",
                "defaultValue": "[resourceGroup().location]",
                "metadata": {
                    "description": "Location for the IoT Hub and Stream Analytics services."
                }
            }
        },
        "variables": {
            "name_suffix": "[take(toLower(parameters('UniqueSuffix')), 8)]",
            "CameraIotHubName": "[concat('handson-iothub', variables('name_suffix'))]",
            "SensorIotHubName": "[concat('handson-iothub-sensor', variables('name_suffix'))]",
            "CameraSAJName": "[concat('handson-SAJ', variables('name_suffix'))]",
            "SensorSAJName": "[concat('handson-SAJ-sensor', variables('name_suffix'))]",
            "CameraCGName": "[concat('handson-iothub', variables('name_suffix'), '/events/handson-cg')]",
            "SensorCGName": "[concat('handson-iothub-sensor', variables('name_suffix'), '/events/handson-cg')]"
        },
        "resources": [
            {
                "type": "Microsoft.Devices/IotHubs",
                "apiVersion": "2020-03-01",
                "name": "[variables('CameraIotHubName')]",
                "location": "[parameters('Region')]",
                "sku": {
                    "name": "S1",
                    "tier": "Standard",
                    "capacity": 1
                },
                "properties": {
                    "ipFilterRules": [],
                    "eventHubEndpoints": {
                        "events": {
                            "retentionTimeInDays": 1,
                            "partitionCount": 4
                        }
                    },
                    "routing": {
                        "endpoints": {
                            "serviceBusQueues": [],
                            "serviceBusTopics": [],
                            "eventHubs": [],
                            "storageContainers": []
                        },
                        "routes": [],
                        "fallbackRoute": {
                            "name": "$fallback",
                            "source": "DeviceMessages",
                            "condition": "true",
                            "endpointNames": [
                                "events"
                            ],
                            "isEnabled": true
                        }
                    },
                    "messagingEndpoints": {
                        "fileNotifications": {
                            "lockDurationAsIso8601": "PT1M",
                            "ttlAsIso8601": "PT1H",
                            "maxDeliveryCount": 10
                        }
                    },
                    "enableFileUploadNotifications": false,
                    "cloudToDevice": {
                        "maxDeliveryCount": 10,
                        "defaultTtlAsIso8601": "PT1H",
                        "feedback": {
                            "lockDurationAsIso8601": "PT1M",
                            "ttlAsIso8601": "PT1H",
                            "maxDeliveryCount": 10
                        }
                    },
                    "features": "None"
                }
            },
            {
                "type": "Microsoft.Devices/iotHubs/eventhubEndpoints/ConsumerGroups",
                "apiVersion": "2018-04-01",
                "name": "[variables('CameraCGName')]",
                "dependsOn": [
                    "[resourceId('Microsoft.Devices/IotHubs', variables('CameraIotHubName'))]"
                ]
            },
            {
                "type": "Microsoft.Devices/IotHubs",
                "apiVersion": "2020-03-01",
                "name": "[variables('SensorIotHubName')]",
                "location": "[parameters('Region')]",
                "sku": {
                    "name": "S1",
                    "tier": "Standard",
                    "capacity": 1
                },
                "properties": {
                    "ipFilterRules": [],
                    "eventHubEndpoints": {
                        "events": {
                            "retentionTimeInDays": 1,
                            "partitionCount": 4
                        }
                    },
                    "routing": {
                        "endpoints": {
                            "serviceBusQueues": [],
                            "serviceBusTopics": [],
                            "eventHubs": [],
                            "storageContainers": []
                        },
                        "routes": [],
                        "fallbackRoute": {
                            "name": "$fallback",
                            "source": "DeviceMessages",
                            "condition": "true",
                            "endpointNames": [
                                "events"
                            ],
                            "isEnabled": true
                        }
                    },
                    "messagingEndpoints": {
                        "fileNotifications": {
                            "lockDurationAsIso8601": "PT1M",
                            "ttlAsIso8601": "PT1H",
                            "maxDeliveryCount": 10
                        }
                    },
                    "enableFileUploadNotifications": false,
                    "cloudToDevice": {
                        "maxDeliveryCount": 10,
                        "defaultTtlAsIso8601": "PT1H",
                        "feedback": {
                            "lockDurationAsIso8601": "PT1M",
                            "ttlAsIso8601": "PT1H",
                            "maxDeliveryCount": 10
                        }
                    },
                    "features": "None"
                }
            },
            {
                "type": "Microsoft.Devices/iotHubs/eventhubEndpoints/ConsumerGroups",
                "apiVersion": "2018-04-01",
                "name": "[variables('SensorCGName')]",
                "dependsOn": [
                    "[resourceId('Microsoft.Devices/IotHubs', variables('SensorIotHubName'))]"
                ]
            },
            {
                "type": "Microsoft.StreamAnalytics/streamingjobs",
                "apiVersion": "2016-03-01",
                "name": "[variables('CameraSAJName')]",
                "location": "[parameters('Region')]",
                "properties": {
                    "sku": {
                        "name": "Standard"
                    },
                    "eventsOutOfOrderPolicy": "Adjust",
                    "outputErrorPolicy": "Stop",
                    "eventsOutOfOrderMaxDelayInSeconds": 0,
                    "eventsLateArrivalMaxDelayInSeconds": 5,
                    "dataLocale": "en-US",
                    "compatibilityLevel": "1.1"
                }
            },
                    {
                "type": "Microsoft.StreamAnalytics/streamingjobs",
                "apiVersion": "2016-03-01",
                "name": "[variables('SensorSAJName')]",
                "location": "[parameters('Region')]",
                "properties": {
                    "sku": {
                        "name": "Standard"
                    },
                    "eventsOutOfOrderPolicy": "Adjust",
                    "outputErrorPolicy": "Stop",
                    "eventsOutOfOrderMaxDelayInSeconds": 0,
                    "eventsLateArrivalMaxDelayInSeconds": 5,
                    "dataLocale": "en-US",
                    "compatibilityLevel": "1.1"
                }
            }
        ]
    }
    ```

5. Select **Save** to save the ARM template.

    ![The template contents are highlighted, as well as the Save button.](media/arm-template.png "Edit template")

6. In the **Basics** tab, complete the following:

    | Field                          | Value                                              |
    | ------------------------------ | ------------------------------------------         |
    | Subscription                   | _select the appropriate subscription_              |
    | Resource group                 | _select `synapse-lab-retail`_                      |
    | Unique Suffix                  | _enter a random value between 4 and 8 letters and numbers with no spaces. This is used to append to the end of the Azure resources to ensure uniqueness._      |
    | Region                         | _leave unchanged_             |

    ![The form is completed as defined.](media/arm-template-form.png "Custom deployment")

7. Select **Review + create**.

8. Select **Create** on the Review + create tab.

    ![The Create button is highlighted.](media/arm-template-review.png "Custom deployment")

### Task 2: Create Azure Data Lake Storage Gen2 account

1. In the search menu, type **storage**, then select **Storage accounts**.

    ![Storage is highlighted in the search box, and the Storage accounts item in the results is highlighted.](media/search-storage.png "Storage search")

2. In the Storage accounts blade, select **+ Add**.

    ![The add button is highlighted.](media/storage-add.png "Storage accounts")

3. In the **Basics** tab, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Subscription                   | _select the appropriate subscription_              |
   | Resource group                 | _select `synapse-lab-retail`_                      |
   | Storage account name           | _`handsonretaildl` + `<unique suffix>` (make the name unique)_      |
   | Location                       | _select the resource group's location_             |
   | Performance           | _select `Standard`_   |
   | Account kind                          | _select `StorageV2 (general purpose v2)`_     |
   | Replication            | _select `Read-access geo-redundant storage (RA-GRS)`_                                      |
   | Blob access tier (default)                           | _select `Hot`_                         |

   ![The form fields are completed with the previously described settings.](media/azure-create-storage-1.png "Create storage account")

4. Select **Next: Networking >**.

5. Keep default settings. Select **Next: Data protection >**.

6. Keep default settings. Select **Next: Advanced >**.

7. Scroll down and select **Enabled** next to **Hierarchical namespace**, then select **Review + create**.

    ![Hierarchical namespace is enabled.](media/azure-create-storage-2.png "Create storage - Advanced")

8. Select **Create** on the review screen.

9. Wait for the deployment to complete, then select **Go to resource**.

    ![Your deployment is complete.](media/azure-create-storage-3.png "Go to resource")

10. Select **Containers** on the overview blade of your new storage account.

    ![The Containers link is highlighted.](media/storage-containers.png "Containers")

11. Select **+ Container** to add a new container. Enter **`shelfdata`** for the container name and set the public access level to **Private**. Select **Create** to create the container.

    ![The container form is completed as described.](media/storage-new-container-shelfdata.png "New container")

> **What is Azure Data Lake Storage Gen2?**
>
> Azure Data Lake Storage Gen2 is an inexpensive data lake storage made available by adding an HDFS interface to Azure Blob Storage. Throughput in gigabits and large-scale petabyte data usage are available, making it extremely cost-effective.

### Task 3: Register an IoT device (for AI camera)

1. Navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the **`handson-iothub + <unique suffix>`** IoT Hub account.

    ![The handson-iothub account is highlighted.](media/resource-group-iothub.png "IoT Hub")

3. Select **IoT devices** on the left-hand menu, then select **+ New**.

    ![The new button is highlighted.](media/iothub-devices-new.png "IoT devices - New")

4. In the **Create a device** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Device ID                   | _enter `TestDevice`_              |
   | Authentication type                 | _select `Symmetric key`_                      |
   | Auto-generate keys           | _check the box_      |
   | Connect this device to an IoT hub | _select `Enable`_             |

   ![The form is configured as described.](media/iothub-devices-new-testdevice.png "Create a device")

5. Select **Save**.

### Task 4: Save IoT device connection information (for AI camera)

1. Select the **TestDevice** that you just added.

    ![The TestDevice is highlighted.](media/testdevice.png "TestDevice")

2. Copy the **Primary Connection String** and save it to a text editor, such as Notepad. This connection string is used to send stream data from IoT devices in subsequent work.

    ![The primary connection string is highlighted.](media/testdevice-connection-string.png "TestDevice")

### Task 5: Register another IoT device (for weight sensor)

1. Navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the **`handson-iothub-sensor + <unique suffix>`** IoT Hub account.

    ![The handson-iothub-sensor account is highlighted.](media/resource-group-iothub-sensor.png "IoT Hub - Sensor")

3. Select **IoT devices** on the left-hand menu, then select **+ New**.

    ![The new button is highlighted.](media/iothub-sensor-devices-new.png "IoT devices - New")

4. In the **Create a device** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Device ID                   | _enter `TestDevice`_              |
   | Authentication type                 | _select `Symmetric key`_                      |
   | Auto-generate keys           | _check the box_      |
   | Connect this device to an IoT hub | _select `Enable`_             |

   ![The form is configured as described.](media/iothub-devices-new-testdevice.png "Create a device")

5. Select **Save**.

### Task 6: Save IoT device connection information (for weight sensor)

1. Select the **TestDevice** that you just added.

    ![The TestDevice is highlighted.](media/testdevice-sensor.png "TestDevice")

2. Copy the **Primary Connection String** and save it to a text editor, such as Notepad. This connection string is used to send stream data from IoT devices in subsequent work.

    ![The primary connection string is highlighted.](media/testdevice-sensor-connection-string.png "TestDevice")

> **What is device registration?**
>
> Issue device IDs and connection keys by registering devices in IoT Hub. Using the issued IDs and keys enables secure communication between devices and the IoT Hub.

### Task 7: Stream Analytics (for AI cameras) input settings

1. Navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the **`handson-SAJ + <unique suffix>`** Stream Analytics job.

    ![The handson-SAJ Stream Analytics job is selected.](media/resource-group-saj.png "Stream Analytics job")

3. Select **Inputs** on the left-hand menu, select **+ Add stream input**, then select **IoT Hub** from the list.

    ![The IoT Hub input option is highlighted.](media/stream-analytics-add-iot-input.png "Add IoT Hub input")

4. In the **IoT Hub** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Input alias                   | _enter `input`_              |
   | IoT Hub                 | _select `handson-iothub + <unique suffix>`_                      |
   | Endpoint           | _select `Messaging`_      |
   | Shared access policy name | _select `iothubowner`_             |
   | Consumer group | _select `handson-cg` (this was created for you by the ARM template)_ |
   | Event serialization format | _select `JSON`_ |
   | Encoding | _select `UTF-8`_ |
   | Event compression type | _select `None`_ |

   ![The form is configured as described.](media/stream-analytics-add-iot-input-form.png "IoT Hub")

5. Select **Save**.

### Task 8: Stream Analytics (for AI cameras) output settings

1. Select **Outputs** on the left-hand menu, select **+ Add**, then select **Blob storage/ADLS Gen2** from the list.

    ![The blob storage/ADLS Gen2 option is highlighted.](media/stream-analytics-add-blob-output.png "Add storage output")

2. In the **Blob storage/ADLS Gen2** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Input alias                   | _enter `output`_              |
   | Storage account                 | _select `handsonretaildl + <unique suffix>`_                      |
   | Container           | _select `Use existing`, then select `shelfdata`_      |
   | Path pattern | _enter `tran/face/{datetime:yyyy}/{datetime:MM}/{datetime:dd}`_             |
   | Event serialization format | _select `JSON`_ |
   | Encoding | _select `UTF-8`_ |
   | Format | _select `Line separated`_ |
   | Minimum rows | _enter `100`_ |
   | Maximum time | _enter `1 minute`_ |
   | Authentication mode | _select `Connection string`_ |

   ![The form is configured as described.](media/stream-analytics-add-blob-output-form.png "IoT Hub")

   > **Minimum rows and maximum time**
   >
   > Must be specified when Parquet is selected in Event serialization format.
   >
   > **Minimum rows**: Minimum number of rows per batch. A new file is created for each batch.
   >
   > **Maximum time**: After a set amount of time and even if the minimum row count requirements are not met, the batch is written to the output.

3. Select **Save**.

### Task 9: Stream Analytics (for AI cameras) query settings

1. Select **Query** on the left-hand menu.

2. Enter the following query, then select **Save query**:

    ```sql
    SELECT
    face_id, date_time, age, gender
    INTO
    [output]
    FROM
    [input] TIMESTAMP BY date_time
    ```

    ![The query is highlighted.](media/stream-analytics-query.png "Query")

3. Select **Overview** on the left-hand menu, then select **Start**.

    ![The start button is highlighted.](media/stream-analytics-start.png "Start")

4. Select **Now** for the job output start time, then select **Start**.

    ![The Start button is highlighted.](media/stream-analytics-start-now.png "Start job")

### Task 10: Stream Analytics (for weight sensors) input settings

1. Navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the **`handson-SAJ-sensor + <unique suffix>`** Stream Analytics job.

    ![The handson-SAJ-sensor Stream Analytics job is selected.](media/resource-group-saj-sensor.png "Stream Analytics job")

3. Select **Inputs** on the left-hand menu, select **+ Add stream input**, then select **IoT Hub** from the list.

    ![The IoT Hub input option is highlighted.](media/stream-analytics-add-iot-input.png "Add IoT Hub input")

4. In the **IoT Hub** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Input alias                   | _enter `input`_              |
   | IoT Hub                 | _select `handson-iothub-sensor + <unique suffix>`_                      |
   | Endpoint           | _select `Messaging`_      |
   | Shared access policy name | _select `iothubowner`_             |
   | Consumer group | _select `handson-cg` (this was created for you by the ARM template)_ |
   | Event serialization format | _select `JSON`_ |
   | Encoding | _select `UTF-8`_ |
   | Event compression type | _select `None`_ |

   ![The form is configured as described.](media/stream-analytics-add-iot-sensor-input-form.png "IoT Hub")

5. Select **Save**.

6. Select **+ Add reference input**.

    ![The blob storage/ADLS Gen2 item is highlighted.](media/stream-analytics-add-blob-input.png "Add reference input")

7. In the **IoT Hub** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Input alias                   | _enter `rf-m-item`_              |
   | Storage account                 | _select `synapselabretail` + your initials + `adls` (example: `synapselabretailjdhadls`) This is the ADLS Gen2 account you created along with the Synapse Analytics workspace_                      |
   | Container           | _select `Use existing`, then select **`sampledata`**_      |
   | Path pattern | _enter `master/m_item/m_item.csv`_             |
   | Event serialization format | _select `CSV`_ |
   | Delimiter | _select `comma (,)`_ |
   | Encoding | _select `UTF-8`_ |

   ![The form is configured as described.](media/stream-analytics-add-blob-input-form.png "IoT Hub")

8. Select **Save**.

### Task 11: Stream Analytics (for weight sensors) output settings

1. Select **Outputs** on the left-hand menu, select **+ Add**, then select **Blob storage/ADLS Gen2** from the list.

    ![The blob storage/ADLS Gen2 option is highlighted.](media/stream-analytics-add-blob-output.png "Add storage output")

2. In the **Blob storage/ADLS Gen2** form, complete the following:

   | Field                          | Value                                              |
   | ------------------------------ | ------------------------------------------         |
   | Input alias                   | _enter `output`_              |
   | Storage account                 | _select `handsonretaildl + <unique suffix>`_                      |
   | Container           | _select `Use existing`, then select `shelfdata`_      |
   | Path pattern | _enter `tran/sensor/{datetime:yyyy}/{datetime:MM}/{datetime:dd}`_             |
   | Event serialization format | _select `JSON`_ |
   | Encoding | _select `UTF-8`_ |
   | Format | _select `Line separated`_ |
   | Minimum rows | _enter `100`_ |
   | Maximum time | _enter `1 minute`_ |
   | Authentication mode | _select `Connection string`_ |

   ![The form is configured as described.](media/stream-analytics-add-blob-sensor-output-form.png "IoT Hub")

3. Select **Save**.

### Task 12: Stream Analytics (for weight sensors) query settings

1. Select **Query** on the left-hand menu.

2. Enter the following query, then select **Save query**:

    ```sql
    SELECT
      [input].face_id
    , [input].shelf_id
    , [input].sensor_no
    , [input].date_time
    , [input].sensor_weight
    , [input].diff_weight
    , [rf-m-item].item_genre
    , [rf-m-item].item_name
    , [rf-m-item].item_price
    INTO
        [output]
    FROM
        [input] TIMESTAMP BY date_time
    JOIN
        [rf-m-item]
        ON [input].shelf_id = [rf-m-item].shelf_id
        AND [input].sensor_no = [rf-m-item].sensor_no
    ```

    ![The query is highlighted.](media/stream-analytics-query-sensor.png "Query")

3. Select **Overview** on the left-hand menu, then select **Start**.

    ![The start button is highlighted.](media/stream-analytics-start.png "Start")

4. Select **Now** for the job output start time, then select **Start**.

    ![The Start button is highlighted.](media/stream-analytics-sensor-start-now.png "Start job")

#### Additional information: Using reference data in Stream Analytics

Browse data stored in a SQL Database or Blob storage (including Azure Data Lake Storage Gen2) with Stream Analytics.

Imagine a use case where static or infrequently modified data is stored as reference data, which is combined with associated stream data from IoT devices.

The concept of this use is expressed in this hands-on training, as follows.

> ※ Direct output of Stream Analytics jobs at up to 200 MB/s to Azure Synapse dedicated SQL pools is now possible due to new Synapse features. In this scenario, you will output to the data lake.

![This diagram displays the smart shelf sending data to IoT Hub, which is ingested into Stream Analytics, transformed, and written to ADLS Gen2.](media/diagram-stream-analytics.png "Stream Analytics to ADLS Gen2 diagram")

**Stream data (weight sensor)**

| face_id | shelf_id | sensor_no | date_time | sensor_weight | diff_weight |
| --- | --- | --- | --- | --- | --- |
| XXX | **01** | **02** | XXX | XXX | XXX |

**Product master**

| shelf_id | sensor_no | item_genre | item_name | item_price |
| --- | --- | --- | --- | --- |
| **01** | **02** | Produce | Apple | 100 |

**Post-processing data** ※ *Combines stream data and product master with shelf_id and sensor_no as the keys*

| face_id | shelf_id | sensor_no | date_time | sensor_weight | diff_weight | item_genre | item_name | item_price |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| XXX | **01** | **02** | XXX |	XXX | XXX | Produce | Apple | 100 |

### Task 13: Prepare to send data

1. Log in to your lab VM.

2. Open Windows Explorer and navigate to **`C:\handson\program\`**.

3. Open **SendFaceData.js** in Notepad and replace the `connectionString` value between the single quotes (`'REPLACE-WITH-YOUR-CONNECTION-STRING'`) on **line 7** with the IoT device connection string that you copied in Task 4 (for AI camera).

    ![The connection string line is highlighted.](media/edit-sendfacedata.png "SendFaceData in Notepad")

4. **Save** the file.

5. Open **SendSensorData.js** in Notepad and replace the `connectionString` value between the single quotes (`'REPLACE-WITH-YOUR-CONNECTION-STRING'`) on **line 7** with the IoT device connection string that you copied in Task 6 (for weight sensor).

    ![The connection string line is highlighted.](media/edit-sendsensordata.png "SendFaceData in Notepad")

6. **Save** the file.

> **Connecting from an IoT device**
>
> Install IoT Hub Client (SDK) on the IoT device. Specify the connection string issued to the device when the device ID is registered via IoT Hub.
>
> ![The IoT Hub client is connected to the IoT device in IoT Hub, which sends data to Stream Analytics.](media/connect-device-iot-hub.png "Connect device to IoT Hub")

### Task 14: Send data

1. On your lab VM, open the **Command Prompt**. You can do this by clicking Start and entering `cmd` to find and select the Command Prompt app.

    ![The cmd search and Command Prompt result are both highlighted.](media/open-command-prompt.png "Open Command Prompt")

2. In the Command Prompt, execute `cd C:\handson\program` to change directories.

3. Install the required `azure-iot-device-mqtt` and `azure-iot-device` Node.js modules by executing the following command:

    ```cmd
    npm install
    ```

4. Send AI camera data by running the following command at the command prompt:

    ```cmd
    node SendFaceData.js
    ```

    In a few moments, the simulated IoT device will start sending telemetry to IoT Hub:

    ![The face data is being sent to IoT Hub.](media/cmd-sendfacedata.png "Command Prompt")

5. Allow the simulator to continue to run in the background. Open a **new Command Prompt** window.

6. In the new Command Prompt, execute `cd C:\handson\program` to change directories.

7. Send weight sensor data by running the following command at the command prompt:

    ```cmd
    node SendSensorData.js
    ```

    Just as happened in the other command prompt, the simulated IoT device will start sending telemetry to IoT Hub:

    ![The weight sensor data is being sent to IoT Hub.](media/cmd-sendsensordata.png "Command Prompt")

8. Allow the simulator to continue to run in the background while you continue the following steps.

### Task 15: Verify sent data

To verify that the IoT Hub devices are successfully retrieving the data, and that the Stream Analytics jobs are retrieving, processing, and writing the data to storage, perform the following steps:

1. Navigate to the `synapse-lab-retail` resource group. In the Azure portal, use the top search bar to search for `synapse-lab-retail`, then select the **synapse-lab-retail** resource group in the search results under **Resource Groups**.

    ![The synapse-lab-infrastructure search results are displayed.](media/search-resource-group.png "Search")

2. Within the resource group, select the ADLS Gen2 account you created in Task 2, named **`handsonretaildl` + `<unique suffix>`**.

    ![The handsonretaildl storage account is selected.](media/resource-group-dl.png "Storage account")

3. Select **Storage Explorer (preview)** in the left-hand menu **(1)**, expand Containers and select **shelfdata (2)**, then open the **tran** folder **(3)**. Verify that you see the **`face`** and **`sensor`** folders **(4)**. These are created by the two Stream Analytics jobs. If you don't see both folders, try refreshing the list after about a minute.

    ![The two folders are displayed in the tran folder.](media/datalake-tran-data.png "Storage Explorer")

4. Confirm that a JSON file has been created in the following folders in the data lake:

    - AI camera data: `shelfdata/tran/face/YYYY/MM//DD/`
    - Weight sensor data: `shelfdata/tran/sensor/YYYY/MM//DD/`

    ![The JSON file for face data is displayed.](media/datalake-face-data.png "Storage Explorer: face data")

    > ※ YYYY/MM/DD contains the current date.

## Exercise 3: Data aggregation

Time required: 40 minutes

In the data aggregation, after data collected in the data lake in various formats is processed with an ETL designed in the GUI, you will ingest it at high speed with distributed processing using Apache Spark and process it to the point where you create a data mart.

In this exercise, you will learn:

- **Apache Spark implementation**: Create a Synapse notebook within Synapse Studio, and implement data aggregation processing using Apache Spark.

- **Data flow construction**: Visually build an ETL pipeline in a code-free way in Synapse Studio to make subsequent processing of various data format files stored in the data lake easier.

- **Pipeline construction**: Build a data pipeline to periodically run a flow from data extraction, conversion, and loading to aggregation.

The diagram below shows the Synapse Studio elements that help us build the data pipeline:

![The diagram shows the Synapse Studio elements that help us build the data pipeline.](media/data-pipeline-diagram.png "Data pipeline creation diagram")
