part of chess;

//j = vertical
// i is horizontal

class ChessNotation extends Notation{

  @override
  String labelTile(int i, int j) {

    String label = '';

    switch(j){
      case 0: label += 'a';
      break;

      case 1: label += 'b';
      break;

      case 2: label += 'c';
      break;

      case 3: label += 'd';
      break;

      case 4: label += 'e';
      break;

      case 5: label += 'f';
      break;

      case 6: label += 'g';
      break;

      case 7: label += 'h';
      break;

    }

    label += (i + 1).toString();

    return label;

  }


}