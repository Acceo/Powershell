###################################################
# Phoenix Design
# Description: Get Onedrive Personal site list from the tenant in a csv file
# By: Jean Luc Gauthier
# Created: 22/01/2020
# Requiered module(s): MsOnline
# Optional: 
###################################################

# Define parameters
# $AdminSiteURL is the default tenant admin Sharepoint site
# $OneDriveSites regroup the list of Sharepoint sites
# $Results get all the personal Ondrive URLs list

param(
	[Parameter(Mandatory=$True, HelpMessage="Enter the Sharepoint tenant URL, ex: https://maintenant-admin.sharepoint.com:")]
	[string]$AdminSiteURL
	)

# Default status message colors
$ErrMsgColor = @{BackgroundColor="Red";ForegroundColor="White"}
$SuccesMsgColor = @{BackgroundColor="Green";ForegroundColor="Black"}
 
#Connect to SharePoint Online Admin Center
Connect-SPOService -Url $AdminSiteURL
 
#Get all Personal Site collections and export to a Text file
$OneDriveSites = Get-SPOSite -Template "SPSPERS" -Limit ALL -includepersonalsite $True
 
$Result=@()
# Get storage quota of each site
Foreach($Site in $OneDriveSites)
{
	$Result += New-Object PSObject -property @{
	URL = $Site.URL
	Owner= $Site.Owner
	#Size_inMB = $Site.StorageUsageCurrent
	StorageQuota_inGB = $Site.StorageQuota/1024
	}
}
 
$Result | Format-Table
 
#Export the data to CSV
$Result | Export-Csv "OneDrive.csv" -Encoding UTF8 -NoTypeInformation