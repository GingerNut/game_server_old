


class Board{
  static const int North = 1;
  static const int North_East = 2;
  static const int East = 3;
  static const int South_East = 4;
  static const int South = 5;
  static const int South_West = 6;
  static const int West = 7;
  static const int North_West = 8;

  static List<int> directions = [North_East, East, South_East, South_West, West, North_West];

  makeBoard(){}


  //TODO chess board

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