import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Pawn extends ChessPiece{

  Pawn(Board board) : super(board){
    name = 'P';
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    int direction = chessColor == ChessColor.white ? Board.North : Board.South;

      Tile nextTile = tile.nextInDirection(direction);
      if(nextTile != null){
        moves.add(nextTile);

        if(tile == startingPosition){

        nextTile = nextTile.nextInDirection(direction);

        if(nextTile != null) moves.add(nextTile);

        }
      }
    return moves;
}


}