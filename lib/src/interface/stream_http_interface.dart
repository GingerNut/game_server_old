import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/client_connection/stream_connection.dart';
import 'package:game_server/src/interface/http_interface.dart';

import '../game_dependency.dart';




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