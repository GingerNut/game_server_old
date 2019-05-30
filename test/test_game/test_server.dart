import 'package:game_server/game_server.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'test_game.dart';

class TestServer extends GameServer{

  getGame(NewGame settings) => TestGame(this,settings);



}