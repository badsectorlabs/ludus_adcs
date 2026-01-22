# Import ADCSTemplate module
Import-Module ADCSTemplate

# Define the template and group name
$displayName = "Web Server"
$groupName = $groupName = (Get-ADGroup -Filter "*" | Where-Object {$_.SID -like "*-513"}).Name

Set-ADCSTemplateACL -DisplayName $displayName -Type Allow -Identity $groupName -Enroll
