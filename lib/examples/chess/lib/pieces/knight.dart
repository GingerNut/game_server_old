
part of chess;

class Knight extends ChessPiece{

  Knight(Board board) : super(board){
    name = 'N';
    value = 3;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    Tile first;
    Tile second;

    first = tile.nextInDirection(Board.North);
    if(first != null) {
      second = first.nextInDirection(Board.North_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Board.North_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Board.South);
    if(first != null) {
      second = first.nextInDirection(Board.South_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Board.South_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Board.East);
    if(first != null) {
      second = first.nextInDirection(Board.North_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Board.South_East);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    first = tile.nextInDirection(Board.West);
    if(first != null) {
      second = first.nextInDirection(Board.North_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);

      second = first.nextInDirection(Board.South_West);
      if(second != null && second.tileOccupation(this) != OccupationStatus.friendly) moves.add(second);
    }

    return moves;
  }


}