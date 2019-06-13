

import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'package:game_server/src/game/board/board.dart';
import 'game_host.dart';
import 'move.dart';

abstract class Game {
  GameState state = GameState.waitingForPlayers;
  final NewGame settings;
  final GameHost host;

  Board board;
  List get players => settings.players;

  Game(this.host, this.settings);

  int get numberOfPlayers => players.length;

  Position _position;
  get position => _position;

  String get id => settings.id;
  String get displayName => settings.displayName;

  List<Move> history = new List();

  String get string;

  setup() async {}

  Future initialise() async{
    _position = getPosition();
    _position.gameId = settings.id;

    List<String> playerIds = List();
    List<String> playerQueue = List();

      for (int i = 0; i < numberOfPlayers; i ++) {
        Player player = players[i];
        player.game = this;
        player.gameId = settings.id;
        playerIds.add(player.id);
        playerQueue.add(player.id);
      }

      _position.playerIds = playerIds;
    _position.playerQueue = playerQueue;
    _position.initialise(settings);

    players.forEach((p) => p.status = PlayerStatus.ingameNotReady);

    _position.setFirstPlayer();

    _position.analyse();

    state = GameState.waitingForAllReady;

    history.clear();

    await waitForAllReady();

    state = GameState.inPlay;

    players.forEach((p) => p.status = PlayerStatus.playing);

    players.forEach((p) => p.gameStarted(id));

    players.firstWhere((p) => p.id ==_position.playerId).yourTurn();
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
    Message response = move.check(_position);

    if(response is GameError) return response;

    _position.makeMove(move);

    history.add(move);

    if(position.gameOver){
      if(position.winner == null ) {
        state = GameState.drawn;
      }
      else {
        state = GameState.won;
      }
    }

    players.forEach((p) => p.moveUpdate(MakeMove(settings.id, position.playerId, move)));

    if (state == GameState.inPlay) {
      players.firstWhere((p) => p.id ==_position.playerId).yourTurn();
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
