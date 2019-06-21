import 'package:game_server/examples/chess/lib/chess_injector.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

import 'chess_piece.dart';

class Knight extends ChessPiece{

  Knight(Board board) : super(board){
    name = 'N';
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    Tile first;
    Tile second;

    first = tile.nextInDirection(Board.North);
    if(first != null) {
      second = first.nextInDirection(Board.North_West);
      if(second != null) moves.add(second);

      second = first.nextInDirection(Board.North_East);
      if(second != null) moves.add(second);
    }

    first = tile.nextInDirection(Board.South);
    if(first != null) {
      second = first.nextInDirection(Board.South_West);
      if(second != null) moves.add(second);

      second = first.nextInDirection(Board.South_East);
      if(second != null) moves.add(second);
    }

    first = tile.nextInDirection(Board.East);
    if(first != null) {
      second = first.nextInDirection(Board.North_East);
      if(second != null) moves.add(second);

      second = first.nextInDirection(Board.South_East);
      if(second != null) moves.add(second);
    }

    first = tile.nextInDirection(Board.West);
    if(first != null) {
      second = first.nextInDirection(Board.North_West);
      if(second != null) moves.add(second);

      second = first.nextInDirection(Board.South_West);
      if(second != null) moves.add(second);
    }

    return moves;
  }


}