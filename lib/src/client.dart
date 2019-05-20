import 'package:game_server/game_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channel/channel.dart';
import 'channel/web_channel_server.dart';
import 'command/command.dart';


class Client implements ChannelHost{
  bool valid = true;

  Channel userChannel;

  Client(WebSocketChannel webSocket){
    userChannel = WebChannelServer(this, webSocket);
  }


  initialise() {

    userChannel.listen((msg) => handleString(msg));
  }



  handleString(String message){
      String type = message.substring(0,3);
      String content = message.substring(3);

      switch(type){
        case Command.echo:
          userChannel.sink("echo $content");
          break;



      }


    }

  }

