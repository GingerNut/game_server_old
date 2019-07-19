library game;

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:game_server/src/design/design.dart';
import 'package:game_server/src/messages/game_message/game_message.dart';
import 'package:game_server/src/messages/message.dart';

part 'navigation/game_event.dart';
part 'navigation/move.dart';
part 'navigation/move_builder.dart';
part 'navigation/start.dart';
part 'navigation/game_end.dart';
part 'position.dart';
part 'position_builder.dart';
part 'settings.dart';

part 'setting.dart';
part 'game_dependency.dart';

part 'board/tiles.dart';
part 'board/markings.dart';
part 'board/piece.dart';
part 'board/tile.dart';

part 'player/isolate_computer.dart';
part 'player/computer_player.dart';
part 'player/computer.dart';
part 'player/move_line.dart';
part 'player/move_queue.dart';
part 'player/move_tree.dart';
part 'player/player.dart';
part 'player/player_variable.dart';

part 'interface.dart';
part 'input.dart';
part 'local_interface.dart';
part 'local_player.dart';



class Game {
  GameState state = GameState.waitingForPlayers;
  GameDependency dependency;

  String gameId;
  String displayName;
  bool timer;
  bool randomStarter = true;
  bool playerHelp;
  double gameTime;
  double moveTime;
  int aiDepth;
  double thinkingTime;
  List<Player> players;
  String firstPlayer;

  Tiles board;

  Game.fromNewGame(this.dependency, NewGame newGame){
    timer = newGame.timer;
    playerHelp = newGame.playerHelp;
    gameTime = newGame.gameTime;
    moveTime = newGame.moveTime;
    randomStarter = newGame.randomStarter;

    players = newGame.players;
    gameId = newGame.id;
    displayName = newGame.displayName;

    if(newGame.firstPlayer != null) {
      firstPlayer = newGame.firstPlayer;
      randomStarter = false;
    }

    if(playerHelp == null) playerHelp = dependency.settings.playerHelp.value;
    if(timer == null) timer = dependency.settings.timer.value;
    if(gameTime == null) gameTime = dependency.settings.gameTime.value;
    if(moveTime == null) moveTime = dependency.settings.moveTime.value;
    if(aiDepth == null) aiDepth = dependency.settings.aiDepth.value;
    if(thinkingTime == null) thinkingTime = dependency.settings.thinkingTime.value;
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

    _position.setTimers(gameTime);

    _position.initialise();

    _position.setFirstPlayer(randomStarter, firstPlayer);

    players.forEach((p) => p.status = PlayerStatus.ingameNotReady);

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
