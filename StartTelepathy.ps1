<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [switch]$EnableTelepathyStorage,
    [switch]$StartSessionLauncher,
    [string]$Location,
    [string]$BatchAccountName,
    [string]$BatchPoolName,
    [string]$ArtifactsFolderName,
    [string]$ContainerName,
    [string]$SrcStorageAccountName,
    [string]$SrcStorageAccountKey,
    [string]$DesStorageAccountName,
    [string]$DesStorageAccountKey,
    [string]$BatchAccountKey
)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -Force
$destination_path = "C:\telepathy"
$srcStorageContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName -StorageAccountKey $srcStorageAccountKey
$blobs = Get-AzStorageBlob -Container $containerName -Blob "$artifactsFolderName*" -Context $srcStorageContext
foreach($blob in $blobs) {  
    New-Item -ItemType Directory -Force -Path $destination_path  
    Get-AzStorageBlobContent -Container $containerName -Blob $blob.Name -Destination $destination_path -Context $srcStorageContext   
} 

$artifactsPath = "$destination_path\$artifactsFolderName\Release"
$desStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$desStorageAccountName;AccountKey=$desStorageAccountKey;EndpointSuffix=core.windows.net"
$batchServiceUrl = "https://$BatchAccountName.$location.batch.azure.com"
if($EnableTelepathyStorage) {
    invoke-expression "$artifactsPath\EnableTelepathyStorage.ps1 -DestinationPath $artifactsPath -DesStorageConnectionString '$desStorageConnectionString'"
}

if($StartSessionLauncher) {
    invoke-expression "$artifactsPath\StartSessionLauncher.ps1 -DestinationPath $artifactsPath -DesStorageConnectionString '$desStorageConnectionString' -BatchAccountName $BatchAccountName -BatchPoolName $BatchPoolName -BatchAccountKey $BatchAccountKey -BatchAccountServiceUrl $batchServiceUrl"
}