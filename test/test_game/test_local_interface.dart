import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/interface/local_interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'test_game.dart';

class TestLocalInterface extends LocalInterface{

  getGame(NewGame settings) => TestGame(this, settings);




}