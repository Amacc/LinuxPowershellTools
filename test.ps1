# Install Dependencies
Install-Module PSScriptAnalyzer
Get-ChildItem -Recurse ./src |
    ForEach-Object{
        Invoke-ScriptAnalyzer $_.FullName
    }
