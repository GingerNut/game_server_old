
import 'package:game_server/src/messages/command/command.dart';

import '../message.dart';

class ChatMessage extends Message{

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



}