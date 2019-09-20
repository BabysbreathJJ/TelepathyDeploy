# TelepathyDeploy
ARM template for telepathy deployment.

## Deploy using script
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