

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'command/command.dart';


class Server{
  final String address;
  final int port;

  Server(this.address, this.port);

  Future<void> initialise()async{

    await shelf_io.serve(handler, address, port).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });

    return;
  }

  var handler = webSocketHandler((webSocket) {
    webSocket.stream.listen((message) {

      String string = message.toString();
      String type = string.substring(0,3);
      String content = string.substring(3);

      switch(type){
        case Command.echo:
          webSocket.sink.add("echo $content");
          break;



      }







    });
  });


  //var staticHandler = shelf_io.createStaticHandler(staticPath, defaultDocument:'home.html');




}