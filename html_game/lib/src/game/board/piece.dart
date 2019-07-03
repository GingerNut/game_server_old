part of game;

abstract class Piece{

  final Board board;

  String name;
  String notation;
  Tile _tile;

  Piece captured;

  Piece(this.board);

  set tile (Tile tile){
    if(_tile != null) _tile.pieces.remove(this);
    _tile = tile;

    if(tile.pieces.isNotEmpty) captured = tile.pieces.first;
    tile.pieces.clear();
    tile.pieces.add(this);
  }

  Tile get tile => _tile;

  List<Tile> get legalMoves;


setup(){

}

bool isFriendly(Piece piece);

}


