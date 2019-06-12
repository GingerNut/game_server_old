
import 'dart:convert';

import 'package:game_server/src/messages/command/command.dart';

import '../message.dart';

class ChatMessage extends Message{
  static const String type = 'chat_message';
  static const String code = 'cha';
  String from;
  DateTime  timeStamp;
  String text;

  ChatMessage(this.from, this.text);

  ChatMessage.fromString(String string){
    List<String> details = string.split(Command.delimiter);

    from = details[0];
    text = details[1];
    timeStamp = DateTime.now();
  }

  String get string => code + from + Command.delimiter + text;


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