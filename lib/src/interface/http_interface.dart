

import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/game_server/advert_list.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/messages/command/join_game.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/start_game.dart';

abstract class HttpInterface{

  Position position;
  Settings onlineSettings = Settings();

  String id = 'Player';
  String password = '';

  ClientConnection connection;
  PlayerStatus _status;
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

  joinGame(NewGame game)=> connection.send(JoinGame(game).string);

  startGame(NewGame game)=> connection.send(StartGame(game).string);

  set status (PlayerStatus status) {
    bool changed = false;

    if(_status != status) changed = true;

    _status = status;

    if (changed) connection.send(SetStatus(status).string);
  }

  PlayerStatus get status => _status;

  sendChat(String text) => connection.send(ChatMessage(id, text).string);

  sendMessage(String to, String text) => connection.send(PrivateMessage(id, to, text).string);


}