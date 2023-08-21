$MyHosts = @{'Plex_Server' = '192.168.50.2'; 'Tekkit_Server' = '192.168.50.215'}

$CreateTargetXML = [xml]"<create_target><name></name><hosts></hosts></create_target>"
$CreateTaskXML = [xml]"<create_task><name></name><target id=\/><config id=\/><scanner id=\/></create_task>"
$StartTaskXML = [xml]"<start_task task_id=\/>"
$GetTaskStatue = [xml]"<get_tasks task_id=\/>"
$GetReportFormatXML = [xml]"<get_report_formats/>"
$GetReportXML = [xml]"<get_reports report_id=\ format_id=\/>"

$PSScript = @"
sudo -u _gvm gvm-cli --gmp-username --gmp-password socket --xml 
"@

foreach ($h in $MyHosts.GetEnumerator()){
    $CreateTargetXML.create_target.name = $Host.Name
    $CreateTargetXML.create_target.hosts = $Host.Value
    Write-Host ($PSScript + ("`"$($CreateTargetXML.OuterXml)`""))
    #$Response = Invoke-VMScript -Script $PSScript + $CreateTargetXML
    $Response = [xml]'<create_target_response status="201" status_text="OK, resource created" id="254cd3ef-bbe1-4d58-859d-21b8d0c046c6"/>'

    if($Response.create_target_response.status -ne '201'){
        Write-Host "FAILD"
    }

}