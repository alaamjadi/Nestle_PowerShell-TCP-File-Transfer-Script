# Sender/Client
# send -ip 10.1.1.1 -port 2222 -file commands.ps1
Param(
    [Parameter(Mandatory=$true)][string]$ip,
    [Parameter(Mandatory=$true)][int]$port,
    [Parameter(Mandatory=$true)][string]$file
)

function Base64Encode-File
{
  param
  (
    [Parameter(Mandatory = $true)]
    [string]$file
  )
  process
  {
    $c = Get-Content $file -Encoding Byte 
    return [System.Convert]::ToBase64String($c)
  }
}


Try {
    $TcpClient=New-Object System.Net.Sockets.TcpClient($ip::Loopback, $port)

    $GetStream = $TcpClient.GetStream()
    $StreamWriter = New-Object System.IO.StreamWriter $GetStream

    $fileName = Split-Path $file -leaf
 
    $data = Base64Encode-File $file
    $file= "$fileName#$data"
    $file | %{
        $StreamWriter.Write($_)
    }
    Write-Host "File `"$file`" encoded to clipboard in $($data.Length) bytes"
    $StreamWriter.Dispose()
    $GetStream.Dispose()
    $TcpClient.Dispose()
}
Catch {
    "Receive Message failed with: `n" + $Error[0]
}
