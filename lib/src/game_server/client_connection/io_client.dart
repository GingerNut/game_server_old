

import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/interface/http_interface.dart';

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