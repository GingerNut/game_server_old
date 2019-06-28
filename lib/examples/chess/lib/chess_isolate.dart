import 'dart:isolate';
import 'package:game_server/game_server.dart';

main(List<String> args, SendPort sendPort) async{

  print('here');

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  Computer computer = Computer(ChessInjector(), receivePort, sendPort);

  await computer.initialise();

}