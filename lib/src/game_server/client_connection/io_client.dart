part of client_connection;

class IoClientConnection extends ClientConnection{
  final String address;
  final int port;

  IoClientConnection(HttpInterface interface, this.address, this.port) : super(interface);

  Future setupChannel() async{
    IOWebChannelClient channel = IOWebChannelClient(this, "ws://" + address + ":$port");
    await channel.connect();

    serverChannel = channel;
    serverChannel.listen((s)=> handleJSON(s));
    return;
  }

}