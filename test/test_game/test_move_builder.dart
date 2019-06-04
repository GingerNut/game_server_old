

import 'package:game_server/src/game/move_builder.dart';

import 'move_fie.dart';
import 'move_fo.dart';
import 'move_fum.dart';
import 'move_number.dart';

class TestMoveBuilder extends MoveBuilder{

  build(String string) {

    switch(string){
      case 'fie' : return MoveFie();
      case 'fo' : return MoveFo();
      case 'fum' : return MoveFum();
      case 'num' : return MoveNumber();
    }
    return null;
  }

}



