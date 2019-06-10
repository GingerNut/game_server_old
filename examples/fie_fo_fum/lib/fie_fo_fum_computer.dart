import 'dart:isolate';

import 'package:game_server/src/game/player/computer_isolate.dart';

import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_sendgame.dart';

class FieFoFumComputer extends ComputerIsolate{
  FieFoFumComputer(ReceivePort receivePort, SendPort sendPort) : super(receivePort, sendPort);

  getMoveBuilder() => FieFoFumMoveBuilder();

  findBestMove() {

  }

  createPosition(String details) {
    var sendGame = FieFoFumSendGame.fromString(details);
    position = sendGame.position;
  }


  doMove(String details) {

  }


  yourTurn(String details) {

  }


}