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

    Move bestMove;

    List<Move> moves = position.getPossibleMoves();

    moves.forEach((m){

      Position trialPosition = position.duplicate;
      trialPosition.makeMove(m);
      m.trialPosition = trialPosition;

    });

    double bestscore = -1000;
    bestMove = moves[0];

    moves.forEach((m) {
      double score = m.trialPosition.score[playerId];

      if(score > bestscore) {
        bestscore = score;
        bestMove = m;

      }

    });

    return bestMove;
  }


}