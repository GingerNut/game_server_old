import 'dart:isolate';

import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/command/tidy.dart';

import '../game_timer.dart';
import '../palette.dart';
import '../player.dart';
import 'computer.dart';



class ComputerPlayer extends Player{

  ReceivePort receivePort = ReceivePort();
  SendPort sendPort;

  initialise() async{
    color = Palette.defaultPlayerColours[number];
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    await Isolate.spawn(setupComputer, receivePort.sendPort);

    receivePort.listen((d){

      if(d is SendPort) {
        sendPort = d;
        sendPort.send("foo");

      } else if(d is String) {
        handleMessage(d);
      }

    });

  }


  handleMessage(String string){

    String type = string.substring(0,3);
    String details = string.substring(3);

    switch(type){

      case SetStatus.code:
        var setStatus = SetStatus.fromString(details);
        status = setStatus.status;
        break;




    }

  }

  @override
  tidyUp() {
    sendPort.send(Tidy().string);
  }

}

setupComputer(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  var port = new ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  Computer computer = Computer(port, sendPort);
  computer.initialise();
}