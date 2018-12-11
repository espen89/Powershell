function Restart-FSPComputer {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
    [parameter(ValueFromPipeline=$True)]
    [string[]]$Computername,
    [switch]$LogToEventlog
    )
    

    begin {
    }

    process {
        Write-Verbose "Starter process del av script"
        ForEach ($Computer in $Computername) {
            try {
                Restart-Computer $Computer -Force -ErrorAction Stop
                    if ($PSBoundParameters.ContainsKey("LogToEventlog")) {
                        Write-EventLog -LogName Application -Source "restart.ps1" -EntryType Information -EventId "1" -Message "Restartet $computer med Restart-FSPComputer" 
                }
            }
            catch {
                    write-error $_.Exception.Message -ErrorAction Continue
                        if ($PSBoundParameters.ContainsKey("LogToEventlog")) {
                        Write-EventLog -LogName Application -Source "restart.ps1" -EntryType Error -EventId "9" -Message $_.Exception
                }
            }
        }
    }
}