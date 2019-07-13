
part of game;

abstract class Move <P> extends GameNavigation{
  static const String code = 'mov';
  bool legal = false;
  String error;

  List<double> playerScores;

  double score(int index){

    if(playerScores.length == 1){
      return playerScores[0];

    } else if(playerScores.length == 2){

      if(index == 0) return playerScores[0] - playerScores[1];
      else return playerScores[1] - playerScores[0];

    } else {

      double highestOpponent = index == 0 ? playerScores[1] : playerScores[0];

      for (int i = 0 ; i < playerScores.length ; i ++){
        if(i == index) continue;

        if(playerScores[i] > highestOpponent) highestOpponent = playerScores[i];

      }

      return playerScores[index] - highestOpponent;
    }
  }

  int number;

  String gamePosition;

  Move parent;


  Message check(P position){

    return doCheck(position);
  }

  Message doCheck(P position);

  Message go(P position){

      doMove(position);

      Position pos  = position as Position;

      playerScores = List(pos.playerIds.length);

      for(int i = 0 ; i < pos.playerIds.length ; i ++){

        playerScores[i] = pos.value(pos.playerIds[i]);
      }

      resultingPosition = pos.json;

      return Success();
  }

  doMove(P position);




}