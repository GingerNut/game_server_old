
import 'package:game_server/src/messages/command/command.dart';

import '../message.dart';

class PrivateMessage extends Message{

  static const String code = 'pri';

  String from;
  String to;
  DateTime  timeStamp;
  String text;

  PrivateMessage(this.from, this.to, this.text);

  PrivateMessage.fromString(String string){
    List<String> details = string.split(delimiter);

    from = details[0];
    to = details[1];
    text = details[2];
    timeStamp = DateTime.now();
  }

  String get string => code
      + from + delimiter
      + to + delimiter
      + text;


}