

import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'package:game_server/src/game/board/board.dart';
import '../game_dependency.dart';
import 'move.dart';

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

  Position position;

  List<Move> history = new List();
  List<Player> unconfirmed = new List();

  setup() async {}

  Future initialise() async{
    position = dependency.getPosition();
    List<String> playerIds = List();
    List<String> playerQueue = List();

      for (int i = 0; i < numberOfPlayers; i ++) {
        Player player = players[i];
        player.game = this;
        player.gameId = gameId;
        playerIds.add(player.id);
        playerQueue.add(player.id);
      }
      
      position.playerIds = playerIds;
    position.playerQueue = playerQueue;

    position.initialise();

    position.setTimers(gameTime);

    players.forEach((p) => p.status = PlayerStatus.ingameNotReady);

    position.setFirstPlayer(firstPlayer);

    position.analyse();

    state = GameState.waitingForAllReady;

    history.clear();

    await waitForAllReady();

    state = GameState.inPlay;

    players.forEach((p) => p.status = PlayerStatus.playing);

    players.forEach((p) => p.gameStarted(gameId));

    Player player =  players.firstWhere((p) => p.id ==position.playerId);

    position.timeLeft[player.id] += moveTime;

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
    Message response = move.check(position);

    if(gameId != gameId ) response == GameError('game id incorrect');

    if(playerId != position.playerId) response == GameError('player id incorrect');

    if(response is GameError) {
      print(response.text);
      return response;
    }

    players.forEach((p) => p.stopTimer());

    MakeMove update = MakeMove(gameId, playerId, move, position.nextMoveNumber);

    position.makeMove(move);

    history.add(move);

    if(position.gameOver){
      if(position.winner == null ) {
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
      players.firstWhere((p) => p.id ==position.playerId).yourTurn();
    }

    return Success();
  }

  _setUnconfirmed(){
    players.forEach((p){

      if(position.playerStatus[p.id] == PlayerStatus.playing) unconfirmed.add(p);

    });
  }

  confirmMove(String playerId, int move){

    if(position.lastMove.number == move){

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
