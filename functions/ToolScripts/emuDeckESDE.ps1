function ESDE_install(){
	setMSG 'Downloading EmulationStation DE'
	rm -r -fo "$temp/esde" -ErrorAction SilentlyContinue
	download $url_esde "esde.zip"
	mkdir $esdePath -ErrorAction SilentlyContinue
	moveFromTo "$temp/esde/EmulationStation-DE" "$esdePath"	
}
function ESDE_init(){	
	setMSG 'EmulationStation DE - Paths and Themes'
	
	#We reset ESDE system files
	#Copy-Item "$esdePath/resources/systems/windows/es_systems.xml.bak" -Destination "$esdePath/resources/systems/windows/es_systems.xml" -ErrorAction SilentlyContinue
	#Copy-Item "$esdePath/resources/systems/windows/es_find_rules.xml.bak" -Destination "$esdePath/resources/systems/windows/es_find_rules.xml" -ErrorAction SilentlyContinue
	
	#We move ESDE + Emus to the userfolder.
	$test=Test-Path -Path "$toolsPath\EmulationStation-DE\EmulationStation.exe"
	if($test){
	
		$userDrive=$userFolder[0]
		
		$destinationFree = (Get-PSDrive -Name $userDrive).Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)
		
		$originSize = (Get-ChildItem -Path "$toolsPath/EmulationStation-DE" -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell
		
		if ( $originSize -gt $destinationFree ){			
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}				
		$Output = $wshell.Popup("We are going to move EmulationStation and all the Emulators to $userFolder in order to improve loading times. This will take long, so please wait until you get a new confirmation window")
		
		mkdir $esdePath  -ErrorAction SilentlyContinue
		moveFromTo "$toolsPath\EmulationStation-DE" "$esdePath"
		
		$Output = $wshell.Popup("Migration complete!")

	}		
	
	#We move download_media folder
	$test=Test-Path -Path "$userFolder\emudeck\EmulationStation-DE\.emulationstation\downloaded_media"
	if($test){
	
		$userDrive=$userFolder[0]
		
		$destinationFree = (Get-PSDrive -Name $userDrive).Free
		$sizeInGB = [Math]::Round($destinationFree / 1GB)
		
		$originSize = (Get-ChildItem -Path "$toolsPath/EmulationStation-DE" -Recurse | Measure-Object -Property Length -Sum).Sum
		$wshell = New-Object -ComObject Wscript.Shell
		
		if ( $originSize -gt $destinationFree ){			
			$Output = $wshell.Popup("You don't have enough space in your $userDrive drive, free at least $sizeInGB GB")
			exit
		}				
		$Output = $wshell.Popup("We are going to move EmulationStation scrape data to $emulationPath/storage in order to free space in your internal drive. This could take long, so please wait until you get a new confirmation window")
		
		mkdir $emulationPath/storage/downloaded_media  -ErrorAction SilentlyContinue
		moveFromTo "$esdePath/.emulationstation/downloaded_media" "$emulationPath/storage/downloaded_media"
		
		$Output = $wshell.Popup("Migration complete!")
	
	}
	
	$destination="$esdePath\.emulationstation"
	mkdir $destination -ErrorAction SilentlyContinue
	copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation" "$destination"
	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="ROMDirectory" value=").*?(?=" />)', "$romsPath"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"
	
	mkdir $emulationPath/storage/downloaded_media -ErrorAction SilentlyContinue 
	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	$updatedXML = $xml -replace '(?<=<string name="MediaDirectory" value=").*?(?=" />)', "$emulationPath/storage/downloaded_media"
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"
	
	mkdir "$toolsPath\launchers\esde" -ErrorAction SilentlyContinue
	createLauncher "esde/EmulationStationDE"
		
	ESDE_applyTheme $esdeTheme
	
	ESDE_setDefaultEmulators
	
	#Citra fixes
	sedFile "$esdePath\resources\systems\windows\es_find_rules.xml" '<entry>%ESPATH%\Emulators\Citra\nightly-mingw\citra-qt.exe</entry>' '<entry>%ESPATH%\Emulators\citra\citra-qt.exe</entry>'
	
}

