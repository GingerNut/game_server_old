import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';

abstract class ChessPiece extends Piece{
  ChessPiece(Board board) : super(board);

  ChessColor chessColor;

  bool isFriendly(Piece piece)=> chessColor == (piece as ChessPiece).chessColor;

  search(List<Tile> moves, int direction){
    Tile nextTile = tile.nextInDirection(direction);


    while(nextTile != null){

      var tileOccupation = nextTile.tileOccupation(this);

      switch(tileOccupation){


        case OccupationStatus.neutral:
          moves.add(nextTile);
          nextTile = nextTile.nextInDirection(direction);
          break;

        case OccupationStatus.friendly:
          nextTile = null;
          break;

        case OccupationStatus.enemy:
          moves.add(nextTile);
          nextTile = null;
          break;
      }

    }


  }

}

enum ChessColor{
  white,
  black
}

