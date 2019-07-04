
part of game;

abstract class Move <P>{
  static const String code = 'mov';
  bool legal = false;
  String error;

  int number;

  String get string;

  Position trialPosition;


  Message check(P position){

    return doCheck(position);
  }

  Message doCheck(P position);

  Message go(P position){

      doMove(position);
      return Success();
  }

  doMove(P position);


}