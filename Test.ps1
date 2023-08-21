class Gvm{
    # This Class implementation ONLY uses socket connection.
    [string] $GvmUsername
    [securestring] $GvmPassword
    hidden [string] $BaseCommand
    hidden [xml] $CreateTargetXML = "<create_target><name></name><hosts></hosts></create_target>"
    #hidden [xml] $CreateTaskXML = "<create_task><name></name><target id=\/><config id=\/><scanner id=\/></create_task>"
    #hidden [xml] $StartTaskXML = "<start_task task_id=\/>"
    #hidden [xml] $GetTaskStatus = "<get_tasks task_id=\/>"
    hidden [xml] $GetReportFormatXML = "<get_report_formats/>"
    hidden [xml] $GetReportXML = "<get_reports/>"

    Gvm([string]$GvmUsername, [securestring]$GvmPassword){
        $this.GvmUsername = $GvmUsername
        $this.GvmPassword = $GvmPassword
        $PlainPass = (New-Object PSCredential 0, $this.GvmPassword).GetNetworkCredential().Password
        $this.BaseCommand = @"
sudo -u _gvm gvm-cli --gmp-username $GvmUsername --gmp-password $PlainPass socket --xml 
"@
    }

    [string] CreateTarget([string] $Name, [string] $Hostname) {
            $XML = $this.CreateTargetXML
            $XML.create_target.name = $Name
            $XML.create_target.hosts = $Hostname
            #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
            $Response = [xml]'<create_target_response status="201" status_text="OK, resource created" id="254cd3ef-bbe1-4d58-859d-21b8d0c046c6"/>'
            if($Response.create_target_response.status -ne '201'){
                throw "ERROR: Failed to create target. Response status $($Response.create_target_response.status)"
            } else {return $Response.create_target_response.id}
    }

    [string] CreateTask([string] $Name, [string] $TargetID, [string] $ConfigID, [string] $ScannerID){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = ''
        if($Response -ne '201'){
            throw "ERROR: Failed to create target. Response status $($Response)"
        }else{return $Response}
    }

    [string] StartTask([string] $TargetId){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = ''
        if($Response -ne '201'){
            throw "ERROR: Failed to create target. Response status $($Response)"
        }else{return $Response}
    }

    [string] GetTaskStatus([string] $TargetId){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = ''
        if($Response -ne '201'){
            throw "ERROR: Failed to create target. Response status $($Response)"
        }else{return $Response}
    }

    [string] GetReportFormat([string] $TargetId){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = ''
        if($Response -ne '201'){
            throw "ERROR: Failed to create target. Response status $($Response)"
        }else{return $Response}
    }

    [string] GetReport([string] $TargetId){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = ''
        if($Response -ne '201'){
            throw "ERROR: Failed to create target. Response status $($Response)"
        }else{return $Response}
    }
}

$GVM = [Gvm]::new("admin", (ConvertTo-SecureString -AsPlainText "PASSWORD"))

#$MyHosts = @{'Plex_Server' = '192.168.50.2'; 'Tekkit_Server' = '192.168.50.215'}

$TargetId = $GVM.CreateTarget("Plex_Server", "192.168.50.2")
Write-Host $TargetId