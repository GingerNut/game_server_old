

import 'package:game_server/src/game_server/channel/web_channel_client_io.dart';
import 'package:game_server/src/game_server/client_connection/user.dart';

class IoUser extends User{
  final String address;
  final int port;

  IoUser(this.address, this.port);

  Future setupChannel() async{
    IOWebChannelClient channel = IOWebChannelClient(this, "ws://" + address + ":$port");
    await channel.connect();

    serverChannel = channel;
    serverChannel.listen((s)=> handleString(s));
    return;
  }

}