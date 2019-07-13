part of game;


class Computer{

  Position position;

  String playerId;
  bool ready = false;
  String gameId;

  Computer(this.dependency);
  MoveBuilder get moveBuilder => dependency.getMoveBuilder();
  PositionBuilder get positionBuilder => dependency.getPositionBuilder();
  final GameDependency dependency;

  int depth = 0;


  findPossibleMoves(Position position){

    GameNavigation situation = position.lastMove;

    situation.children = position.getPossibleMoves();

    situation.children.forEach((m){
      Position test = position.duplicate;
      test.makeMove(m);
    });
  }

  Future<Move> findBestMove() async{

    depth = 0;

    findPossibleMoves(position);

//    position.lastMove.findPossibleMoves(dependency);

    depth = 1;


    return position.lastMove.bestChild(playerId, position.playerIds);
  }


}