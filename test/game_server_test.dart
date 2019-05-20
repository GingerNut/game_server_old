
import 'package:game_server/src/command/command.dart';
import 'package:web_socket_channel/io.dart';
import 'package:test/test.dart';

import 'package:game_server/game_server.dart';

void main(){

  String address = 'localhost';
  int port = 8080;

  IOWebSocketChannel channel;
  Server gameServer;

  setUp(() async {

    gameServer = Server(address, port);
    await gameServer.initialise();
    channel = await IOWebSocketChannel.connect("ws://" + address + ":$port");

  });


  test('websocket basics',() async{

    channel.sink.add(Command.echo + 'hey');
    expect(await channel.stream.first, 'echo hey');

  });


  tearDown(() async {
    await channel.sink.close();
  });



}