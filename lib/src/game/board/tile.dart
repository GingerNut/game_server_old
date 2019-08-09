part of game;

class Tile {
  List<Tile> connections = List();
  final Tiles board;
  final GameDependency dependency;
  final int i;
  final int j;
  final int k;

  bool operator ==(t) => t is Tile && t.i == i && t.j == j;
  int get hashCode => i * j;

  String label;

  Tile north;
  Tile northEast;
  Tile east;
  Tile southEast;
  Tile south;
  Tile southWest;
  Tile west;
  Tile northWest;

  Tile(this.board, this.dependency, this.i, this.j, this.k);

  Tile nextInDirection(int direction) {
    switch (direction) {
      case Tiles.North:
        return north;
      case Tiles.North_East:
        return northEast;
      case Tiles.East:
        return east;
      case Tiles.South_East:
        return southEast;
      case Tiles.South:
        return south;
      case Tiles.South_West:
        return southWest;
      case Tiles.West:
        return west;
      case Tiles.North_West:
        return northWest;
    }
  }

  draw() => dependency.drawTile();
}

enum OccupationStatus { neutral, friendly, enemy }
