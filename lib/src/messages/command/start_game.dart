


import 'dart:convert';

import '../message.dart';
import 'new_game.dart';

class StartGame extends Message{
  static const String type = 'start_game';

  String gameId;

  StartGame(NewGame game){
    this.gameId = game.id;
  }

  StartGame.fromString(String details){
    this.gameId = details;
  }



  StartGame.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}