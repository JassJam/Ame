
# for each file with .hlsli extension, parse it to C string and write it to a <name>.hlsli.hpp file
$files = Get-ChildItem -Path Source -Filter *.hlsli -Recurse
foreach ($file in $files) {
    # $content = Get-Content $file.FullName -Raw
    # $result = 'R"({0})"' -f $content
    # $file_handle  = [System.IO.File]::Open($file.FullName + ".generated.hpp", [System.IO.FileMode]::Create)
    # $stream_writer = New-Object System.IO.StreamWriter($file_handle)
    # $stream_writer.Write($result)
    # $stream_writer.Close()
    # $file_handle.Close()
    # if name ends with .static.hlsli, ignore it
    if ($file.Name.EndsWith(".static.hlsli")) {
        continue
    }

    # rename file to .static.hlsli
    $new_name = $file.FullName.Replace(".hlsli", ".static.hlsli")
    Rename-Item -Path $file.FullName -NewName $new_name

    # remove .hlsli.generated.hpp file if exists
    $generated_file = $file.FullName + ".generated.hpp"
    if (Test-Path $generated_file) {
        Remove-Item $generated_file
        Write-Host "Removed generated file: $generated_file"
    }
}