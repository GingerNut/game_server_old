import 'dart:isolate';
import 'package:game_server/game_server.dart';

main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  Computer computer = Computer(ChessInjector(), receivePort, sendPort);

  computer.initialise();

}