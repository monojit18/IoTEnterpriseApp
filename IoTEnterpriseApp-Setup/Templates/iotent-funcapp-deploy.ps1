param([Parameter(Mandatory=$false)] [string] $rg = "<resource_group>",
      [Parameter(Mandatory=$false)] [string] $fpath = "<folder_path>",
      [Parameter(Mandatory=$false)] [string] $httpfuncAppName = "<httpfuncApp_Name>",
      [Parameter(Mandatory=$false)] [string] $senderfuncAppName = "<senderfuncApp_Name>",
      [Parameter(Mandatory=$false)] [string] $receiverfuncAppName = "<receiverfuncApp_Name>",
      [Parameter(Mandatory=$false)] [string] $storageAccountName = "<storageAccount_Name>")

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $httpfuncAppName `
-storageAccountName $storageAccountName

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $senderfuncAppName `
-storageAccountName $storageAccountName

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $receiverfuncAppName `
-storageAccountName $storageAccountName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $httpfuncAppName `
-storageAccountName $storageAccountName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $senderfuncAppName `
-storageAccountName $storageAccountName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-funcapp-deploy.json" `
-appName $receiverfuncAppName `
-storageAccountName $storageAccountName

