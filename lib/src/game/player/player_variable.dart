import 'package:game_server/src/game/player/player.dart';

import '../position.dart';

class PlayerVariable<T>{

  // supported types - int, double, playerStatus, bool

  static const String integerString = 'igr';
  static const String doubleString = 'dbl';
  static const String playerStatusString = 'pls';
  static const String playerStatusBool = 'boo';

  List<String> playerIds;

  T startingValue;
  List<T> _variable;
  static const String internalMajorDelimiter = '\n';
  static const String internalMinorDelimiter = ',';

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

  static PlayerVariable playerVariablefromString(String string){

    List<String> sections = string.split(PlayerVariable.internalMajorDelimiter);

    String type = sections[0];

    List<String> playerIds = sections[1].split(internalMinorDelimiter);

    int number = int.parse(sections[2]);

    List<String> details = sections[3].split(PlayerVariable.internalMinorDelimiter);


    List values;

    switch(type){
      case integerString: values = List<int>(number);
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
        case integerString: values[i] = int.parse(details[i]);
        break;

        case doubleString: values[i] = double.parse(details[i]);
        break;

        case playerStatusString: values[i] = Position.playerStatusFromString(details[i]);
        break;

        case playerStatusBool: values[i] = (details[i]) == 'TRUE';
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

    string += internalMajorDelimiter;

    string += playerIds.join(internalMinorDelimiter);

    string += internalMajorDelimiter;

    string += _variable.length.toString();

    string += internalMajorDelimiter;

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

      string += internalMinorDelimiter;
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
