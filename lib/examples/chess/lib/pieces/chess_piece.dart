import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';

abstract class ChessPiece extends Piece{
  ChessPiece(Board board) : super(board);

  ChessColor chessColor;






}

enum ChessColor{
  white,
  black
}