function ESDE_addLauncher($emucode, $launcher){
	
	# Configuration file path
	$configFile = "$esdePath/resources/systems/windows/es_find_rules.xml"	
	
	# Emulator name
	$emulatorName = "$emucode"
	
	# New entry to add
	$newEntry = "$toolsPath\launchers\$launcher.bat"
	
	# Load the XML content
	$xmlContent = Get-Content $configFile -Raw
	
	# Create an XML object from the content
	$xml = [xml]$xmlContent
	
	# Find the emulator by name
	$emulator = Select-Xml -Xml $xml -XPath "//emulator[@name='$emulatorName']"
	
	# Check if the emulator was found
	if ($emulator -eq $null) {
		Write-Host "No emulator found with the name '$emulatorName'."
	} else {
		# Add the new entry to the rule
		$newEntryElement = $xml.CreateElement("entry")
		$newEntryElement.InnerText = $newEntry
		$emulator.Node.rule.prependChild($newEntryElement)
		
		# Save the changes to the file
		$xml.Save($configFile)
	
		Write-Host "The new entry has been added successfully."
	}

}

function ESDE_update(){
	Write-Output "NYI"
}
function ESDE_setEmulationFolder(){
	Write-Output "NYI"
}
function ESDE_setupSaves(){
	Write-Output "NYI"
}
function ESDE_setupStorage(){
	Write-Output "NYI"
}
function ESDE_wipe(){
	Write-Output "NYI"
}
function ESDE_uninstall(){
	Write-Output "NYI"
}
function ESDE_migrate(){
	Write-Output "NYI"
}
function ESDE_setABXYstyle(){
	Write-Output "NYI"
}
function ESDE_wideScreenOn(){
	Write-Output "NYI"
}
function ESDE_wideScreenOff(){
	Write-Output "NYI"
}
function ESDE_bezelOn(){
	Write-Output "NYI"
}
function ESDE_bezelOff(){
	Write-Output "NYI"
}
function ESDE_finalize(){
	Write-Output "NYI"
}
function ESDE_applyTheme($theme){
	
	mkdir "$esdePath/themes/" -ErrorAction SilentlyContinue
	
	git clone https://github.com/anthonycaccese/epic-noir-revisited-es-de "$esdePath/themes/epic-noir-revisited" --depth=1
	cd "$esdePath/themes/epic-noir-revisited" ; git reset --hard HEAD ; git clean -f -d ; git pull

	
	$xml = Get-Content "$esdePath\.emulationstation\es_settings.xml"
	if($theme -eq "EPICNOIR"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'epic-noir-revisited'
	}
	if($theme -eq "MODERN-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'modern-es-de'
	}
	if($theme -eq "RBSIMPLE-DE"){
		$updatedXML = $xml -replace '(?<=<string name="ThemeSet" value=").*?(?=" />)', 'slate-es-de'
	}		
	$updatedXML | Set-Content "$esdePath\.emulationstation\es_settings.xml"

}

function ESDE_IsInstalled(){
	$test=Test-Path -Path "$esdePath"
	$testold=Test-Path -Path "$toolsPath/EmulationStation-DE"
	if ($test -or $testold) {
		Write-Output "true"
	}

}
function ESDE_resetConfig(){
	ESDE_init
	if($?){
		Write-Output "true"
	}
}



function ESDE_setDefaultEmulators(){
	mkdir "$esdePath/.emulationstation/gamelists/"  -ErrorAction SilentlyContinue
	
	ESDE_setEmu 'Dolphin (Standalone)' gc
	ESDE_setEmu 'PPSSPP (Standalone)' psp
	ESDE_setEmu 'Dolphin (Standalone)' wii
	ESDE_setEmu 'PCSX2 (Standalone)' ps2
	ESDE_setEmu 'melonDS' nds
	ESDE_setEmu 'Citra (Standalone)' n3ds
	ESDE_setEmu 'Beetle Lynx' atarilynx
	ESDE_setEmu 'DuckStation (Standalone)' psx
	ESDE_setEmu 'Beetle Saturn' saturn
	ESDE_setEmu 'ScummVM (Standalone)' scummvm
}


function ESDE_setEmu($emu, $system){		
    $gamelistFile="$esdePath/.emulationstation/gamelists/$system/gamelist.xml"
	$test=Test-Path -Path "gamelistFile"
	
	if ( Test-Path -Path "$gamelistFile" ){
			
		echo "we do nothing"
		#$xml = [xml](Get-Content $gamelistFile)		
		
		#$xml.alternativeEmulator.label = $emu
		
		# Guardar los cambios en el archivo XML
		#$xml.Save($gamelistFile)
	
	}
	else{
	
		mkdir "$esdePath/.emulationstation/gamelists/$system"  -ErrorAction SilentlyContinue
		
		"$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation"
		
		Copy-Item "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\configs\emulationstation/gamelists/$system/gamelist.xml" -Destination "$gamelistFile" -ErrorAction SilentlyContinue
	}
	
}