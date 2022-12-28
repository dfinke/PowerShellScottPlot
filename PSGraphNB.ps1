using namespace "Microsoft.DotNet.Interactive"

function Write-Notebook {
  # via James O'Neill, in https://github.com/dfinke/PowerShellPivot
  <#
        .SYNOPSIS
          Writes to  the output part of the current cell (a streamlined version of Out-Display)
  
        .PARAMETER Html
          Output to be sent as Hmtl
  
        .PARAMETER Text
          Output to be sent as plain text
  
        .PARAMETER PassThru
          If specified returns the output object, allowing it to be updated.
  
        .EXAMPLE
          > $statusMsg = Write-Notebook -PassThru -text  "Step 1"
          > ...
          > $statusmsg.update("Step2")
  
          Displays and updates text in the current cell output
  
        .EXAMPLE
          >  $PSVersionTable | ConvertTo-Html -Fragment | Write-Notebook
  
          Converts $psversionTable to a table and displays it. Without Write-Notebook the HTML markup would appear.
      #>
  [cmdletbinding(DefaultParameterSetName = 'Html')]
  param   (
    [parameter(Mandatory = $true, ParameterSetName = 'Html', ValueFromPipeline = $true, Position = 1 )]
    $Html,
  
    [parameter(Mandatory = $true, ParameterSetName = 'Text')]
    $Text,
  
    [Alias('PT')]
    [switch]$PassThru
  )
  begin { $htmlbody = @() }
  process { if ($html) { $htmlbody += $Html } }
  end {
    if ($htmlbody.count -gt 0) { $result = [Kernel]::display([Kernel]::HTML($htmlbody), 'text/html') }
    if ($Text) { $result = [Kernel]::display($Text, 'text/plain') }
    if ($PassThru) { return $result }
  }
}

function Show-ImageInNotebook {
  param(
    $DestinationPath
  )

  $png = [System.IO.File]::ReadAllBytes($DestinationPath)
  $b64 = [System.Convert]::ToBase64String($png)
      
  $img = '<img src="data:image/png; base64, {0}"></img>' -f $b64

  Write-Notebook -Html $img
}