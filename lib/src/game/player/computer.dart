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


  findPossibleMoves(Position position){

    GameNavigation siutation = position.lastMove;

    siutation.children = position.getPossibleMoves();

    siutation.children.forEach((m){
      Position test = position.duplicate;
      test.makeMove(m);
    });
  }

  Move bestMove(GameNavigation situation, String playerId){

    Move bestMove = situation.children[0];
    double bestscore = bestMove.score(0);

    situation.children.forEach((m) {
      double score = m.score(position.playerIds.indexOf(playerId));

      if(score > bestscore) {
        bestscore = score;
        bestMove = m;
      }

    });

    return bestMove;
  }


  Future<Move> findBestMove() async{

    print(position.lastMove.resultingPosition);

    findPossibleMoves(position);

    return bestMove(position.lastMove, playerId);
  }


}