import 'package:game_server/examples/chess/lib/chess_position.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/success.dart';

class ChessMove extends Move<ChessPosition>{

  int fromI;
  int fromJ;
  int toI;
  int toJ;
  static const String delimiter = ',';

  ChessMove(Tile from, Tile to){
  fromI = from.i;
  fromJ = from.j;
  toI = to.i;
  toJ = to.j;
  }


  ChessMove.fromString(String string){

    List<String> details = string.split(delimiter);

    fromI = int.parse(details[0]);
    fromJ = int.parse(details[1]);
    toI = int.parse(details[2]);
    toJ = int.parse(details[3]);


  }


  Message doCheck(ChessPosition position) {
      Piece piece = position.board.tile(fromI, fromJ).pieces.first;

      if(piece.legalMoves.contains(position.board.tile(toI, toJ))) return Success();
      else return GameError('illegal move');
  }

  doMove(ChessPosition position) {





  }

  String get string => fromI.toString() + delimiter
      + fromJ.toString() + delimiter
      + toI.toString() + delimiter
      + toJ.toString();

}