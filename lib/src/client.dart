import 'package:game_server/game_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channel/channel.dart';
import 'channel/web_channel_server.dart';
import 'command/command.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';


class Client implements ChannelHost{
  bool valid = true;

  Channel userChannel;

  Client(WebSocketChannel webSocket){
    userChannel = WebChannelServer(this, webSocket);
  }


  initialise() {

    userChannel.listen((message) {

      String string = message.toString();
      String type = string.substring(0,3);
      String content = string.substring(3);

      switch(type){
        case Command.echo:
          userChannel.sink("echo $content");
          break;



      }


    });
  }



  message(String message){


  }

}