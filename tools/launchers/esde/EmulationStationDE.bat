@Write-Output off
set args=%*

powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; RPCS3_renameFolders "}

for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set "toolsPath=%%~a"
for /f "tokens=2 delims==" %%b in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "cloud_sync_status"') do set "cloud_sync_status=%%~b"
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (
		powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmuAll "}		
	)
)
$env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmuAll "}
"ESDEPATH\EmulationStation.exe" %args%
cls
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (
		powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_uploadEmuAll "}		
	)
)