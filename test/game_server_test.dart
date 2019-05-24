
import 'package:game_server/game_server.dart';
import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/stream_channel.dart';

import 'package:game_server/src/channel/web_channel_client_io.dart';
import 'package:game_server/src/client/stream_client.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/database/record.dart';
import 'package:game_server/src/user.dart';


import 'package:test/test.dart';


void main()async{


  Future<StreamChannel> connectToStreamServer(User user, GameServer server) async{
    StreamChannel channel = StreamChannel(user);
    StreamClient client = StreamClient(null);
    StreamChannel clientChannel = StreamChannel(client);
    client.userChannel = clientChannel;
    client.setup();
    await StreamChannel.handshake(channel, clientChannel);
    server.addClient(client);
    return channel;
  }




  group ('basic stream server',(){

    GameServer server = GameServer();
    Channel channel;
    User user = User();

    setUp(() async {
      await server.db.testData();
      user.login('henry', 'h1234');
      channel = await connectToStreamServer(user, server);

    });


    test('communication basics',() async{

      expect(await channel.first, Command.requestLogin);
      expect(server.numberOfClients, 1);

      channel.sink(Command.echo + 'hey');
   // expect(await channel.firstWhere((s) => s.substring(0,3) == 'ech'), 'echo hey');

    });

    tearDown(() async {
      await channel.close();
    });


  });


  group('web socket connection',() {
    String address = 'localhost';
    int port = 8080;
    IOWebChannelClient channel;
    User user;


    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\server.dart

      channel = IOWebChannelClient(user, "ws://" + address + ":$port");
      await channel.connect();

    });


    test('communication basics',() async{

      expect(await channel.first, Command.requestLogin);

      channel.sink(Command.echo + 'hey');
//    expect(await channel.firstWhere((s) => s.substring(0,3) == 'ech'), 'echo hey');

    });

    tearDown(() async {
      await channel.close();
    });

  });



}