

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'client.dart';



class Server {
  final String address;
  final int port;

  static List<Client> _clients = new List();

  Server(this.address, this.port);

  Future<void> initialise()async{

    await shelf_io.serve(handler, address, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });

    return;
  }

  var handler = webSocketHandler((webSocket) {

    Client client = Client(webSocket);
    client.initialise();
    _clients.add(client);


  });





  //var staticHandler = shelf_io.createStaticHandler(staticPath, defaultDocument:'home.html');




}