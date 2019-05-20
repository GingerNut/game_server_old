

import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'client.dart';

class GameServer{
  HttpServer server;
  final String address;
  final int port;

  List<Client> _clients = new List();

  GameServer(this.address, this.port);

  Future<void> initialise()async{

    server = await shelf_io.serve(handler, address, port);

    print('Serving at ws://${server.address.host}:${server.port}');

    return;
  }

  var handler = webSocketHandler((webSocket) {

    Client client = Client(webSocket);
    client.initialise();
    //_clients.add(client);


  });





  //var staticHandler = shelf_io.createStaticHandler(staticPath, defaultDocument:'home.html');




}