######################################################################
# Phoenix Design
# Description: Get Azure Sentinel Alert Rules
# Author: Jean Luc Gauthier
# Created: 06/07/2020
# Module Required: AzureAD
# Optional: 
######################################################################

# Define parameters
# $WSName - Name of the workspace

# Default status message colors
$ErrMsgColor = @{BackgroundColor="Red";ForegroundColor="White"}
$SuccesMsgColor = @{BackgroundColor="Green";ForegroundColor="Black"}


Function ModuleCheck{
    if (Get-Module -ListAvailable -Name AzureAd) {
        Write-Host "Le module Powershell pour Azure est installé." @SuccesMsgColor
    } else {
        Write-Host "Le module Powershell pour Azure est requis, nous essayons de l'installer" @SuccesMsgColor
        Try {
            Install-Module AzureAd -Force -AllowClobber
            Import-Module AzureAd
        }
        Catch{
            Write-Host "Impossible d'installer le module Powershell Azure" @ErrMsgColor
            Break
        }
    }

    if (Get-Module -ListAvailable -Name AzSentinel) {
        Write-Host "Le module Powershell pour Azure Sentinel est installé." @SuccesMsgColor
    } else {
        Write-Host "Le module Powershell pour Azure Sentinel est requis, nous essayons de l'installer" @SuccesMsgColor
        Try {
            Install-Module AzSentinel -Force -AllowClobber
            Import-Module AzSentinel
        }
        Catch{
            Write-Host "Impossible d'installer le module Powershell Azure" @ErrMsgColor
            Break
        }
    }
}

# Function to get all Azure Sentinel Rules
function GetSentinelRules {
    try {
        Get-AzSentinelAlertRule -WorkspaceName sec-ops-main-la | Select-Object displayname, description, severity, tactics, enabled | Out-GridView
    }
    catch {
        Write-Host "Unable to get rules list. Error detected: $_" @ErrMsgColor
    }
    
}

# Main block
ModuleCheck

# Ask for the Sentinel workspace name
If ($Null -eq $WSName) {
  $WSName = Read-Host "Enter the workspace name:"
}

GetSentinelRules