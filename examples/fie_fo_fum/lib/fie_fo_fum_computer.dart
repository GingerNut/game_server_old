import 'dart:isolate';

import 'package:game_server/src/game/player/computer_isolate.dart';

class FieFoFumComputer extends ComputerIsolate{
  FieFoFumComputer(ReceivePort receivePort, SendPort sendPort) : super(receivePort, sendPort);


  findBestMove() {

  }


}