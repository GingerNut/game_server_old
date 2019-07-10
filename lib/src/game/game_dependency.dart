part of game;

abstract class GameDependency{

  Game getGame(NewGame newGame);

  MoveBuilder getMoveBuilder();

  PositionBuilder getPositionBuilder() => PositionBuilder(this);

  Position getPosition();

  Position setPositionType(Position position);

  Input getInput(Interface interface);

  Settings get settings;

  Function get isolateSpawn;

  static spawnIsolate(SendPort sendPort)async{

    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

//    IsolateComputer computer = IsolateComputer([ this class ], receivePort, sendPort);

//    computer.initialise();

  }
}