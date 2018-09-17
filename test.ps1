# Set EAP to stop to catch errors and exit with an error code
$ErrorActionPreference= "Stop"
try{
    # Install Dependencies
    Install-Module PSScriptAnalyzer -Force
    Get-ChildItem -Recurse ./src -Filter "*.ps1" |
        ForEach-Object{
            Write-Host "Checking $($_.FullName)"
            Invoke-ScriptAnalyzer $_.FullName
        }
} catch {
    # Write the error message to screen
    Write-Host ((@(
        "{0} : {1}",
        "{2}",
        "    + CategoryInfo          : {3}",
        "    + FullyQualifiedErrorId : {4}"
    ) -join "`n") -f @(
        $_.InvocationInfo.MyCommand.Name,
        $_.ErrorDetails.Message,
        $_.InvocationInfo.PositionMessage,
        $_.CategoryInfo.ToString(),
        $_.FullyQualifiedErrorId
    ))
    exit $_.Exception.HResult
}
