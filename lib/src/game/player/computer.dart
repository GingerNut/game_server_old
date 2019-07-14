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


    MoveQueue queue = MoveQueue(playerId, position);

    queue.expandAll(aiDepth);

    while(OK){

//      queue.expandTopThree(aiDepth);
      await Future.delayed(Duration(microseconds : 1));

    }

    timer.cancel();

//    queue.expandAll();
//    queue.expandAll();




//    position.lastMove.makeChildren(dependency);
//
//
//    position.lastMove.children.forEach((c) => c.makeChildren(dependency));
//
//    if(aiDepth > 2){
//      position.lastMove.children.forEach((c) {
//        c.children.forEach((d) => d.makeChildren(dependency));
//      } );
//    }
//
//    return position.lastMove.bestChild(playerId, position.playerIds);

  return queue.bestMove;
  }


}