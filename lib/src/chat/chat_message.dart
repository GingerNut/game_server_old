import 'package:game_server/src/game_server/member.dart';

class ChatMessage{

  final String from;
  DateTime  timeStamp;

  final String text;

  ChatMessage(this.from, this.text);


}