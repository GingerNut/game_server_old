import 'tile.dart';

class Piece{
  MovementPattern movementPattern;
  String name;
  Tile tile;




}

class MovementPattern{




}


enum pieceMovement{
  horizontal,
  vertical,
  diagonal,
  horizontalAndVertical,
  all
}

enum capturePattern{
  take,
  surround
}

