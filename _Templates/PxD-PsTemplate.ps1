###################################################
# Phoenix Design Global Powershell Script Template
# Description: 
# By: 
# Created: 
# Requiered module(s): 
# Optional: 
###################################################

# Define parameters
# $Var1Mode Descriptions
# $Var2 Description

param(
	[Parameter(Mandatory=$True, HelpMessage="Description:")]
	[string]$Var1,
	[Parameter(Mandatory=$False, HelpMessage="Description:")]
	[string]$Var2
	)

	# Default status message colors
$ErrMsgColor = @{BackgroundColor="Red";ForegroundColor="White"}
$SuccesMsgColor = @{BackgroundColor="Green";ForegroundColor="Black"}

# Check variables
function VarCheck1 {
	
	# Description
	if ($Var1 -eq '') {
		$Var1 = Read-Host "Question:"
		}
	
	# Switch block for the mode type
	Switch ($Var2) {
		"All" {Write-Host "Description: $Var2." @SuccesMsgColor}
		"Group" {Write-Host "Description: $Var2Mode." @SuccesMsgColor}
		default {Write-Host "Wrong mode type: $Var2." @ErrMsgColor;Exit 1}
		}
}

# Function description
function myFunction1 {

			Try {
				
			}  
			Catch {

				Write-Host "Message." @ErrMsgColor
			}
			Write-Host "Message." @SuccesMsgColor
	
	if (0 -lt $UsersList.count) {
		#some code    
	}
	else {
		#other code
	}
	
}

# Main Script Block
VarCheck1

# Check exit code and break if invalide switch
If ($chechvalue)  {
	#some code
}
myFunction1