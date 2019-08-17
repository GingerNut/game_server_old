part of game;

class Computer {
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

  Future<Move> findBestMove() async {
    Position test = position.duplicate;

    MoveTree tree = MoveTree(test);

    tree.search(6, 2);

    return tree.bestMove;
  }
}
