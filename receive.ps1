# Listener/Server
# receive -port 2222
Param (
    [Parameter(Mandatory=$true)][int]$port
)

function Write-EmbeddedFile
{
  param
  (
    [string]$base64,
    [string]$targetFile
  )
  process
  {
    $Content = [System.Convert]::FromBase64String($base64)
    Write-Output $Content
    Out-File $targetFile
    $Content | Add-Content $targetFile
    # Set-Content -Path ".\$targetFile" -Value $Content -Encoding Byte
  }
}

Try {
    # Set up endpoint and start listening
    $EndPoint = new-object System.Net.IPEndPoint([IPAddress]::Any,$port) 
    $listener = new-object System.Net.Sockets.TcpListener $EndPoint
    $listener.start() 

    # Wait for an incoming connection 
    $data = $listener.AcceptTcpClient()
    Write-Output "Waiting for an incoming connection..."

    # Stream setup
    $stream = $data.GetStream()
    $bytes = New-Object System.Byte[] 1024

    while (($i = $stream.Read($bytes,0,$bytes.Length)) -ne 0){
        $EncodedText = New-Object System.Text.ASCIIEncoding
        $data = $EncodedText.GetString($bytes,0, $i)
      }
      $bits = $data.Split("#")
      
      # Read data from stream and write it to host
      
      if($bits.Length -ne 2)
      {
        $stream.close()
        $listener.stop()
        throw "Data error. Expected 2 items of data on clipboard, but got $($bits.Length)"
      }
      
      $file = $bits[0]
      if($alternativeName -ne $null -and $alternativeName.Length -gt 0)
      {
        $file = $alternativeName
      }
      $data = $bits[1]
      
      Write-Host "Receiving file `"$file`" from $($data.Length) bytes of data"
      # Write-EmbeddedFile $data $file
      
      $Content = [System.Convert]::FromBase64String($data)
      Set-Content -Path ".\$file" -Value $Content -Encoding Byte

      Get-Content -Path ".\$file"
      
      
    # $Content = [System.Convert]::FromBase64String($data)
    # Write-Output $Content
    # Out-File $file
    # $Content | Add-Content $file

    # Close TCP connection and stop listening
    $stream.close()
    $listener.stop()
}
Catch {
    "Receive Message failed with: `n" + $Error[0]
}