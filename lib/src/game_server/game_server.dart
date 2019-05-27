



import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';

class GameServer{

  Database db = Database();

  List<Member> _membersOnline = List();


  int get numberOfClients => _membersOnline.length;

  String get membersOnline{
    String string = '';

    for(int i = 0 ; i < _membersOnline.length ; i++){
      Member m = _membersOnline[i];
      string += m.connection.displayName;
      if(i < _membersOnline.length -1)string += Command.delimiter;
    }
    return string;
  }



  bool clientWithLogin(String id) => _membersOnline.any((m) => m.id == id);

  addConnection(ServerConnection connection) async{
    await connection.initialise(this);
    connection.requestLogin();

    Member member;

    _membersOnline.forEach((m) {
      if(m.id == connection.id) {
        m.connection.close();
        m.connection = connection;
        member = m;
      }
    });

    if(member == null) {
      member = Member(connection.id);
      member.connection = connection;
      _membersOnline.add(member);
    }

  }

  reset(){
    _membersOnline.clear();
  }



}