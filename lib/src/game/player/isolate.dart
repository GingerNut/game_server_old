
import 'dart:isolate';

import '../../game_dependency.dart';
import 'computer.dart';





main(SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);



//  ComputerIsolate isolate = ComputerIsolate(GameDependency(), receivePort, sendPort);

//  isolate.initialise();



}