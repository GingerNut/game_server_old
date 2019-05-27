
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/game_server/channel/web_channel_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'server_connection.dart';




class HttpConnection extends ServerConnection{

  HttpConnection(WebSocketChannel webSocket){
    clientChannel = WebChannelServer(this, webSocket);
  }


  }

