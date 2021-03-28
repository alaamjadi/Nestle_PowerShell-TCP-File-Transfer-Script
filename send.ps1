# Sender/Client
# send -ip 10.1.1.1 -port 2222 -file commands.ps1
Param(
    [Parameter(Mandatory=$true)][string]$ip,
    [Parameter(Mandatory=$true)][int]$port,
    [Parameter(Mandatory=$true)][string]$file
)
Try {
    # Set up endpoint and start listening
    $EndPoint = new-object System.Net.IPEndPoint([ip]::any,$port)

    # Remote host
    $listener = new-object System.Net.Sockets.TcpClient $EndPoint

    # Local Host
    #$TcpClient=New-Object System.Net.Sockets.TcpClient([ip]::Loopback, $port)

    $GetStream = $TcpClient.GetStream()
    $StreamWriter = New-Object System.IO.StreamWriter $GetStream

    foreach($line in Get-Content .\$file) {
        $StreamWriter.Write($line)
    }

    $StreamWriter.Dispose()
    $GetStream.Dispose()
    $TcpClient.Dispose()
}
Catch {
    "Receive Message failed with: `n" + $Error[0]
}