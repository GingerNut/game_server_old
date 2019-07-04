import 'dart:isolate';
import 'package:core_game/html_game.dart';
import 'package:game_server/game_server.dart';

import 'fie_fo_fum.dart';

main(List<String> args, SendPort sendPort) {

  ReceivePort receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);

  Computer computer = Computer(FieFoFumInjector(), receivePort, sendPort);

  computer.initialise();

}