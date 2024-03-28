# Author: An0n-00
# Description: This script will check if the given port is open and what service is running on it.
# Usage: ./check_for_port.ps1
# Version: 1.0
####################################################################################################

# Check if the script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

# Function to check for port
function LookForPort {
    param (
        [int]$port
    )
    netstat -ano | Select-String ":$port"
}

function checkPort {
    # Main script
    $portToCheck = Read-Host "Enter the port to check"
    Clear-Host
    # Check for port
    $portResult = LookForPort -port $portToCheck
    
    if ($portResult) {
        Write-Host "Port $portToCheck is open." -ForegroundColor Green
        # Extract PID
        [int]$pid1 = $portResult -split '\s+' | Select-Object -Index 5
        # Check if $pid1 is an integer
        if ($pid1 -is [int]) {
            # Get service name
            $servicename = Get-Process -Id $pid1 | Select-Object -ExpandProperty ProcessName
            Write-Host "Service running on port $portToCheck is: $serviceName (PID: $pid1)" -ForegroundColor Green
            $command = "netsh advfirewall firewall add rule name=""Blocked Port $portToCheck"" dir=in action=block protocol=TCP localport=$portToCheck"
            $wanna_block = Read-Host "Do you want to block this port? (y/n)"
            if ((($wanna_block -eq "y" -or $wanna_block -eq "Y") -and (-not $isAdmin))) {
                # Prompt the user to confirm elevation
                $confirmation = Read-Host "This action requires administrative privileges. Do you want to continue? (Y/N)"
                if ($confirmation -eq "Y" -or $confirmation -eq "y") {
                    # Execute the command with elevated privileges
                    Start-Process -FilePath "powershell.exe" -ArgumentList "-Command $command" -Verb RunAs
                    Write-Host "Port $portToCheck has been blocked." -ForegroundColor Green
                    Start-Sleep 2
                } else {
                    Write-Host "Operation canceled by the user."
                }
            } elseif (($wanna_block -eq "y" -or $wanna_block -eq "Y") -and $isAdmin){
                # Execute the command with administrative privileges
                Invoke-Expression -Command $command
            } else {
                Write-Host "Operation canceled by the user."
            }
        } else {
            Write-Host "Could not extract PID from port result." -ForegroundColor Red
        }
    } else {
        Write-Host "Port $portToCheck is not open." -ForegroundColor Red
    }
}

do{
    clear-host
    write-host " ______                         ______                             "
    write-host "(_____ \                  _    / _____)                            "
    write-host " _____) )  ___    ____  _| |_ ( (____   _ _ _  _____  _____  ____  "
    write-host "|  ____/  / _ \  / ___)(_   _) \____ \ | | | || ___ || ___ ||  _ \ "
    write-host "| |      | |_| || |      | |_  _____) )| | | || ____|| ____|| |_| |"
    write-host "|_|       \___/ |_|       \__)(______/  \___/ |_____)|_____)|  __/ "
    write-host "                                                            |_|    "
    checkPort
    $continue = Read-Host "`nDo you want to check another port? (y/n)"
    Clear-Host
} while ($continue -eq 'y' -or $continue -eq 'Y')

Write-Host "Bye!" -ForegroundColor Yellow
Start-Sleep 1
clear-host
