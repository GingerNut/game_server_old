

import 'dart:collection';

import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/player_variable.dart';

import 'game.dart';
import 'move.dart';

abstract class Position{

  final Game game;
  Move lastMove;

  PlayerList get players => game.players;
//  int get playersLeft => players.playersLeft;
//  PlayerList get survivors => players.remainingPlayers;

  List<String> playerIds;
  List<String> playerQueue;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;

  String toString(){

    String string = '';

    return string;
  }

  String playerId;

  PlayerOrder get playerOrder;

  Player winner;

  Position(this.game);

  makeMove(Move move){
    move.go(this);
    lastMove = move;
  }

  playerOut() => playerStatus[playerId] = PlayerStatus.out;

  setNextPlayer(){

    switch(playerOrder){
      case PlayerOrder.sequential:
        String p = playerQueue.removeAt(0);
        playerId = playerQueue[0];
        playerQueue.add(p);
        break;
      case PlayerOrder.random:
        playerQueue.shuffle();
        playerId = playerQueue[0];
        break;
      case PlayerOrder.firstToPlay:
      // TODO: Handle this case.
        break;
      case PlayerOrder.highestScore:
      // TODO: Handle this case.
        break;
      case PlayerOrder.lowestScore:
      // TODO: Handle this case.
        break;
    }

  }

  initialise(){
    playerStatus = PlayerVariable(this, PlayerStatus.ingameNotReady);
    score = PlayerVariable(this, 0);
    timeLeft = PlayerVariable(this, game.settings.gameTime);
  }

  setFirstPlayer();

  setupFirstPosition();

  setUpNewPosition();

  analyse();

  checkWin();

}

