import 'board.dart';

class Tile{

  List<Tile> connections = List();
  final Board board;
  final int i;
  final int j;

  String label;

  Tile north;
  Tile northEast;
  Tile east;
  Tile southEast;
  Tile south;
  Tile southWest;
  Tile west;
  Tile northWest;

  Tile(this.board, this.i, this.j);







}