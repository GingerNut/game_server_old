
import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/web_channel_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'client.dart';




class WebClient extends Client{
  bool valid = true;

  Channel userChannel;

  WebClient(WebSocketChannel webSocket){
    userChannel = WebChannelServer(this, webSocket);
  }


  }

