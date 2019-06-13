

import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position_builder.dart';

import 'fie_fo_fum_position.dart';
import 'move_fie.dart';
import 'move_fo.dart';
import 'move_fum.dart';
import 'move_number.dart';

class FieFoFumPositionBuilder extends PositionBuilder{

  build(String string) {

    FieFoFumPosition position = FieFoFumPosition();

    position.count = int.parse(string);

    return position;

  }

}



