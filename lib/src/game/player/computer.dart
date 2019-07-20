part of game;


class Computer{

  Position position;

  String playerId;
  bool ready = false;
  String gameId;
  int aiDepth;
  double thinkingTime;

  Computer(this.dependency);
  MoveBuilder get moveBuilder => dependency.getMoveBuilder();
  PositionBuilder get positionBuilder => dependency.getPositionBuilder();
  final GameDependency dependency;

  Future<Move> findBestMove() async{

    bool OK = true;

    Timer timer = Timer(Duration(seconds: 1), (){OK = false;});

    MoveTree tree = MoveTree(position, position.playerId);

    tree.findBranches();

    while(OK){

      await Future.delayed(Duration(microseconds : 1));

      tree.search(6);

    }

    timer.cancel();


  return tree.bestMove;
  }


}