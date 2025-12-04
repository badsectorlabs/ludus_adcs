# Import ADCSTemplate module
Import-Module ADCSTemplate

# Define the template and group name
$displayName = "Web Server"
$groupName = $groupName = (Get-ADGroup -Identity "$((Get-ADDomain).DomainSID)-513").Name

Set-ADCSTemplateACL -DisplayName $displayName -Type Allow -Identity $groupName -Enroll
