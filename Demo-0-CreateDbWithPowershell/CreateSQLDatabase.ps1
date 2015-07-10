
Set-ExecutionPolicy RemoteSigned
# Connecting to subscription see: 
# http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell

// import azure commandlets
import-module azure


# Login to subscription using Azure Active Directory credentials 
Add-AzureAccount

# List suscriptions where we have access
Get-AzureSubscription


$subscriptionName = "AzureMSDN"
$azurelocation = "West Europe"
Select-AzureSubscription -SubscriptionName $subscriptionName
#Set-AzureSubscription -SubscriptionName $subscriptionName 

# http://azure.microsoft.com/blog/2013/02/07/windows-azure-sql-database-management-with-powershell/


 #list servers
 $server = Get-AzureSqlDatabaseServer -ServerName we-demo

 #create new SQL database server (1 min)
 # $server = New-AzureSqlDatabaseServer -Location "North Europe" -Version 12 -AdministratorLogin "demouser" -AdministratorLoginPassword "demo@pass1"


 $server =  Get-AzureSqlDatabaseServer
 $sqlserverName= $server.ServerName

# set firewall rule on the server
$server | New-AzureSqlDatabaseServerFirewallRule -RuleName "AllowAny" -StartIpAddress 0.0.0.0 -EndIpAddress 255.255.255.255

# Check the firewall rules again 
$server  | Get-AzureSqlDatabaseServerFirewallRule 


# Connect to the server using Sql Authentication - requires firewall to be opened on IP address
#
$servercredential = new-object System.Management.Automation.PSCredential("morcinim", ("RedW1ne!"  | ConvertTo-SecureString -asPlainText -Force))
$ctx = $server | New-AzureSqlDatabaseServerContext -Credential $serverCredential

# List all databases in server
#
Get-AzureSqlDatabase $ctx 

#List all the sevice objectives for server
Get-AzureSqlDatabaseServiceObjective -Context $ctx

# Create a new database of in Basic Tier (15sec)
$db = New-AzureSqlDatabase $ctx -DatabaseName Demo -Edition Basic 

# Show databases
Get-AzureSqlDatabase $ctx

# Get service objectives and select Standard "S0" 
$serviceTiers = Get-AzureSqlDatabaseServiceObjective -Context $ctx
$serviceObjective = $serviceTiers | where {$_.Name -eq "S0"}
$serviceObjective

# Change database maximum size -changing Service tier causes popup
#service objective must match the edition

Set-AzureSqlDatabase $ctx $db -MaxSizeGB 50 -ServiceObjective $serviceObjective

# use Force switch to avoid price popup
Set-AzureSqlDatabase $ctx $db -MaxSizeGB 50 -ServiceObjective $serviceObjective -Force


Get-AzureSqlDatabase $ctx

# Remove the database

# use Force switch to avoid warning
$db | Remove-AzureSqlDatabase

# Remove the server
#
$server | Remove-AzureSqlDatabaseServer