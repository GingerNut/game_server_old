
import 'package:game_server/src/messages/command/command.dart';

import '../message.dart';

class PrivateMessage extends Message{

  String from;
  String to;
  DateTime  timeStamp;
  String text;

  PrivateMessage(this.from, this.to, this.text);

  PrivateMessage.fromString(String string){
    List<String> details = string.split(Command.delimiter);

    from = details[0];
    to = details[1];
    text = details[2];
    timeStamp = DateTime.now();
  }

  String get string => Command.privateMessage
      + from + Command.delimiter
      + to + Command.delimiter
      + text;


}