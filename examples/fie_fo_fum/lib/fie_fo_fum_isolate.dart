

import 'dart:isolate';

import 'package:game_server/src/game/player/computer_isolate.dart';

import 'FieFoFumInjector.dart';


main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  ComputerIsolate isolate = ComputerIsolate(FieFoFumInjector(), receivePort, sendPort);

  isolate.initialise();



}