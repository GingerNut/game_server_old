import 'game_server/client_connection/client_connection.dart';

abstract class Interface{

  ClientConnection connection;

  login(String id, String password);


}