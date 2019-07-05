import 'dart:isolate';
import 'package:core_game/html_game.dart';

import 'chess.dart';



main(List<String> args, SendPort sendPort) async{

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  Computer computer = Computer(ChessInjector(), receivePort, sendPort);

  await computer.initialise();

}