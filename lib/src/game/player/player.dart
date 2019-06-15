library player;

import 'dart:async';
import 'dart:isolate';


import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/messages/command/game_started.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/send_position.dart';
import 'package:game_server/src/messages/command/setId.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';
import 'package:game_server/src/messages/command/your_turn.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/confirm_move.dart';

import '../game.dart';
import '../game_timer.dart';
import '../position.dart';


part 'computer_player.dart';
part 'server_player.dart';


class Player{
  static const int human = 0;
  static const int computer = 1;
  static const int internet = 2;

  Game game;
  String id;
  String displayName;
  String gameId;

  set status (PlayerStatus newStatus) => game.position.playerStatus[id] = newStatus;

  PlayerStatus get status => game == null ? PlayerStatus.queuing : game.position.playerStatus[id];

  GameTimer timer;

  double get timeLeft => game.position.timeLeft(this);

  initialise(){
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    game.position.playerStatus[id] = status;

    if(game.id == 'local game') status = PlayerStatus.ready;

    //TODO get timer working

  }

  moveUpdate(MakeMove move){

      game.confirmMove(id, move.number);
  }


  yourTurn(){


  }



  wait(){

  }

  gameStarted(String gameId){}

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