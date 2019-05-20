
import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/web_channel_client_io.dart';
import 'package:game_server/src/client.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/user.dart';
import 'package:web_socket_channel/io.dart';
import 'package:test/test.dart';

import 'package:game_server/game_server.dart';

void main(){

  String address = 'localhost';
  int port = 8080;

  IOWebChannelClient channel;
  Server gameServer;
  User user;

  setUp(() async {

    gameServer = Server(address, port);
    await gameServer.initialise();
    channel = IOWebChannelClient(user, "ws://" + address + ":$port");
    await channel.connect();

  });


  test('websocket basics',() async{

    channel.sink(Command.echo + 'hey');
    expect(await channel.first, 'echo hey');

  });


  tearDown(() async {
   // await channel.sink.close();
  });



}