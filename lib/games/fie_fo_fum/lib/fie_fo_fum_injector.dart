part of fie_fo_fum;


class FieFoFumInjector extends GameDependency{

  get name => 'Fie Fo Fum';

  Game getGame(NewGame newGame) => Game.fromNewGame(this,  newGame);

  getBoard() => null;

  Position getPosition() => FieFoFumPosition();

  getInput(Interface interface) => FieFoFumInput(interface);
  
  MoveBuilder getMoveBuilder() => FieFoFumMoveBuilder();

  setPositionType(Position position) => position as FieFoFumPosition;

  Settings get settings => FieFoFumSettings();

  Function get isolateSpawn => spawnIsolate;


  static spawnIsolate(SendPort sendPort)async{

    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    IsolateComputer computer = IsolateComputer(FieFoFumInjector(), receivePort, sendPort);

    computer.initialise();

  }




}

