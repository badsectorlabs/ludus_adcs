param(
    [Parameter(Mandatory=$true)]
    [string]$esc16user
)

# Get DistinguishedNames
$domainUsersDN = (Get-ADGroup -Filter "*" | Where-Object {$_.SID -like "*-513"}).DistinguishedName
$esc16userDN = (Get-ADUser -Identity $esc16user).DistinguishedName

#Add GenericAll rights over the esc16user to the Domain Users group
dsacls "$esc16userDN" /G "$domainUsersDN"":GA"
