part of chess;

class ChessInjector extends GameDependency{
  
  Game getGame(NewGame newGame) => Game.fromNewGame(this, newGame);

  MoveBuilder getMoveBuilder() => ChessMoveBuilder();

  Position getPosition() => ChessPosition();

  getInput(Interface interface) => ChessInput(interface);

  setPositionType(Position position) => position as ChessPosition;

  Settings get settings => ChessSettings();

  Function get isolateSpawn => spawnIsolate;

  static spawnIsolate(SendPort sendPort)async{

    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    IsolateComputer computer = IsolateComputer(ChessInjector(), receivePort, sendPort);

    computer.initialise();

  }

}