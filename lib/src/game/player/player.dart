library player;

import 'dart:async';
import 'dart:isolate';


import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/player/computer.dart';
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

  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  set status (PlayerStatus newStatus) => game.position.playerStatus[id] = newStatus;

  PlayerStatus get status => game == null ? PlayerStatus.queuing : game.position.playerStatus[id];

  initialise(){

    game.position.playerStatus[id] = status;

    if(game.gameId == 'local game') status = PlayerStatus.ready;

  }

  moveUpdate(MakeMove move)=> game.confirmMove(id, move.number);


  yourTurn(){
    timer = Timer(Duration(milliseconds: (game.position.timeLeft[id] * 1000).round()), (){
      outOfTime();
    });

    stopwatch.reset();
    stopwatch.start();

  }

  stopTimer(){
    stopwatch.stop();
    timer?.cancel();
    game.position.timeLeft[id] -= stopwatch.elapsed.inSeconds;
  }

  wait(){  }

  gameStarted(String gameId){}

  outOfTime(){
    game.position.playerStatus[id] = PlayerStatus.out;
    game.position.nextPlayer();
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