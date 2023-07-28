function Citra_install(){
	setMSG "Downloading Citra"
	$url_citra = getLatestReleaseURLGH "citra-emu/citra-nightly" "7z" "windows-mingw"
	download $url_citra "citra.7z"
	moveFromTo "$temp/citra/nightly-mingw" "$emusPath\citra"
	Remove-Item -Recurse -Force citra -ErrorAction SilentlyContinue	
	mkdir "$emusPath\citra\user" -ErrorAction SilentlyContinue	
	createLauncher "citra"
	
}
function Citra_init(){

	setMSG "Citra - Configuration"
	$destination="$emusPath\citra\user"
	mkdir $destination -ErrorAction SilentlyContinue
	
	$destination="$emusPath\citra\user\config"	
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\citra\config" "$destination"
	
	sedFile "$emusPath\citra\user\config\qt-config.ini" "C:/Emulation" "$emulationPath"
	sedFile "$emusPath\citra\user\config\qt-config.ini" ":\Emulation" ":/Emulation"
	
	Citra_setupSaves
}
function Citra_update(){
	Write-Output "NYI"
}
function Citra_setEmulationFolder(){
	Write-Output "NYI"
}
function Citra_setupSaves(){
	setMSG "Citra - Saves Links"
	$SourceFilePath = "$emusPath\citra\user\sdmc\"
	$ShortcutPath = -join($emulationPath,"\saves\citra\saves.lnk")
	mkdir "saves\citra" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
	
	$SourceFilePath = "$emusPath\citra\user\states\"
	$ShortcutPath = -join($emulationPath,"\saves\citra\states.lnk")
	mkdir "saves\citra" -ErrorAction SilentlyContinue
	mkdir $SourceFilePath -ErrorAction SilentlyContinue
	createLink $SourceFilePath $ShortcutPath
}
function Citra_setupStorage(){
	Write-Output "NYI"
}

function Citra_setResolution($resolution){
	switch ( $resolution )
	{
		"720P" { $multiplier = 3 }
		"1080P" { $multiplier = 5 }
		"1440P" { $multiplier = 6 }
		"4K" { $multiplier = 9 }
	}	
	$destination="$emusPath\citra\user"
	
	setConfig "resolution_factor" $multiplier $destination\config\qt-config.ini
}

function Citra_wipe(){
	Write-Output "NYI"
}
function Citra_uninstall(){
	Write-Output "NYI"
}
function Citra_migrate(){
	Write-Output "NYI"
}
function Citra_setABXYstyle(){
	Write-Output "NYI"
}
function Citra_wideScreenOn(){
	Write-Output "NYI"
}
function Citra_wideScreenOff(){
	Write-Output "NYI"
}
function Citra_bezelOn(){
	Write-Output "NYI"
}
function Citra_bezelOff(){
	Write-Output "NYI"
}
function Citra_finalize(){
	Write-Output "NYI"
}
function Citra_IsInstalled(){
	$test=Test-Path -Path "$emusPath\citra"
	if($test){
		Write-Output "true"
	}
}
function Citra_resetConfig(){
	Citra_init
	if($?){
		Write-Output "true"
	}
}