

import 'package:game_server/src/game/position.dart';

import 'fie_fo_fum_position_builder.dart';

class FieFoFumPosition extends Position{

  int count = 1;
  get playerOrder => PlayerOrder.sequential;

  get positionBuilder => FieFoFumPositionBuilder();

  String get string{

    String string = '';
    string += count.toString();
    return string;
  }


  analyse() {

  }


  checkWin() {

  }


  setUpNewPosition() {
    count ++;
  }

  setFirstPlayer(){

  }

  bool canPlay(String id) => id == playerId;


  setupFirstPosition() {


  }


}