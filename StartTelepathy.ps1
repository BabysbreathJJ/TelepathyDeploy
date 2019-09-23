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
    [string]$SrcStorageContainerSasToken,
    [string]$DesStorageAccountName,
    [string]$DesStorageAccountKey,
    [string]$BatchAccountKey
)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -Force
$destination_path = "C:\telepathy"
Try {
    $srcStorageContext = New-AzStorageContext -StorageAccountName $SrcStorageAccountName -SasToken $SrcStorageContainerSasToken
    Write-Host "StorageAccountName : $SrcStorageAccountName"
    Write-Host "StorageSasToken : $SrcStorageContainerSasToken"
} Catch {
    Write-Host "Please provide valid storage account name and sas token"
    Write-Host $_
}

Try {
    Write-Host "ContainerName : $ContainerName"
    Write-Host "ArtifactsFolderName : $ArtifactsFolderName"
    $blobs = Get-AzStorageBlob -Container $ContainerName -Blob "$ArtifactsFolderName*" -Context $srcStorageContext
} Catch {
    Write-Host "Error occurs when get source storage blob, can't get storage blob, please confirm you provide valid container name, blob name and storage context "
    Write-Host $_
}

Try {
    Write-Host "DestinationPath in VM : $destination_path"
    foreach($blob in $blobs) {  
        New-Item -ItemType Directory -Force -Path $destination_path  
        Get-AzStorageBlobContent -Container $ContainerName -Blob $blob.Name -Destination $destination_path -Context $srcStorageContext   
    } 
} Catch {
    Write-Host "Error occurs when download source storage blob to VM "
    Write-Host $_
}

$artifactsPath = "$destination_path\$ArtifactsFolderName\Release"
$desStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$DesStorageAccountName;AccountKey=$DesStorageAccountKey;EndpointSuffix=core.windows.net"
$batchServiceUrl = "https://$BatchAccountName.$Location.batch.azure.com"
if($EnableTelepathyStorage) {
    invoke-expression "$artifactsPath\EnableTelepathyStorage.ps1 -DestinationPath $artifactsPath -DesStorageConnectionString '$DesStorageConnectionString'"
}

if($StartSessionLauncher) {
    invoke-expression "$artifactsPath\StartSessionLauncher.ps1 -DestinationPath $artifactsPath -DesStorageConnectionString '$DesStorageConnectionString' -BatchAccountName $BatchAccountName -BatchPoolName $BatchPoolName -BatchAccountKey $BatchAccountKey -BatchAccountServiceUrl $batchServiceUrl"
}