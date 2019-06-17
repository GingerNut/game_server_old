import 'board.dart';
import 'tile.dart';

class Piece{

  Tile startingPosition;
  MovementPattern movementPattern;
  String name;
  Tile _tile;

  set tile (Tile tile){
    _tile = tile;
    tile.piece = this;
  }

  Tile get tile => _tile;


setup(){
  startingPosition.piece = this;
  tile = startingPosition;
}

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

