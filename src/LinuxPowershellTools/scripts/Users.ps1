Function Get-User {
    <#
    .SYNOPSIS
        Gets list of users
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> Get-User
    .INPUTS
        None
    .OUTPUTS
        PSCustomObject.
    .NOTES
        General notes
    #>
    param(
        # TODO: Username filtering
        # [Parameter(ValueFromPipeLine, ValueFromPipeLineByPropertyName)]
        # $UserName
    )
    return (Get-Content /etc/passwd) | ForEach-Object{
        $userfields = $_ -split ':'
        return [pscustomobject]@{
            UserName= $UserFields[0]
            ShadowFile= $(if($userfields[1] -eq 'x'){$true}else{$false})
            UserId= $UserFields[2]
            GroupId= $userfields[3]
            FullName= $Userfields[4]
            HomeDirectory= $UserFields[5]
            ShellAccount= $Userfields[6]
        }
    }
}

Function New-User{
    <#
    .SYNOPSIS
        Creates new user
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> New-User adammcchesney
    .EXAMPLE
        PS C:\> New-User adammcchesney -WhatIf
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        Creates user
    #>
    [cmdletbinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $UserName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch] $DisabledPassword
    )
    process{
        If (-not $PSCmdlet.ShouldProcess("User:Create:$UserName")) {
            return
        }
        if ($DisabledPassword){
            $result = adduser $UserName --disabled-password
        }
        $result = adduser $UserName

        return  $result
    }
}

# removing due to shell change, will revisit in the future
# Function Switch-User{
#     param(
#         [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
#         [string] $UserName
#     )
#     process{
#         return su - $UserName
#     }
# }

Function Remove-User{
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> Remove-User -UserName AdamMcchesney
    .EXAMPLE
        PS C:\> Remove-User -UserName AdamMcchesne
    .INPUTS
        System.String.UserName The username for the user to be deleted.
    .OUTPUTS
        System.String. The Remove-User returns the output of userdel command
    .NOTES
        General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $UserName
    )
    process {
        If (-not $PSCmdlet.ShouldProcess("User:Delete:$UserName")) {
            return
        }
        return userdel -r $UserName
    }
}

Export-ModuleMember -Function New-User, Remove-User, Get-User
