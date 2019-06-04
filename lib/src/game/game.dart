

import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'package:game_server/src/game/board/board.dart';
import 'game_host.dart';
import 'move.dart';

abstract class Game {

  final NewGame settings;
  final GameHost host;

  GameState state = GameState.waitingForPlayers;


  Board board;
  PlayerList get players => settings.players;

  Game(this.host, this.settings);

  int get numberOfPlayers => players.length;

  Position position;

  String get id => settings.id;
  String get displayName => settings.displayName;

  List<Move> history = new List();

  String get string;

  setup() async {}

  Future initialise() async{
    position = getPosition();
    position.setupFirstPosition();

    for (int i = 0; i < numberOfPlayers; i ++) {
      for (int i = 0; i < numberOfPlayers; i ++) {
        Player player = players[i];
        player.game = this;
        player.number = i;
        player.gameId = settings.id;
        player.status = PlayerStatus.waiting;
      }
    }

    state = GameState.waitingForAllReady;

    position.analyse();
    history.clear();

    await waitForAllReady();

    state = GameState.inPlay;

    players.forEach((p) => p.status = PlayerStatus.playing);

    position.player.yourTurn();
    return;
  }


  Future waitForAllReady()async{
    bool allReady = false;

    players.forEach((p) => p.initialise());

    while(allReady == false){

      await Future.delayed(Duration(milliseconds : 100));

      allReady = true;

      players.forEach((p) {
        if(p.status != PlayerStatus.ready) allReady = false;
      });

    }

    return;
  }

  getPosition();

  Message makeMove(Move move) {
    Message response = move.check(position);

    if(response is GameError) return response;

    position.makeMove(move);
    position.analyse();
    position.checkWin();
    history.add(move);

    if(players.playersLeft < 2 && players.length > 1){
      position.winner = players.winner;
      if(position.winner == null ) {
        state = GameState.drawn;
      }
      else {
        state = GameState.won;
      }
    }

    if (state == GameState.inPlay) {
      position.setNextPlayer();
      position.setUpNewPosition();
      position.player.yourTurn();
    }
    return Success();
  }

  tidyUp(){

    players.forEach((p)=> p.tidyUp());

  }


}

enum GameState{
  none,
  waitingForPlayers,
  waitingForAllReady,
  inPlay,
  paused,
  won,
  drawn
}