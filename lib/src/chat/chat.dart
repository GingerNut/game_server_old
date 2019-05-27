import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/messages/command/command.dart';

import 'chat_message.dart';

class Chat{

  final ChatHost host;

  Chat(this.host);

  List<Member> get members => host.members;
  List<ChatMessage> _messages = new List();


  addMessage(ChatMessage message){

    _messages.add(message);

    String broadcast = Command.chat + message.from + Command.delimiter + message.text;

    members.forEach((m) {
      m.connection.send(broadcast);
    });

  }

}



mixin ChatHost{

  List<Member> get members;


}




