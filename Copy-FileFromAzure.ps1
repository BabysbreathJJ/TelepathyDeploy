<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
    [string]$Location,
    [string]$BatchAccountName,
    [string]$BatchPoolName
    [string]$ArtifactsFolderName,
    [string]$ContainerName,
    [string]$SrcStorageAccountName,
    [string]$SrcStorageAccountKey,
    [string]$DesStorageAccountName,
    [string]$DesStorageAccountKey
)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -Force
$destination_path = "C:\telepathy"
$srcStorageContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName -StorageAccountKey $srcStorageAccountKey
$desStorageContext = New-AzStorageContext -StorageAccountName $desStorageAccountName -StorageAccountKey $desStorageAccountKey
$blobs = Get-AzStorageBlob -Container $containerName -Blob "$artifactsFolderName*" -Context $srcStorageContext
foreach($blob in $blobs) {  
    New-Item -ItemType Directory -Force -Path $destination_path  
    Get-AzStorageBlobContent -Container $containerName -Blob $blob.Name -Destination $destination_path -Context $srcStorageContext   
} 

"runtime service-assembly service-registration".split() | New-AzStorageContainer -Context $desStorageContext

function uploadFiles{
    param($LocalPath, $RemotePath, $ContainerName, $StorageContext)
    $files = Get-childItem $localPath
    foreach($file in $files)
    {
        $localFile = "$localPath\$file"
        if($RemotePath) {
            $remoteFile= "$remotePath/$file"
        }
        else {
            $remoteFile= "$file"
        }
        
        if(-not $file.PSIsContainer) {
            Set-AzStorageBlobContent -File $localFile -Blob $remoteFile -Container $ContainerName -Context $StorageContext -Force
        }
        else {
            uploadFiles -LocalPath $localFile -RemotePath $remoteFile -ContainerName $containerName -StorageContext $storageContext 
        }
        
    }
}

uploadFiles -LocalPath "$destination_path\$artifactsFolderName\Release\CcpServiceHost" -RemotePath "ccpservicehost" -ContainerName "runtime" -StorageContext $desStorageContext
uploadFiles -LocalPath "$destination_path\$artifactsFolderName\Release\EchoSvcLib" -RemotePath "ccpechosvc" -ContainerName "service-assembly" -StorageContext $desStorageContext
uploadFiles -LocalPath "$destination_path\$artifactsFolderName\Release\Registration"  -ContainerName "service-registration" -StorageContext $desStorageContext

$desStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=$desStorageAccountName;AccountKey=$desStorageAccountKey;EndpointSuffix=core.windows.net"
$batchAccountKey = Get-AzBatchAccountKeys –AccountName $BatchAccountName
$batchServiceUrl = "https://$BatchAccountName.$location.batch.azure.com"

 Write-Verbose $desStorageConnectionString
 Write-Verbose $batchAccountKey
 Write-Verbose $batchServiceUrl