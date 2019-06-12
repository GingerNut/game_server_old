



import 'dart:convert';

import '../message.dart';
import 'new_game.dart';

class JoinGame extends Message{
  static const type = 'join_game';
  static const String code = 'joi';
    String gameId;


  JoinGame(NewGame game){
    this.gameId = game.id;
  }

  JoinGame.fromString(String details){
    this.gameId = details;
  }

  String get string => code
      + gameId;


  JoinGame.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}