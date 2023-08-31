<#
    .SYNOPSIS
        This is a partial wrapper for the gvm-cli to enable automation of OpenVAS with Powershell.
    .DESCRIPTION
        This implementation purely return the output of the invoked gvm-cli command without any
        processing or validating.
    .NOTES
        This implementation assumes it will be ran locally on the OpenVAS machine, as it uses a socket
        connection and doesn't have SSH added right now (TBD).
        ~ John Titor
#>

class Gvm{
    # This Class implementation ONLY uses socket connection.
    [string] $GvmUsername
    [securestring] $GvmPassword
    hidden [string] $BaseCommand
    hidden [xml] $GetPortListsXML = '<get_port_lists/>'
    hidden [xml] $CreateTargetXML = "<create_target><name></name><hosts></hosts><port_list id=''/></create_target>"
    hidden [xml] $GetScannersXML = '<get_scanners/>'
    hidden [xml] $GetConfigXML = '<get_configs/>'
    hidden [xml] $CreateTaskXML = "<create_task><name></name><target id=''/><config id=''/><scanner id=''/></create_task>"
    hidden [xml] $StartTaskXML = "<start_task task_id=''/>"
    hidden [xml] $GetTaskStatus = "<get_tasks task_id=''/>"
    hidden [xml] $GetReportFormatXML = "<get_report_formats/>"
    hidden [xml] $GetReportXML = "<get_reports report_id='' format_id=''/>"
    hidden [string] $tmpLogFile = $PSScriptRoot + '/tmpLog.log'

    Gvm([string]$GvmUsername, [securestring]$GvmPassword){
        $this.GvmUsername = $GvmUsername
        $this.GvmPassword = $GvmPassword
        $PlainPass = (New-Object PSCredential 0, $this.GvmPassword).GetNetworkCredential().Password
        $this.BaseCommand = @"
sudo -u _gvm gvm-cli --gmp-username $GvmUsername --gmp-password $PlainPass socket --xml 
"@
    }

    [hashtable] GetPortLists(){
        $Result = @{}
        $Command = "$($this.BaseCommand)" + '"' +$This.GetPortListsXML.InnerXml + '" > ' + $this.tmpLogFile + " 2>&1"
        Write-Host "Invoking...`n $Command`n"
        try{
            Invoke-Expression -Command $Command
            $Response = Get-Content -Path $this.tmpLogFile -Raw
            [xml] $Response
            $Keys = Select-Xml -Content $Response -XPath '/get_port_lists_response/port_list/name' | ForEach-Object {"$($_.Node.InnerXml)"}
            $Values = Select-Xml -Content $Response -XPath '/get_port_lists_response/port_list/@id' | ForEach-Object {$_}
            $Keys | ForEach-Object {$Result[$_] = $Values[$Keys.IndexOf($_)]}
        }
        catch{
            throw "Failed to GetPortLists: $(Get-Content -Path $this.tmpLogFile -Raw)"
        }
        return $Result
    }

    [string] CreateTarget([string] $Name, [string[]] $Hostname, [string] $PortListID) {
        $XML = $this.CreateTargetXML
        $XML.create_target.name = $Name
        $XML.create_target.hosts = $Hostname -join ','
        $XML.create_target.port_list.id = $PortListID

        #$XML.create_target.port_list.id = $PortListID
        $Command = "$($this.BaseCommand)" + '"' + $XML.InnerXml.Replace('"', "'") + '" > ' + $this.tmpLogFile + " 2>&1"
        Write-Host "Invoking...`n $Command`n"
        
        try{
            Invoke-Expression -Command $Command
            $Response = Get-Content -Path $this.tmpLogFile -Raw
            [xml] $Response
            $Result = Select-Xml -Content $Response -XPath '/create_target_response/@id' | ForEach-Object {$_}
        }
        catch{
            throw "Failed to CreateTarget: $(Get-Content -Path $this.tmpLogFile -Raw)"
        }
        return $Result
    }

    [hashtable] GetScanners(){
        $Result = @{}
        $Command = "$($this.BaseCommand)" + '"' +$This.GetScannersXML.InnerXml + '" > ' + $this.tmpLogFile + " 2>&1"
        Write-Host "Invoking...`n $Command`n"
        try{
            Invoke-Expression -Command $Command
            $Response = Get-Content -Path $this.tmpLogFile -Raw
            [xml] $Response
            $Keys = Select-Xml -Content $Response -XPath '/get_scanners_response/scanner/name' | ForEach-Object {"$($_.Node.InnerXml)"}
            $Values = Select-Xml -Content $Response -XPath '/get_scanners_response/scanner/@id' | ForEach-Object {$_}
            $Keys | ForEach-Object {$Result[$_] = $Values[$Keys.IndexOf($_)]}
        }
        catch{
            throw "Failed to GetPortLists: $(Get-Content -Path $this.tmpLogFile -Raw)"
        }
        return $Result
    }

    [xml] GetConfigs(){
        Write-Host "Invoking...`n $($this.BaseCommand + $this.GetConfigXML.OuterXml)"
        $Response = (Invoke-Expression -Command "$($this.BaseCommand + '"' + $this.GetConfigXML.OuterXml + '"')")
        return $Response
    }

    [string] CreateTask([string] $Name, [string] $TargetID, [string] $ConfigID, [string] $ScannerID){

        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target.id = $TargetID
        $XML.create_task.config.id =  $ConfigID
        $XML.create_task.scanner.id = $ScannerID
        $Command = "$($this.BaseCommand)" + '"' + $XML.InnerXml.Replace('"', "'") + '" > ' + $this.tmpLogFile + " 2>&1"
        Write-Host "Invoking...`n $Command`n"
        
        try{
            Invoke-Expression -Command $Command
            $Response = Get-Content -Path $this.tmpLogFile -Raw
            [xml] $Response
            $Result = Select-Xml -Content $Response -XPath '/create_target_response/@id' | ForEach-Object {$_}
        }
        catch{
            throw "Failed to CreateTarget: $(Get-Content -Path $this.tmpLogFile -Raw)"
        }
        return $Result
    }

    [xml] StartTask([string] $TaskID){
        $XML = $this.StartTaskXML
        $XML.start_task.task_id = $TaskID
        Write-Host "Invoking...`n $($this.BaseCommand + $XML.OuterXml)"
        $Response = ''
        return $Response
    }

    [xml] GetTaskStatus([string] $TaskID){
        $XML = $this.GetTaskStatusXML
        $XML.get_tasks.task_id = $TaskID
        Write-Host "Invoking...`n $($this.BaseCommand + $XML.OuterXml)"
        $Response = ''
        return $Response
    }

    [xml] GetReportFormat(){
        Write-Host "Invoking...`n $($this.BaseCommand + $this.GetReportFormatXML.OuterXml)"
        $Response = ''
        return $Response
    }

    [xml] GetReport([string] $ReportID, [string] $FormatID){
        $XML = $this.GetReportXML
        $XML.get_reports.report_id = $ReportID
        $XML.get_reports.format_id = $FormatID
        Write-Host "Invoking...`n $($this.BaseCommand + $XML.OuterXml)"
        $Response = ''
        return $Response
    }
}