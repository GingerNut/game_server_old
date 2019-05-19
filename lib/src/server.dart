


import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'command.dart';

class Server{


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


}