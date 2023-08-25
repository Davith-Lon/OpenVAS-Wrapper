$GVM = [Gvm]::new('admin', (ConvertTo-SecureString -AsPlainText '79d2abd2-84ce-48b3-a32a-46c6082517d8'))

$TargetName = 'TDMS'
$Targets = @('192.168.50.2', '192.168.50.215', '192.168.50.248')

# Create Scan Target.
$Response =  $GVM.CreateTarget($TargetName, $Targets)
Write-Host $Response
# $TDMSTargetID = $Response.

# # Get Scanner ID.
# $Response = $GVM.GetScanners()
# $Scanners = $Response.get_scanners_response.scanner
# Write-Host $Scanners

# $CveScannerID = ($Scanners | Where-Object {$_.name -eq 'CVE'} | Select-Object -Property id).id
# Write-Host "CVE Scanner ID: $CveScannerID"

# $DefaultScannerID = ($Scanners | Where-Object {$_.name -eq 'OpenVAS Default'} | Select-Object -Property id).id
# Write-Host "OpenVAS Default Scanner ID: $DefaultScannerID"

# # Get Configuration ID.
# $Response = $GVM.GetConfigs()
# $Configs = $Response.get_configs_response.config

# $FullandFastConfig = ($Configs | Where-Object {$_.name -eq 'Full and fast'} | Select-Object -Property id).id
# Write-Host "Full and Fast Config ID: $FullandFastConfig"

# Create Scan Task.
# $GVM.CreateTask("$TargetName Scan Task", 'fdfsa', '431243123', 'dfafdas342432')
# Start Scan Task.
# $GVM.StartTask('fdasdfas')
# Track Scan Task.
# $GVM.GetTaskStatus('fdasfasf34')
# Get Report Format.
# $GVM.GetReportFormat()
# Get Scan Report.
# $GVM.GetReport('fdasf', 'fdsaf24')