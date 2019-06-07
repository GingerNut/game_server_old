import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'fie_fo_fum_position.dart';

class FieFoFumGame extends Game{
  FieFoFumGame(GameHost host, NewGame settings) : super(host, settings);

  getPosition() => FieFoFumPosition(this);

  @override
  // TODO: implement string
  String get string => null;





}