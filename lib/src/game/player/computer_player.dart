part of player;




class ComputerPlayer extends Player{

  final GameDependency dependency;

  bool computerReady = false;

  ReceivePort receivePort = ReceivePort();
  SendPort sendPort;

  ComputerPlayer(this.dependency);

  MoveBuilder get moveBuilder => dependency.getMoveBuilder();

  StreamController<String> messagesIn;  // just for testing

  initialise() async{
    messagesIn = await StreamController.broadcast();
    timer = GameTimer(this, game.gameTime, moveTime: game.moveTime);
    receivePort.listen((d){

      if(d is SendPort) {
        sendPort = d;
      } else if(d is String) {
        handleMessage(d);
      }
    });

    await Isolate.spawnUri(dependency.computerUri, null,  receivePort.sendPort);

    while(sendPort == null){
      await Future.delayed(Duration(milliseconds : 1));
    }

    send(SetId(id));

    send(SendPosition.fromGame(game));

  }

  moveUpdate(MakeMove move)=> send(move);

  yourTurn()=> send(YourTurn(gameId));

  gameStarted(String gameId) => send(GameStarted(gameId));

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

      case ConfirmMove:
        ConfirmMove confirm = message as ConfirmMove;
        game.confirmMove(confirm.playerId, confirm.number);
        break;

    }

  }

  send(Message message) => sendPort.send(message.json);

  @override
  tidyUp() {
    send(Tidy());
  }

}







