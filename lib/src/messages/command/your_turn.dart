


import 'dart:convert';

import '../message.dart';

class YourTurn extends Message{
  static const String type = 'your_turn';

  String gameId;

  YourTurn(this.gameId);

  YourTurn.fromString(String details){
    this.gameId = details;
  }



  YourTurn.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    gameId = jsonObject['game_id'];
  }

  get json => jsonEncode({
    'type': type,
    'game_id' : gameId
  });
}