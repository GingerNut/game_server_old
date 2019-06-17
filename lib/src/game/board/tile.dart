

import 'package:game_server/src/game/board/piece.dart';

import 'board.dart';

class Tile{

  List<Tile> connections = List();
  final Board board;
  final int i;
  final int j;

  String label;

  Piece _taken;

  Piece get taken {
    Piece toReturn = _taken;
    _taken = null;
    return toReturn;
  }

  Piece get piece => pieces.first;

  set piece (Piece p) {
    if(pieces.isNotEmpty) _taken = pieces.first;

    pieces.clear();
    pieces.add(p);
  }

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