

import 'package:game_server/src/game/palette.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/your_turn.dart';

import 'game.dart';
import 'game_timer.dart';

class Player{
  static const int human = 0;
  static const int computer = 1;
  static const int internet = 2;

  Game game;
  String id;
  String displayName;
  String gameId;
  ServerConnection connection;

  int number;
  int color;
  String reasonOut;
  double score;

  PlayerStatus _status = PlayerStatus.waiting;

  set status (PlayerStatus status) {
    bool changed = false;

    if(_status != status) changed = true;

    _status = status;
    if (changed && connection != null) connection.send(SetStatus(status).string);
  }

  PlayerStatus get status => _status;

  GameTimer timer;

  double get timeLeft => timer.timeLeft;

  Player();

  Player.server(this.id);

  initialise(){
    color = Palette.defaultPlayerColours[number];
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    if(game.id == 'local game') status = PlayerStatus.ready;

  }


  yourTurn(){
    if(connection != null) connection.send(YourTurn(gameId).string);
  }

  sendMessage(String string){}

  wait(){

  }

  outOfTime(){
    Position position = game.position;

    status = PlayerStatus.out;
    position.checkWin();
  }


}


enum PlayerStatus{
  winner,
  disconnected,
  out,
  waiting,
  ready,
  playing
}