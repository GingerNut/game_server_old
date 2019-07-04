

import 'package:core_game/html_game.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';

import 'http_interface.dart';

class LocalHostHttpInterface extends HttpInterface{

  String address = 'localhost';
  int port = 8080;

  LocalHostHttpInterface(GameDependency injector) : super(injector);

  login(String id, String password) async{
    super.login(id, password);
    connection = await IoClientConnection(this, address, port);
    await connection.login(id, password);
  }









}