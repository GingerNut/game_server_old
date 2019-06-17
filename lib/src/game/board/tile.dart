import 'package:game_server/src/game/board/piece.dart';

import 'board.dart';

class Tile{

  List<Tile> connections = List();
  final Board board;
  final int i;
  final int j;

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







}