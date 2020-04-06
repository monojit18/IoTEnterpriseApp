param([Parameter(Mandatory=$false)] [string] $resourceGroup = "serverless-workshop-rg",
      [Parameter(Mandatory=$false)] [string] $subscriptionId = "6bdcc705-8db6-4029-953a-e749070e6db6",
      [Parameter(Mandatory=$false)] [string] $baseFolderPath = "/Users/monojitdattams/Development/Projects/Serverless_Projects/C#_Sources/IoTEnterpriseApp/IoTEnterpriseApp-Setup",
      [Parameter(Mandatory=$false)] [string] $keyVaultname = "serverless-iothub-kv",
      [Parameter(Mandatory=$false)] [string] $objectId = "890c52c5-d318-4185-a548-e07827190ff6",
      [Parameter(Mandatory=$false)] [string] $iotHubName = "serverless-iot-hub",
      [Parameter(Mandatory=$false)] [string] $iotHubConsumerGroupName = "serverless-iothub-cg",
      [Parameter(Mandatory=$false)] [string] $httpfuncAppName = "IoTHttpApp",
      [Parameter(Mandatory=$false)] [string] $senderfuncAppName = "IoTSenderApp",
      [Parameter(Mandatory=$false)] [string] $receiverfuncAppName = "IoTReceiverApp",
      [Parameter(Mandatory=$false)] [string] $eventHubNamespaceName = "serverless-eventhub-ns",
      [Parameter(Mandatory=$false)] [string] $eventHubName = "serverless-eventhub",
      [Parameter(Mandatory=$false)] [string] $eventHubConsumerGroupName = "serverless-eventhub-cg",
      [Parameter(Mandatory=$false)] [string] $storageAccountName = "srvlswkstorage")

$templatesFolderPath = $baseFolderPath + "/Templates"
$keyvaultDeployCommand = "/iotent-keyvault-deploy.ps1 -rg $resourceGroup -fpath $templatesFolderPath -keyVaultName $keyVaultName -objectId $objectId"
$iotHubDeployCommand = "/iotent-iothub-deploy.ps1 -rg $resourceGroup -fpath $templatesFolderPath -iotHubName $iotHubName -iotHubConsumerGroupName $iotHubConsumerGroupName"
$functionDeployCommand = "/iotent-funcapp-deploy.ps1 -rg $resourceGroup -fpath $templatesFolderPath -httpfuncAppName $httpfuncAppName -senderfuncAppName $senderfuncAppName -receiverfuncAppName $receiverfuncAppName -storageAccountName $storageAccountName"
$eventHubDeployCommand = "/iotent-eventhub-deploy.ps1 -rg $resourceGroup -fpath $templatesFolderPath -eventHubNamespaceName $eventHubNamespaceName -eventHubName $eventHubName -eventHubConsumerGroupName $eventHubConsumerGroupName"

# # PS Logout
# Disconnect-AzAccount

# # PS Login
# Connect-AzAccount

# PS Select Subscriotion 
Select-AzSubscription -SubscriptionId $subscriptionId

#  KeyVault deploy
$keyvaultDeployPath = $templatesFolderPath + $keyvaultDeployCommand
Invoke-Expression -Command $keyvaultDeployPath

#Keys List for holding various Keys...to be dsaved in KeyVault
$keysList = New-Object -TypeName System.Collections.ArrayList

#  IoTHub deploy
$iotHubDeployPath = $templatesFolderPath + $iotHubDeployCommand
$iotHubOutput = Invoke-Expression -Command $iotHubDeployPath

# Get IotHub Keys
$outputKeys = $iotHubOutput[1].Outputs.Keys

# Get IotHub Values
$outputValues = $iotHubOutput[1].Outputs.Values

foreach ($item in $outputKeys)
{
      $keysList.Add($item)
}

$index = 0;
foreach ($item in $outputValues)
{
      
      $iotHubConnectionKey = $keysList[$index]
      $iotHubConnectionString = $item.Value

      $iotHubConnectionKeyObject = ConvertTo-SecureString `
      -String $iotHubConnectionString -AsPlainText -Force

      # Save into KeyVault
      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $iotHubConnectionKey `
      -SecretValue $iotHubConnectionKeyObject

      ++$index
}

# Clean up KeysList..to be used later
$keysList.Clear();

#  Function Apps deploy
$functionDeployPath = $templatesFolderPath + $functionDeployCommand
Invoke-Expression -Command $functionDeployPath

#  Event Hub deploy
$eventHubDeployPath = $templatesFolderPath + $eventHubDeployCommand
Invoke-Expression -Command $eventHubDeployPath
$eventHubOutput = Invoke-Expression -Command $eventHubDeployPath

# Get EventHub Keys
$outputKeys = $eventHubOutput[1].Outputs.Keys

# Get EventHub Values
$outputValues = $eventHubOutput[1].Outputs.Values

foreach ($item in $outputKeys)
{
      $keysList.Add($item)
}

$index = 0;
foreach ($item in $outputValues)
{
      
      $eventHubConnectionKey = $keysList[$index]
      $eventHubConnectionString = $item.Value

      $eventHubonnectionKeyObject = ConvertTo-SecureString `
      -String $eventHubConnectionString -AsPlainText -Force

      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $eventHubConnectionKey `
      -SecretValue $eventHubonnectionKeyObject

      ++$index
}

# Clean up KeysList
$keysList.Clear();

Write-Host "Setup All Done"

