


// multiples of 3 and 5

part of fie_fo_fum;

class MoveFum extends FieFoFumMove{
  static const String type ='fum';


  String get string => type;

  doMove(FieFoFumPosition position){
    bool moveOk = false;
    int test = position.count;
    if(test % 3 == 0 && test % 5 == 0) moveOk = true;
    if(!moveOk) position.playerStatus[position.playerId] = PlayerStatus.out;
    else position.score[position.playerId] ++;
  }





}