# Import ADCSTemplate module
Import-Module ADCSTemplate

# Define the template and group name
$displayName = "Web Server"
$groupName = "Domain Users"

Set-ADCSTemplateACL -DisplayName $displayName -Type Allow -Identity $groupName -Enroll