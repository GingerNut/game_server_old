



import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

abstract class Move <P>{
  bool legal = false;
  String error;


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