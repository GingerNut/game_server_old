import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/client_connection/stream_connection.dart';
import 'package:game_server/src/interface/http_interface.dart';

import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position_builder.dart';


class TestStreamInterface extends HttpInterface{

  final GameServer server;

  get moveBuilder => FieFoFumMoveBuilder();
  get positionBuilder => FieFoFumPositionBuilder();

  TestStreamInterface(this.server);

  Future login(String id, String password) async{
    super.login(id, password);
    connection = await StreamClientConnection(this, server);

    await connection.login(id, password);
    return;
  }





}