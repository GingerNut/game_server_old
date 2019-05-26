

import 'client/client.dart';
import 'command/command.dart';
import 'database/database.dart';

class GameServer{

  Database db = Database();

  List<Client> _clients = new List();

  int get numberOfClients => _clients.length;

  String get clientList{
    String string = '';

    for(int i = 0 ; i < _clients.length ; i++){
      Client c = _clients[i];
      string += c.displayName;
      if(i < _clients.length -1)string += Command.delimiter;
    }
    return string;
  }

  removeClient(Client client){

    _clients.remove(client);

  }

  bool clientWithLogin(String id) => _clients.any((c) => c.id == id);

  addClient(Client client) async{
    await client.initialise(this);
    client.requestLogin();
    _clients.add(client);
  }

  reset(){
    _clients.clear();
  }



}