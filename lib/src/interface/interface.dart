


import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/messages/message.dart';

abstract class Interface{
  String id = 'Player';
  String password = '';

  ClientConnection connection;
  Position position;
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

}