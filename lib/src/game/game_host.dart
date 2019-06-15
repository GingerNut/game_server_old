import 'package:game_server/src/messages/command/new_game.dart';

import '../game_dependency.dart';

mixin GameHost{

  getGame(NewGame settings);
}