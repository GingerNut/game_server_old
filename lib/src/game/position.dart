
import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'move.dart';

abstract class Position{

  Move lastMove;

  List<String> playerIds;
  List<String> playerQueue;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;
  PlayerVariable<int> color;

  String toString(){

    String string = '';

    return string;
  }

  String get playerId => playerQueue[0];

  PlayerOrder get playerOrder;

  String winner;

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

  initialise(NewGame settings){
    playerStatus = PlayerVariable(this, PlayerStatus.ingameNotReady);
    score = PlayerVariable(this, 0);
    timeLeft = PlayerVariable(this, settings.gameTime);
    color = PlayerVariable.fromList(this, Palette.defaultPlayerColours);
  }

  setFirstPlayer();

  setupFirstPosition();

  setUpNewPosition();

  analyse();

  checkWin();

  findBestMove();

}

class PlayerVariable<T>{

  final Position position;
  T startingValue;
  List<T> _variable;

  PlayerVariable(this.position, this.startingValue){
    _variable = new List(position.playerIds.length);

    for(int i = 0 ; i < position.playerIds.length ; i ++){
      _variable[i] = startingValue;
    }
  }

  PlayerVariable.fromList(this.position, List<T> values){
    _variable = new List(position.playerIds.length);

    position.playerIds.forEach((p){

      int index = position.playerIds.indexOf(p);

      _variable[index] = values[index];

    });

  }

  operator [](String playerId) => _variable[position.playerIds.indexOf(playerId)];

  operator []=(String playerId, T value) => _variable[position.playerIds.indexOf(playerId)] = value;


}

enum PlayerOrder{
  sequential,
  random,
  firstToPlay,
  highestScore,
  lowestScore
}

