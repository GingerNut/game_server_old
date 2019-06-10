import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/position.dart';

import '../message.dart';

abstract class SendGame extends Message{
  static const code = 'sng';

  Board board;
  Position position;
  List<Move> history;

  SendGame();

  SendGame.fromGame(Game game){

    board = game.board;
    position = game.position;
    history = game.history;
  }

  SendGame.fromString(String string);

  String get string {

    String string = '';
    string += code;
    string += board == null ? ' ' : board.string;
    string += delimiter;
    string += position.string;
    string += delimiter;
    string += history.length.toString();
    history.forEach((m) {
      string += m.string;
      string += delimiter;
    } );

    return string;

  }





}