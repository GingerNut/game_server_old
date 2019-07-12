part of game;


class Computer{

  Position position;
  Position playBoard;
  String playerId;
  bool ready = false;
  String gameId;

  Computer(this.dependency);
  MoveBuilder get moveBuilder => dependency.getMoveBuilder();
  PositionBuilder get positionBuilder => dependency.getPositionBuilder();
  final GameDependency dependency;


  findPossibleMoves(GameNavigation situation){
    playBoard.setTo(situation);

    situation.children = playBoard.getPossibleMoves();

    situation.children.forEach((m){
      playBoard.makeMove(m);
      playBoard.setTo(situation);
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

    playBoard.setTo(position.lastMove);

    findPossibleMoves(position.lastMove);

    return bestMove(position.lastMove, playerId);
  }


}