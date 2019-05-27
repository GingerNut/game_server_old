

import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';

abstract class Interface{
  ClientConnection connection;
  Position position;

  login(String id, String password);

  logout(){
    connection.close();
  }

}