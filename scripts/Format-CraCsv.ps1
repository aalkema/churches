#For example - Revenue file should keep rows 0,1,2,27,49,74

<#
 
.SYNOPSIS
This script takes in a CRA csv file and outputs 'neater' csv
 
.DESCRIPTION
This script removes quotes and spaces from CRA csv files and can output only specified columns from CRA csv files.
 
.EXAMPLE
./Format-CraCsv.ps1 -CsvPath ./Financial6.csv -OutputCsvPath ./FormattedCraRevenue.csv -ErrorLinesPath ./errors.txt -ColumnsToKeep (0,1,2,27,49,74)
 
.PARAMETER CsvPath
    The path to the source CRA csv file

.PARAMETER OutputCsvPath
    The output path of the csv file.  This file will be deleted if it exists before the scripts runs.

.PARAMETER ErrorLinesPath
    The output path for any lines the script can't parse.  This file will be deleted if it exists before the script runs.

.PARAMETER ColumnsToKeep
    0 index based list of column numbers to output in the OutputCsvPath file.
#>

Param (
    [string] $CsvPath,
    [string] $OutputCsvPath,
    [string] $ErrorLinesPath,
    [int[]] $ColumnsToKeep = $null
)

$RawCsv = Get-Content $CsvPath

Remove-Item $OutputCsvPath -ErrorAction SilentlyContinue
Remove-Item $ErrorLinesPath -ErrorAction SilentlyContinue

foreach ($row in $RawCsv) {
    $row = $row.Replace('"','')
    $row = $row.Replace(' ','')
    $RowData = $row -Split ','

    if (-not $ColumnsToKeep -eq $null) {
        $outRow = ""
        foreach ($columnNum in $ColumnsToKeep) {
            $outRow += "$($RowData[$columnNum])`|"
        }
        $outRow = $outRow.TrimEnd('|')
    } else {
        $outRow = $RowData -Join "|"
    }

    Add-Content -Value $outRow -Path $OutputCsvPath
}