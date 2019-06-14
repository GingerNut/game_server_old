part of player;




abstract class ComputerPlayer extends Player{

  bool computerReady = false;

  ReceivePort receivePort = ReceivePort();
  SendPort sendPort;
  MoveBuilder get moveBuilder;

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

    send(SetId(id));

    send(SendPosition.fromGame(game));

  }

  moveUpdate(MakeMove move)=> send(move);

  yourTurn()=> send(YourTurn(gameId));

  gameStarted(String gameId) => send(GameStarted(gameId));

  startComputer();

  handleMessage(String string){
    messagesIn.sink.add(string);

    Message message = Message.inflate(string);

    switch(message.runtimeType){

      case SetStatus:
        var setStatus = message as SetStatus;
        status = setStatus.status;
        break;

      case MakeMove:
        var suggestMove = message as MakeMove;
        Move move = suggestMove.build(moveBuilder);
        game.makeMove(move, suggestMove.gameId, suggestMove.playerId);
        break;
    }

  }

  send(Message message) => sendPort.send(message.json);

  @override
  tidyUp() {
    send(Tidy());
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






