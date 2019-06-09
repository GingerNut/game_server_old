

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

  set status (PlayerStatus newStatus) {
    bool changed = false;

    if(status != newStatus) changed = true;

    game.position.playerStatus[id] = newStatus;

    if (changed && connection != null) connection.send(SetStatus(newStatus).string);
  }

  PlayerStatus get status => game == null ? PlayerStatus.queuing : game.position.playerStatus[id];

  GameTimer timer;

  double get timeLeft => game.position.timeLeft(this);

  Player();

  Player.server(this.id);

  initialise(){
    color = Palette.defaultPlayerColours[number];
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    game.position.playerStatus[id] = status;

    if(game.id == 'local game') status = PlayerStatus.ready;

    //TODO get timer working

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

  tidyUp(){}


}


enum PlayerStatus{
  queuing,
  winner,
  disconnected,
  out,
  ingameNotReady,
  ready,
  playing
}