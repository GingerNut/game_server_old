


import 'dart:convert';

import '../message.dart';
import 'new_game.dart';

class GameStarted extends Message{
  static const String type = 'game_started';

  String gameId;

  GameStarted(this.gameId);


  GameStarted.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}