<#
 
.SYNOPSIS
This script converts the HTML from the churches website into a csv file
 
.DESCRIPTION
This script parses the HTML from exactly this site: http://ottawachurches.ncf.ca/#para into csv - so it is maybe more of a template for getting data from other sites
 
.EXAMPLE
./Get-OttawaChurchesCsv.ps1 -HtmlPath ./ottawachurches.html -OutputCsvPath ./churches.csv -ErrorLinesPath ./errors.txt
 
.PARAMETER HtmlPath
    The path to the html source for the website

.PARAMETER OutputCsvPath
    The output path of the csv file.  This file will be deleted if it exists before the scripts runs.

.PARAMETER ErrorLinesPath
    The output path for any lines the script can't parse.  This file will be deleted if it exists before the script runs.
#>
Param (
    [string] $HtmlPath,
    [string] $OutputCsvPath,
    [string] $ErrorLinesPath
)

$RawHtml = Get-Content $HtmlPath
$lineRegex = @"
^<LI><a href="([~#-\.\w:\/]*)">([^<]*)<\/a>,?\s?(.*),?\s?phone[^\d]*([\d-\(\)]*).*$
"@

Remove-Item $OutputCsvPath -ErrorAction SilentlyContinue
Remove-Item $ErrorLinesPath -ErrorAction SilentlyContinue
Add-Content -Value "Name,Denomination,Address,Url,PhoneNumber,Comment" -Path $OutputCsvPath

foreach ($line in $RawHtml) {
    if ($line[0] -ne '<') {
        $Denomination = $line
        continue
    }
    if ($line -match $lineRegex) {
        $url = $matches[1]
        $address = $matches[3]
        $phoneNumber = $matches[4]
        $name = $matches[2]
        Add-Content -Value "$name|$Denomination|$address|$url|$phoneNumber|" -Path $OutputCsvPath
    } else {
        Add-Content -Value $line -Path $ErrorLinesPath
    }
}