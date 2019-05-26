


class Palette{
  static const int COLOR_NONE = 0;
  static const int COLOR_RED = 1;
  static const int COLOR_BLUE = 2;
  static const int COLOR_PURPLE = 3;
  static const int COLOR_GOLD = 4;
  static const int COLOR_GREY = 5;
  static const int COLOR_BLACK = 6;
  static const int COLOR_WHITE = 7;
  static const int COLOR_SELECTED = 10;
  static const int COLOR_MOVE_GOOD = 12;
  static const int COLOR_WORD_DISSOLVED = 13;
  static const int COLOR_LETTER_DARK = 20;
  static const int COLOR_LETTER_LIGHT = 21;

  static const List<int> defaultPlayerColours = [
    COLOR_WHITE,
    COLOR_BLACK,
    COLOR_BLUE,
    COLOR_RED,
    COLOR_GOLD,
    COLOR_PURPLE
  ];

  static int colorCombo(int background){

    switch(background){
      case Palette.COLOR_NONE:
      case Palette.COLOR_WHITE:
        return Palette.COLOR_LETTER_DARK;

      case Palette.COLOR_MOVE_GOOD:
      case Palette.COLOR_GREY:
      case Palette.COLOR_BLACK:
      case Palette.COLOR_SELECTED:
      case Palette.COLOR_BLUE:
      case Palette.COLOR_RED:
      case Palette.COLOR_WORD_DISSOLVED:
      case Palette.COLOR_PURPLE:
      case Palette.COLOR_GOLD:
        return Palette.COLOR_LETTER_LIGHT;
    }

    return Palette.COLOR_LETTER_DARK;
  }

}