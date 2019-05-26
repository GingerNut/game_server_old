
import 'dart:async';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/command/command.dart';
import 'package:game_server/src/user/IoUser.dart';
import 'package:game_server/src/user/stream_user.dart';
import 'package:game_server/src/user/user.dart';


import 'package:test/test.dart';


void main()async{

  Future <String> nextMessage(Stream<String> stream )async{

    await for(String string in stream){
      return string;
    }
  }

  group ('basic stream server',(){

    GameServer server = GameServer();
    StreamUser user = StreamUser(server);

    setUp(() async {
      await server.db.testData();
      await user.login('henry', 'h1234');
    });

    test('communication basics',() async{

      expect(await nextMessage(user.messagesIn.stream), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)).substring(0,3), Command.loginSuccess);

      user.send(Command.requestClientList);

      expect((await nextMessage(user.messagesIn.stream)), Command.requestClientList + 'Henry');

      expect(user.clients.length, 1);
      expect(server.numberOfClients, 1);

      await user.login('henry', 'h1235');
      expect((await nextMessage(user.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)), Command.gameError);
      await user.login('henry', 'h1234');
      expect((await nextMessage(user.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)), Command.gameError);

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

      // dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart

      await user.login('henry', 'h1234');
    });

    test('communication basics',() async{

      expect(await nextMessage(user.messagesIn.stream), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)).substring(0,3), Command.loginSuccess);

      user.send(Command.requestClientList);

      expect((await nextMessage(user.messagesIn.stream)), Command.requestClientList + 'Henry');

      expect(user.clients.length, 1);

      await user.login('henry', 'h1235');
      expect((await nextMessage(user.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)), Command.gameError);
      await user.login('henry', 'h1234');
      expect((await nextMessage(user.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(user.messagesIn.stream)), Command.gameError);

    });

    tearDown(() async {
      await user.logout();
    });


  }, skip: 'server test'
  );



}