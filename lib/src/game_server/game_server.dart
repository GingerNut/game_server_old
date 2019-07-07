library game_server;

import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';

part 'server_player.dart';
part 'advert_list.dart';

class GameServer{

  final GameDependency injector;

  Database db = Database();

  List<ServerConnection> _connections = List();
  List<ServerPlayer> __playersOnline = List();
  AdvertList _adverts = AdvertList();
  Set<Game> _games = new Set();

  GameServer(this.injector);


  int get numberOfClients => __playersOnline.length;

  List get _players => __playersOnline;

  List<String> get playersOnlineList {

    List<String> playersOnline = new List();

    __playersOnline.forEach((p) => playersOnline.add(p.displayName));

    return playersOnline;
  }

  bool clientWithLogin(String id) => __playersOnline.any((p) => (p.id == id));

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

    ServerPlayer player;

    __playersOnline.forEach((p) {
      if(p.id == connection.id) {
//        p.connection.send(ConnectionSuperseded);
        //TODO superseding connection

        p.connection.close();
        p.connection = connection;
        connection.player = p;
        player = p;
      }
    });

    if(player == null) {
      player = ServerPlayer(connection.id);
      player.connection = connection;
      player.displayName = connection.displayName;
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
      m.connection.send(message);
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

  requestMove(MakeMove makeMove){

    Move move = makeMove.build(injector.getMoveBuilder());

    Game game = _games.firstWhere((g) {
       return (g.gameId == makeMove.gameId);
    } );

    String playerId = makeMove.playerId;

    if(game.position.canPlay(playerId)) game.makeMove(move, makeMove.gameId, makeMove.playerId);

  }

  confirmMove(ConfirmMove confirm){

    Game game = _games.firstWhere((g){
      return(g.gameId == confirm.gameId);
    });

    game.confirmMove(confirm.playerId, confirm.number);

  }

  addGeneralChat(ChatMessage message){

    broadcast(message);

  }

  addPrivateMessage(PrivateMessage message){
    ServerPlayer to;
    ServerPlayer from;

    _players.forEach((p) {
      if(p.id == message.to) to = p;
      if(p.id == message.from) from = p;
    });

    if(to != null) {
      to.connection.send(message);
      if(from != null) from.connection.send(message);

    } else {
      if(from != null) from.connection.send(PrivateMessage('server', from.id, message.to + ' is not online'));
    }



  }

  @override
  getGame(NewGame settings) => injector.getGame(settings);

  @override
  set injector(GameDependency _injector) {
    // TODO: implement injector
  }




}