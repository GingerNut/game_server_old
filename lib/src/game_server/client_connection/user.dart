


import 'dart:async';

import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/command/command.dart';

abstract class User implements ChannelHost{
  String id;
  String displayName;
  String password;
  String secret;
  StreamController<String> messagesIn;

  Channel serverChannel;
  List<String> clients = new List();


  Future login(String id, String password) async{
    messagesIn = await StreamController.broadcast();
    this.id = id;
    this.password = password;

    await setupChannel();


    return;
  }

  close(){}

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
        clients = details.split(Command.delimiter);
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