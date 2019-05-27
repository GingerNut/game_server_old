import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/client_connection/client_connection.dart';
import 'package:game_server/src/game_server/client_connection/stream_connection.dart';
import 'package:game_server/src/interface.dart';

class TestStreamInterface extends Interface{

  Future initialise(GameServer server)async{
    connection = await StreamClientConnection(server);
    return;
  }

  Future login(String id, String password) async{
    await connection.login(id, password);
    return;
  }



}