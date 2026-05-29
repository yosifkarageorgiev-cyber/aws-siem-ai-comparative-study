# =============================================================================
# baseline_activity_v2.ps1
# -----------------------------------------------------------------------------
# Freeze-resistant version of the baseline generator. Every operation has a
# strict timeout so the script cannot hang on a slow remote response.
#
# Designed to generate benign network/auth activity against the Windows
# Server 2019 target (192.168.56.101) from the Windows 11 host (192.168.56.1).
#
# Usage (regular PowerShell, NOT as Administrator):
#   .\baseline_activity_v2.ps1
# =============================================================================

# ---- Config -----------------------------------------------------------------
$Target       = "192.168.56.101"
$AdminUser    = "Administrator"
$AdminPass    = "Kele64eto"
$DurationMin  = 60
$BurstEverySec = 30          # one burst every 30 seconds (faster baseline build-up)
$OpTimeoutSec  = 10          # any single operation gets max 10 seconds

# ---- Helpers ----------------------------------------------------------------
function Write-Log {
    param($Msg)
    $ts = Get-Date -Format "HH:mm:ss"
    Write-Host "[$ts] $Msg"
}

# Wrapper: run a scriptblock with a strict timeout.
# If it doesn't return in time, the job is killed and we move on.
function Invoke-WithTimeout {
    param([scriptblock]$Block, [int]$TimeoutSec = 10, [string]$Name = "op")
    $job = Start-Job -ScriptBlock $Block
    if (Wait-Job $job -Timeout $TimeoutSec) {
        $result = Receive-Job $job 2>$null
        Remove-Job $job -Force
        Write-Log "$Name done"
    } else {
        Stop-Job $job -ErrorAction SilentlyContinue
        Remove-Job $job -Force -ErrorAction SilentlyContinue
        Write-Log "$Name timed out (skipped)"
    }
}

# ---- Activity functions -----------------------------------------------------

function Do-PortProbe {
    # Test that SMB port is open - lightweight, never hangs
    Invoke-WithTimeout -Name "Port 445 probe" -TimeoutSec 5 -Block {
        $r = Test-NetConnection -ComputerName $using:Target -Port 445 `
             -InformationLevel Quiet -WarningAction SilentlyContinue
    }
}

function Do-Ping {
    # Plain ping - generates network activity, can't hang
    Invoke-WithTimeout -Name "Health ping" -TimeoutSec 5 -Block {
        Test-Connection -ComputerName $using:Target -Count 2 -Quiet -ErrorAction SilentlyContinue | Out-Null
    }
}

function Do-NetView {
    # net view - generates SMB null-session events
    Invoke-WithTimeout -Name "Net view" -TimeoutSec 8 -Block {
        $null = cmd.exe /c "net view \\$using:Target /all 2>nul"
    }
}

function Do-AuthList {
    # Authenticated SMB share listing - generates 4624 + 4672 logon events
    Invoke-WithTimeout -Name "Auth share list" -TimeoutSec 10 -Block {
        $null = cmd.exe /c "net use \\$using:Target\IPC`$ /user:$using:AdminUser $using:AdminPass 2>nul"
        Start-Sleep -Milliseconds 500
        $null = cmd.exe /c "net view \\$using:Target 2>nul"
        $null = cmd.exe /c "net use \\$using:Target\IPC`$ /delete 2>nul"
    }
}

function Do-Nslookup {
    # DNS-style query, very lightweight, generates no risk events but
    # contributes to event-mix variety
    Invoke-WithTimeout -Name "Nslookup" -TimeoutSec 5 -Block {
        $null = cmd.exe /c "nslookup $using:Target 2>nul"
    }
}

$Actions = @(
    { Do-PortProbe },
    { Do-Ping },
    { Do-NetView },
    { Do-AuthList },
    { Do-Nslookup }
)

# ---- Main -------------------------------------------------------------------
Write-Host ""
Write-Host "============================================================"
Write-Host "  BASELINE ACTIVITY GENERATOR v2 (freeze-resistant)"
Write-Host "============================================================"
Write-Host "  Target            : $Target"
Write-Host "  Duration          : $DurationMin minutes"
Write-Host "  Burst every       : $BurstEverySec seconds"
Write-Host "  Per-op max time   : $OpTimeoutSec seconds"
Write-Host "  Start time        : $(Get-Date -Format 'HH:mm:ss')"
Write-Host "  End time          : $((Get-Date).AddMinutes($DurationMin).ToString('HH:mm:ss'))"
Write-Host "============================================================"
Write-Host ""

$EndTime = (Get-Date).AddMinutes($DurationMin)
$Burst = 0

while ((Get-Date) -lt $EndTime) {
    $Burst++
    Write-Log "--- Burst $Burst ---"
    $Action = Get-Random -InputObject $Actions
    try { & $Action } catch { Write-Log "Burst $Burst error (skipped)" }
    Start-Sleep -Seconds $BurstEverySec
}

Write-Host ""
Write-Host "============================================================"
Write-Host "  BASELINE COMPLETE - $Burst bursts generated"
Write-Host "============================================================"
