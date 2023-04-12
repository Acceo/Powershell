<#
.SYNOPSIS
    Vérifie les pré-requis pour l'installation du capteur Microsoft Defender for Identity.

.DESCRIPTION
    Vérifie les pré-requis pour l'installation du capteur Microsoft Defender for Identity et doit être exécuter sur chacun des serveurs identifiés.

.PARAMETER $mdi_Tenant
    Le préfixe du nom du tenant .onmicrosoft.com. Pour le tenant 'montenant.onmicrosoft.com' le préfixe est 'montenant'.

.PARAMETER $tenant_Port
    Le port utilisé pour communiquer avec le service MDI du tenant (défaut à 443).

.PARAMETER $mdi_Port
    Le port utilisé pour communiquer avec le service local de mise à jour du capteur (défaut à 444).

.EXAMPLE
    Get-MDICompatibilityStatus.ps1 -mdi_Tenant "monTenant"

.EXAMPLE
    Get-MDICompatibilityStatus.ps1 -mdi_Tenant "monTenant" -Min_NetFramework 461308

.LINK
    Ref: https://github.com/PhxDesign/Powershell/tree/main/M365/Defender

.LINK
    Ref: https://learn.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed#minimum-version

.NOTES
    Version:        1.1
    Creation Date:  31 mars 2023
    Last Updated:   12 avril 2023
    Author:         Jean-Luc Gauthier
    Organization:   Phoenix Design
    Contact:        S/O
    Web Site:       S/O
#>

# Parameters definition
param (
    [Parameter(Mandatory = $true, HelpMessage = 'Inscriver le nom du prefixe de votre tenant .onmicrosot.com, ex: monTenant')]
    [string] $mdi_Tenant,
    [Parameter(Mandatory = $false, HelpMessage = 'Inscrivez le port de communication au service MDI (defaut 443)')]
    [string] $tenant_Port = 443,
    [Parameter(Mandatory = $false, HelpMessage = 'Inscrivez le port de communication pour le service de mise à jour du capteur (defaut 444)')]
    [string] $mdi_Port = 444,
    [Parameter(Mandatory = $false, HelpMessage = 'Inscrivez le no de la version minimum du .Net Framework')]
    [int] $min_NetFramework = 528040
)

function Get-NetFrameworkVersion {
    [int](Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release)
}

function Test-MDITenant {
    # Test DNS Resolution
    $mdi_Tenant = $mdi_Tenant+"sensorapi.atp.azure.com"
    if (Resolve-DnsName -Name $mdi_Tenant) {
        Write-Host "Resolution DNS effectuee pour $mdi_Tenant" -f Green

        # Test network connection from the MDI Connector to the cloud tenant.
        if (Test-NetConnection -Computer $mdi_Tenant -Port $Tenant_Port) {
            Write-Host "Connexion https etablie pour $mdi_Tenant" -f Green
        }
        else {
            Write-Warning "Impossible de communiquer avec le tenant $mdi_Tenant sur le port $Tenant_Port"
        }
    }
    else {
        Write-Warning "Probleme de resolution DNS pour le domaine $mdi_Tenant"
    }
}

function Test-MDILocalServiceUpdate {
    # Test local captor update service
    Test-NetConnection -ComputerName localhost -Port $mdi_Port444
}

# Main script block

# Check minimum requierments
$inst_NetFramework = Get-NetFrameworkVersion
if ( $inst_NetFramework -gt $min_NetFramework) {
    Write-Host "La version .Net Framework est supportée" -f Green
}
else {
    Write-Warning "La version du .Net Framwork n'est pas à jour (minimum 4.8)"
}
Test-MDITenant

#
if (get-package | where name -like "Microsoft Defender pour Identity Sensor*") {
    Test-MDILocalServiceUpdate
}
