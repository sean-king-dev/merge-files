# Function to merge two files
function Merge-Files {
    param (
        [string]$baseFileName,
        [string]$mergeFileName,
        [string]$outputFileName
    )

    try {
        # Build full file paths
        $baseFilePath = Join-Path -Path "diff_files" -ChildPath $baseFileName
        $mergeFilePath = Join-Path -Path "diff_files" -ChildPath $mergeFileName
        $outputFilePath = Join-Path -Path "diff_files" -ChildPath $outputFileName

        # Validate base file
        if (-not (Test-Path -Path $baseFilePath -PathType Leaf)) {
            throw "Base file '$baseFileName' not found."
        }

        # Validate merge file
        if (-not (Test-Path -Path $mergeFilePath -PathType Leaf)) {
            throw "Merge file '$mergeFileName' not found."
        }

        # Create the output directory if it doesn't exist
        $outputDirectory = Split-Path -Path $outputFilePath
        if (-not (Test-Path -Path $outputDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force
        }

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
    catch {
        Write-Host "Error: $_"
    }
}

# Example usage
Merge-Files -baseFileName "live.css" -mergeFileName "uat.css" -outputFileName "merged\merged.css"
