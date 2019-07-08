
part of chess;

class Knight extends ChessPiece{

  Knight(Tiles board) : super(board){
    name = 'N';
    value = 3;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    Tile first;
    Tile second;

    first = tile.nextInDirection(Tiles.North);
    if(first != null) {
      second = first.nextInDirection(Tiles.North_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Tiles.North_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Tiles.South);
    if(first != null) {
      second = first.nextInDirection(Tiles.South_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Tiles.South_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Tiles.East);
    if(first != null) {
      second = first.nextInDirection(Tiles.North_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Tiles.South_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Tiles.West);
    if(first != null) {
      second = first.nextInDirection(Tiles.North_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Tiles.South_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    return moves;
  }


}