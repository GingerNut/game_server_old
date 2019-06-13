import 'dart:isolate';

import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/computer_isolate.dart';
import 'package:game_server/src/game/position.dart';

import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position_builder.dart';


class FieFoFumComputer extends ComputerIsolate{
  FieFoFumComputer(ReceivePort receivePort, SendPort sendPort) : super(receivePort, sendPort);

  get moveBuilder => FieFoFumMoveBuilder();
  get positionBuilder => FieFoFumPositionBuilder();

  findBestMove() {

  }

  Future analysePosition(Position position) async{

    this.position = position;

    position.analyse();

    return;
  }


  doMove(Move move) {

  }


  yourTurn(String details) {

  }


}