param(
    [String]$SteamID,
    [String]$DownloadFolder,
    [String]$DateFilter,
    [bool]$Extract = $true,
    [bool]$DeleteAfterExtract = $true
)

#Enter your Steam ID
$SteamID = "STEAM_0:1:8634346"
$DownloadFolder = "C:\temp\demos"
#Set DateFilter to $True to only download demos after $DownloadDate
$DateFilter = $True
$DownloadDate = "2024-09-21"
#If you wish to extract your files to the download file set this to $True, otherwise, false.
$Extract = $true
#If you wish to delete the .bz2 files after extraction, set $DeleteAfterExtract to $true
$DeleteAfterExtract = $True
#7-Zip Settings
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

### Don't Edit ###
if($DateFilter -eq $True)
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

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
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
        <#Do this if a terminating exception happens#>
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
        <#Do this if a terminating exception happens#>
        Write-Error -Message $_
    }
}

if($DeleteAfterExtract -eq $True)
{
    $demos | Remove-Item
}