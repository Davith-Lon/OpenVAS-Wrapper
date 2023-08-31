Import-Module ./GvmClass.ps1 -Force

$TargetName = 'TDMS'
$Targets = @('192.168.50.2', '192.168.50.215', '192.168.50.248')

try{
    $GVM = [Gvm]::new('admin', (ConvertTo-SecureString -AsPlainText '79d2abd2-84ce-48b3-a32a-46c6082517d8'))
    # Get Port List.
    $Response = $GVM.GetPortLists()
    $PortListID = $Response['All IANA assigned TCP and UDP']

    # Get Scanners.
    $Response = $GVM.GetScanners()
    $ScannerID = $Response['CVE']
    
    # # Create Scan Target.
    $TargetID =  $GVM.CreateTarget($TargetName, $Targets, $PortListID)
    Write-Host $Response
    # $TDMSTargetID = $Response.
}
catch{
    Write-Host $_
}

return 0


# # Get Scanner ID.
# $Response = $GVM.GetScanners()
# $Scanners = $Response.get_scanners_response.scanner

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