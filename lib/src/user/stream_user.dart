import 'package:game_server/game_server.dart';
import 'package:game_server/src/channel/stream_channel.dart';
import 'package:game_server/src/client/stream_client.dart';
import 'package:game_server/src/user/user.dart';


class StreamUser extends User{

  final GameServer server;

  StreamUser(this.server);

  setupChannel() {
    StreamChannel connectToServer = StreamChannel(this);
    StreamClient client = StreamClient();
    StreamChannel connectToUser = StreamChannel(client);

    connectToServer.otherEnd = connectToUser;
    connectToUser.otherEnd = connectToServer;

    client.clientChannel = connectToUser;
    server.addClient(client);

    serverChannel = connectToServer;
    serverChannel.listen((s)=>handleString(s));
  }



}