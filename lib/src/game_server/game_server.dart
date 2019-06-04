

import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'advert_list.dart';


abstract class GameServer implements GameHost{

  Database db = Database();

  List<ServerConnection> _connections = List();
  PlayerList __playersOnline = PlayerList();
  AdvertList _adverts = AdvertList();
  Set<Game> _games = new Set();

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

    Player player;

    __playersOnline.forEach((p) {
      if(p.id == connection.id) {
        p.connection.send(Command.connectionSuperseded);
        //TODO superseding connection
        p.connection.close();
        p.connection = connection;
        connection.player = p;
        player = p;
      }
    });

    if(player == null) {
      player = Player.server(connection.id);
      player.connection = connection;
      connection.player = player;
      __playersOnline.add(player);
    }

  }

  removeMember(ServerConnection con){
    if(con.player != null) __playersOnline.remove(con.player);
  }

  reset(){
    __playersOnline.clear();
  }

  broadcast(Message message){

    _players.forEach((m) {
      m.connection.send(message.string);
    });
  }

  advertiseGame(NewGame advert) {
    _adverts.add(advert);

    broadcast(advert);
  }

  Future<Message> joinGame(Player player, String gameId)async{
      NewGame advert = _adverts.getAdvertrWithId(gameId);

      Message response = await advert.requestJoin(player);

      return response;
  }

  Future<Message> startGame(String gameId) async{
    NewGame advert = _adverts.getAdvertrWithId(gameId);

    if(advert.players.length < advert.maxPlayers) return GameError('game not yet full');

    _adverts.remove(advert);

    Game game = getGame(advert);

    game.initialise();

    _games.add(game);

    return Success();
  }

  addGeneralChat(ChatMessage message){

    broadcast(message);

  }

  addPrivateMessage(PrivateMessage message){
    Player to;
    Player from;

    _players.forEach((p) {
      if(p.id == message.to) to = p;
      if(p.id == message.from) from = p;
    });

    if(to != null) {
      to.connection.send(message.string);
      if(from != null) from.connection.send(message.string);

    } else {
      if(from != null) from.connection.send(PrivateMessage('server', from.id, message.to + ' is not online').string);
    }



  }




}