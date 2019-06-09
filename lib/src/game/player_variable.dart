import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/position.dart';

class PlayerVariable<T>{

  final Position position;
  final T startingValue;
  List<T> _variable;

  PlayerVariable(this.position, this.startingValue){
    _variable = new List(position.playerIds.length);

    for(int i = 0 ; i < position.playerIds.length ; i ++){
      _variable[i] = startingValue;
    }
  }

  operator [](String playerId) => _variable[position.playerIds.indexOf(playerId)];

  operator []=(String playerId, T value) => _variable[position.playerIds.indexOf(playerId)] = value;



}