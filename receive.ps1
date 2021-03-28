# Listener/Server
# receive -port 2222
Param (
    [Parameter(Mandatory=$true)][int]$port
)
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
    $buffer = New-Object System.Byte[] 1024

    # Read data from stream and write it to host
    Out-File 'file.txt'

    while (($i = $buffer.Read($buffer,0,$buffer.Length)) -ne 0){
        $EncodedText = New-Object System.Text.ASCIIEncoding
        $data = $EncodedText.GetString($buffer,0, $i)
        Write-Output $data
        $data | Add-Content 'file.txt'
    }

    # Close TCP connection and stop listening
    $stream.close()
    $listener.stop()
}
Catch {
    "Receive Message failed with: `n" + $Error[0]
}