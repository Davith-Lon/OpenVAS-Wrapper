Import-Module ./GvmClass.ps1 -Force

$GVM = [Gvm]::new("admin", (ConvertTo-SecureString -AsPlainText "PASSWORD"))

#$MyHosts = @{'Plex_Server' = '192.168.50.2'; 'Tekkit_Server' = '192.168.50.215'}

$GVM.CreateTarget("Plex_Server", "192.168.50.2")
$GVM.GetConfigs()
$GVM.GetScanners()
$GVM.CreateTask('name', 'fdfsa', '431243123', 'dfafdas342432')
$GVM.StartTask('fdasdfas')
$GVM.GetTaskStatus('fdasfasf34')
$GVM.GetReportFormat()
$GVM.GetReport('fdasf', 'fdsaf24')