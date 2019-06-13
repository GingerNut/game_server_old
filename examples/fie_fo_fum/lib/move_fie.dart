



// multiples of 3

import 'package:game_server/src/game/move.dart';

import 'fie_fo_fum_move.dart';
import 'fie_fo_fum_position.dart';

class MoveFie extends FieFoFumMove{
  static const String type ='fie';

  String get string => type;

  doMove(FieFoFumPosition position) {
      bool moveOk = false;

      int test = position.count;

      if(test % 3 == 0 && test % 5 != 0) moveOk = true;

      if(!moveOk) position.playerOut();
      else position.score[position.playerId] ++;

  }




}