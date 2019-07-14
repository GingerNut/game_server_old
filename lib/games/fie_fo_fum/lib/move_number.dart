


// multiples of 3

part of fie_fo_fum;

class MoveNumber extends FieFoFumMove{
  static const String type ='num';

  String get string => type;


  Message doCheck(FieFoFumPosition position) {


  }

  doMove(FieFoFumPosition position) {
      bool moveOk = false;

      int test = position.count;
      if(test % 3 != 0 && test % 5 != 0) moveOk = true;
      if(!moveOk) position.playerStatus[position.playerId] = PlayerStatus.out;
      else position.score[position.playerId] ++;
  }


}