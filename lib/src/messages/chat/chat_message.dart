
import 'dart:convert';


import '../message.dart';

class ChatMessage extends Message{
  static const String type = 'chat_message';
  static const String code = 'cha';
  String from;
  DateTime  timeStamp;
  String text;

  ChatMessage(this.from, this.text);


  ChatMessage.fromJSON(String string){
    var jsonObject = jsonDecode(string);

    from = jsonObject['from'];
    text = jsonObject['text'];
  }

  get json => jsonEncode({
    'type': type,
    'text' : text,
    'from':from
  });

}