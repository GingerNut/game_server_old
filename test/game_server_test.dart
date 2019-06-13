
import 'dart:async';

import 'package:game_server/game_server.dart';
import 'package:game_server/src/design/palette.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/player/player.dart';
import 'package:game_server/src/game/player/player_variable.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/messages/chat/chat_message.dart';
import 'package:game_server/src/messages/chat/private_message.dart';
import 'package:game_server/src/messages/command/echo.dart';
import 'package:game_server/src/messages/command/make_move.dart';
import 'package:game_server/src/messages/command/new_game.dart';
import 'package:game_server/src/messages/command/request_player_list.dart';
import 'package:game_server/src/messages/command/send_position.dart';
import 'package:game_server/src/messages/command/set_player_status.dart';
import 'package:game_server/src/messages/error/game_error.dart';
import 'package:game_server/src/messages/message.dart';
import 'package:game_server/src/messages/response/echo_response.dart';
import 'package:game_server/src/messages/response/login_success.dart';
import 'package:game_server/src/messages/response/player_list.dart';
import 'package:game_server/src/messages/response/success.dart';

import 'package:test/test.dart';

import '../examples/fie_fo_fum/lib/fie_fo_fum_computer_player.dart';
import '../examples/fie_fo_fum/lib/fie_fo_fum_local_interface.dart';
import '../examples/fie_fo_fum/lib/fie_fo_fum_move_builder.dart';
import '../examples/fie_fo_fum/lib/fie_fo_fum_position.dart';
import '../examples/fie_fo_fum/lib/fie_fo_fum_position_builder.dart';
import '../examples/fie_fo_fum/lib/move_fie.dart';
import '../examples/fie_fo_fum/lib/move_fo.dart';
import '../examples/fie_fo_fum/lib/move_fum.dart';
import '../examples/fie_fo_fum/lib/move_number.dart';
import '../examples/fie_fo_fum/lib/fie_fo_fum_server.dart';
import '../examples/fie_fo_fum/lib/test_http_interface.dart';
import '../examples/fie_fo_fum/lib/test_stream_interface.dart';


