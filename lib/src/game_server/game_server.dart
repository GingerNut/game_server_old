

import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/command.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';

import 'advert.dart';

abstract class GameServer implements GameHost{

  Database db = Database();

  List<ServerConnection> _connections = List();
  List<Member> _membersOnline = List();
  List<Advert> _adverts = List();

  int get numberOfClients => _membersOnline.length;

  List<Member> get members => _membersOnline;

  String get membersOnlineList{
    String string = '';

    for(int i = 0 ; i < _membersOnline.length ; i++){
      Member m = _membersOnline[i];
      string += m.connection.displayName;
      if(i < _membersOnline.length -1)string += Command.delimiter;
    }
    return string;
  }

  bool clientWithLogin(String id) => _membersOnline.any((m) => m.id == id);

  addConnection(ServerConnection connection) async {
    await connection.initialise(this);
    connection.requestLogin();
    _connections.add(connection);
  }

  removeConnection(ServerConnection connection)async{
    _connections.remove(connection);
  }

  addMember(ServerConnection connection)async{
    _connections.remove(connection);

    Member member;

    _membersOnline.forEach((m) {
      if(m.id == connection.id) {
        m.connection.send(Command.connectionSuperseded);
        //TODO superseding connection
        m.connection.close();
        m.connection = connection;
        connection.member = m;
        member = m;
      }
    });

    if(member == null) {
      member = Member(connection.id);
      member.connection = connection;
      connection.member = member;
      _membersOnline.add(member);
    }

  }

  removeMember(ServerConnection con){
    if(con.member != null) _membersOnline.remove(con.member);
  }

  reset(){
    _membersOnline.clear();
  }

  addGeneralChat(ChatMessage message){

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