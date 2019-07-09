import 'dart:isolate';


import 'package:game_server/src/game/game.dart';

import 'chess.dart';



main(List<String> args, SendPort sendPort) async{

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  IsolateComputer computer = IsolateComputer(ChessInjector(), receivePort, sendPort);

  await computer.initialise();

}