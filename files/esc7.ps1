param(
    [Parameter(Mandatory=$true)]
    [string]$caManagerUser,
    
    [Parameter(Mandatory=$true)]
    [string]$certManagerUser
)

# Import PSPKI module
Import-Module -Name PSPKI

# Store CA hostname
$caHostname = Get-CertificationAuthority | Select-Object -ExpandProperty ComputerName

# Give ManageCA rights to the CA manager user
Get-CertificationAuthority "$caHostname" | Get-CertificationAuthorityAcl | Add-CertificationAuthorityAcl -Identity "$caManagerUser" -AccessType "Allow" -AccessMask "ManageCa" | Set-CertificationAuthorityAcl -RestartCA

# Give ManageCertificates rights to the certificate manager user
Get-CertificationAuthority "$caHostname" | Get-CertificationAuthorityAcl | Add-CertificationAuthorityAcl -Identity "$certManagerUser" -AccessType "Allow" -AccessMask "ManageCertificates" | Set-CertificationAuthorityAcl -RestartCA
