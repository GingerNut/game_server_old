part of chess;

class ChessMoveBuilder extends MoveBuilder{

  Move build(String string) => ChessMove.fromString(string);

}