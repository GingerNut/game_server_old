

import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_dependency.dart';

import 'chess_injector.dart';

class ChessPosition extends Position{

  Board board;
  List<Piece> whiteArmy = List();
  List<Piece> blackArmy = List();
  PlayerVariable first;



  Piece makePawn(){


  }

  Piece makeKnight(){


  }

  Piece makeRook() {

  }


  Piece makeBishop(){


  }

  Piece makeQueen(){


  }
  Piece makeKing(){

  }


  String get string => null;

  @override
  analyse() {

  }

  @override
  bool canPlay(String id) {


  }

  GameDependency get dependency => ChessInjector();

  String get externalVariablesString => null;

  List<Move> getPossibleMoves() {

  }


  initialiseExternalVariables() {
    first = PlayerVariable<bool>(playerIds, false);
  }

  PlayerOrder get playerOrder => PlayerOrder.sequential;

  setExternalVariables(String string) {
    // TODO: implement setExternalVariables
    return null;
  }

  setFirstPlayer() {


  }

  @override
  setUpNewPosition() {
    // TODO: implement setUpNewPosition
    return null;
  }

  @override
  double value(String playerId) {
    // TODO: implement value
    return null;
  }




}