

import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game_server/client_connection/io_client.dart';
import 'package:game_server/src/interface/http_interface.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position_builder.dart';



class TestHttpInterface extends HttpInterface{

  String address = 'localhost';
  int port = 8080;

  login(String id, String password) async{
    super.login(id, password);
    connection = await IoClientConnection(this, address, port);
    await connection.login(id, password);
  }

  get moveBuilder => FieFoFumMoveBuilder();
  get positionBuilder => FieFoFumPositionBuilder();








}