





import 'dart:convert';

import '../message.dart';

class Success extends Message{
  static const String type = 'success';
  static const String code = 'suc';
  String text = '';

  bool operator ==(other) => other is Success;

  Success();

  Success.fromString(String string){
    this.text = string;
  }


  String get string => code;


  Success.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text
  });
}