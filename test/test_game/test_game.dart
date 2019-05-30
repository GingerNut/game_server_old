import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'test_position.dart';

class TestGame extends Game{
  TestGame(GameHost host, NewGame settings) : super(host, settings);

  getPosition() => TestPosition(this);

  @override
  // TODO: implement string
  String get string => null;



}