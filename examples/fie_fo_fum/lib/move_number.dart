


// multiples of 3

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/response.dart';

import 'fie_fo_fum_move.dart';
import 'fie_fo_fum_position.dart';

class MoveNumber extends FieFoFumMove{
  static const String type ='num';

  String get string => type;


  Message doCheck(FieFoFumPosition position) {


  }

  doMove(FieFoFumPosition position) {
      bool moveOk = false;

      int test = position.count;
      if(test % 3 != 0 && test % 5 != 0) moveOk = true;
      if(!moveOk) position.playerStatus[position.playerId] = PlayerStatus.out;
      else position.score[position.playerId] ++;
  }




}