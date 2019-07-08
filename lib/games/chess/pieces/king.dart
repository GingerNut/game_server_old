part of chess;

class King extends ChessPiece{

  bool notYetMoved = true;

  King(Tiles board) : super(board){
    name = 'K';
    value = 9;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Tiles.squareAllDirections.forEach((d){

      Tile nextTile = tile.nextInDirection(d);

        if(nextTile != null && nextTile.tileOccupation(this) != OccupationStatus.friendly )moves.add(nextTile);


    });

    //TODO: add casling

    return moves;
  }

}