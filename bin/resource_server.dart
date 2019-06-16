

// dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart

//

import 'dart:io';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/game_server/server_connection/http_connection.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

import '../examples/fie_fo_fum/lib/fie_fo_fum_injector.dart';


void main() async{
  String address = 'localhost';
  int port = 8080;

  GameServer gameServer = GameServer(FieFoFumInjector());
  await gameServer.db.testData();

  var handler = webSocketHandler((webSocket) {

    HttpConnection client = HttpConnection(webSocket);
    gameServer.addConnection(client);

  });

  HttpServer server = await shelf_io.serve(handler, address, port);
  print('Serving at ws://${server.address.host}:${server.port}');
}