param([Parameter(Mandatory=$false)] [string] $rg = "serverless-workshop-rg",
        [Parameter(Mandatory=$false)] [string] $fpath = "/Users/monojitdattams/Development/Projects/Serverless_Projects/C#_Sources/IoTEnterpriseApp/IoTEnterpriseApp-Setup/Templates",
        [Parameter(Mandatory=$false)] [string] $srvlsVNetName = "serverless-workshop-vnet",
        [Parameter(Mandatory=$false)] [string] $iotSubnetName = "iot-workshop-subnet",
        [Parameter(Mandatory=$false)] [string] $ehubSubnetName = "ehub-workshop-subnet",        
        [Parameter(Mandatory=$false)] [string] $sendFuncSubnetName = "send-func-workshop-subnet",
        [Parameter(Mandatory=$false)] [string] $receiveFuncSubnetName = "receive-func-workshop-subnet",
        [Parameter(Mandatory=$false)] [string] $httpFuncSubnetName = "http-func-workshop-subnet")

Test-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-network-deploy.json" `
-srvlsVNetName $srvlsVNetName `
-iotSubnetName $iotSubnetName `
-ehubSubnetName $ehubSubnetName `
-sendFuncSubnetName $sendFuncSubnetName `
-receiveFuncSubnetName $receiveFuncSubnetName `
-httpFuncSubnetName $httpFuncSubnetName

New-AzResourceGroupDeployment -ResourceGroupName $rg `
-TemplateFile "$fpath/iotent-network-deploy.json" `
-srvlsVNetName $srvlsVNetName `
-iotSubnetName $iotSubnetName `
-ehubSubnetName $ehubSubnetName `
-sendFuncSubnetName $sendFuncSubnetName `
-receiveFuncSubnetName $receiveFuncSubnetName `
-httpFuncSubnetName $httpFuncSubnetName