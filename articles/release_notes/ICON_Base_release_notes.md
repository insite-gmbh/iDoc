# ICON Base Release Notes

Erweiterung ICON-Globals

SocketTimeout:  Mit diesem Parameter kann der Timeout für das Senden und Empfangen der Sockets eingestellt werden.

[SendTimeout](https://msdn.microsoft.com/en-us/library/system.net.sockets.socket.sendtimeout%28v=vs.110%29.aspx)

[ReceiveTimeout](https://msdn.microsoft.com/en-us/library/system.net.sockets.socket.receivetimeout%28v=vs.110%29.aspx)

`<ConfigValue name="SocketTimeout" type="int">30000</ConfigValue>`


SocketSendBufferSize: Mit diesem Parameter kann die Größe des Sendepufferst der Sockets eingestellt werden. Der Wert 0 sorgt dafür das nicht gepuffert wird.
[SocketSendBufferSize](https://msdn.microsoft.com/en-us/library/system.net.sockets.socket.sendbuffersize%28v=vs.110%29.aspx)

`<ConfigValue name="SocketSendBufferSize" type="int">8192</ConfigValue>`
