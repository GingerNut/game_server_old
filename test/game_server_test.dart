import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// dart C:\Users\Stephen\growing_games\game_server\bin\server.dart

void main(){

  IOWebSocketChannel channel;

  setUp(() async {

    var handler = webSocketHandler((webSocket) {
      webSocket.stream.listen((message) {
        print(message);
        webSocket.sink.add("echo $message");
      });
    });

    await shelf_io.serve(handler, 'localhost', 8080).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });

    channel = await IOWebSocketChannel.connect("ws://localhost:8080");
    channel.stream.listen((d) => print(d));
  });


  test('websocket basics',() async{

    channel.sink.add('hey');


  });


  tearDown(() async {
    await channel.sink.close();
  });



}