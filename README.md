# eFPS Match Demo Downloader & Extractor Script

This PowerShell script automates the process of downloading played match demos based on a specific SteamID from the eFPS website and optionally extracts them using 7-Zip. 

## Requirements

- **PowerShell**
- **7-Zip** installed (if you wish to automatically extract the downloaded files)

## Features

- Downloads played match demos based on a provided SteamID.
- Optionally extracts `.bz2` files into `.dem` files using 7-Zip.
- Supports filtering downloads by date.
- Option to automatically delete `.bz2` files after extraction.

## Instructions

### Step 1: Open PowerShell
#### On Windows 10/11:
1. Press `Win + X` and select **Windows PowerShell** from the menu, or
2. Type "PowerShell" in the Windows search bar and press `Enter`.

#### On older versions of Windows:
1. Press `Win + R`, type `powershell`, and press `Enter`.

### Step 2: Prepare the Script
1. Download the script file (e.g., `Demo-Downloader.ps1`) and save it in a folder of your choice.

2. Navigate to the folder where the script is saved using the `cd` command in PowerShell. For example, if the script is in `C:\Scripts`, type the following:
   ```powershell
   cd C:\Scripts
   ```
3. You may need to temporarily allow PowerShell to execute scripts by running:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
4. Call .\Demo-Downloader.ps1 with the appropriate parameters. 
    ```powershell
    .\DownloadMatches.ps1 -SteamID "STEAM_0:1:8634346" -DownloadFolder "C:\Demos" -DateFilter $True -DownloadDate "2024-09-21" -Extract $True -DeleteAfterExtract $True
    ```
## Parameters

### `SteamID`
- **Type**: `String`
- **Description**: Specifies the SteamID to download matches for.
- **Format Example**: `STEAM_0:1:8634346`
  
### `DownloadFolder`
- **Type**: `String`
- **Description**: Specifies the folder path where demos will be downloaded and extracted.
  
### `DateFilter`
- **Type**: `Boolean`
- **Description**: Set to `$True` to only download demos after the specified date in the `DownloadDate` parameter.

### `DownloadDate`
- **Type**: `DateTime`
- **Description**: The date to filter downloads after. Must be in `yyyy-MM-dd` format.
- **Example**: `2024-09-21`

### `Extract`
- **Type**: `Boolean`
- **Description**: Set to `$True` if you want to automatically extract the `.bz2` files after download.

### `DeleteAfterExtract`
- **Type**: `Boolean`
- **Description**: Set to `$True` if you want to automatically delete the `.bz2` files after they are extracted to `.dem` format.

### `7ZipPath`
- **Type**: `String`
- **Description**: Specifies the path to `7z.exe`. If not provided, defaults to `Program Files\7-Zip\7z.exe`.
