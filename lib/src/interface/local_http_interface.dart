

import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game_server/client_connection/io_client.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/interface/http_interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';





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