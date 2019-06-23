part of client_connection;


class StreamClientConnection extends ClientConnection{

  final GameServer server;

  StreamClientConnection(HttpInterface interface, this.server) : super (interface);

  setupChannel() {
    StreamChannel connectToServer = StreamChannel(this);
    StreamConnection client = StreamConnection();
    StreamChannel connectToUser = StreamChannel(client);

    connectToServer.otherEnd = connectToUser;
    connectToUser.otherEnd = connectToServer;

    client.clientChannel = connectToUser;
    server.addConnection(client);

    serverChannel = connectToServer;
    serverChannel.listen((s)=>handleJSON(s));
  }
}