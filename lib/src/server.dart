

import 'client/client.dart';
import 'command/command.dart';
import 'database/database.dart';

class GameServer{

  Database db = Database();

  Set<Client> _clients = new Set();

  int get numberOfClients => _clients.length;

  String get clientList{
    String string = '';

    _clients.forEach((c){
      string += c.displayName;
      string += Command.delimiter;
    });

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




}