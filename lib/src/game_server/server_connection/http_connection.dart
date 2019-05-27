
import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/web_channel_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'server_connection.dart';




class HttpConnection extends ServerConnection{

  HttpConnection(WebSocketChannel webSocket){
    clientChannel = WebChannelServer(this, webSocket);
  }


  }

