part of game;

class Tile{

  List<Tile> connections = List();
  final Board board;
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

     case Board.North: return north;
     case Board.North_East: return northEast;
     case Board.East: return east;
     case Board.South_East: return southEast;
     case Board.South: return south;
     case Board.South_West: return southWest;
     case Board.West: return west;
     case Board.North_West: return northWest;
   }
  }

  OccupationStatus tileOccupation(Piece piece){
      if(pieces.isEmpty) return OccupationStatus.neutral;

      else return pieces.first.isFriendly(piece)? OccupationStatus.friendly : OccupationStatus.enemy;
  }

  printTile(GameDependency dependency){


    print('tile $i $j');


  }


}

enum OccupationStatus{neutral, friendly, enemy}