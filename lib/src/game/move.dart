



import 'package:game_server/src/response/response.dart';
import 'package:game_server/src/response/success.dart';

abstract class Move <P>{
  bool legal = false;
  String error;


  Response check(P position){

    return doCheck(position);
  }

  Response doCheck(P position);

  Response go(P position){

      doMove(position);
      return Success();
  }

  doMove(P position);


}