import 'package:game_server/src/game/position.dart';

import 'board.dart';
import 'tile.dart';

abstract class Piece{

  final Board board;

  Tile startingPosition;
  MovementPattern movementPattern;
  String name;
  Tile _tile;

  Piece captured;

  Piece(this.board);

  set tile (Tile tile){
    _tile = tile;

    if(tile.pieces.isNotEmpty) captured = tile.pieces.first;
    tile.pieces.clear();
    tile.pieces.add(this);
  }

  Tile get tile => _tile;

  List<Tile> get legalMoves;


setup(){
  tile = startingPosition;
}

bool isFriendly(Piece piece);

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

