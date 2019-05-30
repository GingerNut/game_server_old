

import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';

import 'advert.dart';

abstract class GameServer implements GameHost{

  Database db = Database();

  List<ServerConnection> _connections = List();
  PlayerList __playersOnline = PlayerList();
  List<Advert> _adverts = List();

  int get numberOfClients => __playersOnline.length;

  PlayerList get _players => __playersOnline;

  String get playersOnlineList{
    String string = '';

    for(int i = 0 ; i < __playersOnline.length ; i++){
      Player m = __playersOnline[i];
      string += m.connection.displayName;
      if(i < __playersOnline.length -1)string += Command.delimiter;
    }
    return string;
  }

  bool clientWithLogin(String id) => __playersOnline.containsPlayerId(id);

  addConnection(ServerConnection connection) async {
    await connection.initialise(this);
    connection.requestLogin();
    _connections.add(connection);
  }

  removeConnection(ServerConnection connection)async{
    _connections.remove(connection);
  }

  addMember(ServerConnection connection)async{
    _connections.remove(connection);

    Player member;

    __playersOnline.forEach((p) {
      if(p.id == connection.id) {
        p.connection.send(Command.connectionSuperseded);
        //TODO superseding connection
        p.connection.close();
        p.connection = connection;
        connection.player = p;
        member = p;
      }
    });

    if(member == null) {
      member = Player.server(connection.id);
      member.connection = connection;
      connection.player = member;
      __playersOnline.add(member);
    }

  }

  removeMember(ServerConnection con){
    if(con.player != null) __playersOnline.remove(con.player);
  }

  reset(){
    __playersOnline.clear();
  }

  addGeneralChat(ChatMessage message){

    String broadcast = message.string;

    _players.forEach((m) {
      m.connection.send(broadcast);
    });

  }

  addPrivateMessage(PrivateMessage message){
    Player to;
    Player from;

    _players.forEach((m) {
      if(m.id == message.to) to = m;
      if(m.id == message.from) from = m;
    });

    if(to != null) {
      to.connection.send(message.string);
      if(from != null) from.connection.send(message.string);

    } else {
      if(from != null) from.connection.send(PrivateMessage('server', from.id, message.to + ' is not online').string);
    }



  }




}