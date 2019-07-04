


import 'package:core_game/html_game.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';

import '../../game_server.dart';
import 'http_interface.dart';

class StreamHttpInterface extends HttpInterface{

  final GameServer server;

  StreamHttpInterface(GameDependency injector, this.server) : super(injector);

  Future login(String id, String password) async{
    super.login(id, password);
    connection = await StreamClientConnection(this, server);

    await connection.login(id, password);
    return;
  }





}