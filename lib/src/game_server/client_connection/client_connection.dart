


import 'dart:async';

import 'package:game_server/src/interface/http_interface.dart';
import 'package:game_server/src/game_server/channel/channel.dart';
import 'package:game_server/src/messages/message.dart';


enum LoginStatus {requesting, good, error}

abstract class ClientConnection implements ChannelHost{
  final HttpInterface interface;
  String id;
  String displayName;
  String password;
  String secret;
  StreamController<String> messagesIn;
  LoginStatus loginStatus;

  Channel serverChannel;
  List<String> clients = new List();

  ClientConnection(this.interface);


  Future login(String id, String password) async{
   loginStatus = LoginStatus.requesting;
    messagesIn = await StreamController.broadcast();

    this.id = id;
    this.password = password;

    await setupChannel();

    while(loginStatus == LoginStatus.requesting){
      await Future.delayed(Duration(milliseconds : 100));
    }

    if(loginStatus == LoginStatus.error) {
      serverChannel = null;
      this.id = null;
      this.password = null;
    }

    return;
  }

  close(){}

  setupChannel();

  handleJSON(String string){
    var message = Message.inflate(string);

    messagesIn.sink.add(string);

    switch(message.runtimeType){

      case RequestLogin:
        var login = Login(id, password);
        send(login);
        break;

      case PlayerList:
        clients = (message as PlayerList).players;
        break;

      case LoginSuccess:
        var login = message as LoginSuccess;
        loginStatus = LoginStatus.good;
        secret = login.playerSecret;
        displayName = login.displayName;
        send(login);
        break;

      case ChatMessage:
        var chat = message as ChatMessage;
        interface.chatMessages.add(chat);
        break;

      case PrivateMessage:
        var msg = message as PrivateMessage;
        interface.privateMessages.add(msg);
        break;

      case NewGame:
        interface.adverts.add(message);
        break;

      case SendPosition:
        SendPosition sendPosition = message as SendPosition;
        interface.setPosition(sendPosition);
        break;

      case MakeMove:
        MakeMove makeMove = message as MakeMove;
        interface.doMove(makeMove);
        send(ConfirmMove(makeMove.number, makeMove.gameId, interface.id));
        break;

      case GameError:
        var error = message as GameError;
        print (error.text);
        break;

    }

  }

  send(Message message){
    serverChannel.sink(message.json);
  }

}