import 'dart:isolate';

import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/messages/command/send_position.dart';

import 'fie_fo_fum_computer.dart';
import 'fie_fo_fum_move_builder.dart';



class FieFoFumComputerPlayer extends ComputerPlayer{

  get moveBuilder => FieFoFumMoveBuilder();

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