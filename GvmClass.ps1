class Gvm{
    # This Class implementation ONLY uses socket connection.
    [string] $GvmUsername
    [securestring] $GvmPassword
    hidden [string] $BaseCommand
    hidden [xml] $CreateTargetXML = "<create_target><name></name><hosts></hosts></create_target>"
    hidden [xml] $GetScannersXML = '<get_scanners/>' # FIX ME: This will return everything. Implement further.
    hidden [xml] $GetConfigXML = '<get_configs/>'
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

    [xml] CreateTarget([string] $Name, [string] $Hostname) {
            $XML = $this.CreateTargetXML
            $XML.create_target.name = $Name
            $XML.create_target.hosts = $Hostname
            #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
            $Response = [xml]'<create_target_response status="201" status_text="OK, resource created" id="254cd3ef-bbe1-4d58-859d-21b8d0c046c6"/>'
            return [xml] $Response
    }

    [xml] GetScanners(){
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $this.GetScannersXML)
        $Response = ''
        return [xml] $Response
    }

    [xml] GetConfigs(){
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $this.GetConfigXML)
        $Response = ''
        return [xml] $Response
    }

    [xml] CreateTask([string] $Name, [string] $TargetID, [string] $ConfigID, [string] $ScannerID){
        $XML = $this.CreateTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = '<create_task_response status="201" status_text="OK, resource created" id="7249a07c-03e1-4197-99e4-a3a9ab5b7c3b"/>'
        return [xml] $Response
    }

    [xml] StartTask([string] $Name, [string] $TargetId, [string] $ConfigID, [string] $ScannerID){
        $XML = $this.StartTaskXML
        $XML.create_task.name = $Name
        $XML.create_task.target_id = $TargetID
        $XML.create_task.config_id =  $ConfigID
        $XML.create_task.scanner_id = $ScannerID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = '<start_task_response status="202" status_text="OK, request submitted"><report_id>0f9ea6ca-abf5-4139-a772-cb68937cdfbb</report_id></start_task_response>'
        return [xml] $Response
    }

    [xml] GetTaskStatus([string] $TaskID){
        $XML = $this.GetTaskStatusXML
        $XML.get_tasks.task_id = $TaskID
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $XML)
        $Response = '<get_tasks_response status="200" status_text="OK"><status>Running</status><progress>98</progress><get_tasks_response/>'
        return [xml] $Response
    }

    [xml] GetReportFormat(){
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $this.GetReportFormatXML)
        $Response = '<get_report_formats_response status="200" status_text="OK"><report_format id="5057e5cc-b825-11e4-9d0e-28d24461215b"></get_report_formats_response>'
        return [xml] $Response
    }

    [xml] GetReport(){
        #$Response = [xml](Invoke-VMScript -Script $this.BaseCommand + $this.GetReportXML)
        $Response = ''
        return [xml] $Response
    }
}