Import-Module ./GvmClass.ps1 -Force

$TargetName = 'TDMS'
$Targets = @('192.168.50.2', '192.168.50.215', '192.168.50.248')

try{
    $GVM = [Gvm]::new('admin', (ConvertTo-SecureString -AsPlainText '79d2abd2-84ce-48b3-a32a-46c6082517d8'))

    # Get Port List.
    $Response = $GVM.GetPortLists()
    $PortListID = $Response['All IANA assigned TCP and UDP']
    Write-Host "PortListID: $PortListID"

    # Get Configuration ID.
    $Response = $GVM.GetConfigs()
    $ConfigsID = $Response['Full and fast']
    Write-Host "ConfigID: $ConfigsID"

    # Get Scanners.
    $Response = $GVM.GetScanners()
    $ScannerID = $Response['CVE']
    Write-Host "ScannerID: $ScannerID"
    
    # Create Scan Target.
    $TargetID =  $GVM.CreateTarget($TargetName, $Targets, $PortListID)
    Write-Host "TargetID: $TargetID"

    # # Create Scan Task.
    # $TaskID = $GVM.CreateTask("$TargetName Scan Task", $TargetID, $ConfigsID, $ScannerID)
    # Write-Host "TaskID: $TaskID"

    # # Start Scan Task.
    # $ReportID = $GVM.StartTask($TaskID)
    # Write-Host "ReportID: $ReportID"

    # if(!$GVM.WaitForScanTask($TaskID)){
    #     throw 'Scan Task Failed/Timeout...'
    # }

    # #Get Report Format.
    # $Response = $GVM.GetReportFormat()
    # $ReportFormatID = $Response['CSV Results']

    # # Get Scan Report.
    # $GVM.GetReport($ReportID, $ReportFormatID)
}
catch{
    Write-Host $_
}

return 0