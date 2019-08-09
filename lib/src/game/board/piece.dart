part of game;

abstract class Piece {
  final Tiles board;
  final Position position;

  String name;
  String notation;

  Piece(this.board, this.position);

  List<Tile> get legalMoves;

  setup() {}

  bool isFriendly(Piece piece);
}
