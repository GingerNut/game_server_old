import 'dart:convert';

import '../message.dart';

class GameError extends Message{
  static const String type = 'game_error';
  static const String code = 'err';
  String text;

  GameError(this.text);


  String get string => code + delimiter + text;

  GameError.fromString(String string){
    this.text = string;
  }



  GameError.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });

}