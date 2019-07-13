part of game;

abstract class GameNavigation{
  int number;

  String resultingPosition;

  String get string;

  List<Move> children = List();


  makeChildren(GameDependency dependency){

    Position position = dependency.getPositionBuilder().build(resultingPosition);

    children = position.getPossibleMoves();

    if(children.isEmpty) return;

    children.forEach((m){
      Position test = position.duplicate;
      test.makeMove(m);
    });
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





