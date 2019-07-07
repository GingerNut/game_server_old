library game_message;

import 'dart:convert';

import 'package:game_server/src/game/game.dart';




part 'change_screen.dart';
part 'game_timer.dart';
part 'refresh_screen.dart';

abstract class GameMessage extends Message {

  static inflate(String string) {
    var jsonObject = jsonDecode(string);

    switch (jsonObject['type']) {
      case RefreshScreen.type:
        return RefreshScreen.fromJSON(string);

      case ChangeScreen.type:
        return ChangeScreen.fromJSON(string);

      case GameTimer.type:
        return GameTimer.fromJSON(string);

      default:
        return null;
    }
  }

}