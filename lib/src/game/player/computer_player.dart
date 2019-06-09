part of player;


abstract class ComputerPlayer extends Player{

  ReceivePort receivePort = ReceivePort();
  SendPort sendPort;

  StreamController<String> messagesIn;  // just for testing

  initialise() async{
    messagesIn = await StreamController.broadcast();
    timer = GameTimer(this, game.settings.gameTime, moveTime: game.settings.moveTime);

    startComputer();

    receivePort.listen((d){

      if(d is SendPort) {
        sendPort = d;
      } else if(d is String) {
        handleMessage(d);
      }

    });

  }

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

  @override
  tidyUp() {
    sendPort.send(Tidy().string);
  }

}

//setupComputer(SendPort sendPort) async {
//
//  var port = new ReceivePort();
//  sendPort.send(port.sendPort);
//
//  ComputerIsolate computer = ComputerIsolate(port, sendPort);
//  computer.initialise();
//}



