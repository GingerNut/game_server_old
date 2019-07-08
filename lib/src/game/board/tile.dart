part of game;

class Tile{

  List<Tile> connections = List();
  final Tiles board;
  final int i;
  final int j;

  bool operator == (t) => t is Tile && t.i == i && t.j == j;
  int get hashCode => i * j;

  String label;

  List<Piece> pieces = List();

  Tile north;
  Tile northEast;
  Tile east;
  Tile southEast;
  Tile south;
  Tile southWest;
  Tile west;
  Tile northWest;

  Tile(this.board, this.i, this.j);

  Tile nextInDirection(int direction){
   switch(direction){

     case Tiles.North: return north;
     case Tiles.North_East: return northEast;
     case Tiles.East: return east;
     case Tiles.South_East: return southEast;
     case Tiles.South: return south;
     case Tiles.South_West: return southWest;
     case Tiles.West: return west;
     case Tiles.North_West: return northWest;
   }
  }

  OccupationStatus tileOccupation(Piece piece){
      if(pieces.isEmpty) return OccupationStatus.neutral;

      else return pieces.first.isFriendly(piece)? OccupationStatus.friendly : OccupationStatus.enemy;
  }




}

enum OccupationStatus{neutral, friendly, enemy}
