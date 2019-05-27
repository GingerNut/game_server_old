import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';

import 'package:game_server/src/messages/chat/chat_message.dart';

class Chat{

  final ChatHost host;

  Chat(this.host);

  List<Member> get members => host.members;

  addMessage(ChatMessage message){

    String broadcast = message.string;

    members.forEach((m) {
      m.connection.send(broadcast);
    });

  }

  addPrivateMessage(PrivateMessage message){
    Member to;
    Member from;

    members.forEach((m) {
      if(m.id == message.to) to = m;
      if(m.id == message.from) from = m;
    });

    if(to != null) {
      to.connection.send(message.string);
      if(from != null) from.connection.send(message.string);

    } else {
      if(from != null) from.connection.send(PrivateMessage('server', from.id, message.to + ' is not online').string);
    }



  }

}



mixin ChatHost{

  List<Member> get members;


}




