# v1

# Function to merge two files
function Merge-Files {
    param (
        [string]$baseFileName,
        [string]$mergeFileName,
        [string]$outputFileName
    )

    # Build full file paths
    $baseFilePath = Join-Path -Path "diff_files" -ChildPath $baseFileName
    $mergeFilePath = Join-Path -Path "diff_files/merged" -ChildPath $mergeFileName
    $outputFilePath = Join-Path -Path "diff_files/merged" -ChildPath $outputFileName

    # Read content from the base file and the file to merge
    $baseContent = Get-Content $baseFilePath
    $mergeContent = Get-Content $mergeFilePath

    # Compare the content of the two files
    $differences = Compare-Object -ReferenceObject $baseContent -DifferenceObject $mergeContent -PassThru

    # Merge the content of the base file and the differences
    $mergedContent = $baseContent + $differences

    # Write the merged content to a new file
    $mergedContent | Set-Content -Path $outputFilePath

    Write-Host "Files merged successfully. Merged content saved to $outputFilePath"
}

# Example usage

# Merge-Files -baseFileName "live.css" -mergeFileName "uat.css" -outputFileName "merged.css"
