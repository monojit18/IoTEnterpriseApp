param([Parameter(Mandatory=$false)] [string] $rg = "<resource_group>",
      [Parameter(Mandatory=$false)] [string] $fpath = "<folder_path>",
      [Parameter(Mandatory=$false)] [string] $eventHubNamespaceName = "<eventHubNamespace_Name>",
      [Parameter(Mandatory=$false)] [string] $eventHubName = "<eventHub_Name>",
      [Parameter(Mandatory=$false)] [string] $eventHubConsumerGroupName = "<eventHubConsumerGroup_Name>")

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-eventhub-deploy.json" `
-eventHubNamespaceName $eventHubNamespaceName `
-eventHubName $eventHubName `
-consumerGroupName $eventHubConsumerGroupName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-eventhub-deploy.json" `
-eventHubNamespaceName $eventHubNamespaceName `
-eventHubName $eventHubName `
-consumerGroupName $eventHubConsumerGroupName
