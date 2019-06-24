library game;

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:game_server/src/design/design.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';
import 'package:game_server/src/interface/interface.dart';

import 'package:game_server/src/messages/message.dart';

part 'move.dart';
part 'move_builder.dart';
part 'position.dart';
part 'position_builder.dart';
part 'settings.dart';
part 'server_player.dart';
part 'game_dependency.dart';

part 'board/notation.dart';
part 'board/board.dart';
part 'board/markings.dart';
part 'board/piece.dart';
part 'board/tile.dart';

part 'player/computer.dart';
part 'player/computer_player.dart';
part 'player/isolate.dart';
part 'player/player.dart';
part 'player/player_variable.dart';
part 'player/server_player.dart';


class Game {
  GameState state = GameState.waitingForPlayers;
  GameDependency dependency;

  String gameId;
  String displayName;
  bool timer;
  bool playerHelp;
  double gameTime;
  double moveTime;
  List<Player> players;
  String firstPlayer;

  Board board;

  Game.fromNewGame(this.dependency, NewGame newGame){
    timer = dependency.settings.timer;
    playerHelp = dependency.settings.playerHelp;
    gameTime = dependency.settings.gameTime;
    moveTime = dependency.settings.moveTime;

    this.players = newGame.players;
    this.gameId = newGame.id;
    this.displayName = newGame.displayName;

    if(newGame.firstPlayer != null) this.firstPlayer = newGame.firstPlayer;
    if(newGame.playerHelp != null) this.playerHelp = newGame.playerHelp;
    if(newGame.timer != null) this.timer = newGame.timer;
    if(newGame.gameTime != null) this.gameTime = newGame.gameTime;
    if(newGame.moveTime != null) this.moveTime = newGame.moveTime;
  }

  int get numberOfPlayers => players.length;

  Position _position;

  Position get position => _position;

  List<Move> history = new List();
  List<Player> unconfirmed = new List();

  setup() async {}

  Future initialise() async{
    _position = dependency.getPosition();

    List<String> playerIds = List();
    List<String> playerQueue = List();

      for (int i = 0; i < numberOfPlayers; i ++) {
        Player player = players[i];
        player.game = this;
        player.gameId = gameId;
        playerIds.add(player.id);
        playerQueue.add(player.id);
      }
      
      _position.playerIds = playerIds;
    _position.playerQueue = playerQueue;

    _position.initialise();

    _position.setTimers(gameTime);

    players.forEach((p) => p.status = PlayerStatus.ingameNotReady);

    _position.setFirstPlayer(firstPlayer);

    _position.analyse();

    state = GameState.waitingForAllReady;

    history.clear();

    await waitForAllReady();

    state = GameState.inPlay;

    players.forEach((p) => p.status = PlayerStatus.playing);

    players.forEach((p) => p.gameStarted(gameId));

    Player player =  players.firstWhere((p) => p.id ==_position.playerId);

    _position.timeLeft[player.id] += moveTime;

    player.yourTurn();

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

  Future makeMove(Move move, String gameId, String playerId) async{
    Message response = move.check(_position);

    if(gameId != gameId ) response == GameError('game id incorrect');

    if(playerId != _position.playerId) response == GameError('player id incorrect');

    if(response is GameError) {
      print(response.text);
      return response;
    }

    players.forEach((p) => p.stopTimer());

    MakeMove update = MakeMove(gameId, playerId, move, _position.nextMoveNumber);

    _position.makeMove(move);

    history.add(move);

    if(_position.gameOver){
      if(_position.winner == null ) {
        state = GameState.drawn;
      }
      else {
        state = GameState.won;
      }
    }

    _setUnconfirmed();

    players.forEach((p) => p.moveUpdate(update));

    while(unconfirmed.isNotEmpty){
      await Future.delayed(Duration(milliseconds : 10));
    }

    if (state == GameState.inPlay) {
      players.firstWhere((p) => p.id ==_position.playerId).yourTurn();
    }

    return Success();
  }

  _setUnconfirmed(){
    players.forEach((p){

      if(_position.playerStatus[p.id] == PlayerStatus.playing) unconfirmed.add(p);

    });
  }

  confirmMove(String playerId, int move){

    if(_position.lastMove.number == move){

      unconfirmed.retainWhere((p){

        return(p.id == playerId);
      });
    }
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
