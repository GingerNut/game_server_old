import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/interface/local_interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'fie_fo_fum_game.dart';

class FieFoFumLocalInterface extends LocalInterface{

  getGame(NewGame settings) => FieFoFumGame(this, settings);




}