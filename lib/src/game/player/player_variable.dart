import 'package:game_server/src/game/player/player.dart';

import '../position.dart';

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

  printVariable(){

    print(string);

  }

}
