

// dart C:\Users\Stephen\growing_games\game_server\bin\server.dart

import 'dart:io';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/client/web_client.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';


void main() async{
  String address = 'localhost';
  int port = 8080;

  GameServer gameServer = GameServer();
  await gameServer.db.testData();

  var handler = webSocketHandler((webSocket) {

    WebClient client = WebClient(webSocket);
    gameServer.addClient(client);

  });

  HttpServer server = await shelf_io.serve(handler, address, port);
  print('Serving at ws://${server.address.host}:${server.port}');
}