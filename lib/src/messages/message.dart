import 'dart:convert';

import 'package:game_server/src/messages/response/login_success.dart';
import 'package:game_server/src/messages/response/echo_response.dart';
import 'package:game_server/src/messages/response/player_list.dart';

import 'chat/chat_message.dart';
import 'chat/private_message.dart';
import 'command/echo.dart';
import 'command/game_started.dart';
import 'command/join_game.dart';
import 'command/login.dart';
import 'command/logout.dart';
import 'command/make_move.dart';
import 'command/new_game.dart';
import 'command/request_login.dart';
import 'command/request_player_list.dart';
import 'command/send_position.dart';
import 'command/setId.dart';
import 'command/set_player_status.dart';
import 'command/start_game.dart';
import 'command/tidy.dart';
import 'command/your_turn.dart';
import 'error/game_error.dart';
import 'response/success.dart';

abstract class Message{

  String delimiter = '\n';
  String internalDelimiter = ',';

  String get json;

  static Message inflate(String string) {
    var jsonObject = jsonDecode(string);

    switch (jsonObject['type']) {
      case LoginSuccess.type:
        return LoginSuccess.fromJSON(string);
      case Echo.type:
        return Echo.fromJSON(string);
      case EchoResponse.type:
        return EchoResponse.fromJSON(string);
      case JoinGame.type:
        return JoinGame.fromJSON(string);
      case Login.type:
        return Login.fromJSON(string);
      case MakeMove.type:
        return MakeMove.fromJSON(string);
      case NewGame.type:
        return NewGame.fromJSON(string);
      case SendPosition.type:
        return SendPosition.fromJSON(string);
      case SetStatus.type:
        return SetStatus.fromJSON(string);
      case StartGame.type:
        return StartGame.fromJSON(string);
      case Tidy.type:
        return Tidy.fromJSON(string);
      case YourTurn.type:
        return YourTurn.fromJSON(string);
      case GameError.type:
        return GameError.fromJSON(string);
      case Success.type:
        return Success.fromJSON(string);
      case RequestLogin.type:
        return RequestLogin.fromJSON(string);
      case Logout.type:
        return Logout.fromJSON(string);
      case RequestPlayerList.type:
        return RequestPlayerList.fromJSON(string);
      case PlayerList.type:
        return PlayerList.fromJSON(string);
      case ChatMessage.type:
        return ChatMessage.fromJSON(string);
      case PrivateMessage.type:
        return PrivateMessage.fromJSON(string);
      case SetId.type:
        return SetId.fromJSON(string);
      case GameStarted.type:
        return GameStarted.fromJSON(string);
      default:
        return null;
    }
  }


//  Message.fromJSON(String string){
//
//    var jsonObject = JSON.jsonDecode(string);
//
//   ....
//  }

//  get json => JSON.jsonEncode({
//    'type': type,
//    ...
//  });



}