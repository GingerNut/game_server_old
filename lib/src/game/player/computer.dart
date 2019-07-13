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

  Future<Move> findBestMove() async{

    MoveQueue queue = MoveQueue(playerId, position);

    queue.expandAll();
//    queue.expandAll();
//    queue.expandAll();




    position.lastMove.makeChildren(dependency);


    position.lastMove.children.forEach((c) => c.makeChildren(dependency));

//    position.lastMove.children.forEach((c) {
//      c.children.forEach((d) => d.makeChildren(dependency));
//    } );

    return position.lastMove.bestChild(playerId, position.playerIds);

//  return queue.bestMove;
  }


}