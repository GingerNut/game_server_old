import 'package:game_server/src/game/player/player.dart';

import '../position.dart';

class PlayerVariable<T>{

  // supported types - int, double, playerStatus, bool

  static const String integerString = 'igr';
  static const String doubleString = 'dbl';
  static const String playerStatusString = 'pls';
  static const String playerStatusBool = 'boo';

  final List<String> playerIds;

  T startingValue;
  List<T> _variable;
  static const String internalDelimiter = ',';

  PlayerVariable(this.playerIds, this.startingValue){
    _variable = new List(playerIds.length);

    for(int i = 0 ; i < playerIds.length ; i ++){
      _variable[i] = startingValue;
    }
  }

  PlayerVariable.fromList(this.playerIds, List<T> values){
    _variable = new List(playerIds.length);

    playerIds.forEach((p){

      int index = playerIds.indexOf(p);

      _variable[index] = values[index];

    });

  }

  static PlayerVariable playerVariablefromString(List<String> playerIds, String string){

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

      case playerStatusBool: values = List<bool>(number);
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

        case playerStatusBool: values[i] = (details[2 + i]) == 'TRUE';
        break;
      }

    }


    switch(type){
      case integerString:  return PlayerVariable<int>.fromList(playerIds, values);
    break;

    case doubleString: return PlayerVariable<double>.fromList(playerIds, values);
    break;

    case playerStatusString: return PlayerVariable<PlayerStatus>.fromList(playerIds, values);
    break;

    case playerStatusBool: return PlayerVariable<bool>.fromList(playerIds, values);
    break;

  }



  }

  operator [](String playerId) => _variable[playerIds.indexOf(playerId)];

  operator []=(String playerId, T value) => _variable[playerIds.indexOf(playerId)] = value;

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

        case bool: string += v == true ? 'TRUE' : 'FALSE';
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
      case bool: return playerStatusBool;
      default: return '';
    }
  }

  printVariable(){

    print(string);

  }

}
