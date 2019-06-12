import 'dart:convert';

import '../message.dart';

class GameError extends Message{
  static const String type = 'game_error';
  String text;

  GameError(this.text);


  GameError.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });

}