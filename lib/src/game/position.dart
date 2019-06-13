
import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'game.dart';
import 'move.dart';

abstract class Position{

  Move lastMove;


  List<String> playerIds;
  List<String> playerQueue;

  PlayerVariable<PlayerStatus> playerStatus;
  PlayerVariable<double> score;
  PlayerVariable<double> timeLeft;
  PlayerVariable<int> color;

  String get string;

  String get playerId => playerQueue[0];

  PlayerOrder get playerOrder;

  String winner;
  bool gameOver = false;

  bool canPlay(String id);

  makeMove(Move move){
    move.go(this);
    lastMove = move;

    analyse();
    checkWin();

    setNextPlayer();

    if(playerQueue.length < 2 && playerIds.length > 1){
      gameOver = true;

      if(playerQueue.length == 1) winner = playerQueue[0];

    }

    if (!gameOver) {
      setUpNewPosition();
    }
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

  static String playerStatusToString(PlayerStatus p){

    switch (p){
      case PlayerStatus.winner:
        return 'winner';

      case PlayerStatus.disconnected:
        return'disconnected';

      case PlayerStatus.out:
        return 'out';

      case PlayerStatus.ingameNotReady:
        return 'waiting';

      case PlayerStatus.ready:
        return 'ready';

      case PlayerStatus.playing:
        return 'playing';

      case PlayerStatus.queuing:
        return'queuing';
        break;
    }

  }

  static PlayerStatus playerStatusFromString(String string){
    switch (string){
      case 'winner':
        return PlayerStatus.winner;
        break;

      case 'disconnected':
        return PlayerStatus.disconnected;
        break;

      case 'out':
        return PlayerStatus.out;
        break;

      case 'waiting':
        return PlayerStatus.ingameNotReady;
        break;

      case 'ready':
        return PlayerStatus.ready;
        break;

      case 'playing':
        return PlayerStatus.playing;
        break;

      case 'queuing':
        return PlayerStatus.queuing;
        break;
    }

  }

}

class PlayerVariable<T>{

  static const String integerString = 'igr';
  static const String doubleString = 'dbl';
  static const String playerStatusString = 'pls';

  final Position position;
  T startingValue;
  List<T> _variable;
  static const String internalDelimiter = ',';

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

  static PlayerVariable playerVariablefromString(Position position, String string){

    List<String> details = string.split(PlayerVariable.internalDelimiter);

    String type = details[0];
    int number = int.parse(details[1]);

    List values;

    switch(type){
      case integerString:  values = List<int>(number);
        break;

      case doubleString: values = List<double>(number);
        break;

      case playerStatusString: values = List<PlayerStatus>(number);
        break;
    }

    for(int i = 0 ; i < number ; i ++){
      switch(type){
        case integerString: values[i] = int.parse(details[2 + i]);
          break;

        case doubleString: values[i] = double.parse(details[2 + i]);
          break;

        case playerStatusString: values[i] = Position.playerStatusFromString(details[2 + i]);
          break;
      }

    }


    switch(type){
      case integerString:  return PlayerVariable<int>.fromList(position, values);
      break;

      case doubleString: return PlayerVariable<double>.fromList(position, values);
      break;

      case playerStatusString: return PlayerVariable<PlayerStatus>.fromList(position, values);
      break;

    }



  }

  operator [](String playerId) => _variable[position.playerIds.indexOf(playerId)];

  operator []=(String playerId, T value) => _variable[position.playerIds.indexOf(playerId)] = value;

  String get string {
    String string = '';

    string += type;
    string += internalDelimiter;
    string += _variable.length.toString();
    string += internalDelimiter;

    _variable.forEach((v){

      switch(T){
        case int: string += (v as int).toString();
        break;

        case double: string += (v as double).toString();
        break;

        case PlayerStatus: string += Position.playerStatusToString(v as PlayerStatus);
          break;
      }

      string += internalDelimiter;
    });

    return string;
  }

  String get type{

    switch(T){
      case int: return integerString;
      case double: return doubleString;
      case PlayerStatus:
        return playerStatusString;
      default: return '';
    }
  }
}

enum PlayerOrder{
  sequential,
  random,
  firstToPlay,
  highestScore,
  lowestScore
}


