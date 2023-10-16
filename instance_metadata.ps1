# The Azure Instace Metadata Service provides information about currently running virtual machine instances
$resp Invoke-RestMethod -Headers @{"Metadata" = "true"} -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
$resp | ConvertTo-Json -Depth 6

# Using compute data key to get metadata related to compute only
$resp2 Invoke-RestMethod -Headers @{"Metadata" = "true"} -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance/compute?api-version=2021-02-01"
$resp2 | ConvertTo-Json -Depth 6