import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/command/command.dart';

import '../../game_server.dart';

class Client implements ChannelHost {
  Channel userChannel;
  GameServer server;

  initialise(GameServer server) {

    this.server = server;

    userChannel.listen((msg) => handleString(msg));
  }

  requestLogin(){
    userChannel.sink(Command.requestLogin);
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