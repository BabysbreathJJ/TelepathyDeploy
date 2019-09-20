# TelepathyDeploy
ARM template for telepathy deployment.

## Deploy using Azure CLI
```shell
[ "$(az group exists -n ResourceGroupName)" = "true" ] && az group delete -n  ResourceGroupName -y
az group create --name ResourceGroupName --location "japaneast"
az group deployment create `
  --name DeployementName `
  --resource-group ResourceGroupName `
  --template-file  "location of template file" `
  --parameters "location of parameters.json file"
```

## Deploy using Powershell
```shell

```

[ "$(az group exists -n TestTelepathy)" = "true" ] && az group delete -n  TestTelepathy -y
az group create --name TestTelepathy --location "japaneast"
az group deployment create --name TestTelepathy --resource-group TestTelepathy --template-file  "D:\github\TelepathyDeploy\TelepathyDeploy\azuredeploy.json" --parameters "D:\github\TelepathyDeploy\TelepathyDeploy\azuredeploy.parameters.json"