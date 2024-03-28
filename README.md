# Port Checker Script

## Author: An0n-00

## Description
This script is designed to check if a specified port is open and determine which service is running on it.

## Usage
To use this script, simply execute it in a PowerShell environment:

```powershell
./check_for_port.ps1
```

## Version

1.0

---

## Instructions

1. When prompted, enter the port number you want to check.
2. The script will indicate whether the port is open or closed.
3. If the port is open, it will display the service running on that port along with its Process ID (PID).
4. You will be prompted whether you want to block the port.
5. If elevation (administrative privileges) is required and the user confirms, the script will attempt to block the port using Windows Firewall.
6. If elevation is not required, or if the user declines elevation, the script will not block the port.
7. After each port check, you will be asked if you want to check another port. Type 'y' to continue or 'n' to exit.
8. Once finished, the script will display "Bye!" and terminate.

---

**Note**: Administrative privileges may be required to block ports using Windows Firewall. If prompted, please provide the necessary permissions.
