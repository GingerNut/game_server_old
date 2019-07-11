

import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/messages/message.dart';

import '../../game_server.dart';

class HttpInterface extends Interface{


  String id = 'Player';
  String password = '';

  HttpInterface(GameDependency dependency) : super(dependency);
  ClientConnection connection;
  PlayerStatus _status;
  AdvertList adverts = AdvertList();
  List<ChatMessage> chatMessages = List();
  List<PrivateMessage> privateMessages = List();

  login(String id, String password){
    this.id = id;
    this.password = password;
  }

  logout(){
    connection.send(Logout(id));
    connection.close();
  }

  advertiseGame()=> connection.send(NewGame.fromSettings(dependency.settings));

  joinGame(NewGame game)=> connection.send(JoinGame(game));

  startGame(NewGame game)=> connection.send(StartGame(game));

  setPosition(SendPosition sendPosition) {
    position = sendPosition.build(dependency.getPositionBuilder());
    position.lastMove = StartingPosition(position.json);
  }

  set status (PlayerStatus status) {
    bool changed = false;

    if(_status != status) changed = true;

    _status = status;

    if (changed) connection.send(SetStatus(status));
  }

  doMove(MakeMove makeMove){
    Move move = makeMove.getMove(dependency);
    position.makeMove(move);
  }

  PlayerStatus get status => _status;

  sendChat(String text) async => connection.send(ChatMessage(id, text));

  sendMessage(String to, String text) => connection.send(PrivateMessage(id, to, text));

  tryMove (Move move){}

}