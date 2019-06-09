
import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/player_list.dart';
import 'package:game_server/src/game/player_variable.dart';

import 'game.dart';
import 'move.dart';

abstract class Position{

  final Game game;
  Move lastMove;

  List<String> playerIds;
  List<String> playerQueue;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;

  String toString(){

    String string = '';

    return string;
  }

  String get playerId => playerQueue[0];

  PlayerOrder get playerOrder;

  String winner;

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
        if(playerStatus[p] == PlayerStatus.playing) playerQueue.add(p);
        break;

      case PlayerOrder.random:
        String p = playerQueue[0];
        if(playerStatus[p] != PlayerStatus.playing) playerQueue.remove(p);
        playerQueue.shuffle();
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

