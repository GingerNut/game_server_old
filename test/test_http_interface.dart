

import 'package:game_server/src/game_server/client_connection/io_client.dart';
import 'package:game_server/src/interface/http_interface.dart';

class TestHttpInterface extends HttpInterface{

  String address = 'localhost';
  int port = 8080;

  login(String id, String password) async{
    connection = await IoClientConnection(address, port);
    await connection.login(id, password);
  }






}