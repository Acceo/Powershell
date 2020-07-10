###################################################
# Phoenix Design
# Description: Get Microsoft 365 group members
# By: Jean Luc Gauthier
# Created: 30/06/2020
# Requiered module(s): MsOnline
# Optional: 
###################################################

# Define parameters
# $Group Source group name
# $GroupMembers List of group members

param(
    [Parameter(Mandatory=$True, HelpMessage="Description:")]
	[string]$Group,
    [Parameter(Mandatory=$False, HelpMessage="Description:")]
	[string]$GroupMembers
	)

    # Default status message colors
$ErrMsgColor = @{BackgroundColor="Red";ForegroundColor="White"}
$SuccesMsgColor = @{BackgroundColor="Green";ForegroundColor="Black"}

# Check variables
function VarCheck {
    
    # Description
    if ([string]::IsNullOrEmpty($Group)) {
        Read-Host "Enter the group name:"
    }
}

# Function description
function GetGroupMembers {
    
    try{
        $Group = Get-MsolGroup -SearchString $Group
    }
    Catch {
        Write-Host "Unable to retrive the group" $Group.DisplayName". Error detected: $_" @ErrMsgColor
        Break
    }
    Write-Host "Group" $Group.DisplayName "found. Getting users status." @SuccesMsgColor
    $GroupMembers = Get-MsolGroupMember -GroupObjectId $Group.ObjectId | ForEach-Object {get-msoluser -userprincipalname $_.EmailAddress} | select-object UserPrincipalName,DisplayName,Office,StreetAddress,City,Department,IsLicensed,@{n="Status"; e={($_.StrongAuthenticationRequirements.State)}},@{n="Methods"; e={($_.StrongAuthenticationMethods.MethodType) -join ','}},LastPasswordChangeTimestamp,ObjectId
    $GroupMembers | Export-Excel -Show
} 
 
# Main Script Block
VarCheck
GetGroupMembers