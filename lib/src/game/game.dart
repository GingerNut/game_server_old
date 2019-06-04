

import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/response/game_error.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'board.dart';
import 'game_host.dart';
import 'move.dart';

abstract class Game {

  final NewGame settings;
  final GameHost host;

  GameState _state = GameState.waitingForPlayers;

  set state(GameState newState){
    _state = newState;
  }

  GameState get state =>_state;

  Board board;
  PlayerList get players => settings.players;

  Game(this.host, this.settings);

  int get numberOfPlayers => players.length;
  Position position;
  String get id => settings.id;
  String get displayName => settings.displayName;

  List<Move> history = new List();

  bool get gameOver => position.winner != null;

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
        player.playerStatus = PlayerStatus.playing;
      }
    }

    _state = GameState.waitingForAllReady;

    position.analyse();
    history.clear();
    await waitForAllReady();

    _state = GameState.started;
    position.player.yourTurn(position);
    return;
  }


  Future waitForAllReady()async{
    bool allReady = false;



    players.forEach((p) => p.initialise());

    while(allReady == false){

      await Future.delayed(Duration(milliseconds : 100));

      allReady = true;

      players.forEach((p) {
        if(p.playerStatus != PlayerStatus.ready) allReady = false;
      });

    }

    return;
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