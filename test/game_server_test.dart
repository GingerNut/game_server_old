
import 'package:game_server/game_server.dart';
import 'package:game_server/src/channel/channel.dart';
import 'package:game_server/src/channel/stream_channel.dart';

import 'package:game_server/src/channel/web_channel_client_io.dart';
import 'package:game_server/src/client/stream_client.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/user.dart';


import 'package:test/test.dart';


void main()async{


  Future<StreamChannel> connectToStreamServer(User user, GameServer server) async{
    StreamChannel newChannel = StreamChannel(user);
    StreamClient client = StreamClient(null);
    StreamChannel clientChannel = StreamChannel(client);
    client.userChannel = clientChannel;
    await StreamChannel.handshake(newChannel, clientChannel);
    server.addClient(client);
    return newChannel;
  }



  group ('basic stream server',(){

    GameServer server = GameServer();
    StreamChannel userChannel;
    User user = User();

    setUp(() async {

      userChannel = await connectToStreamServer(user, server);

    });


    test('communication basics',() async{

      expect(await userChannel.first, Command.requestLogin);
      expect(server.numberOfClients, 1);

  //    channel.sink(Command.echo + 'hey');
//    expect(await channel.firstWhere((s) => s.substring(0,3) == 'ech'), 'echo hey');

    });

    tearDown(() async {
      await userChannel.close();
    });


  });


  group('web socket basic connection',() {
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