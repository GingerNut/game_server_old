import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/channel/stream_channel.dart';
import 'package:game_server/src/game_server/server_connection/stream_connection.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';


class StreamClientConnection extends ClientConnection{

  final GameServer server;

  StreamClientConnection(this.server);

  setupChannel() {
    StreamChannel connectToServer = StreamChannel(this);
    StreamConnection client = StreamConnection();
    StreamChannel connectToUser = StreamChannel(client);

    connectToServer.otherEnd = connectToUser;
    connectToUser.otherEnd = connectToServer;

    client.clientChannel = connectToUser;
    server.addConnection(client);

    serverChannel = connectToServer;
    serverChannel.listen((s)=>handleString(s));
  }
}