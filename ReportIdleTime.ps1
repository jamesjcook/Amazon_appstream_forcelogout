
param (
    [string]$FleetName = "MyFleet",
    [string]$StackName = "MyStack",
    [string]$UserId = "beabrian"
    [string]$AccessKey = "NUKEY",
    [string]$SecretKey = "NUKEY",
 )

<#
Write-Host ("fleet:"+$FleetName)
Write-Host ("stack:"+$StackName)
Write-Host ("userid:"+$UserId)
#>
Get-AWSRegion #Needed to bring AWS CmdLets into Memory before touching the .Net Objects

Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@

# while ($true) {
    $dim1 = New-Object Amazon.CloudWatch.Model.Dimension
    $dim1.Name = "FleetName"
    $dim1.Value = $FleetName

    $dim2 = New-Object Amazon.CloudWatch.Model.Dimension
    $dim2.Name = "StackName"
    $dim2.Value = $StackName

    $dim3 = New-Object Amazon.CloudWatch.Model.Dimension
    $dim3.Name = "UserId"
    $dim3.Value = $UserId

    $dat = New-Object Amazon.CloudWatch.Model.MetricDatum
    $dat.Timestamp = (Get-Date).ToUniversalTime()
    $dat.Dimensions = $dim1, $dim2, $dim3
    $dat.MetricName = "UserIdleTime"
    $dat.Unit = "None"
    $dat.Value = [PInvoke.Win32.UserInput]::IdleTime.TotalSeconds


    # example with key    Write-CWMetricData -AccessKey $AccessKey -SecretKey $SecretKey -Namespace "Usage Metrics" -MetricData $dat

    Write-CWMetricData -AccessKey $AccessKey -SecretKey $SecretKey -Namespace "Usage Metrics" -MetricData $dat
    
    Write-Host ("Last input " + [PInvoke.Win32.UserInput]::LastInput)
    Write-Host ("Idle for " + [PInvoke.Win32.UserInput]::IdleTime)
    Write-Host ("Idle for " + [PInvoke.Win32.UserInput]::IdleTime.TotalSeconds)
<#    Start-Sleep -Seconds 60
} #>

