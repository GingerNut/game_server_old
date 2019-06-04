


// multiples of 5

import 'package:game_server/src/game/player.dart';

import 'test_move.dart';
import 'test_position.dart';

class MoveFo extends TestMove{
  static const String type ='fo';

  String toString() => type;



  doMove(TestPosition position) {
    bool moveOk = false;
    int test = position.count;
    if(test % 3 != 0 && test % 5 == 0) moveOk = true;
    if(!moveOk) position.player.playerStatus = PlayerStatus.out;
  }





}