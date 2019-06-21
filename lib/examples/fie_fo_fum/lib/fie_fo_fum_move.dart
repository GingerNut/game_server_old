

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'fie_fo_fum_position.dart';

abstract class FieFoFumMove extends Move<FieFoFumPosition>{

  doCheck(FieFoFumPosition position) => Success();

  doMove(FieFoFumPosition position);

}

