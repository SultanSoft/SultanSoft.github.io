<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the script, its purpose, common use cases, etc.
.PARAMETER Parameter1
    Description of Parameter1
.PARAMETER Parameter2
    Description of Parameter2
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


###########################################################################################################
############################################ SCRIPT PARAMETERS ############################################
###########################################################################################################


[CmdletBinding()]
param(
    # Parameter help description
    [Parameter()]
    [String]$Parameter1,

    # Parameter help description
    [Parameter()]
    [String]$Parameter2
)


###########################################################################################################
############################################ SCRIPT VARIABLES #############################################
###########################################################################################################

# Get script start time to produce a time-of-execution display at the end of this script.
$StartTime = Get-Date

# Logging and error-handling variables.
$ScriptName = $MyInvocation.MyCommand.Name

# Transcript file location.
$TranscriptFile = Join-Path -Path $PSScriptRoot -ChildPath "$((Get-Item $ScriptName).BaseName).log"

# Configure Powershell verbose preference to always output verbose messages for this script.
$VerbosePreference = "Continue"

# Configure Powershell error preference to always stop even if encountering a non-terminating error. Uncomment to enable.
#$ErrorActionPreference = 'Stop'

$ScriptVariable1 = "One"
$ScriptVariable2 = "Two"
$ScriptVariable3 = "Three"  ## NOTE: None of these variables are used in this template. They are for demonstration only.
$ScriptVariable4 = "Four"
$ScriptVariable5 = "Five"


###########################################################################################################
############################################ MAIN CONTROLLER ##############################################
###########################################################################################################


Function MainController
{
    # This function controls the flow of the script and the order of helper-function calls.
    
    Try
    {
        Set-VerboseColor

        # Variable declaration for troubleshooting and error reporting.
        $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -Type 'Controller' -FunctionName $Script:CurrentFunction

        # Run initialization functions.
        Start-ScriptTranscript  ## Comment out this line if you don't want a transcript log.
        Start-Function1
        If (2+2 -eq 4) { Start-Function2 }  ## This function only runs if 2+2 equals 4.

        # Run task helper functions.
        Start-Function3
        Start-Function4  ## This function should error.

        # Run cleanup functions
        Start-Function5  ## This function should not execute.
	}
	Catch
	{
        Write-CustomError
    }
	Finally
	{
        <#
            WARNING: DO NOT use Write-Output in the 'Finally' block or in any functions called by the 'Finally' block!
            This will prevent the block from running when CTRL+C is pressed because the pipeline is stopped immediately.
            You can use Write-Verbose or Write-Host messages instead.
        #>
        Stop-ScriptTranscript
        Show-ScriptElapsedTime
    }
}


###########################################################################################################
############################################ HELPER FUNCTIONS #############################################
###########################################################################################################


Function Set-VerboseColor
{
	[CmdletBinding()]
	Param(
		[System.ConsoleColor]$Color = 'Cyan'
	)

    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation

	$Host.PrivateData.VerboseForegroundColor = "$Color"
}


Function Start-Function1
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction
    
    Write-Output 'This text is the result of calling Start-Function1.'
}


Function Start-Function2
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction
    
    Write-Output 'This text is the result of calling Start-Function2.'
}


Function Start-Function3
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction
    
    Write-Output 'This text is the result of calling Start-Function3.'
}


Function Start-Function4
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction
    
    Write-Output 'This text is the result of calling Start-Function4.'
    Write-Warning 'This function is DESIGNED TO FAIL by dividing by zero so you can see what happens with error handling.'
    Start-Sleep 2
    $ExpectedError = 1/0 ## Dividing by zero will cause a terminating excpetion.
}


Function Start-Function5
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction
    
    Write-Output 'This text is the result of calling Start-Function5.'
    Write-Output 'You should not see this function run because the preceeding function should have errored.'
}


Function Start-ScriptTranscript
{
	# Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction

	# Start transcript for this script. Standard output is converted to verbose output using ForEach-Object.
	Write-Verbose 'Starting Transcript...'
	Start-Transcript -Path $TranscriptFile -Force | ForEach-Object {Write-Verbose -Message $_}
}


Function Stop-ScriptTranscript
{
	# Variable declaration for troubleshooting and error reporting.
	$Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction

	# Stop the transcript for this script. Standard output is converted to verbose output using ForEach-Object.
	Write-Verbose 'Stopping Transcript...'
	Stop-Transcript | ForEach-Object {Write-Verbose -Message $_}
}


Function Show-ScriptElapsedTime
{
    # Variable declaration for troubleshooting and error reporting.
    $Script:CurrentFunction = $MyInvocation ; Show-FunctionStartText -FunctionName $Script:CurrentFunction

    # Display total script execution time.
    $TotalElapsedTime = [Int](((Get-Date) - $StartTime).TotalSeconds)
    Write-Verbose '+------------------------------------------------------+'
    Write-Verbose "  Total script execution time = $TotalElapsedTime seconds.  "
    Write-Verbose '+------------------------------------------------------+'
}


Function Show-FunctionStartText
{
    Param(
        [Parameter(Mandatory=$true)]
        [Object]$FunctionName,

        [Parameter()]
        [ValidateSet('Function', 'Controller')]
        [String]$Type = 'Function'
    )
    
    # Write-Host used here only to avoid problems in the finally block where Write-Output cannot be used.
    If ($VerbosePreference -eq "Continue") {Write-Host ''}
    Write-Verbose "<<<<<<<<<<<<<<<< BEGIN $($Type.ToUpper()): $($FunctionName.MyCommand.Name) >>>>>>>>>>>>>>>>"
}


Function Write-CustomError
{    
    Try
    {
        # Format custom error message with red console text. This text also outputs to the transcript.
		$OriginalFG = $Host.UI.RawUI.ForegroundColor
        $Host.UI.RawUI.ForegroundColor = 'Red'

        Write-Output ''
		Write-Output 'ERROR: ===============================[ ERROR ]====================================='
        Write-Output "ERROR: FUNCTION_NAME: $($CurrentFunction.MyCommand.Name)"
        Write-Output "ERROR: MESSAGE: $($Error[0].Exception.Message)"
        Write-Output "ERROR: TYPE: $($Error[0].Exception.GetType().FullName)"
        Write-Output "ERROR: LINE: $($Error[0].InvocationInfo.PositionMessage)"
		Write-Output 'ERROR: ===============================[ ERROR ]====================================='
    }
    Finally
    {
        $Host.UI.RawUI.ForegroundColor = $OriginalFG
    }
}


###########################################################################################################
########################################### SCRIPT EXECUTION ##############################################
###########################################################################################################


# Execute the "MainController" function. This script will not run without the code below.
MainController

