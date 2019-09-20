# TelepathyDeploy
ARM template for telepathy deployment.

## Deploy in Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/BabysbreathJJ/TelepathyDeploy/master/azuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

## Deploy using Azure CLI
```shell
[ "$(az group exists -n ResourceGroupName)" = "true" ] && az group delete -n  ResourceGroupName -y
az group create --name ResourceGroupName --location "japaneast" --subscription subscriptionName
az group deployment create `
  --name DeployementName `
  --resource-group ResourceGroupName `
  --subscription subscriptionName `
  --template-file  "location of template file" `
  --parameters "location of parameters.json file"
```

## Deploy using Powershell
```shell
$ResourceGroupName = ""
$Location = ""
$TemplateFile = ""
$TemplateParameterFile = ""

Connect-AzAccount
if(Get-AzResourceGroup -Name $ResourceGroupName) {
    Remove-AzResourceGroup -Name $ResourceGroupName -Force
}

New-AzResourceGroup -Name $ResourceGroupName -Location $Location
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile

```

[ "$(az group exists -n TestTelepathy)" = "true" ] && az group delete -n  TestTelepathy -y
az group create --name TestTelepathy --location "japaneast" --subscription BigCompS-Int2
az group deployment create --name TestTelepathy --resource-group TestTelepathy --subscription BigCompS-Int2 --template-file  "D:\github\TelepathyDeploy\TelepathyDeploy\azuredeploy.json" --parameters "D:\github\TelepathyDeploy\TelepathyDeploy\azuredeploy.parameters.json"