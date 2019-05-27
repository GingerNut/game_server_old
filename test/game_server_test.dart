
import 'dart:async';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/command/command.dart';

import 'package:test/test.dart';

import 'test_http_interface.dart';
import 'test_stream_interface.dart';


void main()async{

  Future <String> nextMessage(Stream<String> stream )async{

    await for(String string in stream){
      return string;
    }
  }

  group ('basic stream server',(){

    GameServer server = GameServer();
    TestStreamInterface ui = TestStreamInterface(server);

    setUp(() async {
      await server.db.testData();
      await ui.login('henry', 'h1234');
    });

    test('communication basics',() async{

      expect(await nextMessage(ui.connection.messagesIn.stream), Command.requestLogin);
      expect((await nextMessage(ui.connection.messagesIn.stream)).substring(0,3), Command.loginSuccess);

      ui.connection.send(Command.requestClientList);

      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.requestClientList + 'Henry');

      expect(ui.connection.clients.length, 1);
      expect(server.numberOfClients, 1);

      await ui.connection.login('henry', 'h1235');
      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.gameError);
//      await ui.connection.login('henry', 'h1234');
//      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.connectionSuperseded);
//      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.requestLogin);
//      expect((await nextMessage(ui.connection.messagesIn.stream)).substring(0,3), Command.loginSuccess);
//      expect(server.numberOfClients, 1); // replaced connection on member on server

    });

    tearDown(() async {
      await ui.logout();
    });


  },
  );

  group('Game test',() {
    GameServer server = GameServer();
    TestStreamInterface henry = TestStreamInterface(server);
    TestStreamInterface james = TestStreamInterface(server);
    TestStreamInterface sarah = TestStreamInterface(server);
    TestStreamInterface trace = TestStreamInterface(server);

    setUp(() async {
      await server.db.testData();

      await henry.login('henry', 'h1234');
      await james.login('james', 'j1234');
      await sarah.login('sarah', 's1234');
      await trace.login('trace', 't1234');

      await Future.delayed(Duration(seconds: 1));
    });

    test('Logins ',() async{

      expect(server.numberOfClients, 4);
      henry.connection.send(Command.requestClientList);
      expect( await nextMessage(henry.connection.messagesIn.stream),
      Command.requestClientList
          + 'Henry' + Command.delimiter
          + 'Jim' + Command.delimiter
          + 'Sarah' + Command .delimiter
          + 'Tracy') ;

      henry.connection.sendChat('hi');
      expect((await nextMessage(james.connection.messagesIn.stream)).substring(0,3), Command.chat);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.connection.sendChat('Hows it going');
      expect((await nextMessage(henry.connection.messagesIn.stream)).substring(0,3), Command.chat);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.connection.sendMessage('james', 'hello james');
      expect((await nextMessage(james.connection.messagesIn.stream)).substring(0,3), Command.privateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.connection.sendMessage('sarah', 'yo');
      expect((await nextMessage(sarah.connection.messagesIn.stream)).substring(0,3), Command.privateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.connection.sendMessage('emma', 'hey Emma');
      expect((await nextMessage(henry.connection.messagesIn.stream)).substring(0,3), Command.privateMessage);
      expect(henry.privateMessages.length, 1);
      expect(henry.privateMessages[0].from, 'server');
      expect(henry.privateMessages[0].text, 'emma is not online');


    });


    tearDown(() async {
      await henry.logout();
      await james.logout();
      await sarah.logout();
      await trace.logout();
    });


  });


  group('web socket connection',() {
    TestHttpInterface ui = TestHttpInterface();

    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart

      await ui.login('henry', 'h1234');
    });

    test('communication basics',() async{

      expect(await nextMessage(ui.connection.messagesIn.stream), Command.requestLogin);
      expect((await nextMessage(ui.connection.messagesIn.stream)).substring(0,3), Command.loginSuccess);

      ui.connection.send(Command.requestClientList);

      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.requestClientList + 'Henry');

      expect(ui.connection.clients.length, 1);

      await ui.connection.login('henry', 'h1235');
      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.requestLogin);
      expect((await nextMessage(ui.connection.messagesIn.stream)), Command.gameError);

//      await user.login('henry', 'h1234');
//      expect((await nextMessage(user.messagesIn.stream)), Command.connectionSuperseded);
//      expect((await nextMessage(user.messagesIn.stream)), Command.requestLogin);
//      expect((await nextMessage(user.messagesIn.stream)).substring(0,3), Command.loginSuccess);

    });

    tearDown(() async {
      await ui.logout();
    });


  }, skip: 'server test'
  );



}