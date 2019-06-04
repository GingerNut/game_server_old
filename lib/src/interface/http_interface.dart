

import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/interface/interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';

abstract class HttpInterface extends Interface{

//TODO advertise and join server games

  Position position;

  startGame(NewGame newgame){}

}