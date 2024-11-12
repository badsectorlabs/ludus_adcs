param(
    [Parameter(Mandatory=$true)]
    [string]$esc13group
)

# Get DistinguishedNames
$entAdminsDN = (Get-ADGroup -Identity 'Enterprise Admins').DistinguishedName
$esc13groupDN = (Get-ADGroup -Identity $esc13group).DistinguishedName

#Add GenericAll rights over Enterprise Admins to the esc13group
dsacls "$entAdminsDN" /G "$esc13groupDN"":GA"
