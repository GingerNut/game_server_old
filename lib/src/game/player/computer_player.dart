part of player;


abstract class ComputerPlayer extends Player{

  bool computerReady = false;

  ReceivePort receivePort = ReceivePort();
  SendPort sendPort;

  StreamController<String> messagesIn;  // just for testing

  initialise() async{
    messagesIn = await StreamController.broadcast();
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);
    receivePort.listen((d){

      if(d is SendPort) {
        sendPort = d;
      } else if(d is String) {
        handleMessage(d);
      }
    });

    await startComputer();

    while(sendPort == null){
      await Future.delayed(Duration(milliseconds : 1));
    }

    sendGame();

  }

  sendGame();

  startComputer();

  handleMessage(String string){
    messagesIn.sink.add(string);

    String type = string.substring(0,3);
    String details = string.substring(3);

    switch(type){

      case SetStatus.code:
        var setStatus = SetStatus.fromString(details);
        status = setStatus.status;
        break;






    }

  }

  send(String message) => sendPort.send(message);

  @override
  tidyUp() {
    sendPort.send(Tidy().string);
  }

}
// example code
//class FieFoFumComputerPlayer extends ComputerPlayer{
//
//  startComputer() async{
//    await Isolate.spawn(setupFFFComputer, receivePort.sendPort);
//  }
//}
//
//setupFFFComputer(SendPort sendPort) async {
//  var port = new ReceivePort();
//  sendPort.send(port.sendPort);
//  FieFoFumComputer computer = FieFoFumComputer(port, sendPort);
//  computer.initialise();
//}






