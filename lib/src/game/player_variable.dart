import 'package:game_server/src/game/player.dart';
import 'package:game_server/src/game/position.dart';

class PlayerVariable<T>{

  final Position position;
  final T startingValue;
  List<T> _variable;

  PlayerVariable(this.position, this.startingValue){
    _variable = new List(position.players.length);

    for(int i = 0 ; i < position.players.length ; i ++){
      _variable[i] = startingValue;
    }
  }

  operator [](Player player) => _variable[player.number];

  operator []=(Player player, T value) => _variable[player.number] = value;



}