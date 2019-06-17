import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'chess_board.dart';
import 'chess_settings.dart';

class ChessInjector extends GameDependency{

  Uri get computerUri => null;


  Game getGame(NewGame newGame) {

  }

  Board getBoard() => ChessBoard();

  MoveBuilder getMoveBuilder() {

  }


  Position getPosition() {

  }

  PositionBuilder getPositionBuilder() {

  }

  Settings get settings => ChessSettings();





}