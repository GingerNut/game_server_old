import 'package:game_server/game_server.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'fie_fo_fum_game.dart';
import 'fie_fo_fum_move_builder.dart';

class FieFoFumServer extends GameServer{

  getGame(NewGame settings) => FieFoFumGame(this,settings);


  get moveBuilder => FieFoFumMoveBuilder();



}