
import 'package:game_server/src/command.dart';
import 'package:web_socket_channel/io.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:game_server/game_server.dart';

void main(){

  IOWebSocketChannel channel;
  Server socketHandler = Server();

  setUp(() async {

    await shelf_io.serve(socketHandler.handler, 'localhost', 8080).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });

    channel = await IOWebSocketChannel.connect("ws://localhost:8080");



  });


  test('websocket basics',() async{

    channel.sink.add(Command.echo + 'hey');
    expect(await channel.stream.first, 'echo hey');

  });


  tearDown(() async {
    await channel.sink.close();
  });



}