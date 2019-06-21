import 'package:game_server/examples/chess/lib/chess_position.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/messages/message.dart';

class ChessMove extends Move<ChessPosition>{

  int i;
  int j;
  static const String delimiter = ',';

  ChessMove(Tile tile){
    i = tile.i;
    j = tile.j;
  }


  ChessMove.fromString(String string){

    List<String> details = string.split(delimiter);

  }


  Message doCheck(ChessPosition position) {
    // TODO: implement doCheck
    return null;
  }

  doMove(ChessPosition position) {
    // TODO: implement doMove
    return null;
  }

  String get string => i.toString() + delimiter + j.toString();




}