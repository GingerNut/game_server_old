


import 'dart:async';

import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/command/command.dart';

abstract class User implements ChannelHost{
  String id;
  String displayName;
  String password;
  String secret;
  StreamController<String> messagesIn;

  Channel serverChannel;

  Future login(String id, String password) async{
    messagesIn = await StreamController.broadcast();
    this.id = id;
    this.password = password;

    await setupChannel();


    return;
  }

  setupChannel();

  handleString(String message){
    messagesIn.sink.add(message);

    String type = message.substring(0,3);
    String details = message.substring(3);

    switch(type){

      case Command.requestLogin:

        String reply = '';
        reply += Command.login;
        reply += id;
        reply += Command.delimiter;
        reply += password;

        send(reply);
        break;

      case Command.requestClientList:
        print(details);
        break;



    }

  }

  send(String message){
    serverChannel.sink(message);
  }

  logout(){
    serverChannel.close();
  }

}