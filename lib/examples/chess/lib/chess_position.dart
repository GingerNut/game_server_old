

import 'package:game_server/examples/chess/lib/pieces/chess_board.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_dependency.dart';

import 'chess_injector.dart';
import 'pieces/bishop.dart';
import 'pieces/king.dart';
import 'pieces/knight.dart';
import 'pieces/pawn.dart';
import 'pieces/queen.dart';
import 'pieces/rook.dart';

class ChessPosition extends Position{

  ChessBoard board;

  String whitePlayer;
  String blackPlayer;



  String get string => null;

  @override
  analyse() {

  }

  @override
  bool canPlay(String id) {


  }

  GameDependency get dependency => ChessInjector();

  String get externalVariablesString => null;

  List<Move> getPossibleMoves() {

  }

  initialiseExternalVariables() {
      board = ChessBoard();



  }



  printBoard(){

    print('  -------------------------------');

    for (int j = 7 ; j >= 0 ; j --){

      String string = ' | ';

      for (int i = 0 ; i < 8 ; i ++){
        Tile tile = board.tile(i, j);

        if (tile.pieces.isNotEmpty) string += tile.pieces.first.name;
        else string += ' ';

        string += ' | ';

      }

      print(string + '\n');

      print('  -------------------------------');

    }

    print('\n' +  '\n');
  }

  PlayerOrder get playerOrder => PlayerOrder.sequential;

  setExternalVariables(String string) {
    // TODO: implement setExternalVariables
    return null;
  }

  setFirstPlayer(String firstPlayer) {
   super.setFirstPlayer(firstPlayer);

   whitePlayer = playerQueue[0];
   blackPlayer = playerQueue[1];
  }

  @override
  setUpNewPosition() {

  }

  @override
  double value(String playerId) {
    // TODO: implement value
    return null;
  }




}
