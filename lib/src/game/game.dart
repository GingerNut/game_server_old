
import 'dart:math';


import 'package:game_server/src/command/new_game.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/response/game_error.dart';
import 'package:game_server/src/response/response.dart';
import 'package:game_server/src/response/success.dart';

import 'board.dart';
import 'move.dart';

abstract class Game {

  final NewGame settings;

  GameState _state = GameState.waitingForPlayers;

  set state(GameState newState){
    _state = newState;
  }

  GameState get state =>_state;

  Board board;

  Game(this.settings);

  int get numberOfPlayers => settings.numberOfPlayers;
  Position position;
  PlayerList get players => settings.players;
  String get id => settings.id;
  String get displayName => settings.displayName;

  List<Move> history = new List();

  bool get gameOver => position.winner != null;

  String get string;

  setup() async {}

  Future<Response> initialise() async{
    position = getPosition();
    position.setupFirstPosition();

    for (int i = 0; i < numberOfPlayers; i ++) {
      for (int i = 0; i < numberOfPlayers; i ++) {
        Player player = players[i];

        player.game = this;
        player.number = i;
        player.gameId = settings.id;
        player.playerStatus = PlayerStatus.playing;
      }
    }

    _state = GameState.waitingForAllReady;

    await waitForAllReady();

    position.analyse();

    history.clear();

    _state = GameState.started;

    Response response = Success();

    position.player.yourTurn(position);

    return response;
  }


  Future<Response> waitForAllReady()async{
    players.forEach((p) => p.playerStatus =  PlayerStatus.playing);
    return Success();
  }

  getPosition();

  Response makeMove(Move move) {
    Response response = move.check(position);

    if(response is GameError) return response;

    position.makeMove(move);
    position.analyse();
    position.checkWin();
    history.add(move);

    if (!gameOver) {
      position.setNextPlayer();
      position.setUpNewPosition();
      position.player.yourTurn(position);
    }
    return Success();
  }


}

enum GameState{
  none,
  waitingForPlayers,
  waitingForAllReady,
  started,
  paused,
  finished
}