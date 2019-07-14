part of game;

abstract class GameEvent{
  int number;

  String resultingPosition;

  String get string;

  bool allChildrenFound = false;
  List<Move> children = List();

  makeChildren(GameDependency dependency){

    List<Move> kill = List();

    Position position = dependency.getPositionBuilder().build(resultingPosition);

    String player = position.playerId;

    children = position.getPossibleMoves();

    if(children.isEmpty) return;

    children.forEach((m){
      Position test = position.duplicate;
      test.makeMove(m);

      if(test.playerStatus[player] == PlayerStatus.out) kill.add(m);
    });

    kill.forEach((k) => children.remove(k));


  }


  Move bestChild(String player, List<String> players){
    if(children.length == 0) return null;
    else if(children.length ==1) return children[0];
    else{
      Move bestMove = children[0];
      double bestscore = bestMove.compoundValue(player, players);

      children.forEach((m) {
        double score = m.compoundValue(player, players);

        if(score > bestscore) {
          bestscore = score;
          bestMove = m;
        }

      });
      return bestMove;
    }
  }

  Move worstChild(String player, List<String> players){
    if(children.isEmpty) return null;

    else if(children.length ==1) return children[0];

    else{
      Move bestMove = children[0];
      double bestscore = bestMove.compoundValue(player, players);

      children.forEach((m) {
        double score = m.compoundValue(player, players);

        if(score > bestscore) {
          bestscore = score;
          bestMove = m;
        }

      });
      return bestMove;
    }
  }


}





