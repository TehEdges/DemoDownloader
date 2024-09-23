SYNOPSIS
    This script will download played matches that match a given SteamID and extract them to .dem automatically. This script requires 7-Zip be installed to extract.


SYNTAX
    .\Demo-Downloader.ps1 [-SteamID] <String> [-DownloadFolder] <String> [-DateFilter] <Boolean> [-DownloadDate] <DateTime> [-Extract] <Boolean> [-DeleteAfterExtract] <Boolean> [[-7ZipPath] <String>] [<CommonParameters>]


DESCRIPTION
    Script attempts to download matches played by a specific SteamID that were recorded to the eFPS website. It can also be configured to automatically extract the downloaded .bz2 files if you already have 7-Zip installed.


PARAMETERS
    -SteamID <String>
        String Value: Steam ID provided in the following format indicates which player to download for.
        Example: STEAM_0:1:8634346

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DownloadFolder <String>
        String Value: Specifies the path to download and extract demos into.

        Required?                    true
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DateFilter <Boolean>
        Boolean Value: Set to $True if you want to only download demos after the date specified in the $DownloadDate Parameter.

        Required?                    true
        Position?                    3
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DownloadDate <DateTime>
        DateTime Value: Set to the date you wish to use as a download after filter. Must be in yyyy-MM-dd format.
        Example: 2024-09-21

        Required?                    true
        Position?                    4
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Extract <Boolean>
        Boolean Value: Set to $True if you want to extract the .bz2 files once downloaded automatically.

        Required?                    true
        Position?                    5
        Default value                True
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -DeleteAfterExtract <Boolean>
        Boolean Value: Set to true if you wish to delete the .bz2 files after the .dem has been extracted.

        Required?                    true
        Position?                    6
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -7ZipPath <String>
        String Value: Optional Parameter used to set the location for 7z.exe. By default this is set to Program Files\7-Zip\7z.exe

        Required?                    false
        Position?                    7
        Default value                "$env:programFiles\7-Zip\7z.exe"
        Accept pipeline input?       false
        Accept wildcard characters?  false
