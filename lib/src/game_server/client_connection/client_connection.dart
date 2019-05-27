


import 'dart:async';

import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/interface/interface.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';

abstract class ClientConnection implements ChannelHost{
  final Interface interface;
  String id;
  String displayName;
  String password;
  String secret;
  StreamController<String> messagesIn;
  bool loggedIn = false;

  Channel serverChannel;
  List<String> clients = new List();

  ClientConnection(this.interface);


  Future login(String id, String password) async{
    loggedIn = true;
    messagesIn = await StreamController.broadcast();

    this.id = id;
    this.password = password;

    await setupChannel();

    //TODO get the wait until logged in working

    while(loggedIn == false){
      await Future.delayed(Duration(milliseconds : 100));
    }

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

      case Command.loginSuccess:
        loggedIn = true;
        secret = details;
        send(Command.loginSuccess);
        break;

      case Command.chat:
        var msg = ChatMessage.fromString(details);
        interface.chatMessages.add(msg);
        break;

      case Command.privateMessage:
        var msg = PrivateMessage.fromString(details);
        interface.privateMessages.add(msg);
        break;

    }

  }

  send(String message){
    serverChannel.sink(message);
  }

}