library message;

import 'dart:convert';

import 'package:html_game/src/game/game.dart';
import 'game_message/game_message.dart';

part 'chat/chat_message.dart';
part 'chat/private_message.dart';

part 'command/echo.dart';
part 'command/game_started.dart';
part 'command/join_game.dart';
part 'command/login.dart';
part 'command/logout.dart';
part 'command/make_move.dart';
part 'command/new_game.dart';
part 'command/request_login.dart';
part 'command/request_player_list.dart';
part 'command/send_position.dart';
part 'command/set_player_status.dart';
part 'command/setId.dart';
part 'command/start_game.dart';
part 'command/tidy.dart';
part 'command/your_turn.dart';

part 'error/game_error.dart';

part 'response/confirm_move.dart';
part 'response/echo_response.dart';
part 'response/login_success.dart';
part 'response/player_list.dart';
part 'response/response.dart';
part 'response/success.dart';

abstract class Message{

  static String delimiter = '\n';
  static String internalDelimiter = ',';

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
      case ConfirmMove.type:
        return ConfirmMove.fromJSON(string);
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
      case RefreshScreen.type:
        return RefreshScreen.fromJSON(string);
      case ChangeScreen.type:
        return ChangeScreen.fromJSON(string);
      case GameTimer.type:
        return GameTimer.fromJSON(string);

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