param(
    [Parameter(Mandatory=$true)]
    [string]$esc10user
)

# Get DistinguishedNames
$domainUsersDN = (Get-ADGroup -Filter "*" | Where-Object {$_.SID -like "*-513"}).DistinguishedName
$esc10userDN = (Get-ADUser -Identity $esc10user).DistinguishedName

#Add GenericAll rights over the esc10user to the Domain Users group
dsacls "$esc10userDN" /G "$domainUsersDN"":GA"
