<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.145
	 Created on:   	2017-12-10 3:05 PM
	 Created by:   	MaximeB
	 Organization: 	MB_Toolz
	 Filename:     	TeamViewerRightClickTool.ps1
	===========================================================================
	.DESCRIPTION
		SCCM right Click Tool To Start In SCCM.
This Is the Script that make it all work.
#>

##################
# script variables
##################


function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

function Get-TVDevicesId
{
	
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices" -Method GET -Headers $header -ContentType application/json
}

$CurrentDirectory = Get-ScriptDirectory

$XMLImport = Import-Clixml -Path "$CurrentDirectory\TeamViewerRightClickToolZSettings.xml"
$Token = $XMLImport.UserToken
$Password = $XMLImport.TeamViewerPassword

$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$header.Add("authorization", "Bearer $Token")

$ResourceID = $args[0]
$Server = $args[1]
$Namespace = $args[2]
$Mode = $args[4]

$Popup = new-object -comobject wscript.shell


try
{
	$strQuery = "Select ResourceID, Name from SMS_R_System where ResourceID='$ResourceID'"
	$compname = Get-WmiObject -Query $strQuery -Namespace $Namespace -ComputerName $server
	$compname = $compname.Name
}

catch [Exception] {
	$Popup.Popup("Cannot connect to the ConfigMgr-Site: Error-Message: $_.Exception.Message", 0, "Error", 0)
	Break
}

try
{
	$Device = Get-TVDevicesId
	$computername = $compname
	$DeviceInformation = $Device.devices | Where-Object { $_.alias -like $computername -and $_.online_state -eq "Online" }
	$RemoteControlID = $DeviceInformation.remotecontrol_id
	$SplitedRemoteControlID = $RemoteControlID.split('r')
	$FormatedRemoteControlID = $SplitedRemoteControlID[1]
}
catch [Exception] {
	$Popup.Popup("Cannot Get a Teamviewer ID or Get Devices Information: Error-Message: $_.Exception.Message", 0, "Error", 0)
	Break
}


try
{
	if ($Mode -eq "File")
	{
		#Teamviewer fileTransfer
		if ($Password -ne $null -or $Password -ne "")
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID -P $Password -m fileTransfer"
		}
		else
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID -m fileTransfer"
		}
	}
	if ($Mode -eq "VPN")
	{
		#Teamviewer VPN
		if ($Password -ne $null -or $Password -ne "")
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID -P $Password -m vpn"
		}
		else
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID -m vpn"
		}
	}
	else
	{
		#Teamviewer Remote Control
		if ($Password -ne $null -or $Password -ne "")
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID -P $Password"
		}
		else
		{
			Start-Process -FilePath "${Env:ProgramFiles(x86)}\TeamViewer\TeamViewer.exe" -ArgumentList "-i $FormatedRemoteControlID"
		}
	}
	
	
}

catch [Exception] {
	$Popup.Popup("Cannot open Teamviewer: Error-Message: $_.Exception.Message", 0, "Error", 0)
	Break
}