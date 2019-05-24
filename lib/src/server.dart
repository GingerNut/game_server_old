


import 'client/client.dart';
import 'database/database.dart';

class GameServer{

  Database db = Database();

  Set<Client> _clients = new Set();

  int get numberOfClients => _clients.length;

  addClient(Client client){
    client.initialise(this);
    client.requestLogin();
    _clients.add(client);

  }




}