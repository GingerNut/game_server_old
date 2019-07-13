
part of game;

abstract class Move <P> extends GameNavigation{
  static const String code = 'mov';
  bool legal = false;
  String error;
  String movePlayer;

  List<double> values;

  bool isPlayer(String playerId) {
    if(movePlayer == null) return true;

    return movePlayer == playerId;
  }


  double compoundValue(String player, List<String> players){

    double value = absoluteValue(player, players);

    if(children.isNotEmpty){

      // deduct which of the moves gives index the lowest score if player is not playerId
      // add highest score for player if player is playerId
      // bool isplayer performs this function

      Move child = children[0];

     bool playerMove = child.movePlayer == player;

     if(playerMove) {
       value += bestChild(player, players).compoundValue(player, players);

     } else{
       value -= worstChild(player, players).compoundValue(player, players);
     }

    }

    return isPlayer(player) ? value : -value;
  }

  double absoluteValue(String player, List<String> players){

    int index = players.indexOf(player);

    double value;

    if(values.length == 1){
      value =  values[0];

    } else if(values.length == 2){

      if(index == 0) value = values[0] - values[1];
      else value = values[1] - values[0];

    } else {

      double highestOpponent = index == 0 ? values[1] : values[0];

      for (int i = 0 ; i < values.length ; i ++){
        if(i == index) continue;

        if(values[i] > highestOpponent) highestOpponent = values[i];

      }

      value = values[index] - highestOpponent;
    }

    return value;

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

      values = List(pos.playerIds.length);

      movePlayer = pos.playerId;

      for(int i = 0 ; i < pos.playerIds.length ; i ++){

        values[i] = pos.value(pos.playerIds[i]);
      }

      resultingPosition = pos.json;

      return Success();
  }

  doMove(P position);




}