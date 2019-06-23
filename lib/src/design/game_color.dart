part of design;

class GameColor{

  int a;
  int r;
  int g;
  int b;

  GameColor.fromString(String string){

    string = string.substring(1);

    String RString = string.substring(0,2);
    String GString = string.substring(2,4);
    String BString = string.substring(4);

    r = int.parse(RString, radix: 16);
    g = int.parse(GString, radix: 16);
    b = int.parse(BString, radix: 16);
  }

  GameColor(int color){
    b = color % 256;

    color = color ~/ 256.0;

    g = color % 256;

    color = color ~/ 256.0;

    r = color % 256;

    a = color ~/ 256.0;
  }

  int get asInt => a * 256 * 256 * 256 + r * 256 * 256 + g * 256 + b;

  String get string => '0x' + asInt.toRadixString(16);

}