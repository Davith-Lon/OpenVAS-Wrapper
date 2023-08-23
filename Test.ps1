$GVM = [Gvm]::new("admin", (ConvertTo-SecureString -AsPlainText "PASSWORD"))

#$MyHosts = @{'Plex_Server' = '192.168.50.2'; 'Tekkit_Server' = '192.168.50.215'}

$TargetId = $GVM.CreateTarget("Plex_Server", "192.168.50.2")
Write-Host $TargetId