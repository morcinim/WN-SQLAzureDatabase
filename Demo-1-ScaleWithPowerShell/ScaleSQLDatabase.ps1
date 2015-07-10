
# http://azure.microsoft.com/blog/2013/02/07/windows-azure-sql-database-management-with-powershell/
function Scale-Database {
    [CmdletBinding()]
    param (
        [string]$sqlserverName = 'gpsesv12',
        [string]$serviceLevel ='S0',
        [string]$databaseName ='AdventureWorks2012'
        
    )
    $server = Get-AzureSqlDatabaseServer -ServerName $sqlserverName

    $servercredential = new-object System.Management.Automation.PSCredential("morcinim", ("[your password]"  | ConvertTo-SecureString -asPlainText -Force))
    $ctx = $server | New-AzureSqlDatabaseServerContext -Credential $serverCredential

    #find server objective to scale to
    $so = Get-AzureSqlDatabaseServiceObjective -Context $ctx | where {$_.Name -eq $serviceLevel }

    # find database on server
    $db = Get-AzureSqlDatabase $ctx | where {$_.Name -eq $databaseName}

    Set-AzureSqlDatabase $ctx $db -ServiceObjective $so -Force
    Write-Host $databaseName   "scale request to performance level "  $so.Name
}


# Login to subscription using Azure Active Directory credentials 
Add-AzureAccount


$subscriptionName = "AzureMSDN"
$azurelocation = "West Europe"
Select-AzureSubscription -SubscriptionName $subscriptionName


$server ='gpsesv12'
$dbName = 'AdventureWorks2012'
Scale-Database -sqlserverName $server -serviceLevel 'S0' -databaseName $dbName
Get-AzureSqlDatabase -ServerName $server -DatabaseName $dbName