# Set EAP to stop to catch errors and exit with an error code
$ErrorActionPreference= Stop
try{
    # Install Dependencies
    Install-Module PSScriptAnalyzer -Confirm
    Get-ChildItem -Recurse ./src |
        ForEach-Object{
            Invoke-ScriptAnalyzer $_.FullName
        }
} catch {
    # TODO: Setup and use error codes
    exit 1
}
