import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/game_server/client_connection/stream_connection.dart';
import 'package:game_server/src/interface/http_interface.dart';

class TestStreamInterface extends HttpInterface{

  final GameServer server;

  TestStreamInterface(this.server);

  Future login(String id, String password) async{
    connection = await StreamClientConnection(server);

    await connection.login(id, password);
    return;
  }



}