


import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';

class Board{
  static const int North = 1;
  static const int North_East = 2;
  static const int East = 3;
  static const int South_East = 4;
  static const int South = 5;
  static const int South_West = 6;
  static const int West = 7;
  static const int North_West = 8;

  static List<int> hexDirections = [North_East, East, South_East, South_West, West, North_West];
  static List<int> squareOrthogonalDirections = [North, East, West, South];
  static List<int> squareDiagonalDirections = [North_East, South_East, South_West, North_West];
  static List<int> squareAllDirections = [North, North_East, East, South_East, South, South_West, West, North_West];

  Board();

  List<Tile> tiles;

  String get string => null;

  Tile tile(int i, int j){

    Tile tile;
    tiles.forEach((t){
      if(t.i == i && t.j == j) tile = t;
    });

    return tile;
  }

  Board.fromString(String string);

  Board.squareTiles(int size, ConnectionScheme connectionScheme){
    tiles = getSquareTiles(size, size, connectionScheme);
  }

  List<Tile> getSquareTiles(int width, int height, ConnectionScheme connections){

    Array2d tileArray = Array2d(width, height);

    List<Tile> newtiles = List();

    for(int i = 0 ; i < width ; i ++){
      for(int j = 0 ; j < height ; j ++){
        Tile tile = Tile(this, i, j);
        newtiles.add(tile);
        tileArray[i][j] = tile;
      }
    }
    List<int> directions;

    switch(connections){
      case ConnectionScheme.verticalHorizontal:
        directions = squareOrthogonalDirections;
        break;
      case ConnectionScheme.diagonal:
        directions = squareDiagonalDirections;
        break;
      case ConnectionScheme.allDirections:
        directions = squareAllDirections;
        break;
      case ConnectionScheme.none:
        directions = [];
        break;
    }

    for(int i = 0 ; i < width ; i ++){
      for(int j = 0 ; j < height ; j ++){

        Tile t = tileArray[i][j];

        //j = vertical
        // i is horizontal

        directions.forEach((d){
          switch(d){
            case North:
              if(j < height -1) t.north = tileArray[i][j+1];
              t.connections.add(t.north);
              break;

            case North_East:
              if(i < width -1 && j < height -1) t.northEast = tileArray[i + 1][j+1];
              t.connections.add(t.northEast);
              break;

            case East:
              if(i < width -1) t.east = tileArray[i + 1][j];
              t.connections.add(t.east);
              break;

            case South_East:
              if(i > 0 && j < height -1) t.southEast = tileArray[i - 1][j+1];
              t.connections.add(t.southEast);
              break;

            case South:
              if(j > 0) t.south = tileArray[i][j-1];
              t.connections.add(t.south);
              break;

            case South_West:
              if(i > 0 && j > 0) t.southWest = tileArray[i - 1][j-1];
              t.connections.add(t.southWest);
              break;

            case West:
              if(i > 0) t.west = tileArray[i - 1][j];
              t.connections.add(t.west);
              break;

            case North_West:
              if(i < width -1 && j > 0) t.northWest = tileArray[i + 1][j-1];
              t.connections.add(t.northWest);
              break;
          }

        });

      }
    }

    return newtiles;
  }

}

enum ConnectionScheme{
  verticalHorizontal,
  diagonal,
  allDirections,
  none
}


class Array2d<T> {
  List<List<T>> array;
  T defaultValue;

  Array2d(int width, int height, {T this.defaultValue}) {
    array = new List<List<T>>();
    this.width = width;
    this.height = height;
  }

  operator [](int x) => array[x];

  set width(int v) {
    while (array.length > v)
      array.removeLast();
    while (array.length < v) {
      List<T> newList = new List<T>();
      if (array.isNotEmpty) {
        for (int y = 0; y < array.first.length; y++)
          newList.add(defaultValue);
      }
      array.add(newList);
    }
  }

  set height(int v) {
    while (array.first.length > v) {
      for (int x = 0; x < array.length; x++)
        array[x].removeLast();
    }
    while (array.first.length < v) {
      for (int x = 0; x < array.length; x++)
        array[x].add(defaultValue);
    }
  }
}