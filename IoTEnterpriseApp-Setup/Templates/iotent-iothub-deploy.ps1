param([Parameter(Mandatory=$false)] [string] $rg = "<resource_group>",
      [Parameter(Mandatory=$false)] [string] $fpath = "<folder_path>",
      [Parameter(Mandatory=$false)] [string] $iotHubName = "<iotHub_Name>",
      [Parameter(Mandatory=$false)] [string] $iotHubConsumerGroupName = "<iotHubConsumerGroup_Name>")

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-iothub-deploy.json" `
-iotHubName $iotHubName -consumerGroupName $iotHubConsumerGroupName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-iothub-deploy.json" `
-iotHubName $iotHubName -consumerGroupName $iotHubConsumerGroupName
