import 'dart:isolate';

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/computer_isolate.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/suggest_move.dart';

import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position.dart';
import 'fie_fo_fum_position_builder.dart';
import 'move_fie.dart';
import 'move_fo.dart';
import 'move_fum.dart';
import 'move_number.dart';


class FieFoFumComputer extends ComputerIsolate{
  FieFoFumComputer(ReceivePort receivePort, SendPort sendPort) : super(receivePort, sendPort);

  get moveBuilder => FieFoFumMoveBuilder();
  get positionBuilder => FieFoFumPositionBuilder();

  List<Move> moves = new List();

  Move bestMove;

  Future analysePosition(Position position) async{

    this.position = position;

    position.analyse();

    return;
  }

  findPossibleMoves(){

    moves.add(MoveNumber());
    moves.add(MoveFie());
    moves.add(MoveFo());
    moves.add(MoveFum());
  }

  valueMoves(){
    moves.forEach((m)=> tryMove(position, m));
  }

  findBestMove() {

    double bestscore = -1000;
    bestMove = moves[0];

    moves.forEach((m) {
      double score = m.trialPosition.score[playerId];

      if(score > bestscore) {
        bestscore = score;
        bestMove = m;

      }

    });


  }


 tryMove(Position position, Move move){

    Position trialPosition = position.duplicate;
    trialPosition.computer = true;
    trialPosition.duplicated = true;
    trialPosition.makeMove(move);
    move.trialPosition = trialPosition;

  }

  yourTurn(String details) {

    moves.clear();

    findPossibleMoves();

    valueMoves();

    findBestMove();


    send(MakeMove(gameId, playerId, bestMove));
  }


}