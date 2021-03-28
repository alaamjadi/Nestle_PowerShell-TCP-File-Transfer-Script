# Sender/Client
# send -ip 10.1.1.1 -port 2222 -file commands.ps1
Param(
    [Parameter(Mandatory=$true)][string]$ip,
    [Parameter(Mandatory=$true)][int]$port,
    [Parameter(Mandatory=$true)][string]$file
)
Try {
    # Set up endpoint and start listening
    $EndPoint = New-Object System.Net.IPEndPoint($ip::any,$port)
    $loopback = New-Object System.Net.IPEndPoint($ip::Loopback, $port)

    # Remote host
    $listener = new-object System.Net.Sockets.TcpClient $EndPoint

    # Local Host
    # $TcpClient=New-Object System.Net.Sockets.TcpClient($ip::Loopback, $port)

    $GetStream = $TcpClient.GetStream()
    $StreamWriter = New-Object System.IO.StreamWriter $GetStream

    # Creating the buffer
    $buffer = New-Object System.Byte[] 1024
    

    while (($i = $buffer.Read($buffer,0,$buffer.Length)) -ne 0){
        $EncodedText = New-Object System.Text.ASCIIEncoding
        $data = $EncodedText.GetString($buffer,0, $i)
        Write-Output $data
        $data | Add-Content 'file.txt'
    }

    $StreamWriter.Dispose()
    $GetStream.Dispose()
    $TcpClient.Dispose()
}
Catch {
    "Receive Message failed with: `n" + $Error[0]
}