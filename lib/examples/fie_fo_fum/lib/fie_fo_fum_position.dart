

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/computer.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_dependency.dart';

import 'fie_fo_fum_injector.dart';
import 'move_fie.dart';
import 'move_fo.dart';
import 'move_fum.dart';
import 'move_number.dart';

class FieFoFumPosition extends Position{

  int count;

  get playerOrder => PlayerOrder.sequential;
  get dependency => FieFoFumInjector();

  get externalVariablesString => count.toString();

  initialiseExternalVariables() => count = 1;

  setExternalVariables(String string)=> count = int.parse(string);

  analyse() {}

  setUpNewPosition() => count ++;

  bool canPlay(String id) => (id == playerId);

  List<Move> getPossibleMoves() => [MoveNumber(), MoveFie(), MoveFo(), MoveFum()];

  double value(String playerId) => score[playerId];

}