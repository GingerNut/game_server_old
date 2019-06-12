


import 'dart:convert';

import '../message.dart';

class YourTurn extends Message{
  static const String type = 'your_turn';
  static const String code = 'you';
  String gameId;

  YourTurn(this.gameId);

  YourTurn.fromString(String details){
    this.gameId = details;
  }

  String get string => code
      + gameId;


  YourTurn.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}