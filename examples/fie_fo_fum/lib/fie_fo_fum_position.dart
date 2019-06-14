

import 'package:game_server/src/game/move.dart';
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


  makeMove(Move move){

//    if(playerIds.any((s){
//      return (s.substring(0,3) == 'Com');
//    })){
//
//      if(!computer)print('from analyse '
//          + count.toString() + ' '
//          + playerQueue.toString() + ' '
//          + move.runtimeType.toString() + ''
//          + '\n');
//    }

    super.makeMove(move);
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

  bool canPlay(String id) {

    return (id == playerId) ;
  }


  setupFirstPosition() {


  }


}