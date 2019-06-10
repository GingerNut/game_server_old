


// multiples of 5

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player.dart';

import 'fie_fo_fum_move.dart';
import 'fie_fo_fum_position.dart';

class MoveFo extends FieFoFumMove{
  static const String type ='fo';

  String get string => Move.code + type;


  doMove(FieFoFumPosition position) {
    bool moveOk = false;
    int test = position.count;
    if(test % 3 != 0 && test % 5 == 0) moveOk = true;
    if(!moveOk) position.playerOut();
  }





}