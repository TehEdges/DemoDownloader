<#
    .SYNOPSIS
        This script will download played matches that match a given SteamID and extract them to .dem automatically. This script requires 7-Zip be installed to extract.
    .DESCRIPTION
        Script attempts to download matches played by a specific SteamID that were recorded to the eFPS website. It can also be configured to automatically extract the downloaded .bz2 files if you already have 7-Zip installed.
    .PARAMETER SteamID
        String Value: Steam ID provided in the following format indicates which player to download for.
        Example: STEAM_0:1:8634346
    .PARAMETER DownloadFolder
        String Value: Specifies the path to download and extract demos into.
    .PARAMETER DownloadDate
        DateTime Value: Set to the date you wish to use as a download after filter. Must be in yyyy-MM-dd format. Leave blank to download all demos matching the steamid.
        Example: 2024-09-21
    .PARAMETER Extract
        Boolean Value: Set to $True if you want to extract the .bz2 files once downloaded automatically. 
    .PARAMETER DeleteAfterExtract
        Boolean Value: Set to true if you wish to delete the .bz2 files after the .dem has been extracted.
    .PARAMETER 7ZipPath
        String Value: Optional Parameter used to set the location for 7z.exe. By default this is set to Program Files\7-Zip\7z.exe
#>

param (
    [Parameter(Mandatory=$True,
        HelpMessage='Please provide your steamid here. Example: STEAM_0:1:8634346')]
    [String]$SteamID,
    [Parameter(Mandatory=$True,
        HelpMessage='Please enter the path you wish to download your demos to.')]
    [String]$DownloadFolder,
    [Parameter(Mandatory=$False,
        HelpMessage='If you are specifying a date enter your datetime stamp in yyyy-MM-dd format. Else leave blank',ParameterSetName='DateFilter')]
    [DateTime]$DownloadDate,
    [Parameter(Mandatory=$False,
        HelpMessage='If you would like to automatically extract your downloads to .dem, please set this to $True')]
    [ValidateSet($True, $False)]
    [bool]$Extract = $true,
    [Parameter(Mandatory=$False,
        HelpMessage='If you would like to delete the .bz2 files after extraction, set this to $True')]
    [ValidateSet($True, $False)]
    [bool]$DeleteAfterExtract = $True,
    [Parameter(Mandatory=$False,
        HelpMessage='Please provide the path to 7z.exe')]
    [string]$7ZipPath = "$env:programFiles\7-Zip\7z.exe"
)

### Don't Edit ###
if($DownloadDate)
{
    $URL = "https://hl2dm.everythingfps.com/crons/player_demos.php?steamid=$SteamID&key=038fcc47c86f493b5548a36f679d67fe&date=$DownloadDate"
}
else
{
    $URL = "https://hl2dm.everythingfps.com/crons/player_demos.php?steamid=$SteamID&key=038fcc47c86f493b5548a36f679d67fe"
}

## Make sure Downloads Folder exists
if(!(Test-Path $DownloadFolder))
{
    $FolderPath = $DownloadFolder.substring(0, $DownloadFolder.LastIndexOf("\") + 1)
    $FolderName = $DownloadFolder.Split("\") | Select-Object -Last 1
    New-Item -Path $FolderPath -Name $FolderName -ItemType Directory
}


if ($Extract -eq $true -and -not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip executable '$7zipPath' not found"
}


Set-Alias Start-SevenZip $7zipPath


$Demos = Invoke-RestMethod -uri $url
if($demos.Status -eq "Success")
{
    try {
        $i = 1
        $total = $demos.demo_data.demo_link.Count
        $wc = New-Object Net.WebClient
        Foreach($Demo in $demos.demo_data.demo_link)
        {
            Write-Progress -Activity "Downloading Demos" -Status "Downloading: $i of $total" -PercentComplete (($i / $total) * 100)
            $BZ2Name = $Demo.Split("/") | Select-Object -Last 1
            $FullName = $DownloadFolder + "\" + $BZ2Name
            $wc.DownloadFile($demo, $FullName)
            $i++
        }
        $wc.Dispose()
        Write-Progress -Activity "Downloading Demos" -Completed $True
    }
    catch {
        Write-Error -Message $_
    }
}

if($extract -eq $true)
{
    try {
        $demos = Get-ChildItem $DownloadFolder
        $i = 1
        $demos | ForEach-Object{Write-Progress -Activity "Extracting Demos" -Status ("Extracting demo $i of " + $demos.count) -PercentComplete (($i / $demos.count) * 100)
            Start-SevenZip e $_.FullName -o"$DownloadFolder" | Out-Null
            $i++}
        Write-Progress -Activity "Extracting Demos" -Completed $True
    }
    catch {
        Write-Error -Message $_
    }
}

if($DeleteAfterExtract -eq $True)
{
    $demos | Remove-Item
}