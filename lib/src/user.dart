

import 'channel/channel.dart';
import 'command/command.dart';

class User implements ChannelHost{

  String id;
  String displayName;
  String password;
  String secret;

  Channel serverChannel;

  login(String id, String password){

    this.id = id;
    this.password = password;

  }

  handleString(String message){
    print('client string ' + message);

    String type = message.substring(0,3);
    String details = message.substring(3);

    switch(type){

      case Command.requestLogin:

        String reply = '';
        reply += Command.login;
        reply += id;
        reply += Command.delimiter;
        reply += password;

        serverChannel.sink(reply);
        break;




    }


  }

}