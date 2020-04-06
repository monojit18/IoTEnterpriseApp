param([Parameter(Mandatory=$false)] [string] $rg = "<resource_group>",
        [Parameter(Mandatory=$false)] [string] $fpath = "<fpath>",
        [Parameter(Mandatory=$false)] [string] $keyVaultName = "<key_vault_name>",
        [Parameter(Mandatory=$false)] [string] $objectId = "<object_id>")

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-keyvault-deploy.json" `
-keyVaultName $keyVaultName -objectId $objectId

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-keyvault-deploy.json" `
-keyVaultName $keyVaultName -objectId $objectId