import 'package:game_server/src/messages/command/new_game.dart';

import '../injector.dart';

mixin GameHost{

  Injector injector;

  getGame(NewGame settings);
}