void main()async{

  Future <String> nextMessage(Stream<String> stream )async{

    await for(String string in stream){
      return string;
    }
  }


  group('varous methods', (){
    var ui = FieFoFumLocalInterface();

    setUp(() async{
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      await ui.startGame(ui.newGame);
    });

    test('player variable',()async{

      expect(ui.game.position.playerStatus.string,
          PlayerVariable.playerVariablefromString(ui.game.position,ui.game.position.playerStatus.string).string);

      expect(ui.game.position.score.string,
          PlayerVariable.playerVariablefromString(ui.game.position,ui.game.position.score.string).string);

      expect(ui.game.position.color.string,
          PlayerVariable.playerVariablefromString(ui.game.position,ui.game.position.color.string).string);

    });

  });


  group('computer player basics',(){

    var ui = FieFoFumLocalInterface();
    var computer = FieFoFumComputerPlayer();

    setUp(()async{
      ui.addPlayer(Player());
      ui.addPlayer(computer);
      await ui.startGame(ui.newGame);
    });


    test('Basic computer connection', () async{
      computer.send(Echo('hey'));

      Message response = Message.inflate(await nextMessage(computer.messagesIn.stream));

      expect(response.runtimeType, EchoResponse);
      expect((response as EchoResponse).text, 'echo hey');

    },//skip:''
    );


    tearDown((){

      ui.game.tidyUp();

    });

  });

  group('Message testing',(){

    var ui = FieFoFumLocalInterface();

    setUp(() async{
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      await ui.startGame(ui.newGame);
    });


    test('SendPosition',(){
      SendPosition sendPostiion = SendPosition.fromGame(ui.game);
//      expect(sendPostiion.positionString, '1');
//      var jsonObject = sendPostiion.json;
//      expect(jsonObject, '{"type":"send_game","position_string":"1"}');
//      expect(SendPosition.fromJSON(jsonObject).positionString, '1');
      FieFoFumPosition position = sendPostiion.build(FieFoFumPositionBuilder());
      expect(position.count , 1);
      expect(position.playerIds, ['Player 1', 'Player 2', 'Player 3', 'Player 4']);
      expect(position.color['Player 1'], 7);
      expect(position.color['Player 2'], 6);
      expect(position.playerId.substring(0,6)  , 'Player');

      MakeMove makeMove = MakeMove('testGamne', 'player', MoveFie());
      Move move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFie);

      makeMove = MakeMove('testGamne', 'player', MoveFo());
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFo);

      makeMove = MakeMove('testGamne', 'player', MoveFum());
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveFum);

      makeMove = MakeMove('testGamne', 'player', MoveNumber());
      move = MakeMove.fromJSON(makeMove.json).build(FieFoFumMoveBuilder());
      expect(move.runtimeType, MoveNumber);



    });



  });


  group('Fie fo fum basic game ', () {

    var ui = FieFoFumLocalInterface();

    test('start local fie fo fum game',()async{
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());
      ui.addPlayer(Player());


      expect(ui.newGame.players.length, 4);

      await ui.startGame(ui.newGame);
      expect(ui.game.position.playerIds, ['Player 1', 'Player 2', 'Player 3', 'Player 4']);

      expect(ui.position.color['Player 1'], Palette.COLOR_WHITE);
      expect(ui.position.color['Player 2'], Palette.COLOR_BLACK);
      expect(ui.position.color['Player 3'], Palette.COLOR_BLUE);
      expect(ui.position.color['Player 4'], Palette.COLOR_RED);

      String winner = ui.position.playerId;

      expect(ui.position.playerQueue.length, 4);
      expect((ui.game.position as FieFoFumPosition).count, 1);
      ui.makeMove(MoveNumber());   // 1 so this is correct 0
      expect(ui.position.playerQueue.length, 4);
      ui.makeMove(MoveFie());   // 2 so this is wrong 1 out
      expect(ui.position.playerQueue.length, 3);
      ui.makeMove(MoveFie());   // 3 so this is good 2
      expect(ui.position.playerQueue.length, 3);
      ui.makeMove(MoveFo());   // 4 so this is wrong 3 out
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   // 5 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 6 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 7 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 8 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 9 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   //10 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 11 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFie());   // 12 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 13 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveNumber());   // 14 so this is godd 2
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFum());   // 15 so this is godd 0
      expect(ui.position.playerQueue.length, 2);
      ui.makeMove(MoveFo());   // 16 so this is bad 2
      expect(ui.position.playerQueue.length, 1);
      expect(ui.game.state , GameState.won);
      expect(ui.game.position.winner , winner);

    });




  });


  group ('basic stream server',(){

    GameServer server = FieFoFumServer();
    TestStreamInterface ui = TestStreamInterface(server);

    setUp(() async {
      await server.db.testData();
      await ui.login('emma', 'e1234');

    });

    test('communication basics',() async{

//      ui.connection.send(RequestPlayerList.code);
//
//      expect((await nextMessage(ui.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      expect(ui.connection.clients.length, 1);
//      expect(server.numberOfClients, 1);
//
//      await ui.connection.login('henry', 'h1235');
//      expect(server.numberOfClients, 1);
//
//      await ui.connection.login('henry', 'h1234');
//      expect(server.numberOfClients, 2);

    });


  tearDown(() async {
      await ui.logout();
    });


  },
  );

  group('Game test',() {
    GameServer server = FieFoFumServer();
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

    });

    test('Logins and chat',() async{

      expect(server.numberOfClients, 4);
      henry.connection.send(RequestPlayerList());

      var message = Message.inflate(await nextMessage(henry.connection.messagesIn.stream));

      expect(message.runtimeType, PlayerList);
      var playerList = message as PlayerList;
      expect(playerList.players.length, 4);

      expect(playerList.players, ['Henry', 'Jim', 'Sarah', 'Tracy']);

      henry.sendChat('hi');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(james.chatMessages.length,1);
      expect(james.chatMessages[0].from,'henry');
      expect(james.chatMessages[0].text,'hi');

      james.sendChat('Hows it going');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, ChatMessage);
      expect(henry.chatMessages.length,2);
      expect(henry.chatMessages[0].from,'henry');
      expect(henry.chatMessages[0].text,'hi');
      expect(henry.chatMessages[1].from,'james');
      expect(henry.chatMessages[1].text,'Hows it going');

      sarah.sendMessage('james', 'hello james');
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(james.privateMessages.length, 1);
      expect(james.privateMessages[0].from, 'sarah');
      expect(james.privateMessages[0].text, 'hello james');

      expect(sarah.privateMessages.length, 1);
      expect(sarah.privateMessages[0].from, 'sarah');
      expect(sarah.privateMessages[0].text, 'hello james');

      james.sendMessage('sarah', 'yo');
      expect((Message.inflate(await nextMessage(sarah.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(sarah.privateMessages.length, 2);
      expect(sarah.privateMessages[1].from, 'james');
      expect(sarah.privateMessages[1].text, 'yo');

      henry.sendMessage('emma', 'hey Emma');
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, PrivateMessage);
      expect(henry.privateMessages.length, 1);
      expect(henry.privateMessages[0].from, 'server');
      expect(henry.privateMessages[0].text, 'emma is not online');

    });

    test('advertise and start fie fo fum game',() async{

      expect(server.numberOfClients, 4);
      expect(james.adverts.length, 0);
      henry.advertiseGame();
      expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, NewGame);
      expect(james.adverts.length, 1);
      james.joinGame(james.adverts[0]);
       expect((Message.inflate(await nextMessage(james.connection.messagesIn.stream))).runtimeType, Success);

      henry.joinGame(henry.adverts[0]);
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, Success);
      sarah.joinGame(sarah.adverts[0]);
     expect((Message.inflate(await nextMessage(sarah.connection.messagesIn.stream))).runtimeType, Success);
      trace.joinGame(trace.adverts[0]);
      expect((Message.inflate(await nextMessage(trace.connection.messagesIn.stream))).runtimeType, Success);

      henry.startGame(henry.adverts[0]);
      expect((Message.inflate(await nextMessage(henry.connection.messagesIn.stream))).runtimeType, Success);

      henry.status = PlayerStatus.ready;
      james.status = PlayerStatus.ready;
      sarah.status = PlayerStatus.ready;
      trace.status = PlayerStatus.ready;

      var message = Message.inflate(await nextMessage(henry.connection.messagesIn.stream));

      expect(message.runtimeType, SetStatus);
      var setStatus = message as SetStatus;
      expect(setStatus.status, PlayerStatus.ready);

      //TODO make two or three moves

    });


    tearDown(() async {
      await henry.logout();
      await james.logout();
      await sarah.logout();
      await trace.logout();
    });



  });


  group('web socket connection',() {
    TestHttpInterface emma = TestHttpInterface();
    TestHttpInterface henry = TestHttpInterface();

    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart

      await emma.login('emma', 'e1234');
    });

    test('communication basics',() async{

//      emma.connection.send(RequestPlayerList.code);
//
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      expect(emma.connection.clients.length, 1);
//
//      await henry.login('henry', 'h1235');
//
//      emma.connection.send(RequestPlayerList.code);
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma');
//
//      await henry.login('henry', 'h1234');
//      expect((await nextMessage(emma.connection.messagesIn.stream)), RequestPlayerList.code + 'Emma' + Command.delimiter + 'Henry');


    });

    tearDown(() async {
      await emma.logout();
      await henry.logout();
    });


  }, skip: 'server test'
  );

  group('Websocket Game test',() {

    TestHttpInterface henry = TestHttpInterface();
    TestHttpInterface james = TestHttpInterface();
    TestHttpInterface sarah = TestHttpInterface();
    TestHttpInterface trace = TestHttpInterface();

    setUp(() async {

      // dart C:\Users\Stephen\growing_games\game_server\bin\resource_server.dart


      await henry.login('henry', 'h1234');
      await james.login('james', 'j1234');
      await sarah.login('sarah', 's1234');
      await trace.login('trace', 't1234');
    });

    test('Logins and chat',() async{

//      henry.connection.send(RequestPlayerList.code);
//      expect( await nextMessage(henry.connection.messagesIn.stream),
//          RequestPlayerList.code
//              + 'Henry' + Command.delimiter
//              + 'Jim' + Command.delimiter
//              + 'Sarah' + Command .delimiter
//              + 'Tracy') ;
//
//      henry.sendChat('hi');
//      expect((await nextMessage(james.connection.messagesIn.stream)).substring(0,3), ChatMessage.code);
//      expect(james.chatMessages.length,1);
//      expect(james.chatMessages[0].from,'henry');
//      expect(james.chatMessages[0].text,'hi');
//
//      james.sendChat('Hows it going');
//      expect((await nextMessage(henry.connection.messagesIn.stream)).substring(0,3), ChatMessage.code);
//      expect(henry.chatMessages.length,2);
//      expect(henry.chatMessages[0].from,'henry');
//      expect(henry.chatMessages[0].text,'hi');
//      expect(henry.chatMessages[1].from,'james');
//      expect(henry.chatMessages[1].text,'Hows it going');
////
//      sarah.sendMessage('james', 'hello james');
//      expect((await nextMessage(james.connection.messagesIn.stream)).substring(0,3), ChatMessage.code);
//      expect((await nextMessage(james.connection.messagesIn.stream)).substring(0,3), PrivateMessage.code);
//      expect(james.privateMessages.length, 1);
//      expect(james.privateMessages[0].from, 'sarah');
//      expect(james.privateMessages[0].text, 'hello james');
//
//      expect((await nextMessage(sarah.connection.messagesIn.stream)).substring(0,3), PrivateMessage.code);
//      expect(sarah.privateMessages.length, 1);
//      expect(sarah.privateMessages[0].from, 'sarah');
//      expect(sarah.privateMessages[0].text, 'hello james');
//
//      james.sendMessage('sarah', 'yo');
//      expect((await nextMessage(sarah.connection.messagesIn.stream)).substring(0,3), PrivateMessage.code);
//      expect(sarah.privateMessages.length, 2);
//      expect(sarah.privateMessages[1].from, 'james');
//      expect(sarah.privateMessages[1].text, 'yo');
//
//      henry.sendMessage('emma', 'hey Emma');
//      expect((await nextMessage(henry.connection.messagesIn.stream)).substring(0,3), PrivateMessage.code);
//      expect(henry.privateMessages.length, 1);
//      expect(henry.privateMessages[0].from, 'server');
//      expect(henry.privateMessages[0].text, 'emma is not online');
//

    });

    test('Logins and advertise game',() async{





    });


    tearDown(() async {
      await henry.logout();
      await james.logout();
      await sarah.logout();
      await trace.logout();
    });





  }, skip: 'server test'
  );



}