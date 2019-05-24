


import 'client/client.dart';

class GameServer{

  Set<Client> _clients = new Set();

  addClient(Client client){
    client.initialise(this);
    client.requestLogin();
    _clients.add(client);

  }




}