param(
    [Parameter(Mandatory=$true)]
    [string]$esc9user
)

# Get DistinguishedNames
$domainUsersDN = (Get-ADGroup -Identity "$((Get-ADDomain).DomainSID)-513").DistinguishedName
$esc9userDN = (Get-ADUser -Identity $esc9user).DistinguishedName

#Add GenericAll rights over the esc9user to the Domain Users group
dsacls "$esc9userDN" /G "$domainUsersDN"":GA"
