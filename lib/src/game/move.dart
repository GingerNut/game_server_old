



import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/response.dart';
import 'package:game_server/src/messages/response/success.dart';

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