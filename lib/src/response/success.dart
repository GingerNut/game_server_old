




import 'package:game_server/src/response/response.dart';

class Success extends Response{

  bool operator ==(other) => other is Success;

  String render;

  Success.login(String playerId){

    render = 'Successful login for player ' + playerId;
  }

  Success();



}