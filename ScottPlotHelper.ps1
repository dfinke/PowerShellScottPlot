Add-Type -Path .\ScottPlot.dll

. .\psgraphNB.ps1

function Show-ScottPlotInNotebook {
    param(
        $plot, 
        $DestinationPath
    )

    [void] $plot.SaveFig($DestinationPath)
    Show-ImageInNotebook $DestinationPath
    Remove-Item $DestinationPath
}