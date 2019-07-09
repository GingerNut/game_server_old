import 'dart:isolate';
import 'package:game_server/game_server.dart';
import 'package:game_server/src/game/game.dart';

import 'fie_fo_fum.dart';

main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  IsolateComputer computer = IsolateComputer(FieFoFumInjector(), receivePort, sendPort);

  computer.initialise();

}