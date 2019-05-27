

import 'package:game_server/src/game_server/channel/web_channel_client_io.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';

class IoClientConnection extends ClientConnection{
  final String address;
  final int port;

  IoClientConnection(this.address, this.port);

  Future setupChannel() async{
    IOWebChannelClient channel = IOWebChannelClient(this, "ws://" + address + ":$port");
    await channel.connect();

    serverChannel = channel;
    serverChannel.listen((s)=> handleString(s));
    return;
  }

}