# TelepathyDeploy
ARM template for telepathy deployment.

## Deploy in Azure Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FBabysbreathJJ%2FTelepathyDeploy%2Fmaster%2Fazuredeploy.json" target="_blank">
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