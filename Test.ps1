#Import-Module "C:\Users\davit\Dev\OpenVAS-Wrapper\GvmClass.ps1" -Force

$GVM = [Gvm]::new('admin', (ConvertTo-SecureString -AsPlainText '79d2abd2-84ce-48b3-a32a-46c6082517d8'))

#$MyHosts = @{'Plex_Server' = '192.168.50.2'; 'Tekkit_Server' = '192.168.50.215'}

# $GVM.CreateTarget("Plex_Server", "192.168.50.2")
# $GVM.GetConfigs()
$Response = $GVM.GetScanners()

$Scanners = $Response.get_scanners_response.scanner
Write-Host $Scanners

$CveScannerID = ($Scanners | Where-Object {$_.name -eq 'CVE'} | Select-Object -Property id).id
Write-Host "CVE Scanner ID: $CveScannerID"

$DefaultScannerID = ($Scanners | Where-Object {$_.name -eq 'OpenVAS Default'} | Select-Object -Property id).id
Write-Host "OpenVAS Default Scanner ID: $DefaultScannerID"

$Response = $GVM.GetConfigs()
$Configs = $Response.get_configs_response.config

$FullandFastConfig = ($Configs | Where-Object {$_.name -eq 'Full and fast'} | Select-Object -Property id).id
Write-Host "Full and Fast Config ID: $FullandFastConfig"

# $GVM.CreateTask('name', 'fdfsa', '431243123', 'dfafdas342432')
# $GVM.StartTask('fdasdfas')
# $GVM.GetTaskStatus('fdasfasf34')
# $GVM.GetReportFormat()
# $GVM.GetReport('fdasf', 'fdsaf24')