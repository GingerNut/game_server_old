import 'dart:isolate';

import 'package:game_server/src/game/player/player.dart';

import 'fie_fo_fum_computer.dart';


class FieFoFumComputerPlayer extends ComputerPlayer{

  startComputer() async{
    await Isolate.spawn(setupFFFComputer, receivePort.sendPort);
  }
}

setupFFFComputer(SendPort sendPort) async {
  var port = new ReceivePort();
  sendPort.send(port.sendPort);
  FieFoFumComputer computer = FieFoFumComputer(port, sendPort);
  computer.initialise();
}