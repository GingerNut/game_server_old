import 'dart:isolate';

import 'package:game_server/src/game/player/computer.dart';


main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  //Computer computer = Computer(SomeInjector(), receivePort, sendPort);

//  computer.initialise();

}