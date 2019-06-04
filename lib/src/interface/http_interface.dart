

import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/game_server/advert_list.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/messages/command/new_game.dart';

abstract class HttpInterface{

  Position position;
  Settings onlineSettings = Settings();

  String id = 'Player';
  String password = '';

  ClientConnection connection;
  AdvertList adverts = new AdvertList();
  List<ChatMessage> chatMessages = List();
  List<PrivateMessage> privateMessages = List();

  login(String id, String password){
    this.id = id;
    this.password = password;
  }

  logout(){
    connection.send(Command.logout);
    connection.close();
  }

  advertiseGame()=> connection.send(NewGame.fromSettings(onlineSettings).string);

  joinGame(String GameId){


  }

  sendChat(String text) => connection.send(ChatMessage(id, text).string);

  sendMessage(String to, String text) => connection.send(PrivateMessage(id, to, text).string);


}