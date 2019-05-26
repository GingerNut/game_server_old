
import 'package:game_server/game_server.dart';
import 'package:game_server/src/user/IoUser.dart';
import 'package:game_server/src/user/stream_user.dart';
import 'package:game_server/src/user/user.dart';


import 'package:test/test.dart';


void main()async{

  group ('basic stream server',(){

    GameServer server = GameServer();
    StreamUser user = StreamUser(server);

    setUp(() async {
      await server.db.testData();
      await user.login('henry', 'h1234');

    });


    test('communication basics',() async{

      expect(await user.messagesIn.stream.first, 'rql');
      expect(server.numberOfClients, 1);

      await user.login('henry', 'h1235');
      await user.login('henry', 'h1234');

    });

    tearDown(() async {
      await user.serverChannel.close();
    });


  },
  );


  group('web socket connection',() {
    String address = 'localhost';
    int port = 8080;
    User user = IoUser(address, port);

    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\server.dart

      await user.login('henry', 'h1234');

    });


    test('communication basics',() async{

      expect(await user.messagesIn.stream.first, 'rql');



    });

    tearDown(() async {
      await user.logout();
    });

  },skip: 'not testing web');



}