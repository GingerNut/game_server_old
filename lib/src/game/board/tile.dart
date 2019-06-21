

import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game_dependency.dart';

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

  printTile(GameDependency dependency){


    print('tile $i $j');


  }







}