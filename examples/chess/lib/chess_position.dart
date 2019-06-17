

import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_dependency.dart';

import 'chess_injector.dart';
import 'pieces/bishop.dart';
import 'pieces/king.dart';
import 'pieces/knight.dart';
import 'pieces/pawn.dart';
import 'pieces/queen.dart';
import 'pieces/rook.dart';

class ChessPosition extends Position{

  Board board;
  List<Piece> whiteArmy = List();
  List<Piece> blackArmy = List();
  String whitePlayer;
  String blackPlayer;



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

    board = Board.squareTiles(8, ConnectionScheme.allDirections);

    //j = vertical
  // i is horizontal
  // white home is row j = 0 and j = 1
    // black home is row j = 6 and j = 7

    for(int i = 0; i < 8 ; i ++){
      Pawn white = Pawn();
      white.startingPosition = board.tile(i, 1);
      whiteArmy.add(white);

      Pawn black = Pawn();
      black.startingPosition = board.tile(i, 6);
      blackArmy.add(black);
    }
    
    // finish white army
    
    Rook whiteRookLeft = Rook();
    Rook whiteRookRight = Rook();
    whiteRookLeft.startingPosition = board.tile(0, 0);
    whiteRookRight.startingPosition = board.tile(7, 0);
    whiteArmy.add(whiteRookLeft);
    whiteArmy.add(whiteRookRight);

    Knight whiteKnightLeft = Knight();
    Knight whiteKnightRight = Knight();
    whiteKnightLeft.startingPosition = board.tile(1, 0);
    whiteKnightRight.startingPosition = board.tile(6, 0);
    whiteArmy.add(whiteKnightLeft);
    whiteArmy.add(whiteKnightRight);

    Bishop whiteBishopLeft = Bishop();
    Bishop whiteBishopRight = Bishop();
    whiteBishopLeft.startingPosition = board.tile(2, 0);
    whiteBishopRight.startingPosition = board.tile(5, 0);
    whiteArmy.add(whiteBishopLeft);
    whiteArmy.add(whiteBishopRight);
    
    Queen whiteQueen = Queen();
    whiteQueen.startingPosition = board.tile(3, 0);
    whiteArmy.add(whiteQueen);

    King whiteKing = King();
    whiteKing.startingPosition = board.tile(4, 0);
    whiteArmy.add(whiteKing);
    
    // black army

    Rook blackRookLeft = Rook();
    Rook blackRookRight = Rook();
    blackRookLeft.startingPosition = board.tile(0, 7);
    blackRookRight.startingPosition = board.tile(7, 7);
    blackArmy.add(blackRookLeft);
    blackArmy.add(blackRookRight);

    Knight blackKnightLeft = Knight();
    Knight blackKnightRight = Knight();
    blackKnightLeft.startingPosition = board.tile(1, 7);
    blackKnightRight.startingPosition = board.tile(6, 7);
    blackArmy.add(blackKnightLeft);
    blackArmy.add(blackKnightRight);

    Bishop blackBishopLeft = Bishop();
    Bishop blackBishopRight = Bishop();
    blackBishopLeft.startingPosition = board.tile(2, 7);
    blackBishopRight.startingPosition = board.tile(5, 7);
    blackArmy.add(blackBishopLeft);
    blackArmy.add(blackBishopRight);

    Queen blackQueen = Queen();
    blackQueen.startingPosition = board.tile(3, 7);
    blackArmy.add(blackQueen);

    King blackKing = King();
    blackKing.startingPosition = board.tile(4, 7);
    blackArmy.add(blackKing);

    whiteArmy.forEach((p) {
      p.startingPosition.pieces.add(p);
    }
      );


    blackArmy.forEach((p) => p.startingPosition.pieces.add(p));
  }



  printBoard(){

    print('  -------------------------------');

    for (int j = 7 ; j >= 0 ; j --){

      String string = ' | ';

      for (int i = 0 ; i < 8 ; i ++){
        Tile tile = board.tile(i, j);

        if (tile.pieces.isNotEmpty) string += tile.pieces.first.name;
        else string += ' ';

        string += ' | ';

      }

      print(string + '\n');

      print('  -------------------------------');

    }

    print('\n' +  '\n');
  }

  PlayerOrder get playerOrder => PlayerOrder.sequential;

  setExternalVariables(String string) {
    // TODO: implement setExternalVariables
    return null;
  }

  setFirstPlayer(String firstPlayer) {
   super.setFirstPlayer(firstPlayer);

   whitePlayer = playerQueue[0];
   blackPlayer = playerQueue[1];
  }

  @override
  setUpNewPosition() {

  }

  @override
  double value(String playerId) {
    // TODO: implement value
    return null;
  }




}