import 'dart:convert';

import '../message.dart';

class Echo extends Message{
  static const type = 'echo';
  static const code = 'ech';
  String text;

  Echo(this.text);

  String get string => code;

  Echo.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });





}