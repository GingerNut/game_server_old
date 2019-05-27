



import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/game_server/database/database.dart';
import 'package:game_server/src/game_server/member.dart';
import 'package:game_server/src/game_server/server_connection/server_connection.dart';

class GameServer{

  Database db = Database();

  Set<Member> _membersOnline = Set();

  List<ServerConnection> _connections = new List();

  int get numberOfClients => _connections.length;

  String get clientList{
    String string = '';

    for(int i = 0 ; i < _connections.length ; i++){
      ServerConnection c = _connections[i];
      string += c.displayName;
      if(i < _connections.length -1)string += Command.delimiter;
    }
    return string;
  }

  removeClient(ServerConnection client){

    _connections.remove(client);

  }

  bool clientWithLogin(String id) => _connections.any((c) => c.id == id);

  addClient(ServerConnection client) async{
    await client.initialise(this);
    client.requestLogin();
    _connections.add(client);
  }

  reset(){
    _connections.clear();
  }



}